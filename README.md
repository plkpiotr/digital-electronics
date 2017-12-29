# Sprawozdanie z elektroniki cyfrowej - część I
## Programowanie FPGA

## Piotr Pałka - poniedziałek 9:30, podgrupa 2
Dokument ten zawiera podsumowanie zajęć elektroniki cyfrowej z części dotyczącej języka VHDL. Każdy z umieszczonych niżej programów został opatrzony nagłówkiem składającym się kolejno z: numeru zajęć odnoszących się do bezpośrednio programowalnej macierzy bramek, numeru określającego kolejność wykonania programu na zajęciach oraz jego tytuł. Każdy z programów zawiera krótki opis zawierający wnioski i przemyślenia oraz tam gdzie było to niezbędne zamieściłem komentarze bezpośrednio w kodzie.

### 1.1 - Konfiguracja wstępna
Pierwszą czynnością na stanowisku z płytką FPGA było stworzenia projektu w środowisku programistycznym Vivado zgodnie z konspektem zamieszczonym na platformie uczelnianej UPEL. Niezbędnym plikiem do obsługi programowalnej macierzy bramek był plik `Nexys4DDR_Master.xdc` umożliwiający nam określenie, z których elementów będziemy korzystać. Poniżej zamieściłem fragment niezmodyfikowanego, wyżej wspomnianego pliku.
```bash
#set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { CA }]; #IO_L24N_T3_A00_D16_14 Sch=ca
#set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { CB }]; #IO_25_14 Sch=cb
#set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { CC }]; #IO_25_15 Sch=cc
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { CD }]; #IO_L17P_T2_A26_15 Sch=cd
#set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { CE }]; #IO_L13P_T2_MRCC_14 Sch=ce
#set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { CF }]; #IO_L19P_T3_A10_D26_14 Sch=cf
#set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { CG }]; #IO_L4P_T0_D04_14 Sch=cg

#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { DP }]; #IO_L19N_T3_A21_VREF_15 Sch=dp
```

### 1.2 - Przygotowanie pliku .xdc
Aby wskazać podzespoły wykorzystywane w naszym projekcie należało odkomentować (usuwając znak `#`) te, których będziemy używać. W celu ułatwienia pracy na segmentach wyświetlacza zdecydowałem się na zmianę nomenklatury dotyczącej wyświetlacza. Od tej pory zamiast odwoływać się pojedynczo do poszczególnych katod cały segment zawarty jest w jednym słowie. Ułatwi to w przyszłości zakodowanie cyfry.
```bash
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { SEG[0] }]; #IO_L24N_T3_A00_D16_14 Sch=ca
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { SEG[1] }]; #IO_25_14 Sch=cb
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { SEG[2] }]; #IO_25_15 Sch=cc
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { SEG[3] }]; #IO_L17P_T2_A26_15 Sch=cd
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { SEG[4] }]; #IO_L13P_T2_MRCC_14 Sch=ce
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { SEG[5] }]; #IO_L19P_T3_A10_D26_14 Sch=cf
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { SEG[6] }]; #IO_L4P_T0_D04_14 Sch=cg

set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { SEG[7] }]; #IO_L19N_T3_A21_VREF_15 Sch=dp
```

### 1.3 - Uzależnienie diod od switchy
Pierwszym zadaniem na zajęciach było uzależnienie diod od switchy, w taki sposób by stan kolejnych przełączników definiował świecenie odpowiadających im diod. Dzięki równoległemu wykonywaniu instrukcji przypisujemy po prostu wartość sygnału ze słowa `SW` do słowa `LED`.
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity diodesAndSwitches is
    Port (SW : inout STD_LOGIC_VECTOR (15 downto 0);
          LED : out STD_LOGIC_VECTOR (15 downto 0));
end diodesAndSwitches;

architecture behavioral of diodesAndSwitches is
begin
    LED <= SW; -- przypisanie wartości sygnału ze switchy na diody
end behavioral;
```

### 1.4 - Wyświetlenie jedynki
Kolejne ćwiczenie polegało na wyświetleniu cyfry zgodnej z numerem stanowiska. W moim przypadku była to cyfra 1. W tym celu należało wykorzystać dwa słowa: `AN` oraz `SEG`, pamiętając o uprzednim odkomentowaniu ich składowych w pliku `.xdc`. `AN` mówi nam którego lub których z ośmiu wyświetlaczy chcemy użyć (stan niski, czyli `0` określa pracę wyświetlacza), zaś `SEG` definiowało nam, który lub które segmenty wyświetlacza mają być aktywne (tutaj stan wysoki, czy `1` definiowało pracę segmentu).
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity displayOne is
    Port (SEG : inout STD_LOGIC_VECTOR (7 downto 0);
          AN : inout STD_LOGIC_VECTOR (7 downto 0));
end displayOne;

architecture behavioral of displayOne is
begin
    SEG <= "11111001"; -- określenie działających segmentów wyświetlacza stanami wysokimi
    AN <= "11111110"; -- określenie działającego wyświetlacza stanem niskim
end behavioral;
```

