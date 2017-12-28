library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity firstCounter is
    port (CLK100MHZ : in STD_LOGIC;
          SW : inout STD_LOGIC;
          LED : out STD_LOGIC_VECTOR (7 downto 0));
end firstCounter;

architecture behavioral of firstCounter is

signal counter : STD_LOGIC_VECTOR (7 downto 0) := "00000000"; -- wartość początkowa
signal CLK1Hz : STD_LOGIC;                                    -- należy ją zmienić przy zliczaniu w dół
begin
    process(CLK100MHZ)
    variable divider : STD_LOGIC_VECTOR (27 downto 0);
    begin
        if (rising_edge(CLK100MHZ)) then
            if (divider = "10111110101111000001111111") then  -- ustawienie wartości dzielnika częstotliwości
                CLK1Hz <= '1';
                divider := (others => '0');
            else
                CLK1HZ <= '0';
                divider := divider + 1;
            end if;
        end if;
    end process;
    process(CLK1HZ, SW)
    begin
        if (rising_edge(CLK1HZ)) then
            if (SW = '0' AND  counter > "10101010") then    -- zliczanie w dół do wartości 10101010
                counter <= counter - 1;
            elsif (SW = '0' AND counter = "10101010") then  -- osiągnięcie wartości minimalnej
                counter <= "11111111";                      -- powrót do ponownego odliczania
            elsif (SW = '1' AND counter < "10101010") then  -- zliczanie w górę do wartości 10101010
                counter <= counter + 1;
            else                                            -- osiągnięcie wartości maksymalnej
                counter <= "00000000";                      -- powrót do ponownego odliczania
            end if;
        end if;
    end process;
    LED <= counter;                                         -- wyświetlenie wartości licznika na diodach
end behavioral;
