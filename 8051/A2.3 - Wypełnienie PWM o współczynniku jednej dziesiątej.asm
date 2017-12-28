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
