unit Shell;

interface

implementation

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

procedure Main; public name '_main';
begin
    WriteStr('Shell called.'#10#13);
end;

end.
