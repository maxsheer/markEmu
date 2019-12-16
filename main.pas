{Shiryashkin 110 datetime}
{$R+,B+,X-}
{$mode TP}
{$codepage UTF-8}


{TODO
- setup structures (list of callbacks should like as rb-tree or as stack)
- implement cycle detector of a program: we need to save states as rb tree and fast-search it every iteration if proper flag was delivered
- to trace good
- to read good
Fedor needs:
- additional aliases alphabet
- dynamic stack
- algos composition
- if no cycle detector we need to ask every 1000 iterations if we wanna continue iterating or we set our algo as imapplicative`
}


program markem(input, output);

Type: 
Pstack=^callstack;

callstack=record 
	search: string;
	replace: string;
	terminate: integer;
	next: Pstack;
end;

var 
finp, fout, ftra: text;
mainstr, tmp, tmpser, tmprep: string;
i,j,k. tmpter: int;
bus: Pstack;




{functions}
{procedures}

function lstinit(s, r: string; t: integer): Pstack;
var
out: Pstack;
begin
  new(out);
  out^.search := s;
  out^.replace := r;
  out^.terminate := t;
  out^.next := nil;
  lstinit := out;
end;

procedure list_pushback(var lst: Pstack; s, r: string; t: integer);
var
add, tmp: Pstack;
begin
	new(add);
	add^.search := s;
	add^.replace := r;
	add^.terminate := t;
	add^.next := nil;
	tmp := lst;
	while (tmp^.next <> nil) do
		tmp := tmp^.next;
	tmp^.next := add;
end;

procedure freelst(var lst: P);
begin
    if (lst <> nil) then
    begin
        freelst(lst^.next);
        lst^.st := '';
        lst^.next := nil;
        dispose(lst);
    end;
end;

function replace(var st: string; needle: string; rep: string)
var
i, j, k: integer;
flag: boolean;
begin
	i := 1;
	while (i <= length(st)) do
	begin
		j := 1;
		while (needle[j] = st[i + j - 1]) and (j <= length(needle)) 
		and ((i + j - 1) <= length(st)) do
			j := j + 1;
		if (j = length(needle)) then
		begin
			for k:= length(st) + 1 downto 
		end;
	end;
end;


begin
	assign(finp, 'some_input.txt');
	assign(fout, 'some_output.txt');
	assign(ftra, 'some_trace.txt');
	reset(finp);
	reset(fout);
	reset(ftra);
	bus := nil;

	readln(tmp, finp);
	mainstr := tmp;
	readln(tmp);
	while not eof(finp) do
	begin
		readln(tmp);
		i := 1;

		tmpser := '';
		while (tmp[i] <> '-') and (tmp[i] <> '|')
		and (i <= length(tmp)) do
		begin
			tmpser[i] := tmp[i];
			i := i + 1;
		end;
		if (tmp[i] = '|') then
		begin
			tmpser := 1;
			i := i + 4;
		end
		else
		begin
			tmpser := 0;
			i := i + 3;
		end;
		tmprep := '';
		j := 1;
		while (i <= length(tmp)) do
		begin
			tmprep[j] := tmp[i];
			i := i + 1;
			j := j + 1;
		end;
		if (bus = nil) then
			bus := initlst(tmpser, tmprep, tmpter)
		else
			list_pushback(bus, tmpser, tmprep, tmpter);
	end;

	{now let the main process begin}

	

end.
