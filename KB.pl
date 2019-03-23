:- dynamic rules/1.

rules([rid5]).

:- dynamic max_ruleId/1.

max_ruleId(5).

:- dynamic rule/3.

rule(rid5, values([A, _, _, B, C]), D) :-
    A=no,
    B=yes,
    C=brown,
    D="No Problem O.M.P".

