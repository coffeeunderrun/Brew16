unit Interrupts;

interface

procedure Initialize;

var
    TimerTicked: Boolean;

implementation

uses PIC;

const
    AccessPresent  = %10000000;
    AccessRing0    = %00000000;
    AccessRing3    = %01100000;
    AccessTaskGate = %00000101;
    AccessIntGate  = %00000110;
    AccessTrapGate = %00000111;

var
    IDT: array [0..255] of record
        Offset: Word;
        Selector: Word;
        Reserved1: Byte;
        Access: Byte;
        Reserved2: Word;
    end absolute SysSelector:$0;

procedure TimerHandler; assembler; nostackframe;
asm
    mov     byte [TimerTicked], 1
    push    word 0
    call    PIC.EndOfInterrupt
    iret
end;

procedure Initialize;
var
    IDTR: record
        Limit: Word;
        Base: DWord;
    end;
    I: SizeUInt;
begin
    PIC.Initialize;

    { TODO: System memory methods, e.g. FillByte, do not allow specifying a selector.
            I should add some methods to support 16-bit protected mode memory operations. }
    for I := 0 to SizeOf(IDT) do Mem[SysSelector:I] := 0;

    IDT[32].Selector := CodeSelector;
    IDT[32].Offset := Word(@TimerHandler);
    IDT[32].Access := AccessPresent or AccessRing0 or AccessIntGate;

    IDTR.Limit := SizeOf(IDT) - 1;
    IDTR.Base := 0;
    asm
        lidt [IDTR]
        sti
    end;
end;

end.
