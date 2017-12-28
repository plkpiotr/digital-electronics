library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity thirdCounter is
    port (CLK100MHZ : in STD_LOGIC;
          LED : out STD_LOGIC_VECTOR (15 downto 0));
end thirdCounter;

architecture behavioral of thirdCounter is                                           
begin
    process(CLK100MHZ)
    variable cnt: INTEGER := 0;
    begin
        if (rising_edge(CLK100MHZ)) then
            if (cnt < 50000000) then
                cnt := cnt + 1;
                LED <= (others => '0');
            elsif (cnt < 100000000) then
                cnt := cnt + 1;
                LED <= (others => '1');
            else 
                cnt := 0;
            end if;
        end if;
    end process;
end behavioral;