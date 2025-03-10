## Notiuni introductive de Prolog
- Logica matematica reprezinta o ramura a matematicii care, pe scurt, se ocupa cu formalizarea modurilor de gandire utilizate in diverse situatii din matematica si nu numai precum demonstratii, deductii, calcule etc.; de exemplu, logica matematica ne demonstreaza ca principiul reducerii la absurd este corect sau ca este corect sa scriem `3 + 2 = 5`
- Pentru a realiza aceste lucruri, pe parcursul cursului se vor defini sintaxele (cum se scrie corect) si semanticile (cum se interpreteaza corect) alte Logicii Propozitionale si ale Logicii de Ordinul I, urmand ca apoi ele sa se utilizeze pentru a formaliza demonstratiile pe care le intalnim peste tot
- Totusi, cum domeniul informaticii a inceput sa evolueze si sa se diversifice, a aparut si dorinta ramurii de logica matematica sa se automatizez prin crearea de diverse instrumente printre care si limbaje de programare care sa fie folosite pentru a demonstra corectitudinea diferitelor rationamente; asa a aparut limbajul **Prolog**
- **Prolog** este un limbaj de programare **declarativ** (adica doar se specifica ce trebuie sa se realizeze, si nu cum mai exact sa se realizeze) ce este folosit pentru a valida diferite rationamente (basically, sa demonstreze demonstratii)
- Pentru a intelege mai bine modul cum este gandit acest limbaj de programare, hai sa analizam un program si sa-l intelegem impreuna:

```
% Prima data definim ce stim sigur ca este adevarat, adica niste *facts*
parent(john, mary).
parent(john, paul).
parent(susan, mary).
parent(susan, paul).
parent(paul, lisa).
parent(paul, james).
parent(mary, sophia).
parent(mary, tom).

% Acum vom defini regulile, adica rationamentele pe care ne bazam ca sa obtinem alte lucruri despre care sa putem spune ca sunt adevarate
father(X, Y) :- parent(X, Y), male(X).

mother(X, Y) :- parent(X, Y), female(X).

grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% Alte *facts*
male(john).
male(paul).
male(james).
male(tom).
female(susan).
female(mary).
female(lisa).
female(sophia).

% Acum dorim sa vedem daca, plecand de la ce stim noi ca e adevarat si folosind rationamentele descrise, anumite lucruri sunt corecte sau nu (pot fi demonstrate sau nu)
?- grandparent(X, sophia).

?- ancestor(john, tom).

?- sibling(paul, X).
```

## Sintaxa Prolog
- Limbajul Prolog lucreaza cu **predicate**, **variabile** si **constante**
- **Predicatele** reprezinta fie **facts** fie rationamente; in cazul rationamentelor puteti sa le vizualizati ca niste functii recursive ce cauta acele **facts** prin pattern matching exhaustiv (toate variantele posibile); **exemplificare**
- **Variabilele** sunt componente ale programului ce au rolul de a reprezenta constantele in definirea predicatelor; in cadrul interogarilor ele vor fi inlocuite de constantele aferente, fie de utilizator, fie de program prin backtracking **ele trebuie sa inceapa cu litera mare sau cu `_`** altfel vor fi interpretate drept constante; **exemplificare**
- **Constantele** reprezinta componente ale programului care definesc lucruri concrete: un numar, un string, un atom, ce se vor folosi pentru a inlocui variabilele
- **Un atom** este o secventa de litere, cifre si alte simboluri (**trebuie sa inceapa neaparat cu litera mica**) ce defineste o valoare fixa (un fel de obiect constant); putin neintuitivi, ei au rolul de a abstractiza valori

### **Operatorii**

**1. Logical Operators**
| Operator | Meaning | Example |
|----------|---------|---------|
| `,`  | Logical AND (both must be true) | `happy(X), rich(X).` |
| `;`  | Logical OR (at least one must be true) | `happy(X) ; rich(X).` |
| `\+`  | **Logical NOT** (negation) | `\+ happy(john).` (John is **not** happy) |

**2. Comparison Operators**
| Operator | Meaning | Example |
|----------|---------|---------|
| `==`  | Equality check (syntactic comparison) | `X == Y.` |
| `\==` | Not equal | `X \== Y.` |
| `=`   | Unification (assigns values if possible) | `X = 5.` |
| `is`  | Evaluates expressions (used for arithmetic) | `X is 3 + 2.` |
| `>`   | Greater than | `X > Y.` |
| `<`   | Less than | `X < Y.` |
| `>=`  | Greater than or equal | `X >= Y.` |
| `=<`  | Less than or equal | `X =< Y.` |

**3. Arithmetic Operators**
| Operator | Meaning | Example |
|----------|---------|---------|
| `+`  | Addition | `X is 5 + 3.` |
| `-`  | Subtraction | `X is 7 - 2.` |
| `*`  | Multiplication | `X is 4 * 6.` |
| `/`  | Division (floating-point) | `X is 9 / 2.` |
| `//` | Integer division | `X is 9 // 2.` |
| `mod` | Modulus (remainder) | `X is 10 mod 3.` |

**4. Unification and Matching Operators**
| Operator | Meaning | Example |
|----------|---------|---------|
| `=`   | Unification (matches terms) | `X = john.` |
| `\=`  | Not unifiable (terms must not match) | `X \= john.` |
| `==`  | Strict equality (no variable binding) | `f(1) == f(1).` |
| `\==` | Strict inequality | `f(X) \== f(1).` |


## Executia unui program
- Inlocuire
- Pattern matching si backtracking
- Tipuri de rezultate obtinute
- **Trace**