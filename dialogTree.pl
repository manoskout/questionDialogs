/**
Δέντρο διαλόγων

    Έχουν την μορφή 
    dialog(Id,ParentId,QuestionDesc,AnswerAllowedValues, VariableName)
    πχ.dialog(1,0,"Start ?", "Should we start?", AnswerValues{yes:["Ναι",2], no:["Όχι",3]}, "Start").


    Πρέπει να υπάρχει πάντα ένα Root node με ταυτότητα 0 και ταυτότητα πατέρα -1:
    dialog(0,-1,"Αρχή", AnswerValues{yes:["Ναι", 1], "Start"}).

    Πρέπει να υπάρχει πάντα ένα μοναδικό leaf node, το final node με ταυτότητα -1 και ταυτότητα πατέρα οτιδήποτε:
    dialog(-1,-2," Τέλος",AnswerValues{ yes: ["Nai",-1]}, "End").
*/

dialog(0, -1, "ΑΡΧΗ", AnswerValues{yes:["Ναι", 1]}, "Start").

dialog(1, 0, "Υπάρχουν εργαστηριακά δεδομένα;", AnswerValues{yes:["Ναι",2], no:["Όχι",3]},"Lab_values").
    /*Ροή ερωτήσεων όσον αφορά για το αν υπάρχουν εργαστηριακά δεδομένα */
dialog(2, 1, "Ποια από όλα;", AnswerValues{oxidability:["Oxidability",4]},"Which_ones").
dialog(4, 1, "Ποσοστό oxidability (%)", AnswerValues{smaller:[" <3%",-1], medium:[" >3 && =<7",-1], bigger:[" >7",-1]}, "Oxidability").
    /*Ροή ερωτήσεων όσον αφορά για το αν ΔΕΝ υπάρχουν εργαστηριακά δεδομένα */
dialog(3, 1, "Είναι θολό το νερό;", AnswerValues{yes:["Ναι",7], no:["Όχι",7]},"Cloudy_water").
dialog(7, 3, "Τι χρώμα έχει το νερό;", AnswerValues{grey:["Γκρι",-1], brown:["Καφέ",-1]},"Colour_of_water").

dialog(-1, -2," Τέλος", AnswerValues{ yes: ["Nai",-1]}, "End").








ruleData("values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water])").