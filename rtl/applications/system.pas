unit System;

interface

{$define FPC_IS_SYSTEM}
{$define HAS_MEMORYMANAGER}
{$DEFINE FPC_INCLUDE_SOFTWARE_MUL}
{$DEFINE FPC_INCLUDE_SOFTWARE_MOD_DIV}
{$DEFINE FPC_USE_SMALL_DEFAULTSTACKSIZE}
{$define FPC_ANSI_TEXTFILEREC}

{$I systemh.inc}
{$I tnyheaph.inc}
{$I portsh.inc}

const
  LineEnding = #13#10;
  DirectorySeparator = '\';
  DriveSeparator = ':';
  ExtensionSeparator = '.';
  PathSeparator = ';';
  AllowDirectorySeparators : set of AnsiChar = ['\', '/'];
  AllowDriveSeparators : set of AnsiChar = [':'];
  maxExitCode = 255;
  MaxPathLen = 256;

  UnusedHandle    = $ffff;
  StdInputHandle  = 0;
  StdOutputHandle = 1;
  StdErrorHandle  = 2;

  FileNameCaseSensitive : boolean = false;
  FileNameCasePreserving: boolean = false;
  CtrlZMarksEOF: boolean = true;

  sLineBreak = LineEnding;
  DefaultTextLineBreakStyle : TTextLineBreakStyle = tlbsCRLF;

  SelectorInc: Word = $1000;

var
  Mem : array [0..$7FFF - 1] of Byte absolute $0:$0;
  MemW : array [0..($7FFF div SizeOf(Word)) - 1] of Word absolute $0:$0;
  MemL : array [0..($7FFF div SizeOf(LongInt)) - 1] of LongInt absolute $0:$0;

implementation

const
  extra_param_offset = 0;
  extra_data_offset = 0;

var
  __stktop : pointer; public name '__stktop';
  __stkbottom : pointer; public name '__stkbottom';
  __nearheap_start: pointer; public name '__nearheap_start';
  __nearheap_end: pointer; public name '__nearheap_end';

{$I system.inc}
{$I tinyheap.inc}
{$I ports.inc}

procedure system_exit; external name '_exit';

Procedure ChDir(const s:shortstring);
begin
end;

Procedure MkDir(const s:shortstring);
begin
end;

Procedure RmDir(const s:shortstring);
begin
end;

Procedure GetDir(drivenr:byte;var dir:shortstring);
begin
end;

end.
