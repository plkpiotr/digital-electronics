library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity diodesAndSwitches is
    Port (SW : inout STD_LOGIC_VECTOR (15 downto 0);
          LED : out STD_LOGIC_VECTOR (15 downto 0));
end diodesAndSwitches;

architecture behavioral of diodesAndSwitches is
begin
    LED <= SW;  -- przypisanie wartości sygnału ze switchy na diody
end behavioral;