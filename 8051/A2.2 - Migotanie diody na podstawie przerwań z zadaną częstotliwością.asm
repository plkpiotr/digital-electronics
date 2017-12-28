org 0x00;
    JMP init;
org 0x0B;
    JMP irq;
org 0x30;
init:
    MOV TMOD, #0x01;
    MOV TH0, #0xBC;
    MOV TL0, #0x2E;
    MOV R0, #24;
    SETB EA;
    SETB ET0;
    SETB TR0;
main:
    JMP main;
irq:
    MOV TH0, #0xBC;
    MOV TL0, #0x2E;
    DJNZ R0, end;
    CPL P2.1;
    MOV R0, #24;
end:
    RETI;
