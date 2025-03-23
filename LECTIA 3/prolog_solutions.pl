%ex 1
% fibonacci eficient
fiba(0, 1, _).
fiba(1, 1, 1).
%trb pus ultimul Rtt la 1 pt calc lui fiba(2)
fiba(X, R, Rt):- Xt is X - 1, 
                 fiba(Xt, Rt, Rtt),
                 R is Rt + Rtt.
fib(X, R):- fiba(X, R, _).


/*Liste - teorie
[] -> lista vida
[H|T] -> H:= primul elem al listei, T:= restul listei
*/

/*functii predefinite pt listei
length(Lista, Lungime).
member(Element, Lista).
append(L1, L2, Rez).
last(LastElem, Valoare).
reverse(Linit, Lrez).
*/

%ex 2
len([], 0).
len([_|T], K):- len(T, K1), K is K1 + 1.

%ex 3
element_of([X|_], X).
element_of([_|T], X):- element_of(T, X).

%ex 4
max([X], X).
max([H|T], R) :- max(T, R1), H > R1, R is H.
max([H|T], R) :- max(T, R1), H =< R1, R is R1.

%ex 5
reverse([], []).
reverse([H|T], R):- reverse(T, R1), append(R1, [H], R).

%ex 6
palindrom(L):- reverse(L, L).

%ex 7
concat_lists([], L2, L2).
concat_lists([H|L1], L2, [H|L3]):- concat_lists(L1, L2, L3).

% ex 8
remove_duplicates([], []).
remove_duplicates([H|T], L) :- remove_duplicates(T, L), 
    							member(H, L).
remove_duplicates([H|T], [H|L]) :- remove_duplicates(T, L),
    							\+member(H, L).

% ex 9
% atimes(E, L, N) - E apare de N ori in L

atimes(_, [], 0).
% in caz ca interogarea mea il va avea pe E ca necunoscuta, trb sa adaug si acest pas de oprire.
atimes(X, [X], 1).
atimes(E, [H|T], K) :- atimes(E, T, K1), H == E, K is K1 + 1.
atimes(E, [H|T], K) :- atimes(E, T, K), H \== E.

% bonus: dropN(L, R, N) - elimina fiecare al N-lea element din lista L
dropN(L, [], N) :- length(L, N).
dropN([H|T], [H|R], N) :- length(T, L1), L1 >= N, dropN(T, R, N).
dropN(L, R, N) :- append(R, L1, L), length(L1, N).


% ex 10
% sortari
% v1 met insertiei

insertsort([],[]).
insertsort([H|T],L) :- insertsort(T,L1), insert(H,L1,L).

insert(X,[],[X]).
insert(X,[H|T],[X|[H|T]]) :- X < H.
insert(X,[H|T],[H|L]) :- X >= H, insert(X,T,L).

% bonus: quicksort
quicksort([],[]).
quicksort([H|T],L) :- split(H,T,A,B), quicksort(A,M), quicksort(B,N),
                        append(M,[H|N],L).
split(_,[],[],[]).
split(X,[H|T],[H|A],B) :- H < X, split(X,T,A,B).
split(X,[H|T],A,[H|B]) :- H >= X, split(X,T,A,B).