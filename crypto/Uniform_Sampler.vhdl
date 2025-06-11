library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uniform_sampler is
    generic (
        N  : integer := 256;    -- số hệ số đầu ra
        Q  : integer := 3329    -- modulus q trong Kyber
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        byte_stream : in std_logic_vector(0 to 3*N - 1); -- 3*N bytes input
        done       : out std_logic;
        a_hat      : out integer_vector(0 to N-1)
    );
end uniform_sampler;

architecture Behavioral of uniform_sampler is
    signal i, j : integer range 0 to 3*N := 0;
    signal output_poly : integer_vector(0 to N-1);
    signal processing : std_logic := '0';
begin

    process(clk)
        variable d1, d2 : integer;
        variable b0, b1, b2 : integer;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                i <= 0;
                j <= 0;
                processing <= '0';
                done <= '0';
                output_poly <= (others => 0);
            elsif start = '1' then
                i <= 0;
                j <= 0;
                processing <= '1';
                done <= '0';
            elsif processing = '1' then
                if j < N and i + 2 < byte_stream'length / 8 then
                    -- Tách 3 byte
                    b0 := to_integer(unsigned(byte_stream(i*8+7 downto i*8)));
                    b1 := to_integer(unsigned(byte_stream((i+1)*8+7 downto (i+1)*8)));
                    b2 := to_integer(unsigned(byte_stream((i+2)*8+7 downto (i+2)*8)));

                    d1 := b0 + 256 * (b1 mod 16);
                    d2 := (b1 / 16) + 16 * b2;

                    if d1 < Q then
                        output_poly(j) <= d1;
                        j <= j + 1;
                    end if;

                    if d2 < Q and j < N then
                        output_poly(j) <= d2;
                        j <= j + 1;
                    end if;

                    i <= i + 3;
                else
                    processing <= '0';
                    done <= '1';
                end if;
            end if;
        end if;
    end process;

    a_hat <= output_poly;

end Behavioral;
