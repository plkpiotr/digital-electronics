library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fourthCounter is
    port (CLK100MHZ : in STD_LOGIC;
          SW : inout STD_LOGIC;
          LED : out STD_LOGIC_VECTOR (15 downto 0));
end fourthCounter;

architecture behavioral of fourthCounter is                                    
signal cnt : STD_LOGIC_VECTOR (26 downto 0) := "000000000000000000000000000";        
begin
    process(CLK100MHZ, cnt)
    begin
        if (rising_edge(CLK100MHZ)) then
            if (SW = '1') then
                cnt <= "000000000000000000000000000";
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    LED <= cnt (26 downto 11);
end behavioral;