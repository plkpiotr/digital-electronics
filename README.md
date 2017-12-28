# Sprawozdanie z elektroniki cyfrowej - część I
## Programowanie FPGA

## Piotr Pałka - poniedziałek 9:30, podgrupa 2
Dokument ten zawiera podsumowanie zajęć elektroniki cyfrowej z części dotyczącej języka VHDL. Każdy z umieszczonych niżej programów został opatrzony nagłówkiem składającym się kolejno z: numeru zajęć odnoszących się do bezpośrednio programowalnej macierzy bramek, numeru określającego kolejność wykonania programu na zajęciach oraz jego tytuł. Tam gdzie było to niezbędne dodany został również opis programu zawierający wnioski oraz komenatrze zamieszczone bezpośrednio w poszczególnych fragmentach kodu.

### 1.1 - Konfiguracja wstępna
Pierwszą czynnością na stanowisku z płytką FPGA było stworzenia projektu w środowisku programistycznym Vivado zgodnie z konspektem zamieszczonym na platformie uczelnianej UPEL. Niezbędnym plikiem do obsługi programowalnej macierzy bramek był plik `Nexys4DDR_Master.xdc` umożliwiający nam określenie, z których elementów będziemy korzystać. Poniżej zamieściłem fragment niezmodyfikowanego, wyżej wspomnianego pliku.
```bash
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { CA }]; #IO_L24N_T3_A00_D16_14 Sch=ca
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
#set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { SEG[0] }]; #IO_L24N_T3_A00_D16_14 Sch=ca
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { SEG[1] }]; #IO_25_14 Sch=cb
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { SEG[2] }]; #IO_25_15 Sch=cc
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { SEG[3] }]; #IO_L17P_T2_A26_15 Sch=cd
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { SEG[4] }]; #IO_L13P_T2_MRCC_14 Sch=ce
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { SEG[5] }]; #IO_L19P_T3_A10_D26_14 Sch=cf
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { SEG[6] }]; #IO_L4P_T0_D04_14 Sch=cg

set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { SEG[7] }]; #IO_L19N_T3_A21_VREF_15 Sch=dp
```
### 1.3 - Uzależnienie diód od switchy
Pierwszym zadaniem na zajęciach było uzależnienie diód od switchy, w taki sposób by stan kolejnych przełączników definiowały świecenie odpowiadających im diód. Dzięki równoległemu programowaniu przerzucamy po prostu wartość słowa `SW` na wartość słowa `LED`.
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
Opis
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity displayOne is
    Port (SEG : inout STD_LOGIC_VECTOR (7 downto 0);
          AN : inout STD_LOGIC_VECTOR (7 downto 0));
end displayOne;

architecture behavioral of displayOne is
begin
    SEG <= "11111001"; -- komentarz :)
    AN <= "11111110";
end behavioral;
```
### 1.5 - Układ bramek logicznych
Opis
```vhdl
Kod źródłowy
```
### 2.1 - Licznik binarny zliczający w górę, w dół do wartości
Opis
```vhdl
Kod źródłowy
```
### 2.2 - Licznik binarny
Opis
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
Dokument ten zawiera podsumowanie zajęć elektroniki cyfrowej z części dotyczącej języka Assembly oraz języka C. Każdy z umieszczonych niżej programów został opatrzony nagłówkiem składającym się kolejno z: numeru zajęć odnoszących się do mikrokontrolera 8051 lub STM32, numeru określającego kolejność wykonania programu na zajęciach oraz jego tytuł. Tam gdzie było to niezbędne dodany został również opis programu zawierający wnioski oraz komenatrze zamieszczone bezpośrednio w poszczególnych fragmentach kodu.

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