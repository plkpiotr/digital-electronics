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
