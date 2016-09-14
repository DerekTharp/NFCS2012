LIBNAME nfcs 'C:\Data\NFCS';

*If I screw up data, change all nfcs in (DATA nfcs.nfcs & SET nfcs.finra2012 to something else;

*Clean data should have 25,509 observations and 129 variables;

*NFCS 2012 Notes:
-500 resopndents per state (plus DC)
-Quoats within each state for: Age, Gender, Income, Ethnicity, Education
-For all questions in survey except A3a and E5: 98 = Don't know / 99 = Prefer not to say
	-For A3a: 999 = prefer not to say
	-For E5: -98 = Don't know / -99 = Prefer not to say;

DATA nfcs.nfcs;
SET nfcs.finra2012;

*A3) What is your gender? 1 = Male / 2 = Female [Recode] 0 = Male / 1 = Female;
*no missing data;

	*GENDER;
	if A3=1 then gender = 0;
	else gender = 1;

		*MALE;
		if A3=1 then male=1;
		else male=0;

			*FEMALE;
			if A3=2 then female=1;
			else female=0;

*A3Ar_w) What is your age?;
	agecat=A3Ar_w;

	*Age categories;
	if agecat=1 then age18to24=1; else age18to24=0;
	if agecat=2 then age25to34=1; else age25to34=0;
	if agecat=3 then age35to44=1; else age35to44=0;
	if agecat=4 then age45to54=1; else age45to54=0;
	if agecat=5 then age55to64=1; else age55to64=0;
	if agecat=6 then age65plus=1; else age65plus=0;
	


*A4) Which of the following best describes your race or ethnicity? 1 = White or Caucasian / 0 = Other;
*No missing data;		

	*Dummy variables for RACE OR ETHNICITY;
	race=a4;
	if race=1 then white=1; else white=0;             		  *WHITE;
	if race=2 then other=1; else other=0;             		  *OTHER;

*A5_2012) What was the last year of education that you completed? [No missing data]
	1. Did not complete high school
	2. High school graduate - regular HS diploma
	3. High school graduate - GED or alternative credential
	4. Some college
	5. College graduate
	6. Post graduate education
	99. Prefer not to say;


	*Education categories (less than HS, HS, some College, College, Graduate;
	edcats=A5_2012;
	if 	edcats	=	1	then 	edulths	=	1	;	else 	edulths	=	0	;
	if 	2<= edcats	<=	3	then 	eduhs	=	1	;	else 	eduhs	=	0	;
	if 	edcats	=	4	then 	edusomcoll	=	1	;	else 	edusomcoll	=	0	;
	if 	edcats	=	5	then 	educoll	=	1	;	else 	educoll	=	0	;
	if 	edcats	=	6	then 	edugraduate	=	1	;	else 	edugraduate	=	0	;
	if A5_2012 = 99 or A5_2012= '.' then edulths='.' and eduhs='.' and edusomcoll='.' and educoll='.' and edugraduate='.';

	*Education categories (Less than College, Some College, College Graduate, Graduate School);
	
	if 	1<= edcats	<=	3	then 	LessThanCollege	=	1	;	else 	LessThanCollege	=	0	;
	if 	edcats	=	4	then 	SomeCollege	=	1	;	else 	SomeCollege	=	0	;
	if 	edcats	=	5	then 	College	=	1	;	else 	College	=	0	;
	if 	edcats	=	6	then 	Graduate	=	1	;	else 	Graduate	=	0	;
	if A5_2012 = 99 or A5_2012= '.' then LessThanCollege='.' and SomeCollege='.' and College='.' and Graduate='.';

*A6) What is your marital status? [No missing data]
	1. Married
	2. SIngle
	3. Seperated
	4. Divorced
	5. Widowed/widower
	99. Prefer not to say (no responses);

	marcats=A6;
	*Marital status (2 categories);
	if marcats = 1 then married = 1; else married = 0;

		*Marital status (all categories);
		if marcats = 1 then married = 1; else married = 0;
		if marcats = 2 then single = 1; else single = 0;
		if marcats = 3 then seperated = 1; else seperated = 0;
		if marcats = 4 then divorced = 1; else divorced = 0;
		if marcats = 5 then widow = 1; else widow = 0;
		if A6="." or A6=99 then married="." and single="." and seperated="." and divorced="." and widow=".";

*A7) Which of the following describes your current living arrangements? [No missing data]
	1. I am the only adult in the household
	2. I live with my spouse/partner/significant other
	3. I live in my parents' home
	4. I live with other family, friends, or roommates
	99. Prefer not to say (No responses);
		
	livingarrangement=a7;

		*Living arrangement (all categories);
		if livingarrangement = 1 then livealone = 1; else livealone = 0;
		if livingarrangement = 2 then livewithsigother = 1; else livewithsigother=0;
		if livingarrangement = 3 then livewithparents = 1; else livewithparents=0;
		if livingarrangement = 4 then livewithfamother = 1; else livewithfamother=0;
		if a7="." or a7=99 then livealone = "." and livewithsigother="." and livewithparents="." and livewithfamother=".";
	
			*Living arrangement (3 categories);
			if livingarrangement = 1 then livealone = 1; else livealone = 0;
			if livingarrangement = 2 then livewithsigother = 1; else livewithsigother=0;
			if 3 <= livingarrangement <= 4 then livewithother = 1; else livewithother=0;
			if a7="." or a7=99 then livealone = "." and livewithsigother="." and livewithother=".";

*A7a) BUILDER VARIABLE: Household living arrangement and marital status? [No missing data]
	1. Married
	2. Living with partner
	3. Single;
		household=a7a;

		*Household (arrangement and marital status);
		if household = 1 then hhmarried = 1; else hhmarried = 0;
		if household = 2 then hhlivewithpartner = 1; else hhlivewithpartner = 0;
		if household = 3 then hhsingle = 1; else hhsingle = 0;
		if a7a="." then hhmarried="." and hhlivewithpartner="." and hhsingle=".";

*A11) How many children do you have who are financially dependent on you or your spouse/partner? Please include children
	not living at home, and step-children as well. [No missing data]
	1. 1
	2. 2
	3. 3
	4. 4 or more
	5. No financially dependent children
	6. Do not have any children
	99. Prefer not to say (No responses);
		findependent=a11;

		*Number of financial dependent children (not truly continuous due to 4 or more response);
		if 5 <= findependent <= 6 then dependents = 0;
		else if findependent = 1 then dependents = 1;
		else if findependent = 2 then dependents = 2;
		else if findependent = 3 then dependents = 3;
		else if findependent = 4 then dependents = 4;   *note: this is actually 4+;

			*Financial dependent children (4 categories);
			if 5 <= findependent <= 6 then dependents0 = 1; else dependents0 = 0;
			if findependent = 1 then dependents1 = 1; else dependents1 = 0;
			if findependent = 2 then dependents2 = 1; else dependents2 = 0;
			if 3 <= findependent <= 4 then dependents3plus = 1; else dependents3plus = 0;

*A8) What is your approximate annual income, including wages, tips, investment income, public assistance, income from
	retirement plans, etc.? Would you say it is... [No missing data]
	1. Less than $15,000
	2. At least $15,000 but less than $25,000
	3. At least $25,000 but less than $35,000
	4. At least $35,000 but less than $50,000
	5. At least $50,000 but less than $75,000
	6. At least $75,000 but less than $100,000
	7. At least $100,000 but less than $150,000
	8. $150,000 or more
	98. Don't know (No responses)
	99. Prefer not to say (No responses;

		incomecat=a8;
		
		*Income (all categories);
		if incomecat = 1 then incomelt15k = 1; else incomelt15k = 0;
		if incomecat = 2 then income15to25k = 1; else income15to25k = 0;
		if incomecat = 3 then income25to35k = 1; else income25to35k = 0;
		if incomecat = 4 then income35to50k = 1; else income35to50k = 0;
		if incomecat = 5 then income50to75k = 1; else income50to75k = 0;
		if incomecat = 6 then income75to100k = 1; else income75to100k = 0;
		if incomecat = 7 then income100to150k = 1; else income100to150k = 0;
		if incomecat = 8 then incomegt150k = 1; else incomegt150k = 0;

			*Income (5 categories);
			if 1 <= incomecat <= 3 then incomelt35k = 1; else incomelt35k = 0;
			if incomecat = 4 then income35to50k = 1; else income35to50k = 0;
			if incomecat = 5 then income50to75k = 1; else income50to75k = 0;
			if incomecat = 6 then income75to100k = 1; else income75to100k = 0;
			if 7 <= incomecat <= 8 then incomegt100k = 1; else incomegt100k = 0;
	
*AM21) Have you ever been a member of the US Armed Services, either in the active or reserve component? [no missing data, but prefer to to say]
	1. Currently a member of the US Armed Services
	2. Previously a member of the US Armed Services
	3. Never a member of the US Armed Services
	99. Prefer not to say (311 responses);

		military=am21;

		*Military (3 categories);
		if military = 1 then militarycurrent = 1; 
		else if military = 99 or military = "." then militaryecurrent = ".";
		else militarycurrent = 0; 
				
		if military = 2 then militaryprevious = 1; 
		else if military = 99 or military = "." then militaryprevious = "."; 
		else militaryprevious = 0;
				
		if military = 3 then militarynever = 1;
		else if military = 99 or military = "." then militarynever = "."; 
		else militarynever = 0; 

