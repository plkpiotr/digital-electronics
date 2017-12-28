org 0x00;
    JMP init;
org 0x0B;
    JMP irq;
org 0x30;
init:
    MOV TMOD, #0x01;
    MOV TH0, #0x00;
    MOV TL0, #0x00;
    SETB EA;
    SETB ET0;
    SETB TR0;
main:
    JMP main;
irq:
    CPL P2.1;
    RETI;
