/*
ΚΟΥΤΟΥΛΑΚΗΣ ΕΜΜΑΝΟΥΗΛ 4002

URL : localhost:8000
*/
:-style_check(-singleton).
:-encoding(utf8).
:-set_prolog_flag(encoding,utf8).

/*     Load KB , KS, Dialog Tree     
Σημαντικό γιατί είναι ένα από τα κύρια χαρακτιριστηκά οργάνωσης κώδικα  
       πχ. οι μεθόδοι διαγραφης και ότιδήποτε άλλο χρησημοποίησα εκτός από το στίσημο της σελίδας τά έχω μεταφέρει σε άλλο Προλόγκ αρχείο και το καλώ  εδώ*/
:- consult('load_handlers.pl').% Περιέχει τις βιβλιοθήκες και τους handlers που χρησιμοποίησα
:- consult('KB.pl').   % η βαση γνωσης
:- consult('dialogTree.pl'). % περιέχει του διαλόγους που θα εμφανιστούν στην σελίδα μας
:- consult('resources.pl'). % περιεχει την διαγραφη επεξεργασια, εισαγωγη, κανονα και διάφορα χρήσιμα κατηγορίματα που παραμετροποιούν τις συμβολοσειρές 




/*    Δημιουργία σέρβερ    */

server(Port):-
	http_server(http_dispatch,[port(Port)]).
server:-
	server(8000).
:-server.	 % αυτόματο κάλεσμα server με την εκκίνηση του προγράμματος



/*  ΑΡΧΙΚΗ ΣΕΛΙΔΑ ΕΠΙΛΟΓΩΝ */

