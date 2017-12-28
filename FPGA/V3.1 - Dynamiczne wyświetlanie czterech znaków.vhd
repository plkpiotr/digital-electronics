library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity displayCharacters is
    Port (CLK100MHZ: in STD_LOGIC;
          AN : out STD_LOGIC_VECTOR (7 downto 0);  -- słowo odpowiadające za wyświetlacze   
          SEG: out STD_LOGIC_VECTOR (6 downto 0)); -- słowo odpowiadające za segmenty (bez kropki)
end displayCharacters;

architecture behavioral of displayCharacters is
    signal bcd: STD_LOGIC_VECTOR(3 downto 0) := "0000";      -- sygnał odpowiadający za wyświetlanie znaku
    constant three : STD_LOGIC_VECTOR(3 downto 0) := "0011"; -- zdefiniowanie stałych w kodzie BCD
    constant five : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    constant a : STD_LOGIC_VECTOR(3 downto 0) := "1010";
    constant b : STD_LOGIC_VECTOR(3 downto 0) := "1011";

    procedure convert (
        signal input : in STD_LOGIC_VECTOR (3 downto 0);     -- 4-bitowe wejście w kodzie BCD
        signal output: out STD_LOGIC_VECTOR (6 downto 0)) is -- 7-bitowe wyjście (segmenty bez kropki)
    begin
        case input is
            when three => output <= "0110000";  -- wyświetlanie trójki
            when five => output <= "0010010";   -- wyświetlanie piątki
            when a => output <= "0001000";      -- wyświetlanie litery a
            when b => output <= "0000011";      -- wyświetlanie litery b
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
                bcd <= "0011"; -- uruchomienie segementów, by wyświetlały trójkę
                convert(bcd, SEG);
                AN <= "11111110"; -- uruchomienie pierwszego wyświetlacza od lewej
            elsif (counter < 500_000) then
                counter := counter + 1;
                bcd <= "0101"; -- uruchomienie segmentów, by wyświetlały piątkę
                convert(bcd, SEG);
                AN <= "11111101"; -- uruchomienie drugiego wyświetlacza od lewej
            elsif (counter < 750_000) then
                counter := counter + 1;
                bcd <= "1010"; -- uruchomienie segmentów, by wyświetlały literę a
                convert(bcd, SEG);
                AN <= "11111011"; -- uruchomienie trzeciego wyświetlacza od lewej
            elsif (counter < 1_000_000) then
                counter := counter + 1;
                bcd <= "1011"; -- uruchomienie segmentów, by wyświetlały literę b
                convert(bcd, SEG);
                AN <= "11110111"; -- uruchomienie czwartego wyświetlacza od lewej
            else
                counter := 0;
            end if;
        end if;      
    end process;
end behavioral;