org 0x00;
    JMP init;
org 0x30;
init:
    MOV PCON, #0x80;
    MOV SCON, #0x50;
    MOV TMOD, #0x20;
    MOV TH1, #0xF5; zgodnie ze wzorem 245
    MOV TL1, #0xF5;
    SETB TR1;
main:
    MOV SBUF,#0x41; litera A
    MOV R1, #255; można w CALL
loop1:
    MOV R0, #255;
loop2:
    DJNZ R0, loop2;
    DJNZ R1, loop1;
    JMP main;
RET;
end;
