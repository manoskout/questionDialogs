:- dynamic rules/1.

rules([rid4]).

:- dynamic max_ruleId/1.

max_ruleId(5).

:- dynamic rule/3.

rule(rid4, values([A, _, _, B, C]), D) :-
    A=no,
    B=yes,
    C=grey,
    D="Very Severe O.M.P".