### 1.5 - Układ bramek logicznych
Na zajęciach lub w domu należało ponadto zaimplementować symulację kilku wybranych bramek logicznych. Do dyspozycji mieliśmy dwa sygnały pochodzące do przełączników oraz siedem wyjść odnoszących się do kolejno wymienionych bramek.
```vhdl
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
```

### 2.1 - Licznik binarny zliczający w górę, w dół do wartości
Jest to zmodyfikowana wersja licznika na podstawie pracy domowej. Licznik binarny, który zlicza od wartości początkowej w dół lub w górę - w zależności od ustawionego bitu na przełączniku. Do realizacji tego zadania wykorzystałem dwa procesy. Pierwszy z nich służy do utworzenia taktowania o częstotliwości 1 [Hz], stąd wartość dzielnika częstotliwości użyta w tym procesie wynosiła binarnie `10111110101111000001111111`, co dziesiętnie możemy wyrazić jako `49999999`. Sygnał zegarowy jest prostokątną falą o 50% wypełnienia (taki sam czas aktywny i nieaktywny), wobec tego wraz z wykonaniem się kodu `50000000` razy przy stanie wysokim (liczymy bowiem od zera) "sztuczny zegar" oznaczony jako `CLK1Hz` będzie miał wartość bitu równą `1`, przy kolejnych `50000000` razach (pół sekundy) stan niski równy `0`. Drugi z procesów zajmuje się sposobem zliczania jak i samym zliczaniem. Poza procesami przypisujemy stan licznika na diody LED.
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity firstCounter is
    port (CLK100MHZ : in STD_LOGIC;
          SW : inout STD_LOGIC;
          LED : out STD_LOGIC_VECTOR (7 downto 0));
end firstCounter;

architecture behavioral of firstCounter is

signal counter : STD_LOGIC_VECTOR (7 downto 0) := "00000000"; -- wartość początkowa
signal CLK1Hz : STD_LOGIC;                                    -- należy ją zmienić przy zliczaniu w dół
begin
    process(CLK100MHZ)
    variable divider : STD_LOGIC_VECTOR (27 downto 0);
    begin
        if (rising_edge(CLK100MHZ)) then
            if (divider = "10111110101111000001111111") then  -- ustawienie wartości dzielnika częstotliwości
                CLK1Hz <= '1';
                divider := (others => '0');
            else
                CLK1HZ <= '0';
                divider := divider + 1;
            end if;
        end if;
    end process;
    process(CLK1HZ, SW)
    begin
        if (rising_edge(CLK1HZ)) then
            if (SW = '0' AND  counter > "10101010") then    -- zliczanie w dół do wartości 10101010
                counter <= counter - 1;
            elsif (SW = '0' AND counter = "10101010") then  -- osiągnięcie wartości minimalnej
                counter <= "11111111";                      -- powrót do ponownego odliczania
            elsif (SW = '1' AND counter < "10101010") then  -- zliczanie w górę do wartości 10101010
                counter <= counter + 1;
            else                                            -- osiągnięcie wartości maksymalnej
                counter <= "00000000";                      -- powrót do ponownego odliczania
            end if;
        end if;
    end process;
    LED <= counter;                                         -- wyświetlenie wartości licznika na diodach
end behavioral;
```

### 2.2 - Licznik binarny
Prosty licznik binarny napisany od zera na drugich zajęciach. Do jego realizacji potrzebowaliśmy sygnału `cnt`, którego rozmiar (u mnie 27 bitów) odpowiadała za zliczanie z częstotliwością jak najbardziej zbliżoną do 1 [Hz]. Zależność ta wynika z ilorazu 100 [Mhz] tzn. częstotliwości wbudowanej i `2^(n+1)`, którego wynikiem jest 1 [Hz], a szukaną wartością `n`. Dzięki temu ostatni z wyświetlanych bitów będzie świecił z pożądaną częstotliwością. Warto zaznaczyć, że w kodzie zaczęła pojawiać się instrukcja `use IEEE.STD_LOGIC_UNSIGNED.ALL;` umożliwiająca "dodawanie" jedynki do słowa binarnego.
```vhdl
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
```

### 2.3 - Licznik binarny z prescalerem
Modyfikacja poprzedniego programu z powodu wprowadzenia prescalera i zastąpienia sygnału zmienną. Ponadto kod ten powoduje "migotanie" wszystkich diod naraz z częstotliwością 1 [Hz], bez możliwości podglądu stanu licznika na diodach. Stan świecenia i nie świecenia trwający po 0,5 [s] każdy - analogia do programu 2.1.
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

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
                LED <= (others => '0'); -- przypisanie stanu niskiego na wszystkie diody
            elsif (cnt < 100000000) then
                cnt := cnt + 1;
                LED <= (others => '1'); -- przypisanie stanu wysokiego na wszystkie diody
            else 
                cnt := 0; -- rozpoczęcie odliczania w prescalerze od początku
            end if;
        end if;
    end process;
end behavioral;
```

