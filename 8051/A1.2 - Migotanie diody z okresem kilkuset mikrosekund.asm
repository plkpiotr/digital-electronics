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
    MOV R0, #200;
loop:
    DJNZ R0, loop;
    RET;

