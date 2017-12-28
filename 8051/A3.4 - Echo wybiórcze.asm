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
    CLR TI;
    CLR RI;
main:
    JMP main;
irq:
    JB RI, range_a;
    CLR TI;
    RETI;
range_a:
    CLR RI;
    MOV A, SBUF;
    CJNE A, #0x61, range_z; a (ASCII)
    MOV SBUF, A;
    CLR TI;
    RETI;
range_z:
    JC stop;
    CJNE A, #0x7A, exit; z (ASCII)
    MOV SBUF, A;
    CLR TI;
    RETI;
exit:
    JNC stop;
    CLR TI;
    MOV SBUF, A;
    RETI;
stop:
    RETI;
end;
