program Kernel;

procedure WriteStr(C: PChar);
var
    Offset: Word;
begin
    Offset := 0;
    while C^ <> #0 do begin
        Mem[VMemSelector:Offset] := Ord(C^);
        Mem[VMemSelector:Offset + 1] := $4F;
        Inc(Offset, 2);
        Inc(C);
    end;
end;

begin
    WriteStr('Brew16 kernel loaded!');
end.
