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
    LED <= SW;
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
Prosty licznik binarny napisany od zera na drugich zajęciach. Do jego realizacji potrzebowaliśmy sygnału `cnt`, którego rozmiar (u mnie 27 bitów) odpowiadała za zliczanie z częstotliwością jak najbardziej zbliżoną do 1 [Hz]. Zależność ta wynika z ilorazu 100 [Mhz] tzn. częstotliwości wbudowanej i `2^(n+1)`, którego wynikiem jest 1 [Hz], a szukaną wartością `n`. Warto zaznaczyć, że w kodzie zaczęła pojawiać się instrukcja `use IEEE.STD_LOGIC_UNSIGNED.ALL;` umożliwiająca "dodawanie" jedynki do słowa binarnego.
```vhdl
Kod źródłowy
```
### 2.3 - Licznik binarny z prescalerem
Opis
```vhdl
Kod źródłowy
```
### 2.4 - Licznik binarny z resetem
Opis
```vhdl
Kod źródłowy
```
### 3.1 - Dynamiczne wyświetlanie czterech znaków
Opis
```vhdl
Kod źródłowy
```
### 3.2 - Dynamiczne wyświetlanie dzięki procedurze przekodowania
Opis
```vhdl
Kod źródłowy
```
### 3.3 - Licznik uruchamiany na czterech segmentach
Opis
```vhdl
Kod źródłowy
```
# Sprawozdanie z elektroniki cyfrowej - część II
## Programowanie mikrokontrolerów

## Piotr Pałka - poniedziałek 9:30, podgrupa 2
Dokument ten zawiera podsumowanie zajęć elektroniki cyfrowej z części dotyczącej języka Assembly oraz języka C. Każdy z umieszczonych niżej programów został opatrzony nagłówkiem składającym się kolejno z: numeru zajęć odnoszących się do mikrokontrolera 8051 lub STM32, numeru określającego kolejność wykonania programu na zajęciach oraz jego tytuł. Każdy z programów zawiera krótki opis zawierający wnioski i przemyślenia oraz tam gdzie było to niezbędne zamieściłem komentarze bezpośrednio w kodzie.

### 1.1 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 1.2 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 1.3 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 2.1 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 2.2 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 2.3 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 3.1 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 3.2 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 3.3 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 3.4 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 4.1 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```

### 4.2 - Przykładowy program zapalający wybrane diody
Opis
```asm
Kod źródłowy
```