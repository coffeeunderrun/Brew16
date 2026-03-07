{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2014 by the Free Pascal development team.

    Processor dependent implementation for the system unit for
    intel i8086+

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{ TODO: Revisit these for protected mode to handle LDT selectors. }

function fpc_hugeptr_add_longint(p: HugePointer; n: LongInt): HugePointer; compilerproc;
begin
  fpc_hugeptr_add_longint := nil;
end;

function fpc_hugeptr_add_longint_normalized(p: HugePointer; n: LongInt): HugePointer; compilerproc;
begin
  fpc_hugeptr_add_longint_normalized := nil;
end;

function fpc_hugeptr_sub_longint(p: HugePointer; n: LongInt): HugePointer; compilerproc;
begin
  fpc_hugeptr_sub_longint := nil;
end;

function fpc_hugeptr_sub_longint_normalized(p: HugePointer; n: LongInt): HugePointer; compilerproc;
begin
  fpc_hugeptr_sub_longint_normalized := nil;
end;

function fpc_hugeptr_sub_hugeptr(p1, p2: HugePointer): LongInt; compilerproc;
begin
  fpc_hugeptr_sub_hugeptr := 0;
end;

procedure fpc_hugeptr_inc_longint(var p: HugePointer; n: LongInt); compilerproc;
begin
end;

procedure fpc_hugeptr_inc_longint_normalized(var p: HugePointer; n: LongInt); compilerproc;
begin
end;

procedure fpc_hugeptr_dec_longint(var p: HugePointer; n: LongInt); compilerproc;
begin
end;

procedure fpc_hugeptr_dec_longint_normalized(var p: HugePointer; n: LongInt); compilerproc;
begin
end;

function fpc_hugeptr_cmp_normalized_e(p1, p2: HugePointer): Boolean; compilerproc;
begin
  fpc_hugeptr_cmp_normalized_e := false;
end;

function fpc_hugeptr_cmp_normalized_ne(p1, p2: HugePointer): Boolean; compilerproc;
begin
  fpc_hugeptr_cmp_normalized_ne := false;
end;

function fpc_hugeptr_cmp_normalized_b(p1, p2: HugePointer): Boolean; compilerproc;
begin
  fpc_hugeptr_cmp_normalized_b := false;
end;

function fpc_hugeptr_cmp_normalized_be(p1, p2: HugePointer): Boolean; compilerproc;
begin
  fpc_hugeptr_cmp_normalized_be := false;
end;

function fpc_hugeptr_cmp_normalized_a(p1, p2: HugePointer): Boolean; compilerproc;
begin
  fpc_hugeptr_cmp_normalized_a := false;
end;

function fpc_hugeptr_cmp_normalized_ae(p1, p2: HugePointer): Boolean; compilerproc;
begin
  fpc_hugeptr_cmp_normalized_ae := false;
end;
