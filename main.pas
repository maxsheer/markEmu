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
	terminate: (0, 1);
	next: Pstack;
end;

var 
finp, fout, ftra: text;
mainstr, tmp: string;
i,j,k: int;



{functions}
{procedures}


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

	readln(tmp, finp);
	mainstr = tmp;
	readln(tmp);
	while ((tmp[i] >= 'a') and (tmp[i] <= 'z')) 
		or ((tmp[i] >= 'A') and (tmp[i] <= 'Z')) then
	begin
		mainstr[i] = tmp[i];
		i := i + 1;
	end;


end.
