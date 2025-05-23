## Table of contents

- [Table of contents](#table-of-contents)
- [Alte functii utile de Prolog](#alte-functii-utile-de-prolog)
- [Logica propozitionala in Prolog](#logica-propozitionala-in-prolog)
  - [Introducere](#introducere)
  - [Căutarea valorii unei variabile (`val/3`)](#căutarea-valorii-unei-variabile-val3)
  - [Extracția variabilelor (`vars/2`)](#extracția-variabilelor-vars2)
  - [Operații logice de bază](#operații-logice-de-bază)
    - [Negare (`bnon/2`)](#negare-bnon2)
    - [Implicație (`bimp/3`)](#implicație-bimp3)
    - [Disjuncție (`bsau/3`)](#disjuncție-bsau3)
    - [Conjuncție (`band/3`)](#conjuncție-band3)
  - [Evaluarea formulelor (`eval/3`)](#evaluarea-formulelor-eval3)
  - [Evaluarea pentru toate interpretările](#evaluarea-pentru-toate-interpretările)
    - [Generarea combinațiilor (`evs/2`)](#generarea-combinațiilor-evs2)
    - [Evaluarea pe toate interpretările (`all_evals/2`)](#evaluarea-pe-toate-interpretările-all_evals2)
  - [Verificarea tautologiilor (`taut/1`)](#verificarea-tautologiilor-taut1)
  - [Exemplu](#exemplu)
  - [Tot codul (sa il aveti la indemana)](#tot-codul-sa-il-aveti-la-indemana)
    - [Exercitiu Prolog (model colocviu)](#exercitiu-prolog-model-colocviu)


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

# Pe baza faptelor de mai sus executati urmatoarele interogari si observati diferentele:

findall(X, parent(P, X), List).

bagof(X, parent(P, X), List).
```

## Logica propozitionala in Prolog

### Introducere

În acest laborator construim un sistem în Prolog capabil să:
- Extragă variabilele unei formule logice.
- Evalueze formula pentru toate interpretările posibile ale variabilelor.
- Verifice dacă formula este o tautologie (adevărată în orice situație).

Formulele sunt construite din:
- **Atomi** (ex.: `p`, `q`).
- **Operații logice**:
  - `non(T)` – negare (¬T)
  - `imp(T1, T2)` – implicație (T1 ⇒ T2)
  - `si(T1, T2)` – conjuncție logică (T1 ∧ T2)
  - `sau(T1, T2)` – disjuncție logică (T1 ∨ T2)

### Căutarea valorii unei variabile (`val/3`)

```prolog
val(Atom, [(Atom, Val)|_], Val).
val(Atom, [_|T], Res) :-
    val(Atom, T, Res).
```

**Explicație:**
- `val/3` caută valoarea unei variabile într-o listă de perechi `(Variabilă, Valoare)`.
- Dacă prima pereche are variabila dorită, extragem valoarea asociată.
- Dacă nu, ignorăm prima pereche și căutăm recursiv în restul listei.

**Exemplu:**
- Lista: `[(p,1), (q,0), (r,1)]`
- Căutăm valoarea lui `q` $\rightarrow$ obținem `0`.

Această funcție este esențială pentru evaluarea formulelor în funcție de interpretare.

### Extracția variabilelor (`vars/2`)

```prolog
vars(X, [X]) :- atom(X).

vars(imp(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).

vars(non(T), Res) :-
    vars(T, Res).

vars(si(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).

vars(sau(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).
```

**Explicație:**
- Dacă formula este un atom, returnăm o listă cu acel atom.
- Dacă formula este compusă, extragem variabilele din fiecare subformulă și le unim.

### Operații logice de bază

#### Negare (`bnon/2`)

```prolog
bnon(0, 1).
bnon(1, 0).
```

Negarea inversează valoarea de adevăr:

$
\neg 0 = 1, \quad \neg 1 = 0
$

#### Implicație (`bimp/3`)

```prolog
bimp(0, _, 1).
bimp(1, 0, 0).
bimp(1, 1, 1).
```

Implicația este adevărată în toate cazurile, cu excepția în care premisa este adevărată și concluzia este falsă:

$P \Rightarrow Q$

#### Disjuncție (`bsau/3`)

```prolog
bsau(P, Q, Res) :-
    bnon(P, NonP),
    bimp(NonP, Q, Res).
```

**Explicație:**

$
P \lor Q \equiv \neg P \Rightarrow Q
$

Aceasta este o formulare echivalentă pentru disjuncția logică.

#### Conjuncție (`band/3`)

```prolog
band(1, 1, 1).
band(0, _, 0).
band(_, 0, 0).
```

**Explicație:**

Conjuncția logică (AND) este adevărată doar dacă ambii operanzi sunt adevărați:

$
P \land Q
$

### Evaluarea formulelor (`eval/3`)

```prolog
eval(Atom, ListAtoms, Eval) :-
    val(Atom, ListAtoms, Eval).

eval(imp(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    bimp(EvalT1, EvalT2, Eval).

eval(si(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    band(EvalT1, EvalT2, Eval).

eval(sau(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    bsau(EvalT1, EvalT2, Eval).

eval(non(T), ListAtoms, Eval) :-
    eval(T, ListAtoms, EvalT),
    bnon(EvalT, Eval).
```

**Explicație:**
- Evaluăm atomii căutând valoarea lor.
- Evaluăm formulele compuse folosind funcțiile logice definite mai jos.

### Evaluarea pentru toate interpretările

#### Generarea combinațiilor (`evs/2`)

```prolog
evs([V], [[(V, 0)], [(V, 1)]]).
evs([V | Rest], Evals) :- evs(Rest, Res1), append_to_array(Res1, V, Evals).

append_to_list(List, V, [L1, L2]) :-
    append([(V, 0)], List, L1), append([(V, 1)], List, L2).

append_to_array([L], V, Res) :- append_to_list(L, V, Res).
append_to_array([L | Rest], V, Res) :- 
	append_to_list(L, V, Res1), append_to_array(Rest, V, Res2), append(Res1, Res2, Res).
```

Funcțiile `repl/2` și `aux/3` generează toate combinațiile de valori posibile și le asociază cu variabilele.

#### Evaluarea pe toate interpretările (`all_evals/2`)

```prolog
all_evals(Form, Res) :-
    vars(Form, ListVars),
    evs(ListVars, Evals),
    evals(Form, Evals, Res).
```

Evaluăm formula pe toate combinațiile posibile de valori.

### Verificarea tautologiilor (`taut/1`)

```prolog
taut(Form) :-
    all_evals(Form, Evals),
    all(Evals, 1).
```

O formulă este o tautologie dacă se evaluează la 1 pentru toate interpretările.

### Exemplu

Verificăm dacă formula:

$
p \Rightarrow (p \lor q)
$

este o tautologie.

```prolog
?- taut(imp(p, sau(p, q))).
true.
```

Interpretarea pentru toate combinațiile posibile va returna mereu `true`.

### Tot codul (sa il aveti la indemana)
```prolog
% Căutarea valorii unei variabile (val/3)
val(Atom, [(Atom, Val)|_], Val).
val(Atom, [_|T], Res) :-
    val(Atom, T, Res).

% Extracția variabilelor (vars/2)
vars(X, [X]) :- atom(X).

vars(imp(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).

vars(non(T), Res) :-
    vars(T, Res).

vars(si(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).

vars(sau(T1, T2), Res) :-
    vars(T1, Res1),
    vars(T2, Res2),
    union(Res1, Res2, Res).

% Evaluarea formulelor (eval/3)
eval(Atom, ListAtoms, Eval) :-
    val(Atom, ListAtoms, Eval).

eval(imp(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    bimp(EvalT1, EvalT2, Eval).

eval(si(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    band(EvalT1, EvalT2, Eval).

eval(sau(T1, T2), ListAtoms, Eval) :-
    eval(T1, ListAtoms, EvalT1),
    eval(T2, ListAtoms, EvalT2),
    bsau(EvalT1, EvalT2, Eval).

eval(non(T), ListAtoms, Eval) :-
    eval(T, ListAtoms, EvalT),
    bnon(EvalT, Eval).

% Operații logice de bază

% Negare (bnon/2)
bnon(0, 1).
bnon(1, 0).

% Implicație (bimp/3)
bimp(0, _, 1).
bimp(1, 0, 0).
bimp(1, 1, 1).

% Disjuncție (bsau/3)
bsau(P, Q, Res) :-
    bnon(P, NonP),
    bimp(NonP, Q, Res).

% Conjuncție (band/3)
band(1, 1, 1).
band(0, _, 0).
band(_, 0, 0).

% Functia evs genereaza toate evaluarile posibile pentru lista de variabile data in primul parametru
evs([V], [[(V, 0)], [(V, 1)]]).
evs([V | Rest], Evals) :- evs(Rest, Res1), append_to_array(Res1, V, Evals).

append_to_list(List, V, [L1, L2]) :-
    append([(V, 0)], List, L1), append([(V, 1)], List, L2).

append_to_array([L], V, Res) :- append_to_list(L, V, Res).
append_to_array([L | Rest], V, Res) :- 
	append_to_list(L, V, Res1), append_to_array(Rest, V, Res2), append(Res1, Res2, Res).

% Functia evals afiseaza rezultatul formulei pentru fiecare evaluare data
evals(_, [], []).
evals(X, [E|Es], [A|As]) :-
    eval(X, E, A),
    evals(X, Es, As).

% Functia all_evals returneaza rezultatul formulei in toate evaluarile posibile
% Daca este tautologie atunci `Res` este format doar din 1
all_evals(F, Res) :- vars(F, VarsList), evs(VarsList, AllEvals), evals(F, AllEvals, Res).
```

#### Exercitiu Prolog (model colocviu)
- Consideram in continuare reprezentarea formulelor logicii propozitionale folosita in
laboratorul 5. Scrieti un predicat rmdn/2 cu proprietatea ca `rmdn(Phi, Psi)` este adevarat daca si
numai daca Psi este rezultatul eliminarii tuturor negatiilor duble din Phi.

```prolog
rmdn(Phi, Phi) :- atom(Phi).
rmdn(si(Phi, Psi), si(Phi1, Psi1)) :- rmdn(Phi, Phi1), rmdn(Psi, Psi1).
rmdn(sau(Phi, Psi), sau(Phi1, Psi1)) :- rmdn(Phi, Phi1), rmdn(Psi, Psi1).
rmdn(imp(Phi, Psi), imp(Phi1, Psi1)) :- rmdn(Phi, Phi1), rmdn(Psi, Psi1).
rmdn(non(non(Phi)), Psi) :- rmdn(Phi, Psi), !.
rmdn(non(Phi), non(Psi)) :- rmdn(Phi, Psi).
```