web_form(_Request):-
    reply_html_page(
        [\headTemplate],
        [\bodyTemplate,\['
        <div class="container center">
            <br><a class="waves-effect waves-light btn" href="/diagnose">Διάγνωση νερού</a><br>
            <br><a class="waves-effect waves-light btn" href="/update">Ενημέρωση της Βάσης Γνώσης</a><br>
            <br><a class="waves-effect waves-light btn" href="/exitApp">Έξοδος</a>
        </div>
        
        ']]
    ).
	  
/*  ΣΕΛΙΔΑ ΕΠΙΛΟΓΩΝ ΓΙΑ ΕΝΗΜΕΡΩΣΗ ΤΗΣ ΒΑΣΗΣ ΓΝΩΣΗΣ  */

updateKB(Request):-
    reply_html_page(
      [\headTemplate],
      [\bodyTemplate, \['<h6 class="center"><b><u>Ενημέρωση της Βάσης Γνώσης.</u></b></h6><br>'],
        div([class="container center"],[\['
          <p>Σε αυτό το σημείο μπορείς να επιλέξεις μια από τις παρακάτω επιλογές για να ενημερώσεις την Βάση Γνώσης.</p>
          
          <ul class="collapsible popout">
            <li>
              <a class="black-text collapsible-header red" href="/deleteRulePage"><i class="material-icons left" >delete_forever</i>Διαγραφή κανόνα</a>
            </li>
            <li>
              <a class="black-text collapsible-header yellow" href="/editRulePage"><i class="material-icons left" >edit</i>Επεξεργασία κανόνα</a>
            </li>
            <li>
              <a class="black-text collapsible-header green" href="/addRulePage"><i class="material-icons left" >add_box</i>Προσθήκη κανόνα</a>
            </li>
            <li>
              <div class="collapsible-header"><i class="material-icons">whatshot</i>Προβολή Βάσης Γνώσης</div>
              <div class="collapsible-body">
                <iframe src="/kb" frameborder="0" height="400" width="100%"></iframe>
              </div>
            </li>
            <li>
              <a class="black-text collapsible-header teal" href="/"><i class="material-icons left" >home</i>Αρχική</a>
            </li>
          </ul>




          '
          ]
        ])  
      ]).
	  	
/* ΣΕΛΙΔΑ ΓΙΑ ΤΗΝ ΔΙΑΓΝΩΣΗ ΠΕΡΙΒΑΛΛΟΝΤΙΚΟ ΣΥΣΤΗΜΑ ΓΝΩΣΗΣ*/


diagnose(Request):-
    reply_html_page(
        [\headTemplate],
        [\bodyTemplate, \['<h6 class="center"><b><u>Διάγνωση</u></b></h6><br>'],
            div([class="container center"],[
                p('Διάγνωση με την μέθοδο Dry.')
        ]),
            div([class="center"],[
                form([action="/showDialog", method="post"],[
                    input([type="hidden", id="dialogId", name="dialogId",value="0"]),
                    input([type="hidden", id="answer", name="answer", value="yes"]),
                    \['<a id="small" href="/" class="waves-effect waves-light btn red accent-4"><i class="material-icons left">arrow_back</i>πίσω</a>'],
                    button([class="btn waves-effect waves-light green lighten-2", id="small", type="submit"],["Εκκίνηση"])
                ])
            ])   
    ]).


		/* ΣΕΛΙΔΑ ΑΠΟΤΕΛΕΣΜΑΤΩΝ */
 showDialog_page(Request):-
    member(method(post),Request),!,
    %write(dialogId),
    http_parameters(Request,
    [
        dialogId(Id,[atom]),
        answer(Answer,[atom])
    ]),
    atom_number(Id,DialogId),
    reply_html_page(
        [\headTemplate],
        [\bodyTemplate,\processDialog(DialogId,Answer)]
    ).


/*    ΔΙΑΛΟΓΙΚΉ ΣΕΛΙΔΑ ΓΙΑ ΤΗΝ ΔΙΑΓΝΩΣΗ */
processDialog(DialogId, Answer)-->
    {
      DialogId >=0,
      dialog(DialogId, _ParentId, _QuestionText, _AnswerValues, _VariableName),
      findall(Key, Value = _AnswerValues.Key, Keys),
      member(Answer, Keys),
      [Text, CurrentDialog] = _AnswerValues.Answer,
      CurrentDialog >=0,
      (
        (
          DialogId == 0,
          http_session_retractall(sessionData(SD)),
          http_session_assert(sessionData([[0, Answer, _VariableName]]))
        );
        (
          DialogId>0,
          http_session_data(sessionData(Sd)), %παίρνουμε τα δεδομένα του session
          append([[DialogId, Answer, _VariableName]], Sd, NewSessionData), % φτιαχνουμε την καινουρια μεταβλητη που θα μπει στο session

          http_session_assert(sessionData(NewSessionData)), % βαζουμε τα καινουρια δεδομένα νεο session
          http_session_retractall(sessionData(Sd)) % σβηνουμε το παλιο)
        )
      ),
      dialog(CurrentDialog, ParentId, QuestionText, AnswerValues, VariableName),
      atom_string(CurrentDialog, StringCurrentDialog),
      findall([Key1, Label, NextDialog], [Label, NextDialog]=AnswerValues.Key1, Values),
      [[SelectedKey, _, _]| _] = Values
    },
    html([
      \['
        <form class="center" action="showDialog" method="post">
          <h6><b>Διαλόγοι με ερωτήσεις</b></h6>
          <div class="container">
            <table class="highlight responsive-table" >
              <thead>
                <tr>

                    <th>Ερώτηση</th>
                    <th>Απάντηση</th>
                </tr>
              </thead>
              <tbody>
                <tr>'],td([],QuestionText),

                td([],[
                input([type="hidden", id="dialogId", name="dialogId", value=StringCurrentDialog], " "),
                \getAllAnswersRadios(Values, SelectedKey)]),
            \['</tr>
              </tbody>
            </table>
          </div>
          <br>
          <a id="small" href="/" class="waves-effect waves-light btn  red accent-4"><i class="material-icons right">arrow_back</i>πισω</a>
          <button id="small" class="btn waves-effect waves-light" type="submit">επομενο<i class="material-icons right">send</i></button>
        </form>']

    ]).
processDialog(DialogId, Answer) -->
  {
    DialogId > 0,
    dialog(DialogId, _ParentId, _QuestionText, _AnswerValues, _VariableName),
    findall(Key, Value = _AnswerValues.Key, Keys),
    member(Answer, Keys),
    http_session_data(sessionData(Sd)),


    append([[DialogId, Answer, _VariableName]], Sd, NewSessionData),

    http_session_assert(sessionData(NewSessionData)),

    http_session_retractall(sessionData(Sd)),

    findall(
      [StringVariableName1, StringAnswer1],
      (
        member([_, Answer1, VariableName1], NewSessionData),
        atom_string(Answer1, StringAnswer1),
        atom_string(VariableName1, StringVariableName1)
      ),
      Substitutions
    ),

    ruleData(RuleData),
    replace(Substitutions, RuleData, RuleDataResult),

    term_string(TermOfRuleDataResult, RuleDataResult),
    retractall( TermOfRuleDataResult ),
    assertz(TermOfRuleDataResult),
    checkResults(RuleId, TermOfRuleDataResult, Answer2,Results)
  },

  html([
    \['<h6 class="center"><b>Το αποτέλεσμα της διάγνωσης είναι :</b></h6>'],
    div([class="container center"],[
        div([class="card-panel teal lighten-2"],[
        h4(Results)])  
    ]),
    div([class="container center"],
        \['<a id="small" href="/" class="waves-effect waves-light btn green accent-4"><i class="material-icons left">home</i>Αρχική</a>']
    )
  ]).

/* ΣΕ ΠΕΡΙΠΤΩΣΗ ΠΟΥ ΔΕΝ ΥΠΑΡΧΕΙ ΤΟ ΣΥΣΤΗΜΑ ΜΑΣ ΒΓΑΖΕΙ BAD REQUEST */
processDialog(DialogId, Answer)-->
      html(h3("Bad Request")).

/*   ΕΛΕΓΧΟΣ ΑΝ Ο ΚΑΝΟΝΑΣ ΥΠΑΡΧΕΙ ΣΤΗΝ ΒΑΣΗ ΓΝΩΣΗΣ*/

checkResults(RuleId, TermOfRuleDataResult, Answer2,Results):-
    (bagof(Answer2, rule(RuleId, TermOfRuleDataResult, Answer2), Results));
    (Results = 'Ουπς!Δεν υπάρχει στην Βάση Γνωσης μπορείς αν θές να το προσθέσεις.').

/*  ΣΕΛΙΔΑ ΕΙΣΑΓΩΓΗΣ ΝΕΟΥ ΚΑΝΟΝΑ*/

addRule_pa(_Request):-
  reply_html_page(
      [\headTemplate],
      [\bodyTemplate, \['<h6 class="center"><b><u>Ενημέρωση της Βάσης Γνώσης.</u></b></h6><br>'],
        div([class="container center"],[\['
          <form class="col s12" action="/addSuc" method="POST">             
            <div class="input-field col s12">
              <input id="dataR" name="newRuleData" type="text" class="validate" value="values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water])">
              <label for="dataR">Δώσε τα δεδομένα : </label>
            </div>
            <div class="input-field col s12">
              <input id="conR" name="newRuleCon" type="text" class="validate">
              <label for="conR">Δώσε τις προυποθέσεις :  </label>
            </div>
            <div class="input-field col s12">
              <input id="resR" name="newRuleResult" type="text" class="validate">
              <label for="resR">Δώσε το αποτέλεσμα : </label>
            </div>
            <br>
            <a class="waves-effect waves-light btn-small" href="/update"><i class="material-icons left" >arrow_back</i>Back</a>
            <button class="black-text btn waves-effect waves-light green" type="submit" name="action">ADD</button>
            <a class="waves-effect waves-light btn-small" href="/"><i class="material-icons left" >home</i>Home</a> 
            <br><br><br>
          </form> 
          ']
        ])  
  ]).

/*  ΑΚΟΛΟΥΘΕΙ Η ΣΕΛΙΔΑ addition ΟΠΟΥ ΜΑΣ ΒΓΑΖΕΙ ΑΝ ΕΓΙΝΕ Η ΕΙΣΑΓΩΓΗ ΕΠΙΤΥΧΩΣ  */
addition(Request):-
    member(method(post),Request),!,
    http_parameters(Request,
    [
        newRuleData(RuleData,[length>0, string]),
        newRuleCon(RuleCon,[length>0, string]),
        newRuleResult(RuleResult,[length>0, string])
    ]),
    addRule(RuleData,RuleCon,RuleResult),
    reply_html_page(
      [\headTemplate],
      [\bodyTemplate, \['<h6 class="center"><b><u>Ενημέρωση της Βάσης Γνώσης.</u></b></h6><br>'],
        div([class="container center"],[\['
          <p>Η εισαγωγή έγινε επιτυχώς.</p>
          <a class="waves-effect waves-light btn-small" href="/"><i class="material-icons left" >home</i>Home</a> 
          ']
        ])  
      ]).


/* ΣΕΛΙΔΑ ΔΙΑΓΡΑΦΉΣ ΚΑΝΟΝΑ */

deleteRule_pa(_Request):-
  reply_html_page(
      [\headTemplate],
      [\bodyTemplate, \['<h6 class="center"><b><u>Ενημέρωση της Βάσης Γνώσης.</u></b></h6><br>'],
        div([class="container center"],[\['
          <form class="col s12" action="/delSuc" method="POST">             
            <div class="input-field col s12">
              <input id="idtoEdit" name="ruleId" type="text" class="validate">
              <label for="idtoEdit">Δώσε RuleId για διαγραφή : </label>
            </div>
            <br><br>
            <a class="waves-effect waves-light btn-small" href="http://localhost:8080/update"><i class="material-icons left" >arrow_back</i>Back</a>
            <button class="black-text btn waves-effect waves-light red" type="submit" name="action">ΔΙΑΓΡΑΦΗ</button>
            <a class="waves-effect waves-light btn-small" href="http://localhost:8080"><i class="material-icons left" >home</i>Home</a> 
            <br><br><br>
          </form> 
          ']
        ])  
  ]).

deletion(Request):-
  http_parameters(Request,[
    ruleId(Id,[default('NULL')])
    ]),
    deleteRule(Id),
    reply_html_page(
      [\headTemplate],
      [\bodyTemplate,\['<h6 class="center"><b><u>Ενημέρωση της Βάσης Γνώσης.</u></b></h6><br>'],
        div([class="container center"],[\['
          <p>Η διαγραφή έγινε επιτυχώς.</p>
          <a class="waves-effect waves-light btn-small" href="/"><i class="material-icons left" >home</i>Home</a> 
        ']
      ])  
    ]).

/* ΣΕΛΙΔΑ ΕΠΕΞΕΡΓΑΣΙΑΣ ΕΝΟΣ ΥΠΑΡΧΟΝΤΟΣ ΚΑΝΟΝΑ ΣΤΟ ΣΥΣΤΗΜΑ ΓΝΩΣΗΣ */

editRule_pa(_Request):-
  reply_html_page(
      [\headTemplate],
      [\bodyTemplate, \['<h6 class="center"><b><u>Ενημέρωση της Βάσης Γνώσης.</u></b></h6><br>'],
        div([class="container center"],[\['
          <form class="col s12" action="/editSuc" method="POST">     
            <div class="input-field col s12">
              <input id="idtoEdit" name="ruleIdforEdit" type="text" class="validate">
              <label for="idtoEdit">Δώσε RuleId για επεξεργασία : </label>
            </div>        
            <div class="input-field col s12">
              <input id="dataR" name="newRuleData" type="text" class="validate" value="values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water])">
              <label for="dataR">Δώσε τα δεδομένα : </label>
            </div>
            <div class="input-field col s12">
              <input id="conR" name="newRuleCon" type="text" class="validate">
              <label for="conR">Δώσε τις προυποθέσεις :  </label>
            </div>
            <div class="input-field col s12">
              <input id="resR" name="newRuleResult" type="text" class="validate">
              <label for="resR">Δώσε το αποτέλεσμα : </label>
            </div>
            <br>
            <a class="waves-effect waves-light btn-small" href="/update"><i class="material-icons left" >arrow_back</i>Back</a>
            <button class="black-text btn waves-effect waves-light green" type="submit" name="action">ADD</button>
            <a class="waves-effect waves-light btn-small" href="/"><i class="material-icons left" >home</i>Home</a> 
            <br><br><br>
          </form> 
          ']
        ])  
  ]).

edition(Request):-
  http_parameters(Request,[
    ruleIdforEdit(RuleId,[default('NULL')]),
    newRuleData(RuleData,[length>0, string]),
    newRuleCon(RuleCon,[length>0, string]),
    newRuleResult(RuleResult,[length>0, string])
  ]),
  editRule(RuleId,RuleData,RuleCon,RuleResult),
  reply_html_page(
  [\headTemplate],
  [\bodyTemplate,\['<h6 class="center"><b><u>Ενημέρωση της Βάσης Γνώσης.</u></b></h6><br>'],
  div([class="container center"],[\['
    <p>Η τροποποίηση έγινε επιτυχώς.</p>
    <a class="waves-effect waves-light btn-small" href="/"><i class="material-icons left" >home</i>Home</a> 
    ']
    ])  
  ]).

 

/*  ΕΙΝΑΙ ΤΑ TEMPLATES ΤΩΝ ΣΕΛΙΔΩΝ ΓΙΑ ΝΑ ΜΗΝ ΧΡΕΙΑΣΤΕΙ ΝΑ ΕΠΑΝΑΛΑΜΒΑΝΟΜΑΣΤΕ ΚΑΘΕ ΦΟΡΑ */
headTemplate -->
  html(\['
    <title>WebAppExaple</title>
    <meta charset="UTF-8">
	<!-- Compiled and minified CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">

    <!-- Compiled and minified JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    <script src="initialization.js"></script>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
  ']).
bodyTemplate-->
  html(
  \['
  <nav>
    <div class="nav-wrapper teal lighten-2">
      <a href="#" class="brand-logo center">Τμήμα Μηχανικών Πληροφορικής</a>
    </div>
  </nav>
  <h5 class="center">Prolog Web App example</h5>
  ']).