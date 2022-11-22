% Constraint Logic Programming
:- use_module(library(clpfd)).	% Finite domain constraints

/**
  21u-23u 23u-01u 01u-03u 03u-05u
    R1       R2     R3      R4
    L1       L2     L3      L4
    S1       S2     S3      S4
    D1       D2     D3      D4
    W1       W2     W3      W4

Als je met een cijfertje aangeeft wat ze die moment moeten doen, 
of zelfs 2x20 "onbekenden" als je met 0/1 aangeeft op welke shift ze staan. 
(= misschien makkelijker)
HIerop kan je constraints toevoegen zodat de bezetting kloppen, 
het aantal shiften per medewerker begrensd wordt enz ...
Denk meer in termen van matrices en rijen en kolommen 
en schrijf je aparte predicaten om ervoor te zorgen dat de som van een kolom gelijk is aan een waarde enz....

Er zijn een aantal medewerkers die op een fuif kunnen helpen (bv. Robbe, Lisa, Seppe, Dorien en Wesley).
De avond wordt in een aantal shiften gedeeld (bv. 21u-23u, 23u-01u, 01u-03u, 03u-05u).
Daarnaast zijn er een aantal gewenste bezettingen per shift.
Aan de tap is dat bijvoorbeeld [1, 3, 2, 2]
en aan de bonnetjes [1, 2, 2, 1].

Opgelet:
Dorien kan niet tappen
Wesley kan niet aan de bonnetjes zitten.

Uiteraard kan een medewerker niet op 2 plaatsen tegelijk helpen.

21u-23u 23u-01u 01u-03u 03u-05u
	1		2		3		4
*/
/**
 transpose([[a, b, c, d],
        [e, f, g, h],
        [i, j, k, l],
        [m, n, o, p],
        [q, r, s, t]], X).
X = [[a, e, i, m, q], [b, f, j, n, r], [c, g, k, o, s], [d, h, l, p, t]]
*/



workers([robbe, lisa, seppe, dorien, wesley]).
worktimes([shift_1, shift_2, shift_3, shift_4]).

% acties dat elke werker kan uitvoeren
actions(robbe, [drinks, tickets]).
actions(lisa, [drinks, tickets]).
actions(dorien, [tickets]).
actions(seppe, [drinks, tickets]).
actions(wesley, [drinks]).

requirements(drinks, [1, 3, 2, 2]).
requirements(tickets, [1, 2, 2, 1]).

%read(X), X == 1 -> 
% doe als 1
%;
% doe wat het anders moet doen
%.

print_row([]).
print_row([H|R]) :- string_length(H, L), TL is 6-L, tab(TL), write(H), print_row(R).

print_table([]).
print_table([H|R]) :- print_row(H), nl, print_table(R).

make_schedule([[R1, R2, R3, R4],[W1, W2, W3, W4],[L1, L2, L3, L4],[S1, S2, S3, S4],[D1, D2, D3, D4]]) :-
    Vars = [[R1, R2, R3, R4],[W1, W2, W3, W4],[L1, L2, L3, L4],[S1, S2, S3, S4],[D1, D2, D3, D4]],
    print_table(Vars).
    
can_do_work(Worker, Action) :- actions(Worker, Lijst), member(Action, Lijst).    

meets_requirements(Time) :- worktimes(Hours_list), member(Time, Hours_list).