*AM22) Has your spouse ever been a member of the US Armed Services, either in the active or reserve component? [missing 11,189]
	1. Currently a member of the US Armed Services
	2. Previously a member of the US Armed Services
	3. Never a member of the US Armed Services
	99. Prefer not to say (112 responses);

		militaryspouse=am22;

		*Military spouse (3 categories);
		if militaryspouse = 1 then militaryspousecurrent = 1; 
		else if militaryspouse = 99 or militaryspouse = "." then militaryspousecurrent = "."; 
		else militaryspousecurrent = 0;
				
		if militaryspouse = 2 then militaryspouseprevious = 1; 
		else if militaryspouse = 99 or militaryspouse = "." then militaryspouseprevious = "."; 
		else militaryspouseprevious = 0;
				
		if militaryspouse = 3 then militaryspousenever = 1;
		else if militaryspouse = 99 or militaryspouse = "." then militaryspousenever = "."; 
		else militaryspousenever = 0;

*A9) Which of the following best describes your current employment or work status?
	1. Self employed
	2. Work full-time for an employer
	3. Work part-time for an employer
	4. Homemaker
	5. Full-time student
	6. Permanently sick, disabled, or unable to work
	7. Unemployed or temporarily laid off
	8. Retired
	99. Prefer not to say (no responses);

		workstatus=a9;
				
		*Work status (all categories);
		if workstatus = 1 then selfemployed = 1; else selfemployed = 0; 
		if workstatus = 2 then workft = 1; else workft = 0; 
		if workstatus = 3 then workpt = 1; else workpt = 0; 
		if workstatus = 4 then homemaker = 1; else homemaker = 0; 
		if workstatus = 5 then ftstudent = 1; else ftstudent = 0; 
		if workstatus = 6 then disabled = 1; else disabled = 0; 
		if workstatus = 7 then unemployed = 1; else unemployed = 0; 
		if workstatus = 8 then retired = 1; else retired = 0; 

*A10) Which of the following best describes your spouse/partner's current employment or work status? (9163 missing / NA)
	1. Self employed
	2. Work full-time for an employer
	3. Work part-time for an employer
	4. Homemaker
	5. Full-time student
	6. Permanently sick, disabled, or unable to work
	7. Unemployed or temporarily laid off
	8. Retired
	99. Prefer not to say (no responses);

		spworkstatus=a10;
				
		*Spouse work status (all categories);
		if spworkstatus = 1 then spselfemployed = 1; 
		else if spworkstatus = '.' then spselfemployed = '.';
		else spselfemployed = 0; 

		if spworkstatus = 2 then spworkft = 1; 
		else if spworkstatus = '.' then spworkft = '.';
		else spworkft = 0;
 
		if spworkstatus = 3 then spworkpt = 1;  
		else if spworkstatus = '.' then spworkpt = '.';
		else spworkpt = 0;

		if spworkstatus = 4 then sphomemaker = 1; 
		else if spworkstatus = '.' then sphomemaker = '.';
		else sphomemaker = 0; 

		if spworkstatus = 5 then spftstudent = 1; 
		else if spworkstatus = '.' then spftstudent = '.';
		else spftstudent = 0; 

		if spworkstatus = 6 then spdisabled = 1; 
		else if spworkstatus = '.' then spdisabled = '.';
		else spdisabled = 0; 

		if spworkstatus = 7 then spunemployed = 1; 
		else if spworkstatus = '.' then spunemployed = '.';
		else spunemployed = 0; 

		if spworkstatus = 8 then spretired = 1;  
		else if spworkstatus = '.' then spretired = '.';
		else spretired = 0;

*A10a) [Builder Variable] Household retirement status [no missing data]
	1. Non-retired household
	2. Retired household (respondent retired)
	3. Retired household (respondent not working and spouse retired);

		hhretirement=a10a;

		*Household retirement status (all categories);
		if hhretirement = 1 then hhnotretired = 1; else hhnotretired = 0;
		if hhretirement = 2 then hhrespretired = 1; else hhrespretired = 0;
		if hhretirement = 3 then hhspouseretired = 1; else hhspouseretired=0;

*A21) Are you a part-teim student taking courses for credit? [11352 missing]
	1. Yes
	2. No
	98. Don't know (69 responses)
	99. Prefer not to say (29 responses);

		ptstatus=a21;

		*Part time status;
		if ptstatus = 1 then ptstudent = 1; 
		else if ptstatus='.' or 98 <= ptstatus <= 99 then ptstudent = '.';
		else ptstudent = 0;

		if ptstatus = 2 then notptstudent = 1; 
		else if ptstatus ='.' or 98 <= ptstatus <= 99 then notptstudent = '.';
		else notptstudent = 0;

*A22) Which of the following best describes the school you are attending? [23740 missing]
	1. Four-year college or university
	2. Tow-year community college
	3. Vocational, technical, or trade school
	4. Other
	98. Don't know (10 responses)
	99. Prefer not to say (18 responses);

		schoolstatus=a22;

		*School status;
		if schoolstatus = 1 then fouryear = 1;
		else if schoolstatus ='.' or 98 <= schoolstatus <= 99 then fouryear ='.';
		else fouryear = 0;

		if schoolstatus = 2 then twoyear = 1;
		else if schoolstatus ='.' or 98 <= schoolstatus <= 99 then twoyear ='.';
		else twoyear = 0;

		if schoolstatus = 3 then vocational = 1;
		else if schoolstatus ='.' or 98 <= schoolstatus <= 99 then vocational ='.';
		else vocational = 0;
		
		if schoolstatus = 4 then schoolother = 1;
		else if schoolstatus ='.' or 98 <= schoolstatus <= 99 then schoolother ='.';
		else schoolother = 0;


*A14) Who in the household is most knowledgeable about saving, investing, and debt? [9163 missing]
	1. You
	2. Someone else
	3. You and someone else are equally knowledgeable
	98. Don't know (475 responses)
	99. Prefer not to say (127 responses);

		mostknow=a14;

		*Household most knowledgeable;
		if mostknow = 1 then respknow = 1;
		else if mostknow ='.' or 98 <= mostknow <= 99 then respknow = '.';
		else respknow = 0;

		if mostknow = 2 then spouseknow = 1;
		else if mostknow ='.' or 98 <= mostknow <= 99 then spouseknow = '.';
		else spouseknow = 0;

		if mostknow = 3 then equalknow = 1;
		else if mostknow ='.' or 98 <= mostknow <= 99 then equalknow = '.';
		else equalknow = 0;

*[SECTION J: FINANCIAL ATTITUDES & BEHAVIORS];

*J1) Overall, thinking of your assets, debts, and savings, how satisfied are you with your current personal 
	financial condition? Please us a 10-point scale, where 1 means "Not At All Satisfied" and 10 means 
	"Extremely Satisfied." [No missing data]
		1 - 10
		98. Don't know (288 responses)
		99. Prefer not to say (203 responses);

		finsat=j1;
	
		*Satisifaction with personal financial condition;
		if 1 <= finsat <= 10 then finsatscale = finsat;
		else if finsat ='.' or 98 <= finsat <= 99 then finsatscale = '.';
		else finsatscale = 0;