### 2.4 - Licznik binarny z resetem
Ostatnia zmiana polegała na sprawdzeniu działania funkcji resetu. Wykorzystałem do niej drugą wersję programu 2.2 - modyfikacja polegała wyłącznie na dodaniu opcji zresetowania z poziomu switcha tzn. wartość bitu równa `1` rozpoczynała zliczanie od początku. Na wyjściu otrzymywaliśmy stan licznika, gdzie najmłodszy bit "mrugał" z częstotliwością 1 [Hz].
```vhdl
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
            if (SW = '1') then  -- sprawdzanie czy funkcja resetu jest uruchomiona
                cnt <= "000000000000000000000000000"; -- zliczanie od zera
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    LED <= cnt (26 downto 11);
end behavioral;
```

### 3.1 - Dynamiczne wyświetlanie czterech znaków
Na trzecich zajęciach swoją pracę rozpoczęliśmy od dynamicznego wyświetlania czterech znaków - innymi słowy przemiennego wyświeltania czterech znaków na odpowiadających każdemu z nich wyświetlaczowi z tak wysoką częstotliwością aby obserwator mógł widzieć je wszystkie "naraz". Do wykonania tego zadania potrzebowaliśmy procedury konwertującej z zapisu BCD w celu uproszczenia kododwania znaków oraz procesu, który wystarczająco szybko potrafiłby "przerzucać" wyświetlanie na kolejne segmenty. Zgodnie z dobranymi wartościami każdy ze znaków wyświetlany jest przez 2,5 [ms] - częstotliwość 400 [Hz] zapewnia, że dane na wyświetlaczach będą widoczne równocześnie.
```vhdl
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
```

### 3.2 - Dynamiczne wyświetlanie dzięki procedurze przekodowania
Ten program był modyfikacją poprzedniego wynikającą z wyświetlania ośmiu znaków zamiast czterech, stąd nie powielałem komentarzy w poniższych wierszach, aby zachować przejrzystość kodu. Czas wyświetlania jednego znaku w tym przypadku wynosił 1,25 [ms], co również umożliwiło jednoczesne obserwowanie każdej z liczb.
```vhdl
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
```

### 3.3 - Licznik uruchamiany na czterech segmentach
Ostatnim programem napisanym na ćwiczeniach w języku VHDL był licznik, którego działanie mogliśmy prześledzić na czterech segmentach. Do procedury przekodowania z kodu BCD zostały dodane dwie brakujące cyfry w odróżnieniu od poprzedniego programu. Ponadto oprócz procesu odpowiedzialnego za "równoczesne" wyświetlanie znaków należało dodać proces umożliwiający dodawanie kolejnych wartości do poprzedniej. W ten sposób wartości na kolejnych wyświetlaczach (patrząc od lewej) zmieniają się kolejno co: 0,01 [s], 0,1 [s], 1 [s] oraz 10 [s]. Bardzo pomocnym narzędziem w napisaniu tego programu okazały się być `shared variable`, czyli zmienne, których można było używać między procesami.
```vhdl
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

    procedure convert ( -- pełna procedura przekodowania cyfr od 0 do 9
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

    process (CLK100MHZ) -- proces wykorzystywany do "równoczesnego" wyświetlania
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
    
    process (CLK100MHZ) -- proces związany z obsługą licznika tzn. inkrementacją wartości
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
```
# Sprawozdanie z elektroniki cyfrowej - część II
## Programowanie mikrokontrolerów

## Piotr Pałka - poniedziałek 9:30, podgrupa 2
Dokument ten zawiera podsumowanie zajęć elektroniki cyfrowej z części dotyczącej języka Assembly oraz języka C. Każdy z umieszczonych niżej programów został opatrzony nagłówkiem składającym się kolejno z: numeru zajęć odnoszących się do mikrokontrolera 8051 lub STM32, numeru określającego kolejność wykonania programu na zajęciach oraz jego tytuł. Każdy z programów zawiera krótki opis zawierający wnioski i przemyślenia oraz tam gdzie było to niezbędne zamieściłem komentarze bezpośrednio w kodzie.

