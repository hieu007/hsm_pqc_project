library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cbd is
    generic (
        ETA : integer := 2  -- có thể thay đổi thành 3 nếu cần
    );
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        byte_array : in  std_logic_vector(64*ETA*8 - 1 downto 0);
        start      : in  std_logic;
        done       : out std_logic;
        poly_out   : out integer_vector(0 to 255)
    );
end cbd;

architecture Behavioral of cbd is

    -- Total bits = 64*eta bytes * 8 bits/byte
    constant TOTAL_BITS : integer := 64 * ETA * 8;
    signal bits : std_logic_vector(TOTAL_BITS - 1 downto 0);

    signal fi : integer_vector(0 to 255);
    signal i  : integer range 0 to 255 := 0;
    signal processing : std_logic := '0';

begin

    -- Convert bytes to bits
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                bits <= (others => '0');
            elsif start = '1' then
                bits <= byte_array;
            end if;
        end if;
    end process;

    -- CBD computation loop
    process(clk)
        variable a, b : integer;
        variable j    : integer;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                i <= 0;
                processing <= '0';
                done <= '0';
            elsif start = '1' then
                processing <= '1';
                i <= 0;
            elsif processing = '1' then
                a := 0;
                b := 0;

                -- Sum first eta bits for a
                for j in 0 to ETA-1 loop
                    if bits(2*i*ETA + j) = '1' then
                        a := a + 1;
                    end if;
                end loop;

                -- Sum next eta bits for b
                for j in 0 to ETA-1 loop
                    if bits(2*i*ETA + ETA + j) = '1' then
                        b := b + 1;
                    end if;
                end loop;

                fi(i) <= a - b;

                if i = 255 then
                    done <= '1';
                    processing <= '0';
                else
                    i <= i + 1;
                end if;
            end if;
        end if;
    end process;

    poly_out <= fi;

end Behavioral;
