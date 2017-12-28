library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity logicGates is
    port (SW : inout STD_LOGIC_VECTOR (1 downto 0);
          LED : out STD_LOGIC_VECTOR (6 downto 0));
end logicGates;

architecture behavioral of logicGates is
begin
    LED(0) <= SW(0) AND SW(1);          -- AND
    LED(1) <= NOT (SW(0) AND SW(1));    -- NAND
    LED(2) <= SW(0) OR SW(1);           -- OR
    LED(3) <= NOT (SW(0) OR SW(1));     -- NOR
    LED(4) <= SW(0) XOR SW(1);          -- XOR
    LED(5) <= NOT (SW(0) XOR SW(1));    -- XNOR
    LED(6) <= NOT SW(1);                -- NOT
end behavioral;