### 1.1 - Przykładowy program zapalający wybrane diody
Pierwszy program polegał na zaświeceniu wybranych diod. Podczas jego implementacji należało pamiętać, że uruchomienie diody związane jest ze stanem niskim.
```asm
org 0x00;
    JMP main; bezwarunkowy skok pod etykietę "wait"
org 0x30;
main:
    MOV P1, #0x55; binarnie: 0101 0101 - co druga dioda świeci w module 2
    CALL wait; wywołanie procedury "wait"
    MOV P1, #0xAA; binarnie: 1010 1010 - odwrócenie stanu wszystkich diod w module 2
    CALL wait; wywołanie procedury "wait"
    JMP main; bezwarunkowy skok pod etykietę "wait"
wait:
    MOV R0, #200; wpisanie do rejestru R0 wartości 200 (dec) - adresowanie natychmiastowe (#)
loop:
    DJNZ R0, loop; "dekrementuj R0 i skocz jeśli wynik różny od zera" (2 cykle)
    RET; powrót z procedury
```

### 1.2 - Migotanie diody z okresem kilkuset mikrosekund
Drugi z programów zapewniał migotanie diody, którego jednak nie mogliśmy doświadczalnie zaobserwować z uwagi na fakt, że czas świecenia i nie świecenia wynosił przy różnych modyfikacjach wartości pod rejestrem `R0` kilkaset mikrosekund.
```asm
org 0x00;
    JMP main; bezwarunkowy skok pod etykietę "main"
org 0x30;
main:
    MOV P1, #0x55; binarnie: 0101 0101 - co druga dioda świeci w module 2
    CALL wait; wywołanie procedury "wait"
    MOV P1, #0xAA; binarnie: 1010 1010 - odwrócenie stanu wszystkich diod w module 2
    CALL wait; wywołanie procedury "wait"
    JMP main; bezwarunkowy skok pod etykietę "main"
wait:
    MOV R0, #200; wpisanie do rejestru R0 wartości 200 (dec) - adresowanie natychmiastowe (#)
loop:
    DJNZ R0, loop; dekrementuj R0 i skocz do "loop" jeśli wynik różny od zera (2 cykle)
    RET; powrót z procedury (podprogramu)
```

### 1.3 - Migotanie diody z częstotliwością 1 Hz
Trzeci z programów umożliwiał już dostrzeżenie zmiany stanu diody. Fragment "main" pozostał taki sam jednak do "wydłużenia" oczekiwania wewnątrz etykiety wait dodałem zagnieżdżone pętle wykorzystując instrukcje `DJNZ`.
```asm
org 0x00;
    JMP main; bezwarunkowy skok pod etykietę "main"
org 0x30;
main:
    MOV P1, #0x55; binarnie: 0101 0101 - co druga dioda świeci w module 2
    CALL wait; wywołanie procedury "wait"
    MOV P1, #0xAA; binarnie: 1010 1010 - odwrócenie stanu wszystkich diod w module 2
    CALL wait; wywołanie procedury "wait"
    JMP main; bezwarunkowy skok pod etykietę "main"
wait:
    MOV R0, #63; wpisanie do rejestru R0 wartości 63 (dec) - adresowanie natychmiastowe (#)
loop1:
    MOV R1, #63; wpisanie do rejestru R1 wartości 63 (dec) - adresowanie natychmiastowe (#)
loop2:
    MOV R2, #63; wpisanie do rejestru R2 wartości 63 (dec) - adresowanie natychmiastowe (#)
loop3:
    DJNZ R2, loop3; "dekrementuj R0 i skocz do "loop3" jeśli wynik różny od zera" (2 cykle)
    DJNZ R1, loop2; "dekrementuj R1 i skocz do "loop2" jeśli wynik różny od zera" (2 cykle)
    DJNZ R0, loop1; "dekrementuj R2 i skocz do "loop1" jeśli wynik różny od zera" (2 cykle)
    RET; powrót z procedury (podprogramu)
```

### 2.1 - Migotanie diody na podstawie przerwań
Działanie programu analogiczne do przykładu 1.2 wzbogacone o obsługę przerwań.
```asm
org 0x00;
    JMP init;
org 0x0B;
    JMP irq;
org 0x30;
init:
    MOV TMOD, #0x01; określenie pracy timera T0 jako 16-bitowy
    MOV TH0, #0x00; ustawienie wartości bardziej znaczącego bajta timera
    MOV TL0, #0x00; ustawienie wartości mniej znaczącego bajta timera
    SETB EA; zezwolenie na globalne przerwania
    SETB ET0; zezwolenie na przerwania pochodzące od timera T0
    SETB TR0; dołączenie sygnału do timera T0
main:
    JMP main;
irq:
    CPL P1.1; odwórcenie bitu, czyli stanu diody
    RETI; powrót z procedury obsługi przerwania
```

