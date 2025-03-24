## Alte functii utile
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

## Exercitii
- Subset of N elements from L:
```
getList(L, N, M) :- subset(L, M), length(M, N).

subset([], []).
subset([H | T], [H | Subset]) :- subset(T, Subset).
subset([_ | T], Subset) :- subset(T, Subset).
```

```
% Code that didn't work

ans(X, List) :- length(List, Len), aux(X, Len, List).

aux(H, 2, [H | _]).
aux(X, N, [_ | Rest]) :- aux(X, OldN, Rest), N is OldN + 1, !.
```