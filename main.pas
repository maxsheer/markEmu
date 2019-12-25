{Shiryashkin 110 datetime}
{$R+,B+,X-}
{$mode TP}
{$codepage UTF-8}

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
soc: set of char;
finp, fout, ftra: text;
tmp: string;
mainstr, tmpser, tmprep, main_prev: row;
i, j, k, tmpter, rc, applied: integer;
bus, cur_rule: Pstack;
choice: char;



{functions}
{procedures}

procedure print(s: row);
var i: integer;
begin
	for i := 1 to s.len do
		write(s.dat[i]);
	writeln;
end;

procedure printfd(s: row; var F: text);
var i: integer;
begin
	for i := 1 to s.len do
		write(F, s.dat[i]);
end;

procedure printfdln(s: row; var F: text);
var i: integer;
begin
	for i := 1 to s.len do
		write(F, s.dat[i]);
	writeln(F);
end;

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
        lst^.search.dat := '';
		lst^.search.len := 0;
        lst^.next := nil;
        dispose(lst);
    end;
end;

function apply_rule(var st: row; rule: Pstack; var F: text): integer;
var
i, j, k: integer;
flag, overflow: boolean;
ow: row;
begin
	i := 1;
	flag := false;
	overflow := false;
	while (i <= st.len) and (not flag) do
	begin
		j := 0;
		while (rule^.search.dat[j + 1] = st.dat[i + j]) and (j <= rule^.search.len) 
		and ((i + j) <= st.len) do
			j := j + 1;
		if (j = rule^.search.len) then
		begin
			if (rule^.search.len > rule^.replace.len) then
			begin
				for k := i to (i + rule^.replace.len - 1) do
					st.dat[k] := rule^.replace.dat[k - i + 1];
				for k := (i + rule^.replace.len) to (st.len - 1) do
					st.dat[k] := st.dat[k + rule^.search.len - rule^.replace.len];
				st.len := st.len - (rule^.search.len - rule^.replace.len);
			end;

			if (rule^.search.len = rule^.replace.len) then
				for k := i to (i + rule^.replace.len - 1) do
				begin
					st.dat[k] := rule^.replace.dat[k - i + 1];
				end;
				
			if (rule^.search.len < rule^.replace.len) then
			begin
				if (st.len - (rule^.search.len - rule^.replace.len)) > 255 then
				begin
					overflow := true;
					ow.dat := 'Overflow warning';
					ow.len := 16;
					printfdln(ow, F);
				end
				else
				begin
					for k := (st.len + rule^.replace.len - rule^.search.len)  
					downto (i + rule^.replace.len - 1) do
						st.dat[k] := st.dat[k - (rule^.replace.len - rule^.search.len)];
					for k := i to (i + rule^.replace.len - 1) do
						st.dat[k] := rule^.replace.dat[k - i + 1];
					st.len := st.len - (rule^.search.len - rule^.replace.len)
				end;
			end;
			flag := true;
		end;
		i := i + 1;
	end;
	if flag and (not overflow) then
		apply_rule := i - 1
	else if (not overflow) then
		apply_rule := 0
	else
		apply_rule := -1;
end;


begin
	{initialization}
	assign(finp, 'some_input.txt');
	assign(fout, 'some_output.txt');
	assign(ftra, 'some_trace.txt');
	reset(finp);
	rewrite(fout);
	rewrite(ftra);
	soc := ['Y', 'y', 'N', 'n'];
	bus := nil;

	readln(finp, tmp);
	mainstr.dat := tmp;
	mainstr.len := length(tmp);
	readln(finp, tmp);
	while not eof(finp) do
	begin
		readln(finp, tmp);
		i := 1;

		tmpser.dat := '';
		tmpser.len := 0;
		while (tmp[i] <> '-') and (tmp[i] <> '|')
		and (i <= length(tmp)) do
		begin
			tmpser.dat[i] := tmp[i];
			tmpser.len := tmpser.len + 1;
			i := i + 1;
		end;
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
		tmprep.dat := '';
		tmprep.len := 0;
		j := 1;
		while (i <= length(tmp)) do
		begin
			tmprep.dat[j] := tmp[i];
			tmprep.len := tmprep.len + 1;
			i := i + 1;
			j := j + 1;
		end;
		if (bus = nil) then
			bus := lstinit(tmpser, tmprep, tmpter)
		else
			list_pushback(bus, tmpser, tmprep, tmpter);
	end;

	{now let the main process begin}
	i := 0;
	k := 1000;
	tmpter := 0;
	printfdln(mainstr, ftra);
	while (i <= k) and (tmpter = 0) do
	begin
		cur_rule := bus;
		applied := 0;
		tmpter := 0;
		while (cur_rule <> nil) and (applied = 0) do
		begin
			rc := 1;
			main_prev := mainstr;
			applied := apply_rule(mainstr, cur_rule, ftra);
			tmpter := cur_rule^.terminate;
			if (applied > 0) then
			begin
				printfd(main_prev, ftra);
				write(ftra, '(', rc, ',', applied, ')');
				if (tmpter = 1) then
					write(ftra, '|');
				write(ftra, '-->');
				printfdln(mainstr, ftra);
			end;
			cur_rule := cur_rule^.next;
			if (applied < 0) then
				cur_rule := nil;
			rc := rc + 1;
		end;
		
		if (applied <= 0) then
			tmpter := 1;
		i := i + 1;
		if (i mod 1000) = 999 then
		begin
			choice := chr(0);
			writeln('Process reached its' + chr(39) + ' 1000th iteration. Continue? [Y/N]');
			readln(choice);
			while not (choice in soc) do begin
				writeln('Incorrect option. Make your choice again. [Y/N]');
				readln(choice);
			end;
			case choice of
				'Y', 'y': k := k + 1000;
				'N', 'n': i := i + 1;
			end;
		end;
	end;
	printfd(mainstr, fout);
	close(finp);
	close(fout);
	close(ftra);
end.