### 2.2 - Migotanie diody na podstawie przerwań z zadaną częstotliwością
Działanie programu analogiczne do przykładu 1.3 ulepszone o obsługę przerwań. W tym programie należało jednak wymyślić sposób w jaki sposób dobrać wartości `TL0`, `TH0` oraz `R0`, aby częstotliwość mrugania diody wynosiła 1 [Hz]. W moim przypadku procedura obliczeń była następująca: dioda ma się świecić przez 0,5 [s] oraz przez takim sam nie świecić. Wobec tego: `0,5 [s] / x = 1,2 [us]`. Przekształcając względem x: `x = 0,5 / (1,2 * 10 ^ (-6)) = 416 666 ` cykli. Wybieram liczbę najbardziej zbliżoną do `416 666`, której dzielnik nie jest większy niż `255`, bo na taką wartość pozwala nam rejest. W moim przypadku jest to liczba `416 664`, zaś dzieląc ją przez `24` otrzymujemy `17 361`. Od maksymalnej liczby odejmuję umieszczoną w rejestrze wartość, czyli: `65 535 - 17 361 = 48 174`. Pozostaje zamienić ją na postać szesnastkową tj. `BC2E`. `BC` wpisujemy do `TH0`, zaś `2E` do `TL0`. Implementacja tego zadania została umieszczona poniżej:
```asm
org 0x00;
    JMP init;
org 0x0B;
    JMP irq;
org 0x30;
init:
    MOV TMOD, #0x01; określenie pracy timera T0 jako 16-bitowy
    MOV TH0, #0xBC; ustawienie wartości bardziej znaczącego bajta timera
    MOV TL0, #0x2E; ustawienie wartości mniej znaczącego bajta timera
    MOV R0, #24; wpisanie do rejestru R0 wartości 24 (dec) - adresowanie natychmiastowe (#)
    SETB EA; zezwolenie na globalne przerwania
    SETB ET0; zezwolenie na przerwania pochodzące od timera T0
    SETB TR0; dołączenie sygnału do timera T0
main:
    JMP main;
irq:
    MOV TH0, #0xBC; ustawienie wartości bardziej znaczącego bajta timera
    MOV TL0, #0x2E; ustawienie wartości mniej znaczącego bajta timera
    DJNZ R0, end; "dekrementuj R0 i skocz do "end" jeśli wynik różny od zera" (2 cykle)
    CPL P1.1; odwórcenie bitu, czyli stanu diody
    MOV R0, #24; wpisanie do rejestru R0 wartości 24 (dec) - adresowanie natychmiastowe (#)
end:
    RETI; powrót z procedury obsługi przerwania

```

### 2.3 - Wypełnienie PWM o współczynniku jednej dziesiątej
Współczynnik wypełnienia wynosi 10%, co oznacza, że przez 90% dioda nie świeci. W labolatorium efekt był zauważalny poniżej 20% lub przy odizolowaniu światła poprzez rzucanie cienia na moduł z diodami.
```asm
org 0x00;
    JMP init
org 0x0B;
    JMP irq;
org 0x30;
init:
    MOV TMOD, #0x01;  określenie pracy timera T0 jako 16-bitowy
    MOV TH0, #0xFC; ustawienie wartości bardziej znaczącego bajta timera
    MOV TL0, #0xED; ustawienie wartości mniej znaczącego bajta timera
    SETB EA; zezwolenie na globalne przerwania
    SETB ET0; zezwolenie na przerwania pochodzące od timera T0
    SETB TR0; dołączenie sygnału do timera T0
    MOV R0, #01; liczba cykli o stanie niskim, które pozostały
    MOV R1, #09; liczba cykli o stanie wysokim, które pozostały
main:
    JMP main;
irq:
    MOV TH0, #0xFC;
    MOV TL0, #0xED;
    DJNZ R0, end;
    MOV A, R1;
    MOV R0, A;
    MOV A, #10; przenoszenie ilości, jakie mają się wykonać
    SUBB A, R0; odejmowanie wskazanego argumentu od zawartości akumulatora
    MOV R1, A;
    CPL P1.1; zmiana stanu diody na przeciwny
end:
    RETI; powrót z procedury obsługi przerwania
```

