unit System;

{$POINTERMATH OFF}

interface

type
    DWord    = LongWord;
    Cardinal = LongWord;
    Integer  = SmallInt;
    HResult  = Cardinal;

    PChar = ^Char;
    Char = AnsiChar;

    TExceptAddr = record end;

    TGuid = packed record case Integer of
        1: (
            Data1: DWord;
            Data2: Word;
            Data3: Word;
            Data4: array [0..7] of Byte;
        );
        2: (
            D1: DWord;
            D2: Word;
            D3: Word;
            D4: array [0..7] of Byte;
        );
        3: (
            time_low: DWord;
            time_mid: Word;
            time_hi_and_version: Word;
            clock_seq_hi_and_reserved: Byte;
            clock_seq_low: Byte;
            node: array [0..5] of Byte;
        );
    end;

    jmp_buf = packed record
        bp,sp: Word;
        ip: Word;
    end;

    FileRec = record end;
    TextRec = record end;

    TTypeKind = (tkUnknown,tkInteger,tkChar,tkEnumeration,tkFloat,
                tkSet,tkMethod,tkSString,tkLString,tkAString,
                tkWString,tkVariant,tkArray,tkRecord,tkInterface,
                tkClass,tkObject,tkWChar,tkBool,tkInt64,tkQWord,
                tkDynArray,tkInterfaceRaw,tkProcVar,tkUString,tkUChar,
                tkHelper,tkFile,tkClassRef,tkPointer);

var
  Mem : array [0..$7FFF - 1] of Byte absolute $0:$0;
  MemW : array [0..($7FFF div SizeOf(Word)) - 1] of Word absolute $0:$0;
  MemL : array [0..($7FFF div SizeOf(LongInt)) - 1] of LongInt absolute $0:$0;

const
    ExtraParamOffset = 0;
    MaxSmallint = 32767;

procedure fpc_initializeunits; compilerproc; public name 'FPC_INITIALIZEUNITS';
procedure fpc_do_exit; compilerproc; public name 'FPC_DO_EXIT';

function Ptr(Seg, Off: Word): FarPointer; inline;

implementation

procedure fpc_initializeunits; assembler; nostackframe; compilerproc;
asm
end;

procedure fpc_do_exit; assembler; nostackframe; compilerproc;
asm
end;

function Ptr(Seg, Off: Word): FarPointer; assembler; nostackframe;
asm
    mov si, sp
    mov ax, ss:[si + 2 + ExtraParamOffset] // Offset
    mov dx, ss:[si + 4 + ExtraParamOffset] // Segment
end;

end.
