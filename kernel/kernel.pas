program Kernel;

uses Fs.Fat, Video;

type
    TProcedure = procedure;

procedure Main;
var
    Shell: TProcedure;
begin
    SetVideoMode($03);
    WritePChar('Brew16 kernel loaded.'#10#13);

    if Fs.Fat.LoadFile('SHELL   BIN', Pointer($500)) <> 0 then
        WritePChar('Shell loaded.'#10#13)
    else
        WritePChar('Failed to load shell.'#10#13);

    Shell := TProcedure(Pointer($500));
    Shell;

    WritePChar('Shell returned.'#10#13);
end;

begin
    Main;
    while true do;
end.