### 3.1 - Konfiguracja portu szeregowego z wysyłaniem znaku
Zgodnie z poleceniem program ten powinien wysyłać znak przy prędkości transmisji równej 4800 [bit/sek] oraz dla ustawienia SMOD równego 1. Poniżej zaimplementowałem wysyłanie wielkiej litery A bez mechanizmu przerwań, a przy udziale pętli zagnieżdżonych.
```asm
org 0x00;
    JMP init;
org 0x30;
init:
    MOV PCON, #0x80; ustawienie SMOD (najstarszego bitu PCON) na wartość 1
    MOV SCON, #0x50; ustawienie REN = 1 - uaktywnienie odbiornika
    MOV TMOD, #0x20; ustawienie drugiego trybu timera - zegara z przeładowaniem
    MOV TH1, #0xF5; prędkość transmisji 4800 [bit/sek]
    MOV TL1, #0xF5; prędkość transmisji 4800 [bit/sek]
    SETB TR1; uruchomienie licznika
main:
    MOV SBUF,#0x41; wysłanie kodu ASCII litery A
    MOV R1, #255; poniżej pętle zagnieżdżone
loop1:
    MOV R0, #255;
loop2:
    DJNZ R0, loop2;
    DJNZ R1, loop1;
    JMP main;
RET; powrót z procedury (podprogramu)
end;

```

### 3.2 - Konfiguracja PS z wysłaniem znaku w oparciu o przerwania
Chcąc wyjaśnić dobór wartości `TH1` i `TL1` w tym przykładzie i programie 3.1 muszę nadmienić, że wykorzystałem pierwszy tryb asynchroniczny zapewniający transmisję w oparciu o wzór: `F = ((2 ^ SMOD) * (FOSC)) / (32 * 12 * (256 - TH1))`.
```asm
org 0x00;
    JMP init;
org 0x23;
    JMP irq;
org 0x30;
init:
    MOV PCON, #0x80; ustawienie SMOD (najstarszego bitu PCON) na wartość 1
    MOV SCON, #0x50; ustawienie REN = 1 - uaktywnienie odbiornika
    MOV TMOD, #0x20; ustawienie drugiego trybu timera - zegara z przeładowaniem
    MOV TH1, #0xF5; prędkość transmisji 4800 [bit/sek]
    MOV TL1, #0xF5; prędkość transmisji 4800 [bit/sek]
    SETB TR1; uruchomienie licznika
    SETB EA; zezwolenie na globalne przerwania
    SETB ES; zezwolenie na przerwania z portu szeregowego
    SETB REN; uaktywnienie odbiornika
    CLR RI; wyczyszczenie znacznika przerwania odbiornika
    SETB TI; ustawienie znacznika przerwania nadajnika - programowe wywołanie pierwszego przerwania
main:
    JMP main; ponowne wykonanie głównego programu
irq:
    JNB RI, zero; skocz do etykiety "zero" jeśli bit zerowy - sprawdzenie rodzaju przerwania
    CLR RI; wyczyszczenie znacznika przerwania odbiornika
zero:
    JNB TI, irq; skocz do etykiety "irq" jeśli bit zerowy
    CLR TI; wyczyszczenie znacznika przerwania nadajnika
    MOV SBUF, #0x40; wysłanie kodu ASCII znaku @
    RETI; powrót z procedury obsługi przerwania
end;
```

### 3.3 - Echo
Działanie programu polega na wysłaniu znaku z klawiatury i odbiorze go przez mikrokontroler.
```asm
org 0x00;
    JMP init;
org 0x23;
    JMP irq;
org 0x30;
init:
    MOV PCON, #0x80; ustawienie SMOD (najstarszego bitu PCON) na wartość 1
    MOV SCON, #0x50; ustawienie REN = 1 - uaktywnienie odbiornika
    MOV TMOD, #0x20; ustawienie drugiego trybu timera - zegara z przeładowaniem
    MOV TH1, #0xF5; prędkość transmisji 4800 [bit/sek]
    MOV TL1, #0xF5; prędkość transmisji 4800 [bit/sek]
    SETB TR1; uruchomienie licznika
    SETB EA; zezwolenie na globalne przerwania
    SETB ES; zezwolenie na przerwania z portu szeregowego
    SETB REN; uaktywnienie odbiornika
    CLR RI; wyczyszczenie znacznika przerwania odbiornika
    SETB TI; ustawienie znacznika przerwania nadajnika - programowe wywołanie pierwszego przerwania
main:
    JMP main; ponowne wykonanie głównego programu
irq:
    JNB RI, zero; skocz do etykiety "zero" jeśli bit zerowy - sprawdzenie rodzaju przerwania
    CLR RI; wyczyszczenie znacznika przerwania odbiornika
    MOV SBUF, A; wysłanie kodu ASCII wpisanego znaku
    MOV A, SBUF; odbiór zapamiętanego kodu ASCII przez mikrokontroler
zero:
    JNB TI, irq; skocz do etykiety "irq" jeśli bit zerowy
    CLR TI; wyczyszczenie znacznika przerwania nadajnika
    RETI; powrót z procedury obsługi przerwania
end;
```

