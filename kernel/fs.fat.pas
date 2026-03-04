unit Fs.Fat;

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
    ClusterBad = $FF7;
    ClusterEnd = $FF8;

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
        CreationTime: Word; // Bits 15-11=hours, 10-5=minutes, 4-0=seconds/2
        CreationDate: Word; // Bits 15-9=year (since 1980), 8-5=month, 4-0=day
        LastAccessDate: Word;
        FirstClusterHigh: Word;
        LastModifiedTime: Word;
        LastModifiedDate: Word;
        FirstClusterLow: Word;
        FileSize: DWord;
    end;

    PDap = ^TDap;
    TDap = packed record
        Size: Byte;
        Reserved: Byte;
        Count: Word;
        Offset: Word;
        Segment: Word;
        Lba: QWord;
    end;
    {$if sizeof(TDap) <> 16}
        {$error "sizeof(TDap) <>> 16"}
    {$endif}

procedure CalculateChs(Lba: Word; const Bpb: TBiosParameterBlock; out Cylinder, Head, Sector: Byte);
begin
    Cylinder := Lba div (Bpb.SectorsPerCylinder * Bpb.HeadCount);
    Head := (Lba div Bpb.SectorsPerCylinder) mod Bpb.HeadCount;
    Sector := Lba mod Bpb.SectorsPerCylinder + 1;
end;

function ReadSectors(Drive, Cylinder, Head, Sector, Count: Byte; BufferPtr: Pointer): Byte; assembler;
asm
    push    bx
    mov     ah, $02
    mov     al, Count
    mov     ch, Cylinder
    mov     cl, Sector
    mov     dh, Head
    mov     dl, Drive
    mov     bx, BufferPtr
    int     $13
    pop     bx
end;

function ReadSectors(Drive: Byte; const DapPtr: Pointer): Boolean; assembler;
asm
    push    si
    mov     si, DapPtr
    xor     ax, ax
    mov     ah, $42
    mov     dl, Drive
    int     $13
    pop     si
end;

function GetBiosParameterBlock(Drive: Byte; out Bpb: TBiosParameterBlock): Boolean; inline;
var
    Buffer: array [0..511] of Byte;
begin
    if ReadSectors(Drive, 0, 0, 1, 1, @Buffer) = 0 then exit(false);
    Bpb := PBiosParameterBlock(@Buffer)^;
    GetBiosParameterBlock := true;
end;

function LoadFile(const Path: PChar; const DestPtr: Pointer): Byte;
var
    Bpb: TBiosParameterBlock;
    Buffer: array [0..511] of Byte;
    Cylinder, Head, Sector: Byte;
    EntryIndex, Cluster: Word;
    RootDirectorySector, DataRegionSector, FileDataSector: Word;
begin
    if not GetBiosParameterBlock(0, Bpb) then exit(0);

    RootDirectorySector := Bpb.ReservedSectors + Bpb.FatCount * Bpb.SectorsPerFat;
    DataRegionSector := RootDirectorySector +
        (Word(Bpb.RootDirectoryEntryCount * 32 + Bpb.BytesPerSector - 1) div Bpb.BytesPerSector);

    CalculateChs(RootDirectorySector, Bpb, Cylinder, Head, Sector);
    if ReadSectors(0, Cylinder, Head, Sector, 1, @Buffer) = 0 then exit(0);

    for EntryIndex := 0 to Bpb.RootDirectoryEntryCount - 1 do with PDirectoryEntry(@Buffer)[EntryIndex] do begin
        if Name[0] = Path[0] then begin
            Cluster := FirstClusterLow;
            break;
        end;
    end;

    FileDataSector := DataRegionSector + ((Cluster - 2) * Bpb.SectorsPerCluster);
    CalculateChs(FileDataSector, Bpb, Cylinder, Head, Sector);
    LoadFile := ReadSectors(0, Cylinder, Head, Sector, Bpb.SectorsPerCluster, DestPtr);
end;

end.
