translateMove([move,X],['cmd /k cd ',X]). %move directory
translateMove([move,up,one,directory],['cmd /k cd ../']). %move one directory up
translateMove([move,up,one,layer],['cmd /k cd ../']). %move one directory up
translateMove([move,back],['cmd /k cd ../']). %move one directory up
translateMove([move,drive,X],['cmd /k cd ',X,':']). %move to different drive

translateShow([show,drive,X],['cmd /k dir ',X,':']). %show all files
translateShow([show],['cmd /k dir']). %show current directory
translateShow([show,all,files,drive,Y],['cmd /k dir ',Y,':*.*']). %show all files on one drive
translateShow([show,all,X,files,drive,Y],['cmd /k dir ',Y,':*.',X]). %show certain type of file
translateShow([show,X,files,drive,Y],['cmd /k dir ',Y,':*.',X]). %show certain type of file
translateShow([show,all,files,directory,X],['cmd /k dir ','\\',X]).
translateShow([show,all,files,directory],['cmd /k dir ']).
translateShow([show,all,X,files,directory],['cmd /k dir *.',X]). %show certain type of file 
translateShow([show,contents,directory],['cmd /k dir ']).
translateShow([show,all,contents,directory],['cmd /k dir ']). 

translateCopy([copy,all,from,drive,X,drive,Y], ['cmd /k copy ',X,':*.* ',Y,':']). %copy all
translateCopy([copy,File,drive,X], ['cmd /k copy /-Y ',File,'.* ',X,':']).
translateCopy([copy,File,X], ['cmd /k copy /-Y ',File,'.* ',X]).
translateCopy([copy,all,files,directory,X], ['cmd /k copy /-Y ','*.* ',X]).
translateCopy([copy,all,files,X], ['cmd /k copy /-Y ','*.* ',X]).
translateCopy([copy,all,F,files,directory,X], ['cmd /k copy /-Y ','*.',F,' ',X]).
translateCopy([copy,all,F,files,X], ['cmd /k copy /-Y ','*.',F,' ',X]).
translateCopy([copy,all,files,drive,X], ['cmd /k copy /-Y ','*.* ',X,':']).

translateCreate([create,directory,X], ['cmd /k mkdir ',X]).
translateCreate([create,new,directory,X], ['cmd /k mkdir ',X]).
translateCreate([create,directory,X,drive,Y], ['cmd /k mkdir ',Y,':',X]).

translateTransfer([transfer,all,drive,X,drive,Y], ['cmd /k move ',X,':*.* ',Y,':']).
translateTransfer([transfer,File,drive,X], ['cmd /k move ',File,'.* ',X,':']).
translateTransfer([transfer,File,X], ['cmd /k move ',File,'.* ',X]).
translateTransfer([transfer,all,files,directory,X], ['cmd /k move ','*.* ',X]).
translateTransfer([transfer,all,files,drive,X], ['cmd /k move ','*.* ',X,':']).
translateTransfer([transfer,all,F,files,X], ['cmd /k move ','*.',F,' ',X]).
translateTransfer([transfer,all,F,files,directory,X], ['cmd /k move ','*.',F,' ',X]).
translateTransfer([transfer,all,F,files,drive,X], ['cmd /k move ','*.',F,' ',X,':']).

translateType([type,X], ['cmd /k type ',X]).
translateType([type,file,X], ['cmd /k type ',X]).
translateType([type,directory,,X], ['cmd /k type ',X]).
translateType([type,drive,X], ['cmd /k type ',X,':']).
translateType([type,X], ['cmd /k type ',X,':']).

translateVol([properties,X], ['cmd /k vol ',X,':']).
translateVol([properties,drive,X], ['cmd /k vol ',X,':']).
translateVol([properties,drive], ['cmd /k vol C:']).
translateVol([properties], ['cmd /k vol C:']).

translateRename([rename,X,Y],['cmd /k rename ',X,' ',Y]).
translateRename([X,rename,Y],['cmd /k rename ',X,' ',Y]).

translate(Input,Result) :- %capture phrase and split into which command is being called
	captureCommandWord(Input,Result),
	pass_to_os(Result),
	take_input.

translate(_,[]) :-
	write('I do not understand, try re-phrasing the command'), nl,
	take_input.

	%TYPE
captureCommandWord(Input,Result):-
	member(type,Input),
	translateType(Input,Result).

	%PORPERTIES
captureCommandWord(Input,Result):-
	member(properties,Input),
	translateVol(Input,Result).
   
   %CREATE
captureCommandWord(Input,Result):-
	member(create,Input),
	translateCreate(Input,Result). 

	%TRANSFER (MOVE FILES)
captureCommandWord(Input,Result):-
	member(transfer,Input),
	translateTransfer(Input,Result). 
   
   %COPY FILES
captureCommandWord(Input,Result):-
	member(copy,Input),
	translateCopy(Input,Result).

	%QUIT
captureCommandWord(Input,_):-
	member(quit,Input),
	write('Quitting, goodbye'),
%relative file path will only work with full prolog installed, portable version will not find this file
%write to kb file, so spelling mistakes can be picked up again if needed
	tell('./spellChecker.pl'),
	listing(sp),
	told.

	%MOVE DIRECTORY (CD)
captureCommandWord(Input,Result):-
	member(move,Input),
	translateMove(Input,Result).

	%SHOW (DIR)
captureCommandWord(Input,Result):-
	member(show,Input),
	translateShow(Input,Result).

	%RENAME
captureCommandWord(Input,Result):-
	member(rename,Input),
	translateRename(Input,Result).

captureCommandWord([],_):- 
	write('No Commands have been given to me'),nl,
	take_input. %commands passed are an empty list


process_commands :-
   repeat,
      write('Command -> '),
      tokenize_line(user,X),
      tokens_words(X,What),
      simplify(What,SimplifiedWords),
      translate(SimplifiedWords,Command),
      pass_to_os(Command),
      Command == [quit],
   !.

pass_to_os([])     :- !.

pass_to_os([quit]) :- !.

pass_to_os(Command) :-
   concat(Command,String),
   win_exec(String,show).


concat([H|T],Result) :-
   name(H,Hstring),
   concat(T,Tstring),
   append(Hstring,Tstring,Result).

concat([],[]).

append([H|T],L,[H|Rest]) :-
	append(T,L,Rest).
	append([],L,L).

%stop condition
output_commands([]).

%recursively output all commands in list
output_commands([Head|Tail]):-
	write(Head),nl,
	output_commands(Tail).

%recursive stop check, when empty list AND accumulator and result are the same
reverse([],Acc,Acc).

%take a list, add its head as the head of the accumulator and recurse
reverse([H|T],Acc,Result):-  
	reverse(T,[H|Acc],Result). 
