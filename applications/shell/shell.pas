program Shell;

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
    WriteStr('Shell called.'#10#13);
end.
