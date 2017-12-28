org 0x00;
    JMP main;
org 0x30;
main:
    MOV P1, #0x55;
    CALL wait;
    MOV P1, #0xAA;
    CALL wait;
    JMP main;
wait:
    MOV R0, #63;
loop1:
    MOV R1, #63;
loop2:
    MOV R2, #63;
loop3:
    DJNZ R2, loop3;
    DJNZ R1, loop2;
    DJNZ R0, loop1;
    RET;
