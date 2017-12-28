org 0x00;
    JMP init;
org 0x23;
    JMP irq;
org 0x30;
init:
    SETB EA;
    SETB ES;
    SETB REN;
    MOV PCON, #0x80;
    MOV SCON, #0x50;
    MOV TMOD, #0x20;
    MOV TH1, #0xF5; zgodnie ze wzorem 245
    MOV TL1, #0xF5;
    SETB TR1;
    CLR RI;
    SETB TI;
main:
    JMP main;
irq:
    JNB RI, zero;
    CLR RI;
    MOV SBUF, A; znak z klawiatury
    MOV A, SBUF;
zero:
    JNB TI, irq;
    CLR TI;
    RETI;
end;
