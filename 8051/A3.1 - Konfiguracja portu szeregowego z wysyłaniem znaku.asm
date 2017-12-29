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
