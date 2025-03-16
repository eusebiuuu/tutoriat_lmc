## Aritmetica in Prolog
- Prolog lucreaza in principal cu numere intregi, pentru ca sunt mai utile pentru logica propozitionala.
- Atunci cand scriem o expresie in prolog, o putem face in 2 moduri:
  - fie infix: `3 + 4`
  - fie prefix `+(3, 4)`
- Atunci cand dorim sa evaluam expresii trebuie sa-i spunem explicit interpretorului sa o faca, altfel (daca folosim `=`) va compara termen cu termen expresiile si va intoarce `true` doar daca **se potrivesc exact** (dupa conversia la stilul prefix)
- **IMPORTANT**: In prolog, operatorul `=` are rolul de a unifica valorile. Deci daca avem `constanta = constanta` atunci va verifica daca constantele se potrivesc exact, iar daca avem `variabila = constanta` va incerca toate valorile de constante posibile (atomi, string-uri, numere) care sa se potriveasca pentru variabila, utilizand regulile programului (sau cele definite implicit)
- Acum, pentru a-i spune interpretorului sa evalueze expresiile, vom folosi operatorul `=:=`, iar atunci cand lucram cu variabile (**care trebuie sa fie in membrul stang**) vom folosi operatorul `is`, pentru ca aici dorim ca variabilei sa-i fie atribuita rezultatul expresiei, fara sa aiba loc un union
- Aceleasi principii functioneaza si in cazul operatorilor relationali din lectia 1

## Operatorii aritmetici
- In prolog, operatorii aritmetici sunt fie **functii** predefinite, fie **predicate** definite de noi.

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
- 

