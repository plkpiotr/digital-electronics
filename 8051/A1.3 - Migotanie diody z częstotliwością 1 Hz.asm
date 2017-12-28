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
    MOV R0, #63; wpisanie do rejestru R0 wartości 63 (dec) - adresowanie natychmiastowe (#)
loop1:
    MOV R1, #63; wpisanie do rejestru R1 wartości 63 (dec) - adresowanie natychmiastowe (#)
loop2:
    MOV R2, #63; wpisanie do rejestru R2 wartości 63 (dec) - adresowanie natychmiastowe (#)
loop3:
    DJNZ R2, loop3; "dekrementuj R0 i skocz do "loop3" jeśli wynik różny od zera" (2 cykle)
    DJNZ R1, loop2; "dekrementuj R1 i skocz do "loop2" jeśli wynik różny od zera" (2 cykle)
    DJNZ R0, loop1; "dekrementuj R2 i skocz do "loop1" jeśli wynik różny od zera" (2 cykle)
    RET; powrót z procedury
