:-use_module(library(http/thread_httpd)).
:-use_module(library(http/http_dispatch)).
:-use_module(library(http/html_write)).
:-use_module(library(http/html_head)).
:-use_module(library(http/http_error)).
:-use_module(library(http/http_parameters)).
:-use_module(library(http/http_session)).
:-use_module(library(http/http_path)).

:-http_handler('/',web_form,[]).
:-http_handler('/apotelesmata', results,[]).
:-http_handler('/diagnose', diagnose,[]).
:-http_handler('/update', updateKB,[]).
:-http_handler('/exit',exit_page,[]).
:-http_handler('/showDialog',showDialog_page,[]).   
:-http_handler('/deleteRulePage',deleteRule_pa,[]).               
:-http_handler('/editRulePage',editRule_pa,[]).                 
:-http_handler('/addRulePage',addRule_pa,[]).                  
:-http_handler('/addSuc',addition,[]).
:-http_handler('/editSuc',edition,[]).
:-http_handler('/delSuc',deletion,[]).


/* Εδώ ουσιαστικά ανεβάζουμε στον σέρβερ το kb.pl για να εμφανίσουμε τους κανόνες στην σελίδα μας */ 
:- http_handler('/kb',  http_reply_file('KB.pl', []), []).
:- http_handler('/initialization.js', http_reply_file('initialization.js',[]),[]).