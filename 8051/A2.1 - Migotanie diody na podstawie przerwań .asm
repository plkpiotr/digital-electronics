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
    CPL P1.1; odwrócenie bitu, czyli stanu diody
    RETI; powrót z procedury obsługi przerwania
