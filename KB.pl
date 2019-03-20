:- dynamic rules/1, max_ruleId/1, rule/3.
rules([rid1,rid2,rid3,rid4,rid5]).
max_ruleId(5).

rule(rid1,values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water]),Answer):-
	Lab_values=yes,
	Which_ones=oxidability,
	Oxidability= smaller,
	Answer="Severe O.M.P".
	
rule(rid2,values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water]),Answer):-
	Lab_values=yes,
	Which_ones=oxidability,
	Oxidability = medium,
	Answer="Moderate O.M.P".
	
rule(rid3,values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water]),Answer):-
	Lab_values=yes,
	Which_ones=oxidability,
	Oxidability = bigger,
	Answer="No Problem O.M.P".
	
rule(rid4,values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water]),Answer):-
	Lab_values=no,
	Cloudy_water=yes,
	Colour_of_water=grey,
	Answer="Very Severe O.M.P".
	
rule(rid5,values([Lab_values,Which_ones,Oxidability,Cloudy_water,Colour_of_water]),Answer):-
	Lab_values=no,
	Cloudy_water=yes,
	Colour_of_water=brown,
	Answer="No Problem O.M.P".
	
	
	
