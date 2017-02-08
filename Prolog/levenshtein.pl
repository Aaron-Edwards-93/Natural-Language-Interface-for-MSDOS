%----LEVENSHTEIN DISTANCE SPELL CORRECTION----%
levenshtein(Word1,Word2):-
	atom_chars(Word1,List1),
	atom_chars(Word2,List2),
	lev(List1,List2,0),
	%add connection for this spelling mistake to kb
	asserta(sp([Word2|X],[Word1|X])).
	
%lev does not unify, 
%recurse using next word in phrase
levenshtein(Word1,[_|Phrase]):-
	levenshtein(Word1,Phrase).

%no more words in phrase to check
levenshtein(_,[]).
	
%Both empty lists, recursive stop condition
lev([],[],Result):-
	!,
	Result < 3,
	Result > 0.

lev([],Word2,Result):- %Empty list clause
	length(Word2,L),
	Diff is (Result + L),
	lev([],[],Diff).

lev(Word1,[],Result):- %Empty list clause
	length(Word1,L),
	Diff is (Result + L),
	lev([],[],Diff).
	
%Head of both lists are the same
lev([X|Tail1],[Y|Tail2],Result):-
	X == Y,
	lev(Tail1,Tail2,Result).

%Differing Heads of lists
lev([X|Tail1],[Y|Tail2],Result):-
	X \== Y,
	Diff is (Result + 1),
	lev(Tail1,Tail2,Diff).