### 3.4 - Echo wybiórcze
W odniesieniu do przykładu 3.3 program został wzbogacony o filtrowanie znaków tzn. transmisja danych w obie strony przebiega wyłącznie dla małych liter łacińskiego alfabetu [a-z].
```asm
org 0x00;
    JMP init;
org 0x23;
    JMP irq;
org 0x30;
init:
    MOV PCON, #0x80; ustawienie SMOD (najstarszego bitu PCON) na wartość 1
    MOV SCON, #0x50; ustawienie REN = 1 - uaktywnienie odbiornika
    MOV TMOD, #0x20; ustawienie drugiego trybu timera - zegara z przeładowaniem
    MOV TH1, #0xF5; prędkość transmisji 4800 [bit/sek]
    MOV TL1, #0xF5; prędkość transmisji 4800 [bit/sek]
    SETB TR1; uruchomienie licznika
    SETB EA; zezwolenie na globalne przerwania
    SETB ES; zezwolenie na przerwania z portu szeregowego
    SETB REN; uaktywnienie odbiornika
    CLR RI; wyczyszczenie znacznika przerwania odbiornika
    CLR TI; wyczyszczenie znacznika przerwania nadajnika
main:
    JMP main;
irq:
    JB RI, range_a; skocz do "range_a" gdy bit ustawiony
    CLR TI;
    RETI;
range_a:
    CLR RI; wyczyszczenie znacznika przerwania odbiornika
    MOV A, SBUF; odbiór zapamiętanego kodu ASCII przez mikrokontroler
    CJNE A, #0x61, range_z; porównaj argumenty A i "a" i skocz do "range_z" gdy nie są równe
    MOV SBUF, A; wysłanie kodu ASCII wpisanego znaku
    CLR TI;
    RETI;
range_z:
    JC stop; skocz do "stop" jeśli jest przeniesienie
    CJNE A, #0x7A, exit; porównaj argumenty A i "z" i skocz do "exit" gdy nie są równe
    MOV SBUF, A; wysłanie kodu ASCII wpisanego znaku
    CLR TI;
    RETI;
exit:
    JNC stop; skocz do "stop" jeśli nie ma przeniesienia
    CLR TI;
    MOV SBUF, A; wysłanie kodu ASCII wpisanego znaku
    RETI;
stop:
    RETI;
end;
```
## Dodatek - STM32
Gwoli uproszczenia kodu dla płytki Nucleo STM32F411 wszystkie potrzebne modyfikacje umieszczałem wewnątrz plików `main.c` i to właśnie ich fragmenty, odpowiadające za pożądane funkcjonalności umieściłem w sprawozdaniu.  

