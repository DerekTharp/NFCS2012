LIBNAME comps 'C:\Data\NFCS';

DATA comps.comps;
set comps.finra2012;

/*Emergency Fund*/

if J5=1 then efund=1; 
if j5=2 then efund=0;

risk = j2;
if j2 in (98, 99) then risk= '.';

/*age*/

agecat= A3Ar_w;
if agecat=1 then age18to24=1; else age18to24=0;
if agecat=2 then age25to34=1; else age25to34=0;
if agecat=3 then age35to44=1; else age35to44=0;
if agecat=4 then age45to54=1; else age45to54=0;
if agecat=5 then age55to64=1; else age55to64=0;
if agecat=6 then age65plus=1; else age65plus=0;
if 2<=agecat<=5;


/*Income*/
if a8 in (1,2,3) then incomelt35=1; else incomelt35=0;
if a8=4 then income35to50=1; else income35to50=0;
if a8=5 then income50to75=1; else income50to75=0;
if a8=6 then income75to100=1; else income75to100=0;
if 7<=a8<=8then income100plus=1; else income100plus=0;

if a8=98 or a8=99 or a8='.' then incomelt35='.' and income35to50='.' and income50to75='.' and income75to100='.' and income100plus='.'; 


/*employment status*/

employmentcats=A9;

if 	employmentcats	=	1	then 	workself	=	1	;	else 	workself	=	0;
if 	employmentcats	=	2	then 	workfull	=	1	;	else 	workfull	=	0;
if 	employmentcats	=	3	then 	workpart	=	1	;	else 	workpart	=	0;
if 	4<= employmentcats <=6	then 	workother	=	1	;	else 	workother	=	0;
if 	employmentcats	=	7	then 	workunemployed	=	1	;	else 	workunemployed	=	0;
if 	employmentcats	=	8	then 	workretired	=	1	;	else 	workretired	=	0 ;  
if workretired=0;

if A9=99 or A9='.' then workself='.' and workfull='.' and workpart='.' and workother='.' and workunemployed='.';

/*financial knowledge*/
if M6=1 then compoundinterest=1; else compoundinterest=0;
if M7=3 then inflation=1; else inflation=0;
if M8=2 then bonds=1; else bonds=0;
if M9=1 then mortgages=1; else mortgages=0;
if M10=2 then diversification=1; else diversification=0;
finknowledge= compoundinterest + inflation + bonds + mortgages + diversification;

if m6= '.' or m7='.' or m8='.' or m9='.' or m10='.' or m6= 99 or m7=99 or m8=99 or m9=99 or m10=99 then finknowledge='.';

/*education*/ 
edcats=A5_2012;
if 	edcats	=	1	then 	edulths	=	1	;	else 	edulths	=	0	;
if 	2<= edcats	<=	3	then 	eduhs	=	1	;	else 	eduhs	=	0	;
if 	edcats	=	4	then 	edusomcoll	=	1	;	else 	edusomcoll	=	0	;
if 	edcats	=	5	then 	educoll	=	1	;	else 	educoll	=	0	;
if 	edcats	=	6	then 	edugraduate	=	1	;	else 	edugraduate	=	0	;
if A5_2012 = 99 or A5_2012= '.' then edulths='.' and eduhs='.' and edusomcoll='.' and educoll='.' and edugraduate='.';

/*censusregion*/
if CENSUSREG =1 then northeast=1; else northeast=0;
if CENSUSREG =2 then midwest=1; else midwest=0;
if CENSUSREG =3 then south=1; else south=0;
if CENSUSREG =4 then west=1; else west=0;
if censusreg='.' then northeast='.' and midwest= '.' and south='.' and west='.';

/*marital status*/
marcats= A7A;  
if 	marcats	=	1	then 	statmar	=	1	;	else 	statmar	=	0	;
if 	marcats	=	2	then 	statcohab	=	1	;	else 	statcohab	=	0	;
if 	marcats	=	3	then 	statsingle	=	1	;	else 	statsingle	=	0	;
if A7A = '.' then statmar='.' and statcohab='.' and statsingle='.';

run;

proc freq data=comps.comps;
table efund risk finknowledge age35to44 age45to54 age55to64 eduhs edusomcoll educoll edugraduate statmar statcohab workself workpart workother workunemployed 
midwest south west income35to50  income50to75 income75to100 income100plus;
run;

proc reg data=comps.comps;
model risk = efund finknowledge age35to44 age45to54 age55to64 eduhs edusomcoll educoll edugraduate statmar statcohab workself workpart workother workunemployed 
midwest south west income35to50  income50to75 income75to100 income100plus;
run;

proc calis data=comps.comps method=fiml;
 path risk <- efund finknowledge age35to44 age45to54 age55to64 eduhs edusomcoll educoll edugraduate statmar statcohab workself workpart workother workunemployed 
midwest south west income35to50  income50to75 income75to100 income100plus;
run; 

PROC UNIVARIATE;
VAR efund;
HISTOGRAM efund;
RUN;

PROC NPAR1WAY WILCOXON;
CLASS efund;
VAR efund;
RUN;



