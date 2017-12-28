library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity firstCounter is
    port (CLK100MHZ : in STD_LOGIC;
          SW : inout STD_LOGIC;
          LED : out STD_LOGIC_VECTOR (7 downto 0));
end firstCounter;

architecture behavioral of firstCounter is                                    

signal counter : STD_LOGIC_VECTOR (7 downto 0) := "00000000";    -- value at the beginning
                                                                -- change if count down
signal CLK1Hz : STD_LOGIC;
begin
    process(CLK100MHZ)
    variable divider : STD_LOGIC_VECTOR (27 downto 0);
    begin
        if (rising_edge(CLK100MHZ)) then
            if (divider = "10111110101111000001111111") then
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
            if (SW = '0' AND  counter > "10101010") then    -- count down to 10101010
                counter <= counter - 1;
            elsif (SW = '0' AND counter = "10101010") then  -- reach min value
                counter <= "11111111";
            elsif (SW = '1' AND counter < "10101010") then  -- count up to 10101010
                counter <= counter + 1;
            else                                            -- reach max value
                counter <= "00000000";
            end if;
        end if;
    end process;
    LED <= counter;
end behavioral;

signal counter : STD_LOGIC_VECTOR (7 downto 0) := "00000000";   -- value at the beginning
                                                                -- change if count down
signal CLK1Hz : STD_LOGIC;
begin
    process(CLK100MHZ)
    variable divider : STD_LOGIC_VECTOR (27 downto 0);
    begin
        if (rising_edge(CLK100MHZ)) then
            if (divider = "10111110101111000001111111") then
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
            if (SW = '0' AND  counter > "10101010") then      -- count down to 10101010
                counter <= counter - 1;
            elsif (SW = '0' AND counter = "10101010") then    -- reach min value
                counter <= "11111111";
            elsif (SW = '1' AND counter < "10101010") then    -- count up to 10101010
                counter <= counter + 1;
            else                                              -- reach max value
                counter <= "00000000";
            end if;
        end if;
    end process;
    LED <= counter;
end behavioral;
