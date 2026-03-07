unit System;

{$implicitexceptions off}

interface

{$define FPC_SYSTEM_HAS_STACKTOP}

{$define FPC_IS_SYSTEM}

{$define DISABLE_NO_THREAD_MANAGER}
{ Do not use standard memory manager }
{$define HAS_MEMORYMANAGER}
{$define FPC_NO_DEFAULT_HEAP}

{$define FPC_ANSI_TEXTFILEREC}

{ make output and stdout as well as input and stdin equal to save memory }
{$define FPC_STDOUT_TRUE_ALIAS}

{$define FPC_INCLUDE_SOFTWARE_MUL}
{$define FPC_INCLUDE_SOFTWARE_MOD_DIV}

{$I systemh.inc}

const
    LineEnding = #10;
    DefaultTextLineBreakStyle: TTextLineBreakStyle = tlbsCrLF;
    CtrlZMarksEOF: Boolean = false; (* #26 not considered as end of file *)

    DirectorySeparator = '/';
    AllowDirectorySeparators: set of AnsiChar = ['\', '/'];
    AllowDriveSeparators: set of AnsiChar = [':'];

    UnusedHandle    = -1;
    StdInputHandle  = 0;
    StdOutputHandle = 1;
    StdErrorHandle  = 2;

    SysSelector  = $8;
    CodeSelector = $10;
    DataSelector = $18;
    VMemSelector = $20;

    extra_param_offset = 0;
    extra_data_offset  = 0;

    SelectorInc: Word = $8; // GDT entries are 8 bytes

var
    Mem: array [0..$7FFF - 1] of Byte absolute $0:$0;
    MemW: array [0..($7FFF div SizeOf(Word)) - 1] of Word absolute $0:$0;
    MemL: array [0..($7FFF div SizeOf(LongInt)) - 1] of LongInt absolute $0:$0;

implementation

var
    __stktop: record end; external name '_stack_top';
    __stkbottom: record end; external name '_stack_bottom';

{$define FPC_SYSTEM_EXIT_NO_RETURN}
{$I system.inc}

function StackTop: pointer;
begin
    StackTop := @__stktop;
end;

procedure system_exit; noreturn; external name '_halt';

end.