*J2) When thinking of your financial investments, how willing are you to take risks? Please use a 10-point scale, where 
	1 means "Not At All Willing" and 10 means "Very Willing." [No missing data]
		1 - 10
		98. Don't know (622 responses)
		99. Prefer not to say (195 responses;

		finrisk=j2;

		*Willingness to take financial risk;
		if 1 <= finrisk <= 10 then finriskscale = finrisk;
		else if finrisk ='.' or 98 <= finrisk <= 99 then finriskscale = '.';
		else finriskscale = 0;

*J3) Over the past year, would you say your/household spending was less than, more than, or about equal to
	your/household's income? Please do not include the purchase of a new house or car, or other big investments
	you may have made.                        [No missing data]
		1. Spending less than income
		2. Spending more than income
		3. Spending about equal to income
		98. Don't know (837 responses)
		99. Prefer not to say (160 responses);

		hhspending=j3;

		*Household spending relative to income;
		if hhspending = 1 then hhspendingless = 1;
		else if hhspending='.' or 98 <= hhspending <= 99 then hhspendingless='.';
		else hhspendingless = 0;

		if hhspending = 2 then hhspendingmore = 1;
		else if hhspending='.' or 98 <= hhspending <= 99 then hhspendingmore='.';
		else hhspendingmore = 0;

		if hhspending = 3 then hhspendingequal = 1;
		else if hhspending='.' or 98 <= hhspending <= 99 then hhspendingequal='.';
		else hhspendingequal = 0;

*J4) In a typical month, how difficult is it for you to cover your expenses and pay all your bills?  [No missing data]
		1. Very difficult
		2. Somewhat difficult
		3. Not at all difficult
		98. Don't know (329 responses)
		99. Prefer not to say (185 responses);

		paydifficult=j4;

		*Difficulty paying bills in a typical month;
		if paydifficult = 1 then paydifficultvery = 1;
		else if paydifficult='.' or 98 <= paydifficult <= 99 then paydifficultvery='.';
		else paydifficultvery=0;

		if paydifficult = 2 then paydifficultsome = 1;
		else if paydifficult='.' or 98 <= paydifficult <= 99 then paydifficultsome='.';
		else paydifficultsome=0;

		if paydifficult = 3 then paydifficultno = 1;
		else if paydifficult='.' or 98 <= paydifficult <= 99 then paydifficultno='.';
		else paydifficultno=0;

*J5) Have you set aside emergency or rainy day funds that would cover your expenses for 3 months in case of sickness,
	job loss, economic downturn, or other emergencies?  [No missing data]
		1. Yes
		2. No
		98. Don't know (663 responses)
		99. Prefer not to say (349 responses);

		efund=j5;

		*Emergency fund;
		if efund = 1 then efundyes = 1;
		else if efund='.' or 98 <= efund <= 99 then efundyes='.';
		else efundyes = 0;

		if efund = 2 then efundno = 1;
		else if efund='.' or 98 <= efund <= 99 then efundno='.';
		else efundno = 0;

*J6) Are you setting aside any money for your children's college education? [15644 missing]
		1. Yes
		2. No
		98. Don't know (139 responses)
		99. Prefer not to say (180 responses);

		collegesave=j6;

		*College Savings;
		if collegesave = 1 then collegesaveyes = 1;
		else if collegesave='.' or 98 <= collegesave <= 99 then collegesaveyes='.';
		else collegesaveyes = 0;

		if collegesave = 2 then collegesaveno = 1;
		else if collegesave='.' or 98 <= collegesave <= 99 then collegesaveno='.';
		else collegesaveno = 0;

*J8) Have you ever tried to figure out how much you need to save for retirement? [5071 missing]
		1. Yes
		2. No
		98. Don't know (680 responses)
		99. Prefer not to say (213 responses);

		retiresave=j8;

		*Tried to figure out retirement savings?;
		if retiresave = 1 then retiresaveyes = 1;
		else if retiresave='.' or 98 <= retiresave <= 99 then retiresaveyes='.';
		else retiresaveyes = 0;

		if retiresave = 2 then retiresaveno = 1;
		else if retiresave='.' or 98 <= retiresave <= 99 then retiresaveno='.';
		else retiresaveno = 0;

*J9) Before you/your spouse retired, did you try to figure out how much you needed to save for retirement? [20438 missing]
		1. Yes
		2. No
		98. Don't know (129 responses)
		99. Prefer not to say (82 responses);

		retirecalc=j9;

		*Tried to figure out retirement savings?;
		if retirecalc = 1 then retirecalcyes = 1;
		else if retirecalc='.' or 98 <= retirecalc <= 99 then retirecalcyes='.';
		else retirecalcyes = 0;

		if retirecalc = 2 then retirecalcno = 1;
		else if retirecalc='.' or 98 <= retirecalc <= 99 then retirecalcno='.';
		else retirecalcno = 0;

*J10) In the past 12 months, has your household experienced a large drop in income which you did no expect? [No missing]
		1. Yes
		2. No
		98. Don't know (442 responses)
		99. Prefer not to say (208 responses);

		incomeshock=j10;

		*Tried to figure out retirement savings?;
		if incomeshock = 1 then incomeshockyes = 1;
		else if incomeshock='.' or 98 <= incomeshock <= 99 then incomeshockyes='.';
		else incomeshockyes = 0;

		if incomeshock = 2 then incomeshockno = 1;
		else if incomeshock='.' or 98 <= incomeshock <= 99 then incomeshockno='.';
		else incomeshockno = 0;

*J20) How confident are you that you could come up with $2,000 if an unexpected need arose within the next month? [No missing]
		1. I am certain I could come up with the full $2,000
		2. I could probably come up with $2,000
		3. I could probably not come up with $2,000
		4. I am certain I could not come up with $2,000
		98. Don't know (819)
		99. Prefer not to say (188);

		comeup2000=j20;

		*Confidence that you could come up with $2,000;
		if comeup2000 = 1 then comeup2000yes = 1;
		else if comeup2000='.' or 98 <= comeup2000 <= 99 then comeup200yes='.';
		else comeup2000yes = 0;

		if comeup2000 = 2 then comeup2000prob = 1;
		else if comeup2000='.' or 98 <= comeup2000 <= 99 then comeup2000prob='.';
		else comeup2000prob = 0;

		if comeup2000 = 3 then comeup2000probnot = 1;
		else if comeup2000='.' or 98 <= comeup2000 <= 99 then comeup2000probnot='.';
		else comeup2000probnot = 0;

		if comeup2000 = 4 then comeup2000no = 1;
		else if comeup2000='.' or 98 <= comeup2000 <= 99 then comeup2000no='.';
		else comeup2000no = 0;

*J11) In the past 12 months, have you obtained a copy of your credit report? [No missing]
		1. Yes
		2. No
		98. Don't know (327 responses)
		99. Prefer not to say (234 responses);

		obtaincredrep=j11;

		*Tried to figure out retirement savings?;
		if obtaincredrep = 1 then obtaincredrepyes = 1;
		else if obtaincredrep='.' or 98 <= obtaincredrep <= 99 then obtaincredrepyes='.';
		else obtaincredrepyes = 0;

		if obtaincredrep = 2 then obtaincredrepno = 1;
		else if obtaincredrep='.' or 98 <= obtaincredrep <= 99 then obtaincredrepno='.';
		else obtaincredrepno = 0;

*J12) In the past 12 months, have you checked your credit score? [No missing]
		1. Yes
		2. No
		98. Don't know (262 responses)
		99. Prefer not to say (220 responses);

		checkcredscore=j12;

		*Tried to figure out retirement savings?;
		if checkcredscore = 1 then checkcredscoreyes = 1;
		else if checkcredscore='.' or 98 <= checkcredscore <= 99 then checkcredscoreyes='.';
		else checkcredscoreyes = 0;

		if checkcredscore = 2 then checkcredscoreno = 1;
		else if checkcredscore='.' or 98 <= checkcredscore <= 99 then checkcredscoreno='.';
		else checkcredscoreno = 0;

*[SECTION K: FINANCIAL ADVISORS];