### 4.1 - Plik główny dla wyświetlacza
Poniższy fragment pliku `main.c` został wzbogacony (po skonfigurowaniu i wygenerowaniu kodu przez platformę STM32CubeMX) o kolejno w kodzie: zmienne określające stan licznika i cztery kolejno wyświetlane cyfry, funkcję konwertującą cyfrę na aktywowane segmenty, funkcję zmieniającą wyświetlacz co 3 [ms], a także funkcję odpowiadającą za obsługę licznika (inkrementowanie wartości). Sam koncept jest identyczny jak dla programu 3.3 z I części sprawozdania dotyczącej języka VHDL. Wykorzystany został timer nr 9.
```c
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stm32f4xx_hal.h"

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private variables ---------------------------------------------------------*/
TIM_HandleTypeDef htim9;

/* USER CODE BEGIN PV */
/* Private variables ---------------------------------------------------------*/
int counter0 = 0;
int counter1 = 0;
int counter2 = 0;
int counter3 = 0;
int counter4 = 0;
int number1 = 0;
int number2 = 0;
int number3 = 0;
int number4 = 0;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_TIM9_Init(void);

/* USER CODE BEGIN PFP */
/* Private function prototypes -----------------------------------------------*/
void convert(int number) {
	switch(number) {
	case 0:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 1:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 2:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 3:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 4:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 5:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 6:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 7:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 8:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	case 9:
		HAL_GPIO_WritePin(SEG_A_GPIO_Port, SEG_A_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_B_GPIO_Port, SEG_B_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_C_GPIO_Port, SEG_C_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_D_GPIO_Port, SEG_D_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_E_GPIO_Port, SEG_E_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(SEG_F_GPIO_Port, SEG_F_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(SEG_G_GPIO_Port, SEG_G_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(DP_GPIO_Port, DP_Pin, GPIO_PIN_RESET);
		break;
	}
}

void HAL_SYSTICK_Callback() {
	counter0++;
	if (counter0 < 3) {
		HAL_GPIO_WritePin(COM1_GPIO_Port, COM1_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(COM2_GPIO_Port, COM2_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM3_GPIO_Port, COM3_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM4_GPIO_Port, COM4_Pin, GPIO_PIN_SET);
		convert(number1);
	} else if (counter0 < 6) {
		HAL_GPIO_WritePin(COM1_GPIO_Port, COM1_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM2_GPIO_Port, COM2_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(COM3_GPIO_Port, COM3_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM4_GPIO_Port, COM4_Pin, GPIO_PIN_SET);
		convert(number2);
	} else if (counter0 < 9) {
		HAL_GPIO_WritePin(COM1_GPIO_Port, COM1_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM2_GPIO_Port, COM2_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM3_GPIO_Port, COM3_Pin, GPIO_PIN_RESET);
		HAL_GPIO_WritePin(COM4_GPIO_Port, COM4_Pin, GPIO_PIN_SET);
		convert(number3);
	} else if (counter0 < 12) {
		HAL_GPIO_WritePin(COM1_GPIO_Port, COM1_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM2_GPIO_Port, COM2_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM3_GPIO_Port, COM3_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(COM4_GPIO_Port, COM4_Pin, GPIO_PIN_RESET);
		convert(number4);
	} else
		counter0 = 0;
}

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim) {
	if (htim->Instance == TIM9) {
		number1++;
		if (number1 == 10)
			number1 = 0;
		counter2++;
		if (counter2 == 0) {
			counter2 = 0;
			number2++;
			if (number2 == 6)
				number2 = 0;
		}
		counter3++;
		if (counter3 == 60) {
			counter3 = 0;
			number3++;
			if (number3 == 10)
				number3 = 0;
		}
		counter4++;
		if (counter4 == 600) {
			counter4 = 0;
			number4++;
			if (number4 == 6)
				number4 = 0;
		}
	}
}
/* USER CODE END PFP */

/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration----------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_TIM9_Init();

  /* USER CODE BEGIN 2 */
  HAL_TIM_Base_Start_IT(&htim9);
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
  /* USER CODE END WHILE */

  /* USER CODE BEGIN 3 */

  }
  /* USER CODE END 3 */

}
```

### 4.2 - Plik główny dla portu szeregowego
Poniższy fragment pliku `main.c` został wzbogacony (po skonfigurowaniu i wygenerowaniu kodu przez platformę STM32CubeMX) o zmienne umożliwiające transmisję danych. W ćwiczeniu wykorzystano timer nr 9 oraz nadawanie danych z UART za pomocą DMA (Direct Memory Access) tj. bezpośredniego dostępu do pamięci.
```c
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "stm32f4xx_hal.h"

/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Private variables ---------------------------------------------------------*/
ADC_HandleTypeDef hadc1;

TIM_HandleTypeDef htim9;

UART_HandleTypeDef huart2;
DMA_HandleTypeDef hdma_usart2_tx;
DMA_HandleTypeDef hdma_usart2_rx;

/* USER CODE BEGIN PV */
/* Private variables ---------------------------------------------------------*/
int volume = 0;
uint8_t posted[9];
uint8_t received;
uint16_t size = 0;
/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
static void MX_GPIO_Init(void);
static void MX_DMA_Init(void);
static void MX_TIM9_Init(void);
static void MX_USART2_UART_Init(void);
static void MX_ADC1_Init(void);

/* USER CODE BEGIN PFP */
/* Private function prototypes -----------------------------------------------*/
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc) {
	volume = HAL_ADC_GetValue(&hadc1);
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
	size = sprintf( (char * ) posted,  "1, %d", volume);
	HAL_UART_Transmit_DMA(&huart2, posted, size);
}
/* USER CODE END PFP */

/* USER CODE BEGIN 0 */

/* USER CODE END 0 */

int main(void)
{

  /* USER CODE BEGIN 1 */

  /* USER CODE END 1 */

  /* MCU Configuration----------------------------------------------------------*/

  /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
  HAL_Init();

  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* Configure the system clock */
  SystemClock_Config();

  /* USER CODE BEGIN SysInit */

  /* USER CODE END SysInit */

  /* Initialize all configured peripherals */
  MX_GPIO_Init();
  MX_DMA_Init();
  MX_TIM9_Init();
  MX_USART2_UART_Init();
  MX_ADC1_Init();

  /* USER CODE BEGIN 2 */
  HAL_ADC_Start_IT(&hadc1);
  HAL_UART_Receive_DMA(&huart2, &received, 1);
  /* USER CODE END 2 */

  /* Infinite loop */
  /* USER CODE BEGIN WHILE */
  while (1)
  {
  /* USER CODE END WHILE */

  /* USER CODE BEGIN 3 */

  }
  /* USER CODE END 3 */

}
```