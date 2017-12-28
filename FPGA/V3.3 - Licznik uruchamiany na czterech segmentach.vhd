library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity displayCharacters is
    Port (CLK100MHZ: in STD_LOGIC;
          AN : out STD_LOGIC_VECTOR (7 downto 0);    
          SEG : out STD_LOGIC_VECTOR (6 downto 0));
end displayCharacters;

architecture behavioral of displayCharacters is
    shared variable bcd1 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    shared variable bcd2 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    shared variable bcd3 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    shared variable bcd4 : STD_LOGIC_VECTOR (3 downto 0) := "0000";

    procedure convert (
        variable input : in STD_LOGIC_VECTOR (3 downto 0);
        signal output : out STD_LOGIC_VECTOR (6 downto 0)) is
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
            when "1000" => output <= "0000000";
            when "1001" => output <= "0010000";
            when others => output <= "1000000";
        end case;
    end convert;

begin

    process (CLK100MHZ)
        variable counter: INTEGER := 0;
    begin
        if (rising_edge(CLK100MHZ)) then
            if (counter < 250_000) then
                counter := counter + 1;
                convert(bcd1, SEG);
                AN <= "11111110";
            elsif (counter < 500_000) then
                counter := counter + 1;
                convert(bcd2, SEG);
                AN <= "11111101";
            elsif (counter < 750_000) then
                counter := counter + 1;
                convert(bcd3, SEG);
                AN <= "11111011";
            elsif (counter < 1_000_000) then
                counter := counter + 1;
                convert(bcd4, SEG);
                AN <= "11110111";
            else
                counter := 0;
            end if;
        end if;      
    end process;
    
    process (CLK100MHZ)
        variable counter1: INTEGER := 0;
        variable counter2: INTEGER := 0;
        variable counter3: INTEGER := 0;
        variable counter4: INTEGER := 0;
    begin
        if (rising_edge(CLK100MHZ)) then
            if (counter1 < 1_000_000) then
                counter1 := counter1 + 1;
            else
                counter1 := 0;
                if (bcd1 < "1010") then
                    bcd1 := bcd1 + 1;
                else
                    bcd1 := "0001";
                end if;
            end if;
            if (counter2 < 10_000_000) then
                counter2 := counter2 + 1;
            else
                counter2 := 0;
                if (bcd2 < "1010") then
                    bcd2 := bcd2 + 1;
                else
                    bcd2 := "0001";
                end if;
            end if;
            if (counter3 < 100_000_000) then
                counter3 := counter3 + 1;
            else
                counter3 := 0;
                if (bcd3 < "1010") then
                    bcd3 := bcd3 + 1;
                else
                    bcd3 := "0001";
                end if;
            end if;
            if (counter4 < 1_000_000_000) then
                counter4 := counter4 + 1;
            else
                counter4 := 0;
                if (bcd4 < "1010") then
                    bcd4 := bcd4 + 1;
                else
                    bcd4 := "0001";
                end if;
            end if;
        end if;      
    end process;

end behavioral;