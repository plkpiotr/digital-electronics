org 0x00;
    JMP init
org 0x0B;
    JMP irq;
org 0x30;
init:
    MOV TMOD, #0x01;
    MOV TH0, #0xFC;
    MOV TL0, #0xED;
    SETB EA;
    SETB ET0;
    SETB TR0;
    MOV R0, #01;        - liczba cykli o stanie niskim, które pozostały
    MOV R1, #09;        - liczba cykli o stanie wysokim, które pozostały
main:
    JMP main;
irq:
    MOV TH0, #0xFC;
    MOV TL0, #0xED;
    DJNZ R0, end;
    MOV A, R1;
    MOV R0, A;
    MOV A, #10;            - przenoszenie ilości, jakie mają się wykonać
    SUBB A, R0;            - odejmowanie
    MOV R1, A;
    CPL P1.1;            - zmiana stanu diody na przeciwny
end:
    RETI;
