program Kernel;

procedure WriteStr(C: PChar);
var
    Offset: Word;
begin
    Offset := 0;
    while C^ <> #0 do begin
        Mem[VMemSel:Offset] := Ord(C^);
        Mem[VMemSel:Offset + 1] := $4F;
        Inc(Offset, 2);
        Inc(C);
    end;
end;

begin
    WriteStr('Brew16 kernel loaded!');
end.
