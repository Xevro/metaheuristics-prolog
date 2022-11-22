workers([robbe, lisa, seppe, dorien, wesley]).
worktimes([shift_21_23u, shift_23_01u, shift_01_03u, shift_03_05u]).

% Taken die elke werknemer kan uitvoeren
actions(robbe, [drinks, tickets]).
actions(lisa, [drinks, tickets]).
actions(wesley, [drinks]).
actions(dorien, [tickets]).
actions(seppe, [drinks, tickets]).

% Contraints voor elke taak, array geeft drukte aan per shift (worktimes)
requirements(drinks, [1, 3, 2, 2]).
requirements(tickets, [1, 2, 2, 1]).

print_row([]).
print_row([H|T]) :- write(H), tab(3), print_row(T).

print_table([], []).
print_table([H1|T1], [H|T]) :- write(H1), tab(5), print_row(H), nl, print_table(T1, T).

print_schedules(Print_Action) :-
    Print_Action = both,
    print_drinks(), print_tickets() ;
    Print_Action = drinks,
    print_drinks() ;
    Print_Action = tickets,
    print_tickets().

print_tickets() :-
    worktimes(Shifts),
    make_table(_, Tickets),
    writeln("Werkschema voor de inkom tickets:"),
    print_table(Shifts, Tickets), nl.

print_drinks() :-
    worktimes(Shifts),
    make_table(Drinks, _),
    writeln("Werkschema voor de bar (toog):"),
    print_table(Shifts, Drinks), nl.

print_workers() :-
    workers(Workers),
    write('Overzicht van alle werknemers:'), nl,
    print_row(Workers), nl.

print_shifts() :-
    worktimes(Worktimes),
    write('Overzicht van alle werktijden:'), nl,
    print_row(Worktimes), nl.

menu_option(Choice) :-
    Choice = 1,
    print_schedules(both) ;
    Choice = 2,
    print_schedules(drinks) ;
    Choice = 3,
    print_schedules(tickets) ;
    Choice = 4,
    print_workers() ;
    Choice = 5,
    print_shifts() ;
    Choice = 6,
    abort.


menu() :-
    write('-------------------------- MENU -------------------------'), nl,
    write('> Voer een keuze in (en eindig met een punt).'), nl,
    write('> 1. Print een werkschema overzicht van alle activiteiten'), nl,
    write('> 2. Print een werkschema overzicht van de bar (toog) activiteiten'), nl,
    write('> 3. Print een werkschema overzicht van de inkom tickets activiteiten'), nl,
    write('> 4. Print een overzicht van alle werknemers'), nl,
    write('> 5. Print een overzicht van alle werktijden'), nl,
    write('> 6. Afsluiten van het programma'), nl, nl,
    read(Choice),
    menu_option(Choice), menu.


% Opmaken van werkschema voor beide taken (Drinks en Tickets)
schedular([], Drinks_Schedule, Drinks_Schedule, Tickets_Schedule, Tickets_Schedule, _).
schedular([_|T], Drinks, Drinks_Schedule, Ticket, Tickets_Schedule, Slot) :-
    workers(Workers),
    % Een lijst van alle werknemers die de bar kunnen doen aanmaken
    once(make_list(Workers, drinks, [], Drinks_Workers)),
    % Alle requirements voor de bar ophalen en in Drinks_Requirements laden
    requirements(drinks, Drinks_Requirements),
    % Voor het huidige slot de verreiste werknemer vinden
    nth0(Slot, Drinks_Requirements, Drinks_Requirement),
    % Toekennen van werknemer op het slot volgens de verreiste
    once(assign_Workers(Drinks_Requirement, Drinks_Workers, [], Assigned_Workers1)),
    % De toegekende werkenemerslijst aan de vorige toegekende werknemers toevoegen
    append(Drinks, [Assigned_Workers1], Drinks1),
    % Doorzoeken van de lijst met alle werknemers die kunnen werken voor de tickets behalve die dat al toegekend zijn
    once(make_list(Workers, tickets, Assigned_Workers1, Tickets_Workers)),
    % Alle requirements voor de tickets ophalen en in Tickets_Requirements laden
    requirements(tickets, Tickets_Requirements),
    % Voor het huidige slot werknemer de verreiste vinden
    nth0(Slot, Tickets_Requirements, Tickets_Requirement),
    once(assign_Workers(Tickets_Requirement, Tickets_Workers, [], Assigned_Workers2)),
    % De toegekende werkenemerslijst aan de vorige toegekende werknemers toevoegen
    append(Ticket, [Assigned_Workers2], Ticket1),
    Slot1 is Slot + 1,
    schedular(T, Drinks1, Drinks_Schedule, Ticket1, Tickets_Schedule, Slot1).


make_table(Drinks, Ticket) :-
    worktimes(Shifts),
    schedular(Shifts, [], Drinks, [], Ticket, 0), !.


make_list(Workers, Job, Assigned, New_Workers) :-
    % Zoeken van de werknemers die enkel 1 taak kunnen en aan een lijst toevoegen
    once(make_list1(Workers, Job, Assigned, Workers1, 1)),
    % Zoeken van de werknemers die meer dan 1 taak kunnen en aan een lijst toevoegen
    once(make_list1(Workers, Job, Assigned, Workers2, 2)),
    % Beide lijsten samenvoegen
    append(Workers1, Workers2, New_Workers).


make_list1([], _, L, L, _).
make_list1([H|T], Job, L1, L, Len) :-
    % Controleren of de werken al toegekend is
    once(not(member(H, L1))),
    % Zoek alle actions dat een werknemer kan doen
    actions(H, Actions),
    % Controleren of de actions van een werknemer gelijk is aan een gegeven lengte
    length(Actions, Len),
    % Controleren of een werknemer de gevraagde action kan doen
    member(Job, Actions),
    % Voeg werknemer toe aan de werknemerslijst
    append(L1, [H], L2),
    make_list1(T, Job, L2, L, Len) ;
    % Als de werknemer al toegekend is dan wordt de werknemer verwijderd uit de lijst
    delete(L1, H, L2),
    make_list1(T, Job, L2, L, Len).


assign_Workers(0, _, Assigned_Workers, Assigned_Workers).
assign_Workers(Requirement, [H|T], Non_Assigned, Assigned) :-
    Requirement > 0,
    append(Non_Assigned, [H], Assign),
    Remaining is Requirement - 1,
    assign_Workers(Remaining, T, Assign, Assigned).
