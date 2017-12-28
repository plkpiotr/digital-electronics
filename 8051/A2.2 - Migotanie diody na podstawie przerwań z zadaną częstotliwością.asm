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
