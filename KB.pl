:- dynamic rules/1.

rules([rid6, rid7, rid8, rid9]).

:- dynamic max_ruleId/1.

max_ruleId(9).

:- dynamic rule/3.

rule(rid6, values([_, A, B, _, _]), C) :-
    true,
    A=B,
    C='ante geia'.
rule(rid7, values([_, A, _, _, _]), B) :-
    true,
    A=oxidability,
    B='ante geia'.
rule(rid8, values([A, B, _, _, _]), C) :-
    A=yes,
    B=oxidability,
    C='ante geia'.
rule(rid9, values([_, A, B, _, _]), C) :-
    true,
    A=B,
    C='ante geia'.

