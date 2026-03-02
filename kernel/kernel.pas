program Kernel;

procedure SetVideoMode(Mode: Byte); register; assembler; nostackframe; inline;
asm
    xor ah, ah
    int $10
end;

procedure WriteChar(C: Char); register; assembler; nostackframe; inline;
asm
    mov ah, $0E
    int $10
end;

procedure WriteStr(Str: PChar); assembler;
asm
    push si
    mov si, Str
    mov ah, $0E
@loop:
    lodsb
    or al, al
    jz @done
    int $10
    jmp @loop
@done:
    pop si
end;

begin
    SetVideoMode($03);
    WriteStr('Brew16 kernel loaded.'#10#13);
    while true do;
end.
