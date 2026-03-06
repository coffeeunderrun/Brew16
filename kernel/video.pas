unit Video;

interface

procedure SetVideoMode(Mode: Byte); register; inline;

procedure WriteChar(C: Char); register; inline;

procedure WritePChar(Str: PChar);

procedure WriteString(const Str: String); inline;

implementation

procedure SetVideoMode(Mode: Byte); register; assembler; nostackframe;
asm
    xor     ah, ah
    int     $10
end;

procedure WriteChar(C: Char); register; assembler; nostackframe;
asm
    mov     ah, $0E
    int     $10
end;

procedure WritePChar(Str: PChar); assembler;
asm
    push    si
    mov     si, Str
    mov     ah, $0E
@loop:
    lodsb
    or      al, al
    jz      @done
    int     $10
    jmp     @loop
@done:
    pop     si
end;

procedure WriteString(const Str: String);
var
    C: Char;
begin
    for C in Str do WriteChar(C);
end;

end.
