/* ΜΕΘΟΔΟΣ ΔΙΑΓΡΑΦΗΣ */
deleteRule(ID):-
	retract( (rule(ID,_,_):-_) ),
	rules(List),
	delete(List,ID,NewList),
	retract(rules(List)),
	asserta(rules(NewList)),
	saveKB.
/* ΜΕΘΟΔΟΣ ΠΡΟΣΘΗΚΗΣ */
addRule(RuleData,RuleCon,RuleResult):-
    %προσθήκη max_ruleId 
    max_ruleId(MaxID),
    NewMaxID is MaxID+1,
    atom_concat(rid,NewMaxID,NewRuleId),
    retract( max_ruleId(MaxID) ),
    asserta( max_ruleId(NewMaxID) ),

    %προσθήκη στα Rules
    rules(List),
    append(List,[NewRuleId],NewList),
    retract(rules(List)),
    asserta(rules(NewList)),
    atom_string(NewRuleId, SRuleId),
    string_list_concat(
    [
      "rule(", SRuleId, ",", RuleData, ",", "Answer", "):-",
      RuleCon, ",", "Answer", "='", RuleResult, "'"
    ],
    StringRule),
    term_string(Rule, StringRule),
	assertz(Rule),
    saveKB.

/* ΜΕΘΟΔΟΣ ΕΠΕΞΕΡΓΑΣΙΑΣ */
editRule(RuleId,RuleData,RuleCon,RuleResult):-
    atom_string(RuleId, SRuleId),
    retract( (rule(RuleId,_,_):-_) ),
    string_list_concat(
    [
      "rule(", SRuleId, ",", RuleData, ",", "Answer", "):-",
      RuleCon, ",", "Answer", "='", RuleResult, "'"
    ],
    StringRule),
    term_string(Rule, StringRule),
	assertz(Rule),
    saveKB.

/* ΜΕΘΔΟΔΟΣ ΑΠΟΘΗΚΕΥΣΗΣ */
saveKB:-
	tell('KB.pl'),
	listing(rules),
	listing(max_ruleId),
	listing(rule),
	told.

/* ΕΝΩΝΕΙ ΟΛΑ ΤΑ STRING ΣΤΗ ΛΙΣΤΑ 
ΠΑΡΑΔΕΊΓΜΑΤΑ
 ?- string_list_concat(["1"], S).
 S = "1".
 
 ?- string_list_concat(["1", 2], S).
 false.

 ?- string_list_concat(["1", "2", "3"], S).
 S = "123"
*/
string_list_concat([], S):- 
  S = "".
string_list_concat([H], S):- !, 
  string(H), 
  S = H.
string_list_concat([H|T], S):- 
  string_list_concat([H|T], "", S).
string_list_concat([H|T], Acc, S):- 
  string(H),
  string_concat(Acc, H, Acc1),
  string_list_concat(T, Acc1, S).
string_list_concat([], Acc, S):- 
  S = Acc.


/* Για την μέθοδο Dry κάνουμε όλες τις ερωτήσεις να είναι τύπου radio button */
/* ΑΥΤΗ Η ΣΥΝΑΡΤΗΣΗ ΕΠΙΣΤΡΕΦΕΙ ΜΙΑ ΛΙΣΤΑ ΑΠΟ ΤΙΣ ΕΠΙΛΟΓΕΣ ΤΟΥ ΧΡΗΣΤΗ */
getAllAnswersRadios(AnswerValues, SelectedKey) -->
  getAnswersRadios(AnswerValues, SelectedKey).
getAnswersRadios([], _SelectedKey) -->
  [].
getAnswersRadios([H|T], SelectedKey) -->
  answerRadio(H, SelectedKey),
  getAnswersRadios(T, SelectedKey).
answerRadio(AnswerRadio, SelectedKey) -->
  {
    [Key, Label, _NextDialog] = AnswerRadio,
    atom_string(Key, StringKey),
    (
      (
        Key = SelectedKey,
        InputAttributes = [type="radio", name="answer", value=StringKey, checked=""]
      )
      ;
      (
        InputAttributes = [type="radio", name="answer", value=StringKey]
      )
    )
  },
    html([
      label([],[
        input(InputAttributes),
        span([],[Label])
      ])]).


 
/**
 
 Example:
 ?- replace([], "Manos Koutoulakis", Result).
 Result = "Manos Koutoulakis".
 
 ?- replace("", "Manos Koutoulakis", Result).
 false.
 
 ?- replace([""], "Manos Koutoulakis", Result).
 Result = "Manos Koutoulakis".
 */
replace([], OriginalString, Result):-
  string(OriginalString),
  Result = OriginalString, !.
replace(Substitutions, OriginalString, Result):-
  string(OriginalString),
  is_list(Substitutions),
  replace1(Substitutions, OriginalString, Result).
replace1(Substitutions, OriginalString, Result):-
  replace2(Substitutions, OriginalString, Acc, Result).
replace2([], String, Acc, Result):- !,
  Result = String.
replace2([[S1, S2]|T], String, Acc, Result):- !,
  replace(S1, S2, String, Acc),
  replace2(T, Acc, Acc1, Result).
replace2(Substitutions, String, Acc, Result):-
  Result = String.
/* Αυτό θα αντικαταστήσει την πρώτη εμφάνιση του String1 στο OriginalString με το String2.
ΠΑΡΑΔΕΙΓΜΑ
?- replace("2", "_|_", "121", Result).
Result = "1_|_1".
*/
replace(String1, String2, OriginalString, Result):- 
  string(String1), string_length(String1, String1Length), String1Length > 0,
  string(String2),
  string(OriginalString),

  % ΑΥΤΟ ΘΑ ΑΠΟΤΥΧΕΙ ΑΝ String1 ΔΕΝ ΥΠΑΡΧΕΙ ΤΟ OriginalString
  sub_string(OriginalString, Before, Length, After, String1),
  sub_string(OriginalString, 0, Before, _, LeftString),
  Before1 is Before+Length,
  sub_string(OriginalString, Before1, After, _, RightString),
  string_concat(LeftString, String2, TempString),
  string_concat(TempString, RightString, Result), !.
% ΑΝ replace(String1, String2, OriginalString, Result) ΑΠΟΤΥΧΕΙ ΤΟΤΕ ΕΠΙΣΤΡΕΦΕΙ OriginalString.
replace(String1, String2, OriginalString, Result):-
  Result = OriginalString.
