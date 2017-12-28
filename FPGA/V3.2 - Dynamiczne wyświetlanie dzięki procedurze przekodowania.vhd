library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity displayNumbers is
    Port (CLK100MHZ: in STD_LOGIC;
          AN : out STD_LOGIC_VECTOR (7 downto 0);    
          SEG : out STD_LOGIC_VECTOR (6 downto 0));
end displayNumbers;

architecture behavioral of displayNumbers is
    signal bcd : STD_LOGIC_VECTOR(3 downto 0) := "0000";

    procedure convert (
        signal input : in STD_LOGIC_VECTOR (3 downto 0);
        signal output: out STD_LOGIC_VECTOR (6 downto 0)) is
    begin
        case input is
            when "0000" => output <= "1000000";
            when "0001" => output <= "1111001";
            when "0010" => output <= "0100100";
            when "0011" => output <= "0110000";
            when "0100" => output <= "0011001";
            when "0101" => output <= "0010010";
            when "0110" => output <= "0000010";
            when "0111" => output <= "1011000";
            when others => output <= "1111111";
        end case;
    end convert;

begin
    process (CLK100MHZ)
        variable counter: INTEGER := 0;
    begin
        if (rising_edge(CLK100MHZ)) then
            if (counter < 125_000) then
                counter := counter + 1;
                bcd <= "0000";
                convert(bcd, SEG);
                AN <= "11111110";
            elsif (counter < 250_000) then
                counter := counter + 1;
                bcd <= "0001";
                convert(bcd, SEG);
                AN <= "11111101";
            elsif (counter < 375_000) then
                counter := counter + 1;
                bcd <= "0010";
                convert(bcd, SEG);
                AN <= "11111011";
            elsif (counter < 500_000) then
                counter := counter + 1;
                bcd <= "0011";
                convert(bcd, SEG);
                AN <= "11110111";
            elsif (counter < 625_000) then
                counter := counter + 1;
                bcd <= "0100";
                convert(bcd, SEG);
                AN <= "11101111";
            elsif (counter < 750_000) then
                counter := counter + 1;
                bcd <= "0101";
                convert(bcd, SEG);
                AN <= "11011111";
            elsif (counter < 875_000) then
                counter := counter + 1;
                bcd <= "0110";
                convert(bcd, SEG);
                AN <= "10111111";
            elsif (counter < 1_000_000) then
                counter := counter + 1;
                bcd <= "0111";
                convert(bcd, SEG);
                AN <= "01111111";
            else
                counter := 0;
            end if;
        end if;      
    end process;
end behavioral;