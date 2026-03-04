unit ObjPas;

{$mode objfpc}
{$I-}{$S-}

interface

const
    MaxInt  = MaxSmallint;
type
    Integer  = smallint;
    PInteger = ^Integer;

    IntegerArray  = array[0..(32768 div SizeOf(Integer))-2] of Integer;
    TIntegerArray = IntegerArray;
    PIntegerArray = ^IntegerArray;
    PointerArray  = array [0..(32768 div SizeOf(Pointer))-2] of Pointer;
    TPointerArray = PointerArray;
    PPointerArray = ^PointerArray;
implementation

end.