*K_) In the last 5 years have you asked for advice from a fianncial professional (outside the military, for
	military members) regarding of of the following?
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		debtadv=k_1;
		investmentadv=k_2;
		mortgageadv=k_3;
		insuranceadv=k_4;
		taxadv=k_5;

	*K_1) Debt Counseling 
		[Missing: No / Don't Know: 320 / Prefer not to say: 236];
		if debtadv = 1 then debtadvyes = 1;
		else if debtadv='.' or 98 <= debtadv <= 99 then debtadvyes='.';
		else debtadvyes = 0;

		if debtadv = 2 then debtadvno = 1;
		else if debtadv='.' or 98 <= debtadv <= 99 then debtadvno='.';
		else debtadvno = 0;

	*K_2) Investment advice 
		[Missing: No / Don't Know: 350 / Prefer not to say: 236];
		if investmentadv = 1 then investmentadvyes = 1;
		else if investmentadv='.' or 98 <= investmentadv <= 99 then investmentadvyes='.';
		else investmentadvyes = 0;

		if investmentadv = 2 then investmentadvno = 1;
		else if investmentadv='.' or 98 <= investmentadv <= 99 then investmentadvno='.';
		else investmentadvno = 0;

	*K_3) Mortgage/loan advice 
		[Missing: No / Don't Know: 326 / Prefer not to say: 224];
		if mortgageadv = 1 then mortgageadvyes = 1;
		else if mortgageadv='.' or 98 <= mortgageadv <= 99 then mortgageadvyes='.';
		else mortgageadvyes = 0;

		if mortgageadv = 2 then mortgageadvno = 1;
		else if mortgageadv='.' or 98 <= mortgageadv <= 99 then mortgageadvno='.';
		else mortgageadvno = 0;

	*K_4) Insurance advice 
		[Missing: No / Don't Know: 352 / Prefer not to say: 225];
		if insuranceadv = 1 then insuranceadvyes = 1;
		else if insuranceadv='.' or 98 <= insuranceadv <= 99 then insuranceadvyes='.';
		else insuranceadvyes = 0;

		if insuranceadv = 2 then insuranceadvno = 1;
		else if insuranceadv='.' or 98 <= insuranceadv <= 99 then insuranceadvno='.';
		else insuranceadvno = 0;

	*K_5) Tax advice 
		[Missing: No / Don't Know: 375 / Prefer not to say: 228];
		if taxadv = 1 then taxadvyes = 1;
		else if taxadv='.' or 98 <= taxadv <= 99 then taxadvyes='.';
		else taxadvyes = 0;

		if taxadv = 2 then taxadvno = 1;
		else if taxadv='.' or 98 <= taxadv <= 99 then taxadvno='.';
		else taxadvno = 0;

*[SECTION B: MONEY MANAGEMENT]

B20) In a typical month, does your household receive income (e.g., from work, from benefit programs, or from any
	other sources) in any of the following ways? (Select an answer for each)
		1. Yes
		2. No
		3. Don't know
		4. Prefer not to say;

		paidcash=b20_1;
		paidcheck=b20_2;
		paiddirectdeposit=b20_3;
		paiddebitcard=b20_4;

	*B20_1) Receive pay in cash
		[Missing: No / Don't Know: 236 / Prefer not to say: 371];
		if paidcash = 1 then paidcashyes = 1;
		else if paidcash='.' or 98 <= paidcash <= 99 then paidcashyes='.';
		else paidcashyes = 0;

		if paidcash = 2 then paidcashno = 1;
		else if paidcash='.' or 98 <= paidcash <= 99 then paidcashno='.';
		else paidcashno = 0;

	*B20_2) Receive pay in check
		[Missing: No / Don't Know: 233 / Prefer not to say: 359];
		if paidcheck = 1 then paidcheckyes = 1;
		else if paidcheck='.' or 98 <= paidcheck <= 99 then paidcheckyes='.';
		else paidcheckyes = 0;

		if paidcheck = 2 then paidcheckno = 1;
		else if paidcheck='.' or 98 <= paidcheck <= 99 then paidcheckno='.';
		else paidcheckno = 0;

	*B20_3) Receive pay in direct deposit
		[Missing: No / Don't Know: 246 / Prefer not to say: 375];
		if paiddirectdeposit = 1 then paiddirectdeposityes = 1;
		else if paiddirectdeposit='.' or 98 <= paiddirectdeposit <= 99 then paiddirectdeposityes='.';
		else paiddirectdeposityes = 0;

		if paiddirectdeposit = 2 then paiddirectdepositno = 1;
		else if paiddirectdeposit='.' or 98 <= paiddirectdeposit <= 99 then paiddirectdepositno='.';
		else paiddirectdepositno = 0;

	*B20_4) Receive pay in prepaid debit card
		[Missing: No / Don't Know: 267 / Prefer not to say: 373];
		if paiddebitcard = 1 then paiddebitcardyes = 1;
		else if paiddebitcard='.' or 98 <= paiddebitcard <= 99 then paiddebitcardyes='.';
		else paiddebitcardyes = 0;

		if paiddebitcard = 2 then paiddebitcardno = 1;
		else if paiddebitcard='.' or 98 <= paiddebitcard <= 99 then paiddebitcardno='.';
		else paiddebitcardno = 0;

*B11a) Do you or your spouse sometimes go to a check cashing store to cash checks?  [14991]
		1. Yes
		2. No
		98. Don't know (51)
		99. Prefer not to say (9);

		checkcashstore=b11a;

		*Use check cashing store;
		if checkcashstore = 1 then checkcashstoreyes = 1;
		else if checkcashstore='.' or 98 <= checkcashstore <= 99 then checkcashstoreyes='.';
		else checkcashstoreyes = 0;

		if checkcashstore = 2 then checkcashstoreno = 1;
		else if checkcashstore='.' or 98 <= checkcashstore <= 99 then checkcashstoreno='.';
		else checkcashstoreno = 0;

*B21) How did you receive most of your income in the past 12 months? [2223 missing]
		1. Cash
		2. Checks
		3. Direct deposit
		4. Prepaid debit cards
		98. Don't know (58 responses)
		99. Prefer not to say (58 responses);

		t12pay=b21;

		*Form of most payment over past 12 montsh;
		if t12pay = 1 then t12paycash = 1;
		else if t12pay='.' or 98 <= t12pay <= 99 then t12paycash='.';
		else t12paycash = 0;
		
		if t12pay = 2 then t12paycheck = 1;
		else if t12pay='.' or 98 <= t12pay <= 99 then t12paycheck='.';
		else t12paycheck = 0;

		if t12pay = 3 then t12paydirectdeposit = 1;
		else if t12pay='.' or 98 <= t12pay <= 99 then t12paydirectdeposit='.';
		else t12paydirectdeposit = 0;

		if t12pay = 4 then t12paydebit = 1;
		else if t12pay='.' or 98 <= t12pay <= 99 then t12paydebit='.';
		else t12paydebit = 0;

