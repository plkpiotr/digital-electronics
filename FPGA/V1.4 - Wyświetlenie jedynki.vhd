library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity displayOne is
    Port (SEG : inout STD_LOGIC_VECTOR (7 downto 0);
          AN : inout STD_LOGIC_VECTOR (7 downto 0));
end displayOne;

architecture behavioral of displayOne is
begin
    SEG <= "11111001"; -- określenie działających segmentów wyświetlacza stanami wysokimi
    AN <= "11111110";  -- określenie działającego wyświetlacza stanem niskim
end behavioral;