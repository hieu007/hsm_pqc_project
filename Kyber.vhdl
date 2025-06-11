-- CRYSTALS-Kyber FPGA Full Implementation (CBD, Parse, NTT)
-- File: kyber_fpga_full.vhdl

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--------------------------------------------------------------------------------
-- CBD MODULE (Centered Binomial Distribution)
--------------------------------------------------------------------------------
entity cbd is
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        start  : in  std_logic;
        B      : in  std_logic_vector(511 downto 0);
        done   : out std_logic;
        f_out  : out integer_vector(0 to 255)
    );
end cbd;

architecture Behavioral of cbd is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                done <= '0';
            elsif start = '1' then
                for i in 0 to 255 loop
                    variable a, b : integer := 0;
                    for j in 0 to 1 loop  -- eta = 2
                        a := a + to_integer(unsigned(B(2*i*2 + j)));
                        b := b + to_integer(unsigned(B(2*i*2 + 2 + j)));
                    end loop;
                    f_out(i) <= a - b;
                end loop;
                done <= '1';
            end if;
        end if;
    end process;
end Behavioral;

--------------------------------------------------------------------------------
-- PARSE MODULE (Uniform Sampling)
--------------------------------------------------------------------------------
entity parse is
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        start  : in  std_logic;
        B      : in  std_logic_vector(767 downto 0);
        done   : out std_logic;
        coeffs : out integer_vector(0 to 255)
    );
end parse;

architecture Behavioral of parse is
    constant q : integer := 3329;
    signal i, j : integer := 0;
begin
    process(clk)
        variable d1, d2 : integer;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                i <= 0; j <= 0;
                done <= '0';
            elsif start = '1' then
                while j < 256 loop
                    d1 := to_integer(unsigned(B(i*8 + 7 downto i*8))) + 256 * (to_integer(unsigned(B((i+1)*8 + 3 downto (i+1)*8))) mod 16);
                    d2 := (to_integer(unsigned(B((i+1)*8 + 7 downto (i+1)*8))) / 16) + 16 * to_integer(unsigned(B((i+2)*8 + 7 downto (i+2)*8)));
                    if d1 < q then
                        coeffs(j) <= d1;
                        j <= j + 1;
                    end if;
                    if d2 < q and j < 256 then
                        coeffs(j) <= d2;
                        j <= j + 1;
                    end if;
                    i <= i + 3;
                end loop;
                done <= '1';
            end if;
        end if;
    end process;
end Behavioral;

--------------------------------------------------------------------------------
-- NTT MODULE (Number Theoretic Transform)
--------------------------------------------------------------------------------
entity ntt_transform is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        start     : in  std_logic;
        f_in      : in  integer_vector(0 to 255);
        done      : out std_logic;
        f_hat_out : out integer_vector(0 to 255)
    );
end ntt_transform;

architecture Behavioral of ntt_transform is
    constant q : integer := 3329;
    constant r : integer := 17;
    function modexp(base, exp, modn : integer) return integer is
        variable result : integer := 1;
        variable b := base;
        variable e := exp;
    begin
        while e > 0 loop
            if (e mod 2 = 1) then
                result := (result * b) mod modn;
            end if;
            e := e / 2;
            b := (b * b) mod modn;
        end loop;
        return result;
    end function;

    signal i, j : integer := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                done <= '0';
            elsif start = '1' then
                for i in 0 to 255 loop
                    f_hat_out(i) <= 0;
                    for j in 0 to 255 loop
                        f_hat_out(i) <= (f_hat_out(i) + (f_in(j) * modexp(r, i*j, q))) mod q;
                    end loop;
                end loop;
                done <= '1';
            end if;
        end if;
    end process;
end Behavioral;

--------------------------------------------------------------------------------
-- TOP MODULE: kyber_top (connects all blocks)
--------------------------------------------------------------------------------
entity kyber_top is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        start       : in  std_logic;
        cbd_input   : in  std_logic_vector(511 downto 0);
        parse_input : in  std_logic_vector(767 downto 0);
        done_all    : out std_logic;
        final_ntt   : out integer_vector(0 to 255)
    );
end kyber_top;

architecture Behavioral of kyber_top is
    signal cbd_out    : integer_vector(0 to 255);
    signal parse_out  : integer_vector(0 to 255);
    signal ntt_result : integer_vector(0 to 255);
    signal cbd_done   : std_logic := '0';
    signal parse_done : std_logic := '0';
    signal ntt_done   : std_logic := '0';
    signal go_parse   : std_logic := '0';
    signal go_ntt     : std_logic := '0';
begin
    -- CBD
    cbd_inst : entity work.cbd port map (clk, reset, start, cbd_input, cbd_done, cbd_out);
    -- Parse
    parse_inst : entity work.parse port map (clk, reset, go_parse, parse_input, parse_done, parse_out);
    -- NTT
    ntt_inst : entity work.ntt_transform port map (clk, reset, go_ntt, parse_out, ntt_done, ntt_result);

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                go_parse <= '0'; go_ntt <= '0'; done_all <= '0';
            elsif start = '1' then
                go_parse <= '0'; go_ntt <= '0'; done_all <= '0';
            elsif cbd_done = '1' and go_parse = '0' then
                go_parse <= '1';
            elsif parse_done = '1' and go_ntt = '0' then
                go_ntt <= '1';
            elsif ntt_done = '1' then
                done_all <= '1';
            end if;
        end if;
    end process;

    final_ntt <= ntt_result;

end Behavioral;