*B22) How often does your household use each of the following methods to make payments (e.g., for shopping, paying bills
	or for any other purposes)? (select an answer for each) []
		1. Frequently
		2. Sometimes
		3. Never
		98. Don't know ( responses)
		99. Prefer not to say ( responses);

		paycash=b22_1;
		paycheck=b22_2;
		paycredit=b22_3;
		paydebit=b22_4;
		payprepaydebit=b22_5;
		payonline=b22_6;
		paymoneyorder=b22_7;
		paytapmobile=b22_8;

	*B22_1) Pay using cash
		[0 Missing / 187 Don't Know / 234 Prefer not to say];
		if paycash = 1 then paycashfrequent = 1;
		else if paycash='.' or 98 <= paycash <= 99 then paycashfrequent='.';
		else paycashfrequent = 0;

		if paycash = 2 then paycashsome = 1;
		else if paycash='.' or 98 <= paycash <= 99 then paycashsome='.';
		else paycashsome = 0;

		if paycash = 3 then paycashnone = 1;
		else if paycash='.' or 98 <= paycash <= 99 then paycashnone='.';
		else paycashnone = 0;

	*B22_2) Pay using check
		[0 Missing / 203 Don't Know / 248 Prefer not to say];
		if paycheck = 1 then paycheckfrequent = 1;
		else if paycheck='.' or 98 <= paycheck <= 99 then paycheckfrequent='.';
		else paycheckfrequent = 0;

		if paycheck = 2 then paychecksome = 1;
		else if paycheck='.' or 98 <= paycheck <= 99 then paychecksome='.';
		else paychecksome = 0;

		if paycheck = 3 then paychecknone = 1;
		else if paycheck='.' or 98 <= paycheck <= 99 then paychecknone='.';
		else paychecknone = 0;

	*B22_3) Pay using credit
		[0 Missing / 212 Don't Know / 276 Prefer not to say];
		if paycredit = 1 then paycreditfrequent = 1;
		else if paycredit='.' or 98 <= paycredit <= 99 then paycreditfrequent='.';
		else paycreditfrequent = 0;

		if paycredit = 2 then paycreditsome = 1;
		else if paycredit='.' or 98 <= paycredit <= 99 then paycreditsome='.';
		else paycreditsome = 0;

		if paycredit = 3 then paycreditnone = 1;
		else if paycredit='.' or 98 <= paycredit <= 99 then paycreditnone='.';
		else paycreditnone = 0;

	*B22_4) Pay using debit
		[0 Missing / 212 Don't Know / 276 Prefer not to say];
		if paydebit = 1 then paydebitfrequent = 1;
		else if paydebit='.' or 98 <= paydebit <= 99 then paydebitfrequent='.';
		else paydebitfrequent = 0;

		if paydebit = 2 then paydebitsome = 1;
		else if paydebit='.' or 98 <= paydebit <= 99 then paydebitsome='.';
		else paydebitsome = 0;

		if paydebit = 3 then paydebitnone = 1;
		else if paydebit='.' or 98 <= paydebit <= 99 then paydebitnone='.';
		else paydebitnone = 0;

	*B22_5) Pay using pre-paid debit
		[0 Missing / 307 Don't Know / 294 Prefer not to say];
		if payprepaydebit = 1 then payprepaydebitfrequent = 1;
		else if payprepaydebit='.' or 98 <= payprepaydebit <= 99 then payprepaydebitfrequent='.';
		else payprepaydebitfrequent = 0;

		if payprepaydebit = 2 then payprepaydebitsome = 1;
		else if payprepaydebit='.' or 98 <= payprepaydebit <= 99 then payprepaydebitsome='.';
		else payprepaydebitsome = 0;

		if payprepaydebit = 3 then payprepaydebitnone = 1;
		else if payprepaydebit='.' or 98 <= payprepaydebit <= 99 then payprepaydebitnone='.';
		else payprepaydebitnone = 0;

	*B22_6) Pay using online payments
		[0 Missing / 259 Don't Know / 280 Prefer not to say];
		if payonline = 1 then payonlinefrequent = 1;
		else if payonline='.' or 98 <= payonline <= 99 then payonlinefrequent='.';
		else payonlinefrequent = 0;

		if payonline = 2 then payonlinesome = 1;
		else if payonline='.' or 98 <= payonline <= 99 then payonlinesome='.';
		else payonlinesome = 0;

		if payonline = 3 then payonlinenone = 1;
		else if payonline='.' or 98 <= payonline <= 99 then payonlinenone='.';
		else payonlinenone = 0;

	*B22_7) Pay using money orders
		[0 Missing / 286 Don't Know / 272 Prefer not to say];
		if paymoneyorder = 1 then paymoneyorderfrequent = 1;
		else if paymoneyorder='.' or 98 <= paymoneyorder <= 99 then paymoneyorderfrequent='.';
		else paymoneyorderfrequent = 0;

		if paymoneyorder = 2 then paymoneyordersome = 1;
		else if paymoneyorder='.' or 98 <= paymoneyorder <= 99 then paymoneyordersome='.';
		else paymoneyordersome = 0;

		if paymoneyorder = 3 then paymoneyordernone = 1;
		else if paymoneyorder='.' or 98 <= paymoneyorder <= 99 then paymoneyordernone='.';
		else paymoneyordernone = 0;

	*B22_8) Pay by waving/tapping mobile phone over sensor
		[0 Missing / 272 Don't Know / 280 Prefer not to say];
		if paytapmobile = 1 then paytapmobilefrequent = 1;
		else if paytapmobile='.' or 98 <= paytapmobile <= 99 then paytapmobilefrequent='.';
		else paytapmobilefrequent = 0;

		if paytapmobile = 2 then paytapmobilesome = 1;
		else if paytapmobile='.' or 98 <= paytapmobile <= 99 then paytapmobilesome='.';
		else paytapmobilesome = 0;

		if paytapmobile = 3 then paytapmobilenone = 1;
		else if paytapmobile='.' or 98 <= paytapmobile <= 99 then paytapmobilenone='.';
		else paytapmobilenone = 0;

*B1) Does your household have a checking account? [0 missing]
		1. Yes
		2. No
		98. Don't know (107 responses)
		99. Prefer not to say (303 responses);

		havechecking=b1;

		if havechecking = 1 then havecheckingyes = 1;
		else if havechecking='.' or 98 <= havechecking <= 99 then havecheckingyes='.';
		else havecheckingyes = 0;

		if havechecking = 2 then havecheckingno = 1;
		else if havechecking='.' or 98 <= havechecking <= 99 then havecheckingno='.';
		else havecheckingno = 0;

*B2) Does your household have a savings/money market account or CDs? [0 missing]
		1. Yes
		2. No
		98. Don't know (183 responses)
		99. Prefer not to say (314 responses);

		havesaving=b2;

		if havesaving = 1 then havesavingyes = 1;
		else if havesaving='.' or 98 <= havesaving <= 99 then havesavingyes='.';
		else havesavingyes = 0;

		if havesaving = 2 then havesavingno = 1;
		else if havesaving='.' or 98 <= havesaving <= 99 then havesavingno='.';
		else havesavingno = 0;

*B4) Do you or your partner/spouse overdraw your checking account occassionally? [2561 missing]
		1. Yes
		2. No
		98. Don't know (146 responses)
		99. Prefer not to say (161 responses);

		overdraw=b4;

		if overdraw = 1 then overdrawyes = 1;
		else if overdraw='.' or 98 <= overdraw <= 99 then overdrawyes='.';
		else overdrawyes = 0;

		if overdraw = 2 then overdrawno = 1;
		else if overdraw='.' or 98 <= overdraw <= 99 then overdrawno='.';
		else overdrawno = 0;

*B23) Has your household ever had an account at a bank or a credit union? [2561 missing]
		1. Yes
		2. No
		98. Don't know (146 responses)
		99. Prefer not to say (161 responses);

		overdraw=b4;

		if overdraw = 1 then overdrawyes = 1;
		else if overdraw='.' or 98 <= overdraw <= 99 then overdrawyes='.';
		else overdrawyes = 0;

		if overdraw = 2 then overdrawno = 1;
		else if overdraw='.' or 98 <= overdraw <= 99 then overdrawno='.';
		else overdrawno = 0;

*B23) Has your household ever had an account at a bank or credit union? [23951 missing]
		1. Yes
		2. No
		98. Don't know (23 responses)
		99. Prefer not to say (12 responses);

		everhadbank=b23;

		if everhadbank = 1 then everhadbankyes = 1;
		else if everhadbank='.' or 98 <= everhadbank <= 99 then everhadbankyes='.';
		else everhadbankyes = 0;

		if everhadbank = 2 then everhadbankno = 1;
		else if everhadbank='.' or 98 <= everhadbank <= 99 then everhadbankno='.';
		else everhadbankno = 0;

*B14) Does your household have any investments in stocks, bonds, mutual funds, or other securities? [1558 missing]
		1. Yes
		2. No
		98. Don't know (429 responses)
		99. Prefer not to say (492 responses);

		haveinvestments=b14;

		if haveinvestments = 1 then haveinvestmentsyes = 1;
		else if haveinvestments='.' or 98 <= haveinvestments <= 99 then haveinvestmentsyes='.';
		else haveinvestmentsyes = 0;

		if haveinvestments = 2 then haveinvestmentsno = 1;
		else if haveinvestments='.' or 98 <= haveinvestments <= 99 then haveinvestmentsno='.';
		else haveinvestmentsno = 0;

*[Section C: Retirement Accounts];

*****VARIABLE MISSING?************

*C1) Do you or your spouse have any retirement plans through a current or previous employer, like a 
	pension plan, a TSP, or a 401(k)? [ missing]
		1. Yes
		2. No
		98. Don't know ( responses)
		99. Prefer not to say ( responses);

		haveretirementplan=c1;

		if haveretirementplan = 1 then haveretirementplanyes = 1;
		else if haveretirementplan='.' or 98 <= haveretirementplan <= 99 then haveretirementplanyes='.';
		else haveretirementplanyes = 0;

		if haveretirementplan = 2 then haveretirementplanno = 1;
		else if haveretirementplan='.' or 98 <= haveretirementplan <= 99 then haveretirementplanno='.';
		else haveretirementplanno = 0;

*Also missing: C2, C3, C4, C5, C10, C11

******************************************************

*[Section D: Sources of Income];

