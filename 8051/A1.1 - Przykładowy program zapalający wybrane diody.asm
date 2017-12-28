ORG 0;
    LJMP start;
ORG 100h; instrukcja informująca o uruchomieniu właściwego programu spod adresu 100 (16), 256 (10)
start:
    MOV P0, #0x00; binarnie: 0000 0000 - wszystkie diody świecą w module 1
    MOV P1, #0x55; binarnie: 0101 0101 - co druga dioda świeci w module 2
    MOV P2, #0xF0; binarnie: 1111 0000 - kolejne cztery diody świecą, kolejne cztery nie w module 3
    MOV P3, #0xC3; binarnie: 1100 0011 - po dwie krańcowe diody świecą w module 4
loop:
    LJMP loop; pętla "nieskończona" zapewniająca bezpieczną pracę po zapaleniu diod
end;
