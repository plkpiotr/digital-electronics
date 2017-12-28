ORG 0;
    LJMP start;
ORG 100h;
start:
    MOV P0, #0x00;
    MOV P1, #0x55;
    MOV P2, #0xF0;
    MOV P3, #0xC3;
loop:
    LJMP loop;
end;
