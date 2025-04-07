## Table of contents

- [Table of contents](#table-of-contents)
- [Potrivirea si gasirea solutiilor](#potrivirea-si-gasirea-solutiilor)
- [Aritmetica in Prolog](#aritmetica-in-prolog)
- [Liste](#liste)
- [Exercitii (rezolvate)](#exercitii-rezolvate)
- [Alte functii utile de Prolog](#alte-functii-utile-de-prolog)
    - [Exercitiu](#exercitiu)
- [Prezentare curs 4 (slide-urile 40 - 60)](#prezentare-curs-4-slide-urile-40---60)


## Potrivirea si gasirea solutiilor
- Dupa cum am spus in lectiile precedente, Prolog se bazeaza pe **backtracking**, **resolution** si **union**
- Forta Prolog-ului sta in gasirea solutiilor pentru o anumita problema sau formula, bazandu-se pe functionalitatea de **uniune** (sau potrivire), de **backtracking** (adica incearca toate posibilitatile in mod recursiv) si de **rezolutie**:
```
% Faptele
parent(john, mary).
parent(john, paul).
parent(susan, mary).
parent(susan, paul).
parent(paul, lisa).
parent(paul, james).
parent(mary, sophia).
parent(mary, tom).

% Recursivitatea in reguli:
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% Resolutia se poate observa in urmatorul query, in care se va apela recursiv predicatul ancestor:
% ?- ancestor(john, sophia).

sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% Exemple de unificare:
% ?- ancestor(X, sophia).
% 
% ?- ancestor(john, tom).
% 
% ?- sibling(paul, X).
```

- **Uniunea / potrivirea** se realizeaza, fie implicit, ca mai sus, fie cu predicatul `=` (adica se poate scrie `=(t1, t2)` in loc de `t1 = t2`) si este determinata de urmatoarea regula:
> Two terms match, if they are equal or if they contain variables that can be instantiated in such a way that the resulting terms are equal.
- Deci, daca avem `constanta = constanta` atunci va verifica daca constantele se potrivesc exact, iar daca avem `variabila = constanta` va incerca toate valorile de constante posibile care sa se potriveasca pentru variabila, utilizand regulile programului (sau cele definite implicit)
- de exemplu, urmatoarele interogari dau `true` / gasesc minim o solutie:
```
is_alive(maria) = is_alive(X)

5 + 4 = 5 + 4 (care este echivalent cu +(5, 4) = +(5, 4))

"bob" = bob

X = bob ; X = john

kill(shoot(gun), stab(knife)) = kill(X,stab(Y))
```
- insa urmatoarele dau `false`:
```
4 + 5 = 5 + 4 (echivalent cu +(4, 5) = +(5, 4))

X = bob, X = john

friends(alex, X) = friends(X, mary) (de ce da false?)
```

## Aritmetica in Prolog
- Prolog lucreaza in principal cu numere intregi, pentru ca sunt mai utile pentru logica propozitionala.
- Atunci cand scriem o expresie in prolog, o putem face in 2 moduri:
  - fie infix: `3 + 4`
  - fie prefix `+(3, 4)`
- Atunci cand dorim sa evaluam expresii trebuie sa-i spunem explicit interpretorului sa o faca, altfel (daca folosim `=`) va compara termen cu termen expresiile si va intoarce `true` doar daca **se potrivesc exact** (dupa conversia la stilul prefix)
- Acum, pentru a-i spune interpretorului sa evalueze expresiile, vom folosi operatorul `=:=`, iar atunci cand lucram cu variabile (**care trebuie sa fie in membrul stang**) vom folosi operatorul `is`, pentru ca aici dorim ca variabilei sa-i fie atribuita rezultatul expresiei, **fara sa aiba loc un union**
- Aceleasi principii functioneaza si in cazul operatorilor relationali din lectia 1

```
% Cateva exemple:
?- 8 =:= 6+2.
true

?- 12 =:= 6*2.
true

?- -2 =:= 6-8.
true

?- 3 =:= 6/2.
true

?- 1 =:= mod(7,2).
true

?- X is 6+2.
X = 8

?- X is 6*2.
X = 12

?- R is mod(7,2).
R = 1
```

## Liste
- O lista are forma urmatoare: `[H|T]`, unde $H$ este primul element al listei, iar $T$ este restul listei (posibil `[]`)
- `[]` = lista vida
- Functii predefinite pentru liste:
  - `length(Lista, Lungime).`
  - `member(Element, Lista).`
  - `append(L1, L2, Rez).`
  - `last(LastElem, Valoare).`
  - `reverse(Linit, Lrez).`

## Exercitii (rezolvate)
- Cerinte:
```
last_but_one(X, L).

fib(N, R).

len(L, N).

elem_of(L, X).

maxL(L, M).

reverse(L, LR).

palindrom(L).

concat_lists(L1, L2, LR).

remove_duplicates(L, LR). 

atimes(E, L, N).

insertsort(L, LR).

quicksort(L, LR).
```
- Solutii:
```
last_but_one(X, [X, _]).
last_but_one(X, [_ | T]) :- last_but_one(X, T).


% fibonacci eficient
fiba(0, 1, _).
fiba(1, 1, 1).
%trb pus ultimul Rtt la 1 pt calc lui fiba(2)
fiba(X, R, Rt):- Xt is X - 1, 
                 fiba(Xt, Rt, Rtt),
                 R is Rt + Rtt.
fib(X, R):- fiba(X, R, _).


len([], 0).
len([_|T], K):- len(T, K1), K is K1 + 1.


element_of([X|_], X).
element_of([_|T], X):- element_of(T, X).


max([X], X).
max([H|T], R) :- max(T, R1), H > R1, R is H.
max([H|T], R) :- max(T, R1), H =< R1, R is R1.


reverse([], []).
reverse([H|T], R):- reverse(T, R1), append(R1, [H], R).

palindrom(L):- reverse(L, L).


concat_lists([], L2, L2).
concat_lists([H|L1], L2, [H|L3]):- concat_lists(L1, L2, L3).


remove_duplicates([], []).
remove_duplicates([H|T], L) :- remove_duplicates(T, L), 
    							member(H, L).
remove_duplicates([H|T], [H|L]) :- remove_duplicates(T, L),
    							\+ member(H, L).


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


% insertion sort
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
```

## Alte functii utile de Prolog
- `bagof(Var, p, L)` va returna in variabila L toate variabilele care pot tine locul lui `Var` in `p`, sub forma unei **liste de liste**, in functie de celelalte variabile libere
- `setof(Var, p, L)` face acelasi lucru cu `bagof` doar ca returneaza lista de solutii fara duplicate
- `findall(Var, p, L)` face exact ce face `bagof` doar ca nu tine cont de variabilele libere si raspunsul returnat reprezinta concatenarea dintre toate gruparile posibile de variabile libere din `bagof`; de aceea, in caz ca nu se gasesc solutii se returneaza `[]`

```
parent(john, mary).
parent(john, paul).
parent(susan, mary).
parent(susan, paul).
parent(paul, lisa).
parent(paul, james).
parent(mary, sophia).
parent(mary, tom).

findall(X, parent(P, X), List).

bagof(X, parent(P, X), List).
```

#### Exercitiu
- Subset of N elements from L:
```
getList(L, N, M) :- subset(L, M), length(M, N).

subset([], []).
subset([H | T], [H | Subset]) :- subset(T, Subset).
subset([_ | T], Subset) :- subset(T, Subset).
```

## Prezentare curs 4 (slide-urile 40 - 60)