*D20) Over the past 12 months, did you/your household receive any of the following types of income? 
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		earnedincome=d20_1;
		pensionincome=d20_2;
		retirementincome=d20_3;
		ssincome=d20_4;
		govincome=d20_5;
		businessincome=d20_6;
		familyincome=d20_7;

	*D20_1) Salaries, wages, freelance pay or tips
		[No Missing] (298 Don't know) (274 Prefer not to say);

		if earnedincome = 1 then earnedincomeyes = 1;
		else if earnedincome='.' or 98 <= earnedincome <= 99 then earnedincomeyes='.';
		else earnedincomeyes = 0;

		if earnedincome = 2 then earnedincomeno = 1;
		else if earnedincome='.' or 98 <= earnedincome <= 99 then earnedincomeno='.';
		else earnedincomeno = 0;

	*D20_2) Payments from pension plan
		[No Missing] (348 Don't know) (286 Prefer not to say);

		if pensionincome = 1 then pensionincomeyes = 1;
		else if pensionincome='.' or 98 <= pensionincome <= 99 then pensionincomeyes='.';
		else pensionincomeyes = 0;

		if pensionincome = 2 then pensionincomeno = 1;
		else if pensionincome='.' or 98 <= pensionincome <= 99 then pensionincomeno='.';
		else pensionincomeno = 0;

	*D20_3) Withdrawals from retirement accounts
		[No Missing] (389 Don't know) (283 Prefer not to say);

		if retirementincome = 1 then retirementincomeyes = 1;
		else if retirementincome='.' or 98 <= retirementincome <= 99 then retirementincomeyes='.';
		else retirementincomeyes = 0;

		if retirementincome = 2 then retirementincomeno = 1;
		else if retirementincome='.' or 98 <= retirementincome <= 99 then retirementincomeno='.';
		else retirementincomeno = 0;
		
	*D20_4) Social Security retirement benefits
		[No Missing] (338 Don't know) (316 Prefer not to say);

		if ssincome = 1 then ssincomeyes = 1;
		else if ssincome='.' or 98 <= ssincome <= 99 then ssincomeyes='.';
		else ssincomeyes = 0;

		if ssincome = 2 then ssincomeno = 1;
		else if ssincome='.' or 98 <= ssincome <= 99 then ssincomeno='.';
		else ssincomeno = 0;

	*D20_5) Other federal or state benefits (e.g., unemlpoyment, disability, SSI, TANF)
		[No Missing] (370 Don't know) (311 Prefer not to say);

		if govincome = 1 then govincomeyes = 1;
		else if govincome='.' or 98 <= govincome <= 99 then govincomeyes='.';
		else govincomeyes = 0;

		if govincome = 2 then govincomeno = 1;
		else if govincome='.' or 98 <= govincome <= 99 then govincomeno='.';
		else govincomeno = 0;

	*D20_6) Income from a business
		[No Missing] (319 Don't know) (304 Prefer not to say);

		if businessincome = 1 then businessincomeyes = 1;
		else if businessincome='.' or 98 <= businessincome <= 99 then businessincomeyes='.';
		else businessincomeyes = 0;

		if businessincome = 2 then businessincomeno = 1;
		else if businessincome='.' or 98 <= businessincome <= 99 then businessincomeno='.';
		else businessincomeno = 0;

	*D20_7) Money from family members who do not live in your household
		[No Missing] (304 Don't know) (322 Prefer not to say);

		if familyincome = 1 then familyincomeyes = 1;
		else if familyincome='.' or 98 <= familyincome <= 99 then familyincomeyes='.';
		else familyincomeyes = 0;

		if familyincome = 2 then familyincomeno = 1;
		else if familyincome='.' or 98 <= familyincome <= 99 then familyincomeno='.';
		else familyincomeno = 0;

*[SECTION E: HOME & MORTGAGES];

*Ea) Do you or your spouse/partner currently own any of the following?
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		ownhome=ea_1;
		otherrealestate=ea_2a;

	*Ea_1) Own your home?  [No Missing] (156 Don't Know) (189 Prefer not to say);

		if ownhome = 1 then ownhomeyes = 1;
		else if ownhome='.' or 98 <= ownhome <= 99 then ownhomeyes='.';
		else ownhomeyes = 0;

		if ownhome = 2 then ownhomeno = 1;
		else if ownhome='.' or 98 <= ownhome <= 99 then ownhomeno='.';
		else ownhomeno = 0;

	*Ea_2a) Own other real estate (second home, investment, etc.)?  [No Missing] (167 Don't Know) (190 Prefer not to say);

		if otherrealestate = 1 then otherrealestateyes = 1;
		else if otherrealestate='.' or 98 <= otherrealestate <= 99 then otherrealestateyes='.';
		else otherrealestateyes = 0;

		if otherrealestate = 2 then otherrealestateno = 1;
		else if otherrealestate='.' or 98 <= otherrealestate <= 99 then otherrealestateno='.';
		else otherrealestateno = 0;

*E4a) Approximately when did you buy your current home?
		1. 1999 or earlier	6. 2004		11. 2009	97. You did not purchase it
		2. 2000				7. 2005		12. 2010	98. Don't know
		3. 2001				8. 2006		13. 2011	99. Prefer not to say
		4. 2002				9. 2007		14. 2012
		5. 2003				10. 2008;	
		
		yearhomepurchased=e4a;

		 ***Think about how to code this***;

***No data for E5?***;

