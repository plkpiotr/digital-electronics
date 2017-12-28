library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity secondCounter is
    port (CLK100MHZ : in STD_LOGIC;
          LED : out STD_LOGIC_VECTOR (15 downto 0));
end secondCounter;

architecture behavioral of secondCounter is                                    
signal cnt : STD_LOGIC_VECTOR (26 downto 0) := "000000000000000000000000000";        
begin
    process(CLK100MHZ, cnt)
    begin
        if (rising_edge(CLK100MHZ)) then
            cnt <= cnt + 1; -- operacja możliwa dzięki STD_LOGIC_UNSIGNED.ALL
        end if;
    end process;
    LED <= cnt (26 downto 11); -- wyświetlenie 16 najstarszych bitów
end behavioral;