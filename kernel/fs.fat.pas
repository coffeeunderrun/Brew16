unit Fs.Fat;

{$modeswitch advancedrecords}

interface

function LoadFile(const Path: PChar; const DestPtr: Pointer): Byte;

implementation

uses Video;

const
    FileAttrReadOnly  = $01;
    FileAttrHidden    = $02;
    FileAttrSystem    = $04;
    FileAttrVolumeId  = $08;
    FileAttrDirectory = $10;
    FileAttrArchive   = $20;
    FileAttrLongName  = $0F;

    ClusterFree = $000;
    ClusterBad  = $FF7;
    ClusterEnd  = $FF8;

type
    PBiosParameterBlock = ^TBiosParameterBlock;
    TBiosParameterBlock = packed record
        Jump: array [0..2] of Byte;
        OemName: array [0..7] of Char;
        BytesPerSector: Word;
        SectorsPerCluster: Byte;
        ReservedSectors: Word;
        FatCount: Byte;
        RootDirectoryEntryCount: Word;
        LogicalSectorCount: Word;
        MediaDescriptor: Byte;
        SectorsPerFat: Word;
        SectorsPerCylinder: Word;
        HeadCount: Word;
        HiddenSectorCount: DWord;
        LargeSectorCount: DWord;
        DriveNumber: Byte;
        Reserved: Byte;
        Signature: Byte;
        VolumeId: DWord;
        VolumeLabel: array [0..10] of Char;
        FileSystemType: array [0..7] of Char;
    end;

    PDirectoryEntry = ^TDirectoryEntry;
    TDirectoryEntry = packed record
        Name: array [0..7] of Char;
        Extension: array [0..2] of Char;
        Attributes: Byte;
        Reserved: Byte;
        CreationTime10: Byte; // 10ms units
        CreationTime: Word;   // Bits 15-11=hours, 10-5=minutes, 4-0=seconds/2
        CreationDate: Word;   // Bits 15-9=year (since 1980), 8-5=month, 4-0=day
        LastAccessDate: Word;
        FirstClusterHigh: Word;
        LastModifiedTime: Word;
        LastModifiedDate: Word;
        FirstClusterLow: Word;
        FileSize: DWord;
    end;

    TDriveStatus = Byte;

    TDriveContext = record
        DriveNumber: Byte;
        DriveType: Byte;
        CylinderCount: Word;
        SectorsPerTrack: Byte;
        SectorsPerCylinder: Word;
        SideCount: Byte;
        DriveCount: Byte;

        function Initialize(Drive: Byte): TDriveStatus;
        function ReadSectors(Lba: Word; Count: Byte; const BufferPtr: Pointer): Byte;
    end;

var
    Bpb: TBiosParameterBlock;
    DriveCtx: TDriveContext;
    Buffer: array [0..511] of Byte;

function TDriveContext.Initialize(Drive: Byte): TDriveStatus; assembler;
asm
    mov     ah, $08
    mov     dl, Drive
    mov     si, Self                            // Drive context self-pointer
    mov     [si + DriveNumber], dl

    push    es
    int     $13
    pop     es                                  // Int 13h changes ES

    mov     [si + DriveType], bl

    mov     bl, cl                              // Sectors per track in bits 0..5
    and     bl, $3F                             // Mask out bits 6..7
    mov     [si + SectorsPerTrack], bl

    mov     byte [si + CylinderCount], ch       // Lower 8 bits of cylinder count
    and     cl, $C0                             // Upper 2 bits of cylinder count in bits 6..7
    rol     cl, 2                               // Rotate bits 6..7 to 0..1
    mov     byte [si + CylinderCount + 1], cl

    mov     [si + DriveCount], dl
    inc     dh                                  // Side count is zero-based
    mov     [si + SideCount], dh

    mov     cx, ax                              // Save Int 13h return value
    mov     al, dh                              //   Side count
    mul     bl                                  // * Sectors per track
    mov     [si + SectorsPerCylinder], ax
    mov     ax, cx                              // Restore Int 13h return value
end;

function TDriveContext.ReadSectors(Lba: Word; Count: Byte; const BufferPtr: Pointer): Byte; assembler;
asm
    mov     si, Self

    mov     ax, Lba
    xor     dx, dx
    div     word [si + SectorsPerCylinder]
    mov     bx, ax                          // Cylinder = LBA div Sectors per cylinder

    mov     ax, dx                          // Offset = LBA mod Sectors per cylinder
    div     byte [si + SectorsPerTrack]
    mov     dh, al                          // Head = Offset div Sectors per track
    mov     cl, ah
    inc     cl                              // Sector = Offset mod Sectors per track + 1

    mov     ch, bl                          // Lower 8 bits of cylinder
    mov     al, bh                          // Upper 2 bits of cylinder
    and     al, $03                         // Mask out bits 2..7
    shl     al, 6                           // Shift bits 0..1 to 6..7
    and     cl, $3F                         // Mask out bits 6..7
    or      cl, al                          // Combine bits 6..7 of cylinder with sector number

    mov     ah, $02
    mov     al, Count
    mov     bx, BufferPtr
    mov     dl, [si + DriveNumber]
    int     $13
end;

function LoadFile(const Path: PChar; const DestPtr: Pointer): Byte;
var
    Cylinder, Head, Sector: Byte;
    EntryIndex, Cluster: Word;
    RootDirectoryLba, DataRegionLba, FileDataLba: Word;
begin
    with DriveCtx do begin
        if Initialize(0) <> 0 then exit(0);

        if ReadSectors(0, 1, @Buffer) = 0 then exit(0);
        Move(Buffer, Bpb, SizeOf(TBiosParameterBlock));

        RootDirectoryLba := Bpb.ReservedSectors + Bpb.FatCount * Bpb.SectorsPerFat;
        if ReadSectors(RootDirectoryLba, 1, @Buffer) = 0 then exit(0);

        Cluster := 0;
        for EntryIndex := 0 to Bpb.RootDirectoryEntryCount - 1 do with PDirectoryEntry(@Buffer)[EntryIndex] do begin
            if Attributes = 0 then continue;
            if CompareChar(Name[0], Path[0], 11) <> 0 then continue;
            Cluster := FirstClusterLow;
            break;
        end;
        if Cluster = 0 then exit(0);

        DataRegionLba := RootDirectoryLba + (Word(Bpb.RootDirectoryEntryCount * 32 + Bpb.BytesPerSector - 1) div Bpb.BytesPerSector);
        FileDataLba := DataRegionLba + ((Cluster - 2) * Bpb.SectorsPerCluster);
        LoadFile := ReadSectors(FileDataLba, Bpb.SectorsPerCluster, DestPtr);
    end;
end;

end.
