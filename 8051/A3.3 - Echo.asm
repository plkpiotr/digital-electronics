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
