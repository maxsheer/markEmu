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

Type 
Pstack=^callstack;

row=record
	dat: string;
	len: integer;
end;

callstack=record 
	search: row;
	replace: row;
	terminate: integer;
	next: Pstack;
end;

var 
finp, fout, ftra: text;
tmp: string;
mainstr, tmpser, tmprep: row;
i,j,k,tmpter, applied: integer;
bus, cur_rule: Pstack;




{functions}
{procedures}

function lstinit(s, r: row; t: integer): Pstack;
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

procedure list_pushback(var lst: Pstack; s, r: row; t: integer);
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

procedure freelst(var lst: Pstack);
begin
    if (lst <> nil) then
    begin
        freelst(lst^.next);
        lst^.search := '';
        lst^.next := nil;
        dispose(lst);
    end;
end;

function apply_rule(var st: row; rule: Pstack): integer;
var
i, j, k: integer;
flag: boolean;
begin
	i := 1;
	flag := false;
	while (i <= length(st)) and (not flag) do
	begin
		j := 1;
		while (rule^.search[j] = st[i + j - 1]) and (j <= length(rule^.search)) 
		and ((i + j - 1) <= length(st)) do
			j := j + 1;
		if (j = length(rule^.search)) then
		begin
			if (length(rule^.search) > length(rule^.replace)) then
			begin
				for k := i to (i + length(rule^.replace) - 1) do
					st[k] := rule^.replace[k - i + 1];
				for k := (i + length(rule^.replace)) to length(st) - 1 do
					st[k] := st[k + length(rule^.search) - length(rule^.replace)];
			end;
			if (length(rule^.search) = length(rule^.replace)) then
				for k := i to (i + length(rule^.replace) - 1) do
					st[k] := rule^.replace[k - i + 1];
			if (length(rule^.search) < length(rule^.replace)) then
			begin
				for k := (length(st) + length(rule^.replace) - length(rule^.search))  
				downto (i + length(rule^.replace) - 1) do
					st[k] := st[k - (length(rule^.replace) - length(rule^.search))];
				for k := i to (i + length(rule^.replace) - 1) do
					st[k] := st[k - i + 1];
			end;
			flag := true;
		end;
		i := i + 1;
	end;
	if flag then
		apply_rule := 1
	else
		apply_rule := 0;
end;


begin
	assign(finp, 'some_input.txt');
	assign(fout, 'some_output.txt');
	assign(ftra, 'some_trace.txt');
	reset(finp);
	reset(fout);
	reset(ftra);
	bus := nil;

	readln(finp, tmp);
	mainstr := tmp;
	readln(finp, tmp);
	while not eof(finp) do
	begin
		readln(finp, tmp);
		i := 1;

		tmpser := '';
		while (tmp[i] <> '-') and (tmp[i] <> '|')
		and (i <= length(tmp)) do
		begin
			tmpser[i] := tmp[i];
			i := i + 1;
		end;
		writeln(tmpser);
		if (tmp[i] = '|') then
		begin
			tmpter := 1;
			i := i + 4;
		end
		else
		begin
			tmpter := 0;
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
		writeln(tmp,' ', tmpser, ' ', tmprep);
		if (bus = nil) then
			bus := lstinit(tmpser, tmprep, tmpter)
		else
			list_pushback(bus, tmpser, tmprep, tmpter);
	end;

	{now let the main process begin}
	i := 0;
	k := 1000;
	tmpter := 0;
	while (i <= k) and (tmpter = 0) do
	begin
		cur_rule := bus;
		applied := 0;
		tmpter := 0;
		while (cur_rule <> nil) and (applied = 0) do
		begin
			applied := apply_rule(mainstr, cur_rule);
			tmpter := cur_rule^.terminate;
			cur_rule := cur_rule^.next;
		end;
		if applied = 0 then
			tmpter := 1;
		i := i + 1;
	end;
	writeln(mainstr)
end.
