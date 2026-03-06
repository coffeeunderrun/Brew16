program Kernel;

procedure WriteStr(C: PChar);
var
    Offset: Word;
begin
    Offset := 0;
    while C^ <> #0 do begin
        Mem[$B800:Offset] := Ord(C^);
        Mem[$B800:Offset + 1] := $4F;
        Inc(Offset, 2);
        Inc(C);
    end;
end;

begin
    WriteStr('Brew16 kernel loaded!');
end.
