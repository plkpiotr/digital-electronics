library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity displayCharacters is
    Port (CLK100MHZ: in STD_LOGIC;
          AN : out STD_LOGIC_VECTOR (7 downto 0);    
          SEG: out STD_LOGIC_VECTOR (6 downto 0));
end displayCharacters;

architecture behavioral of displayCharacters is
    signal bcd: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant three : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant five : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    constant a : STD_LOGIC_VECTOR(3 downto 0) := "1010";
    constant b : STD_LOGIC_VECTOR(3 downto 0) := "1011";

    procedure convert (
        signal input : in STD_LOGIC_VECTOR (3 downto 0);
        signal output: out STD_LOGIC_VECTOR (6 downto 0)) is
    begin
        case input is
            when three => output <= "0110000";
            when five => output <= "0010010";
            when a => output <= "0001000";
            when b => output <= "0000011";
            when others => output <= "1111111";
        end case;
    end convert;

begin
    process (CLK100MHZ)
        variable counter: INTEGER := 0;
    begin
        if (rising_edge(CLK100MHZ)) then
            if (counter < 250_000) then
                counter := counter + 1;
                bcd <= "0011";
                convert(bcd, SEG);
                AN <= "11111110";
            elsif (counter < 500_000) then
                counter := counter + 1;
                bcd <= "0101";
                convert(bcd, SEG);
                AN <= "11111101";
            elsif (counter < 750_000) then
                counter := counter + 1;
                bcd <= "1010";
                convert(bcd, SEG);
                AN <= "11111011";
            elsif (counter < 1_000_000) then
                counter := counter + 1;
                bcd <= "1011";
                convert(bcd, SEG);
                AN <= "11110111";
            else
                counter := 0;
            end if;
        end if;      
    end process;
end behavioral;