unit Kernel;

interface

implementation

uses Fs.Fat, Video;

type
    TProcedure = procedure;

procedure Main; noreturn; public name '_main';
var
    Shell: TProcedure;
begin
    SetVideoMode($03);
    WriteStr('Brew16 kernel loaded.'#10#13);

    if Fs.Fat.LoadFile('SHELL.BIN', Pointer($500)) <> 0 then
        WriteStr('Shell loaded.'#10#13)
    else
        WriteStr('Failed to load shell.'#10#13);

    Shell := TProcedure(Pointer($500));
    Shell;

    WriteStr('Shell returned.'#10#13);

    while true do;
end;

end.