*E7) Do you currently have any mortgages on your home? [9970 Missing] (85 Don't Know) (82 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		currentmortgage=e7;

		if currentmortgage = 1 then currentmortgageyes = 1;
		else if currentmortgage='.' or 98 <= currentmortgage <= 99 then currentmortgageyes='.';
		else currentmortgageyes = 0;

		if currentmortgage = 2 then currentmortgageno = 1;
		else if currentmortgage='.' or 98 <= currentmortgage <= 99 then currentmortgageno='.';
		else currentmortgageno = 0;

*E8) Do you have any home equity loans? [9970 Missing] (316 Don't Know) (78 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		currentheloan=e8;

		if currentheloan = 1 then currentheloanyes = 1;
		else if currentheloan='.' or 98 <= currentheloan <= 99 then currentheloanyes='.';
		else currentheloanyes = 0;

		if currentheloan = 2 then currentheloanno = 1;
		else if currentheloan='.' or 98 <= currentheloan <= 99 then currentheloanno='.';
		else currentheloanno = 0;

*E20) Do you currently owe more on your home than you think you could sell it for? [15343 Missing] (775 Don't Know) (26 Prefer not to say)
		1. Yes, owe more
		2. No
		98. Don't know
		99. Prefer not to say;

		underwater=e20;

		if underwater = 1 then underwateryes = 1;
		else if underwater='.' or 98 <= underwater <= 99 then underwateryes='.';
		else underwateryes = 0;

		if underwater = 2 then underwaterno = 1;
		else if underwater='.' or 98 <= underwater <= 99 then underwaterno='.';
		else underwaterno = 0;

*E15) How many times have you been late with your mortgage payments in the last 2 years? (if you have more than one
	mortgage on your home(s), please include them all). [16096 Missing] (130 Don't Know) (42 Prefer not to resopnd)
		1. Never
		2. Once
		3. More than once
		98. Don't know
		99. Prefer not to say;

		latemortgage=e15;
		
		if latemortgage = 1 then latemortgagenever = 1;
		else if latemortgage='.' or 98 <= latemortgage <= 99 then latemortgagenever='.';
		else latemortgagenever = 0;

		if latemortgage = 2 then latemortgageonce = 1;
		else if latemortgage='.' or 98 <= latemortgage <= 99 then latemortgageonce='.';
		else latemortgageonce = 0;

		if latemortgage = 3 then latemortgageonceplus = 1;
		else if latemortgage='.' or 98 <= latemortgage <= 99 then latemortgageonceplus='.';
		else latemortgageonceplus = 0;

*E16) Have you been involved in a foreclosure process on your home in the last 2 years? [No Missing] (195 Don't Know) (140 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		foreclosure=e16;

		if foreclosure = 1 then foreclosureyes = 1;
		else if foreclosure='.' or 98 <= foreclosure <= 99 then foreclosureyes='.';
		else foreclosureyes = 0;

		if foreclosure = 2 then foreclosureno = 1;
		else if foreclosure='.' or 98 <= foreclosure <= 99 then foreclosureno='.';
		else foreclosureno = 0;

*[SECTION F: CREDIT CARDS];

*F1) How many credit cards do you have? Please include store and gas station credit cards but NOT debit cards.
					[No Missing] (210 Don't Know) (356 Prefer not to say)
		1. 1
		2. 2-3
		3. 4-8
		4. 9-12
		5. 13-20
		6. More than 20
		7. No credit cards
		8. Don't know
		9. Prefer not to say;

		numcreditcards=f1;

		if numcreditcards = 1 then cc1 = 1;
		else if numcreditcards='.' or 98 <= numcreditcards <= 99 then cc1='.';
		else cc1 = 0;

		if numcreditcards = 2 then cc2to3 = 1;
		else if numcreditcards='.' or 98 <= numcreditcards <= 99 then cc2to3='.';
		else cc2to3 = 0;

		if numcreditcards = 3 then cc4to8 = 1;
		else if numcreditcards='.' or 98 <= numcreditcards <= 99 then cc4to8='.';
		else cc4to8 = 0;

		if numcreditcards = 4 then cc9to12 = 1;
		else if numcreditcards='.' or 98 <= numcreditcards <= 99 then cc9to12='.';
		else cc9to12 = 0;

		if numcreditcards = 5 then cc13to20 = 1;
		else if numcreditcards='.' or 98 <= numcreditcards <= 99 then cc13to20='.';
		else cc13to20 = 0;

		if numcreditcards = 6 then ccgt20 = 1;
		else if numcreditcards='.' or 98 <= numcreditcards <= 99 then ccgt20='.';
		else ccgt20 = 0;

		if numcreditcards = 7 then cc0 = 1;
		else if numcreditcards='.' or 98 <= numcreditcards <= 99 then cc0='.';
		else cc0 = 0;

*F2) In the past 12 months, which of the following describes your experience with creidt cards? (select an answer for each)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		alwayspayfull=f2_1;
		sometimescarrybalance=f2_2;
		sometimespaymin=f2_3;
		sometimeslatefee=f2_4;
		sometimesexceedcredit=f2_5;
		sometimescashadvance=f2_6;

	*F2_1) I always paid my credit cards in full      [6904 Missing] (136 Don't know) (113 Prefer not to say);

		if alwayspayfull = 1 then alwayspayfullyes = 1;
		else if alwayspayfull='.' or 98 <= alwayspayfull <= 99 then alwayspayfullyes='.';
		else alwayspayfullyes = 0;

		if alwayspayfull = 2 then alwayspayfullno = 1;
		else if alwayspayfull='.' or 98 <= alwayspayfull <= 99 then alwayspayfullno='.';
		else alwayspayfullno = 0;

	*F2_2) In some months, I carried over a balance and was charged interest  [6904 Missing] (170 Don't know) (99 Prefer not to say);

		if sometimescarrybalance = 1 then sometimescarrybalanceyes = 1;
		else if sometimescarrybalance='.' or 98 <= sometimescarrybalance <= 99 then sometimescarrybalanceyes='.';
		else sometimescarrybalanceyes = 0;

		if sometimescarrybalance = 2 then sometimescarrybalanceno = 1;
		else if sometimescarrybalance='.' or 98 <= sometimescarrybalance <= 99 then sometimescarrybalanceno='.';
		else sometimescarrybalanceno = 0;

	*F2_3) Some months, I only paid the minimum      [6904 Missing] (172 Don't know) (104 Prefer not to say);

		if sometimespaymin = 1 then sometimespayminyes = 1;
		else if sometimespaymin='.' or 98 <= sometimespaymin <= 99 then sometimespayminyes='.';
		else sometimespayminyes = 0;

		if sometimespaymin = 2 then sometimespayminno = 1;
		else if sometimespaymin='.' or 98 <= sometimespaymin <= 99 then sometimespayminno='.';
		else sometimespayminno = 0;


	*F2_4) Some months, I only paid the minimum      [6904 Missing] (195 Don't know) (112 Prefer not to say);

		if sometimeslatefee = 1 then sometimeslatefeeyes = 1;
		else if sometimeslatefee='.' or 98 <= sometimeslatefee <= 99 then sometimeslatefeeyes='.';
		else sometimeslatefeeyes = 0;

		if sometimeslatefee = 2 then sometimeslatefeeno = 1;
		else if sometimeslatefee='.' or 98 <= sometimeslatefee <= 99 then sometimeslatefeeno='.';
		else sometimeslatefeeno = 0;

	*F2_5) Some months, I was charged a fee for exceeding my credit line     [6904 Missing] (190 Don't know) (101 Prefer not to say);

		if sometimesexceedcredit = 1 then sometimesexceedcredityes = 1;
		else if sometimesexceedcredit='.' or 98 <= sometimesexceedcredit <= 99 then sometimesexceedcredityes='.';
		else sometimesexceedcredityes = 0;

		if sometimesexceedcredit = 2 then sometimesexceedcreditno = 1;
		else if sometimesexceedcredit='.' or 98 <= sometimesexceedcredit <= 99 then sometimesexceedcreditno='.';
		else sometimesexceedcreditno = 0;

	*F2_6) Some months, I used cards for a cash advance    [6904 Missing] (159 Don't know) (97 Prefer not to say);

		if sometimescashadvance = 1 then sometimescashadvanceyes = 1;
		else if sometimescashadvance='.' or 98 <= sometimescashadvance <= 99 then sometimescashadvanceyes='.';
		else sometimescashadvanceyes = 0;

		if sometimescashadvance = 2 then sometimescashadvanceno = 1;
		else if sometimescashadvance='.' or 98 <= sometimescashadvance <= 99 then sometimescashadvanceno='.';
		else sometimescashadvanceno = 0;

*F10) Thinking about when you obtained your most recent credit card, did you collect information about different cards
	from more than one company in order to compare them?  [6904 Missing] (1068 Don't know) (86 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		researchcc=f10;

		if researchcc = 1 then researchccyes = 1;
		else if researchcc='.' or 98 <= researchcc <= 99 then researchccyes='.';
		else researchccyes = 0;

		if researchcc = 2 then researchccno = 1;
		else if researchcc='.' or 98 <= researchcc <= 99 then researchccno='.';
		else researchccno = 0;

*[SECTION G: OTHER DEBT];

*G1) Does your household currently have an auto loan? [No Missing] (188 Don't Know) (172 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		autoloan=g1;

		if autoloan = 1 then autoloanyes = 1;
		else if autoloan='.' or 98 <= autoloan <= 99 then autoloanyes='.';
		else autoloanyes = 0;

		if autoloan = 2 then autoloanno = 1;
		else if autoloan='.' or 98 <= autoloan <= 99 then autoloanno='.';
		else autoloanno = 0;

*G20) Do you currently have any unpaid bills from a health care or medical service provider? 
						[No Missing] (419 Don't Know) (206 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		medicalbills=g20;

		if medicalbills = 1 then medicalbillsyes = 1;
		else if medicalbills='.' or 98 <= medicalbills <= 99 then medicalbillsyes='.';
		else medicalbillsyes = 0;

		if medicalbills = 2 then medicalbillsno = 1;
		else if medicalbills='.' or 98 <= medicalbills <= 99 then medicalbillsno='.';
		else medicalbillsno = 0;

*G21) Do you currently have any student loans?  [No Missing] (153 Don't Know) (166 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		studentloans=g21;

		if studentloans = 1 then studentloansyes = 1;
		else if studentloans='.' or 98 <= studentloans <= 99 then studentloansyes='.';
		else studentloansyes = 0;

		if studentloans = 2 then studentloansno = 1;
		else if studentloans='.' or 98 <= studentloans <= 99 then studentloansno='.';
		else studentloansno = 0;

*G22) Are you concerned that you might not be able to pay off your student loans?  [20368 Missing] (237 Don't Know) (14 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		studentloanconcern=g22;

		if studentloanconcern = 1 then studentloanconcernyes = 1;
		else if studentloanconcern='.' or 98 <= studentloanconcern <= 99 then studentloanconcernyes='.';
		else studentloanconcernyes = 0;

		if studentloanconcern = 2 then studentloanconcernno = 1;
		else if studentloanconcern='.' or 98 <= studentloanconcern <= 99 then studentloanconcernno='.';
		else studentloanconcernno = 0;

*G4) Have you declared bankruptcy in the last two years?  [No Missing] (106 Don't Know) (122 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		bankruptcy=g4;

		if bankruptcy = 1 then bankruptcyyes = 1;
		else if bankruptcy='.' or 98 <= bankruptcy <= 99 then bankruptcyyes='.';
		else bankruptcyyes = 0;

		if bankruptcy = 2 then bankruptcyno = 1;
		else if bankruptcy='.' or 98 <= bankruptcy <= 99 then bankruptcyno='.';
		else bankruptcyno = 0;

*G25) In the past 5 years how many times have you... (select an answer for each)
		1. Never
		2. 1 Time
		3. 2 Times
		4. 3 Times
		5. 4 or more times
		98. Don't know
		99. Prefer not to say;

		autotitleloan=g25_1;
		paydayloan=g25_2;
		taxadvance=g25_3;
		pawnshop=g25_4;
		renttoown=g25_5;

		*Continuous G25 variables;

	*G25_1) Taken out an auto title loan? (continuous)  [No Missing] (189 Don't know) (186 Prefer not to answer);

		if 1 <= autotitleloan <= 5 then autotitleloancount = autotitleloan - 1;
		else if autotitleloan='.' or 98 <= autotitleloan <= 99 then autotitleloancount='.';
		else autotitleloancount = 0;

	*G25_2) Taken out a short term "payday" loan? (continuous)  [No Missing] (200 Don't know) (205 Prefer not to answer);

		if 1 <= paydayloan <= 5 then paydayloancount = paydayloan - 1;
		else if paydayloan='.' or 98 <= paydayloan <= 99 then paydayloancount='.';
		else paydayloancount = 0;

	*G25_3) Gotten an advance on your tax return? (continuous)  [No Missing] (212 Don't know) (200 Prefer not to answer);

		if 1 <= taxadvance <= 5 then taxadvancecount = taxadvance - 1;
		else if taxadvance='.' or 98 <= taxadvance <= 99 then taxadvancecount='.';
		else taxadvancecount = 0;

	*G25_4) Used a pawn shop? (continuous)  [No Missing] (195 Don't know) (201 Prefer not to answer);

		if 1 <= pawnshop <= 5 then pawnshopcount = pawnshop - 1;
		else if pawnshop='.' or 98 <= pawnshop <= 99 then pawnshopcount='.';
		else pawnshopcount = 0;

	*G25_5) Used rent-to-own store? (continuous)  [No Missing] (172 Don't know) (181 Prefer not to answer);

		if 1 <= renttoown <= 5 then renttoowncount = renttoown - 1;
		else if renttoown='.' or 98 <= renttoown <= 99 then renttoowncount='.';
		else renttoowncount = 0;

*G23) How strongly do you agree or disagree with the following statement? Please give your answer on a scale of
	1 to 7, where 1 = "Strongly Disagree", 7 = "Strongle Agree", and 4 = "Neither Agree Nor Disagree". You can use
	any number from 1 to 7.		(continuous)		[No Missing] (187 Don't know) (223 Prefer not to answer)
		1. Strongly Disagree
		2.
		3.
		4. Neither Agree Nor Disagree
		5.
		6.
		7. Strongly Agree
		98. Don't know
		99. Prefer not to say;

		toomuchdebt=g23;

		*I have too much debt right now;

		if 1 <= toomuchdebt <= 7 then toomuchdebtscale = toomuchdebt;
		else if toomuchdebt='.' or 98 <= toomuchdebt <= 99 then toomuchdebtscale='.';
		else toomuchdebtscale = 0;

*[SECTION H: INSURANCE]

*H1) Are you covered by health insurance?  [No Missing] (243 Don't Know) (177 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		healthinsurance=h1;

		if healthinsurance = 1 then healthinsuranceyes = 1;
		else if healthinsurance='.' or 98 <= healthinsurance <= 99 then healthinsuranceyes='.';
		else healthinsuranceyes = 0;

		if healthinsurance = 2 then healthinsuranceno = 1;
		else if healthinsurance='.' or 98 <= healthinsurance <= 99 then healthinsuranceno='.';
		else healthinsuranceno = 0;

*H3) Do you have a life insurance policy?  [No Missing] (645 Don't Know) (205 Prefer not to say)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		lifeinsurance=h3;

		if lifeinsurance = 1 then lifeinsuranceyes = 1;
		else if lifeinsurance='.' or 98 <= lifeinsurance <= 99 then lifeinsuranceyes='.';
		else lifeinsuranceyes = 0;

		if lifeinsurance = 2 then lifeinsuranceno = 1;
		else if lifeinsurance='.' or 98 <= lifeinsurance <= 99 then lifeinsuranceno='.';
		else lifeinsuranceno = 0;

*[SECTION M: SELF-ASSESSMENT & LITERACY];

*M1) How strongly do you agree or disagree with the following statements? Please give your answer on a scale of 1 to 7
	where 1 = "Strongly Disagree," and 7 = "Strongly Agree," and 4 = "Neither Agree Nor Disagree". You can use any
	number from 1 to 7. (Select an answer for each)		
		1. Strongly Disagree
		2.
		3.
		4. Neither Agree Nor Disagree
		5.
		6.
		7. Strongly Agree
		98. Don't know
		99. Prefer not to say;

	*M1_1) I am good at dealing with day-to-day financial matters, such as checking accounts, credit and debit cards,
		and tracking expenses   [No Missing] (177 Don't know) (186 Prefer not to say);

		goodfinancial=m1_1;

		if 1 <= goodfinancial <= 7 then goodfinancialscale = goodfinancial;
		else if goodfinancial='.' or 98 <= goodfinancial <= 99 then goodfinancialscale='.';
		else goodfinancialscale = 0;

	*M1_2) I am pretty good at math     [No Missing] (125 Don't know) (168 Prefer not to say);
  
		goodmath=m1_2;

		if 1 <= goodmath <= 7 then goodmathscale = goodmath;
		else if goodmath='.' or 98 <= goodmath <= 99 then goodmathscale='.';
		else goodmathscale = 0;

*M20) Was financial education offered by a school or college you attended, or a workplace where you were employed?
										   										[No Missing] (2414 Don't know) (237 Prefer not to say)
		1. Yes, but I did not participate in the financial education offered
		2. Yes, and I did participate in the financial education
		3. No
		98. Don't know
		99. Prefer not to say;

		FinEd=m20;

		if FinEd = 1 then FinEdYesNoPar = 1;
		else if FinEd='.' or 98 <= FinEd <= 99 then FinEdYesNoPar='.';
		else FinEdYesNoPar = 0;

		if FinEd = 2 then FinEdYesPar = 1;
		else if FinEd='.' or 98 <= FinEd <= 99 then FinEdYesPar='.';
		else FinEdYesPar = 0;
	
		if FinEd = 3 then FinEdNo = 1;
		else if FinEd='.' or 98 <= FinEd <= 99 then FinEdNo='.';
		else FinEdNo = 0;

*M21) When did you receive that financial education? (for each category below)
		1. Yes
		2. No
		98. Don't know
		99. Prefer not to say;

		inhighschool=m21_1;
		incollege=m21_2;
		fromemployer=m21_3;
		frommilitary=m21_4;

	*M21_1) In high school;  *[20245 Missing] (86 Don't know) (5 Prefer not to say);

		if inhighschool = 1 then inhighschoolyes = 1;
		else if inhighschool='.' or 98 <= inhighschool <= 99 then inhighschoolyes='.';
		else inhighschoolyes = 0;

		if inhighschool = 2 then inhighschoolno = 1;
		else if inhighschool='.' or 98 <= inhighschool <= 99 then inhighschoolno='.';
		else inhighschoolno = 0;

	*M21_2) In college;  *[21120 Missing] (43 Don't know) (2 Prefer not to say);

		if incollege = 1 then incollegeyes = 1;
		else if incollege='.' or 98 <= incollege <= 99 then incollegeyes='.';
		else incollegeyes = 0;

		if incollege = 2 then incollegeno = 1;
		else if incollege='.' or 98 <= incollege <= 99 then incollegeno='.';
		else incollegeno = 0;

	*M21_3) From an employer;  *[20245 Missing] (67 Don't know) (10 Prefer not to say);

		if fromemployer = 1 then fromemployeryes = 1;
		else if fromemployer='.' or 98 <= fromemployer <= 99 then fromemployeryes='.';
		else fromemployeryes = 0;

		if fromemployer = 2 then fromemployerno = 1;
		else if fromemployer='.' or 98 <= fromemployer <= 99 then fromemployerno='.';
		else fromemployerno = 0;

	*M21_4) From the military;  *[24537 Missing] (21 Don't know) (2 Prefer not to say);

		if frommilitary = 1 then frommilitaryyes = 1;
		else if frommilitary='.' or 98 <= frommilitary <= 99 then frommilitaryyes='.';
		else frommilitaryyes = 0;

		if frommilitary = 2 then frommilitaryno = 1;
		else if frommilitary='.' or 98 <= frommilitary <= 99 then frommilitaryno='.';
		else frommilitaryno = 0;

RUN;
