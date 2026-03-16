program Kernel;

uses Interrupts;

function IntToStr(Value: Byte): String;
begin
    Str(Value, IntToStr);
end;

function IntToStr(Value: Word): String;
begin
    Str(Value, IntToStr);
end;

var
    VMem: array [0..$7FFF] of Byte absolute VMemSelector:0;

procedure WriteStr(Str: String);
var
    Offset: Word;
    Ch: Char;
begin
    Offset := 0;
    for Ch in Str do begin
        VMem[Offset] := Ord(Ch);
        VMem[Offset + 1] := $4F;
        Inc(Offset, 2);
    end;
end;

var
    Counter: Word = 0;

begin
    WriteStr('Brew16 kernel loaded!');
    Interrupts.Initialize;

    while true do begin
        if not Interrupts.TimerTicked then continue;
        Interrupts.TimerTicked := false;
        WriteStr('Timer ticked: ' + IntToStr(Counter));
        Inc(Counter);
    end;
end.
