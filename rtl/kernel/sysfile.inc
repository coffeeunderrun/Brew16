procedure do_close(handle : longint);
begin
end;

procedure do_erase(p : PAnsiChar; pchangeable: boolean);
begin
end;

procedure do_rename(p1,p2 : PAnsiChar; p1changeable, p2changeable: boolean);
begin
end;

function do_write(h: longint; addr: pointer; len: longint) : longint;
begin
  result := -1;
end;

function do_read(h: longint; addr: pointer; len: longint) : longint;
begin
  result := -1;
end;

function do_filepos(handle: longint) : longint;
begin
  result := -1;
end;

procedure do_seek(handle, pos: longint);
begin
end;

function do_seekend(handle: longint):longint;
begin
  result := -1;
end;

function do_filesize(handle : longint) : longint;
begin
  result := -1;
end;

procedure do_truncate(handle, pos: longint);
begin
end;

procedure do_open(var f;p:PFileTextRecChar;flags:longint; pchangeable: boolean);
begin
end;

function do_isdevice(handle: THandle): boolean;
begin
  result := false;
end;
