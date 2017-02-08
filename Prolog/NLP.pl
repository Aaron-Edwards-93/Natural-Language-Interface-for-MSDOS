%Self Starting Program, First thing to be done is consult the various supporting Prolog Scripts
:- consult(et),consult(msdos),consult(dictionary),consult(spellchecker),consult(levenshtein).

intro:- 
	write('Welcome! I am a program designed to help you navigate your Windows File System.'),nl,
	write('Firstly if you want to quit, simply tell me so!'),nl,
	write('I can be used to View Files inside a given Directory/Folder,'),nl,
	write('I can Copy Files, Rename Files, Create new Folders/Directories, Transfer files to different 
	locations, show you the contents of files, I can give you the Properties of a given storage device,
	and Move between Directories/Folders.'),nl,
	take_input,nl.

%use et to take input from user, tokenise it into a list of words
take_input:-
	tokenize_line(user,Commands),
	tokens_words(Commands,Atom), %produce list of commands
	simplify(Atom,SimplifiedAtoms), %remove redundant words, pass to dictionary.pl for simlification
	spellChecker(SimplifiedAtoms), %run levenshtein spell checking, update knowledge base with results
	correctSpelling(SimplifiedAtoms,CorrectedAtoms),
	parse_command(CorrectedAtoms,[[]]). %parse command(s) into a list of instructions

%recursive stop condition
parse_command([],[]).

%list to parse is empty, but commands can be processed
parse_command([],CommandList):-
	reverse(CommandList,[],NewCommandList),
	translate_commands(NewCommandList).

%head of list is the word we are using as a delimiter
parse_command([then|Tail],[H|Rest]):-
	parse_command(Tail,[[],H|Rest]).

%if head of list is not delimiter
parse_command([X|Tail],[H|Rest]):- 
	append(H,[X],NewCommandList),
	parse_command(Tail,[NewCommandList|Rest]).

translate_commands([[]]). %recursive stop condition

translate_commands([H|Tail]):-
	translate(H,_),!, %pass to msdos.pl for translation into msdos and sending the command to the OS
	translate_commands(Tail).

%self starter
:- intro,nl.