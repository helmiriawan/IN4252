/* Import file */
%web_drop_table(work.import);
filename reffile 'merged.csv';
proc import datafile = reffile
	replace
	dbms = csv
	out = work.mydata;
	getnames=yes;
run;


/* Descriptive statistics */
proc means data = work.mydata;
	var nPhotos nFollowers nFollows nComments nTags nGroups nFaves;
run;


/* Generate histogram */
proc univariate data = work.mydata;
	/* histogram nFaves; */
	histogram nFaves / midpoints = 0 to 50 by 1 vscale = count ;
run;


/* Negative binomial regression analysis */
ods output parameterestimates = pe;
proc genmod data = work.mydata;
	model nFaves = nComments nTags nPhotos nFollowers nFollows nGroups /dist=negbin;
	/*make 'parmest' out =  myfile;*/
run;
proc print data = pe label noobs; 
   format _numeric_ 12.6 ;
run;
