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
    DJNZ R0, loop; dekrementuj R0 i skocz do "loop" jeśli wynik różny od zera (2 cykle)
    RET; powrót z procedury
