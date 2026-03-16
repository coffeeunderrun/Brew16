unit PIC;

interface

procedure Initialize;

procedure EndOfInterrupt(IRQ: Byte);

implementation

const
    PIC1_CONTROL = $20;
    PIC1_DATA    = $21;
    PIC2_CONTROL = $A0;
    PIC2_DATA    = $A1;

procedure Initialize;
begin
    // Begin initialization, ICW4 needed
    Port[PIC1_CONTROL] := $11;
    Port[PIC2_CONTROL] := $11;

    // Remap PIC1 vectors to 0x20-0x27
    Port[PIC1_DATA] := $20;

    // Remap PIC2 vectors to 0x28-0x2F
    Port[PIC2_DATA] := $28;

    // Inform PIC1 that PIC2 is connected to IRQ2
    Port[PIC1_DATA] := $04;

    // Inform PIC2 to cascade through IRQ2 on PIC1
    Port[PIC2_DATA] := $02;

    // Environment 8086 mode
    Port[PIC1_DATA] := $01;
    Port[PIC2_DATA] := $01;

    // Mask all PIC1 IRQs, except PIT
    Port[PIC1_DATA] := %11111110;

    // Mask all PIC2 IRQs
    Port[PIC2_DATA] := %11111111;
end;

procedure EndOfInterrupt(IRQ: Byte);
begin
    if IRQ >= 16 then exit;
    if IRQ >= 8 then Port[PIC2_CONTROL] := $20;
    Port[PIC1_CONTROL] := $20
end;

end.
