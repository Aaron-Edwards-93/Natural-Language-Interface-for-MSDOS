:-dynamic sp/2.

correctSpelling(List,Result) :-
  sp(List,NewList),
  !,
  correctSpelling(NewList,Result).

correctSpelling([W|Words],[W|NewWords]) :-
  correctSpelling(Words,NewWords).

correctSpelling([],[]).

spellChecker([]).

spellChecker([Head|Tail]):-
	spellCheck(Head),
	spellChecker(Tail).
	
spellChecker([_|Tail]):-
	spellChecker(Tail).

%---------PREDICATES TO CHECK FOR SPELLING
%---- ERRORS IN WORDS WE KNOW ABOUT------%
spellCheck(Atom):-
	levenshtein(type,Atom).
spellCheck(Atom):-
	levenshtein(properties,Atom).
spellCheck(Atom):-
	levenshtein(create,Atom).
spellCheck(Atom):-
	levenshtein(transfer,Atom).
spellCheck(Atom):-
	levenshtein(copy,Atom).
spellCheck(Atom):-
	levenshtein(quit,Atom).
spellCheck(Atom):-
	levenshtein(show,Atom).
spellCheck(Atom):-
	levenshtein(rename,Atom).
spellCheck(Atom):-
	levenshtein(disk,Atom).