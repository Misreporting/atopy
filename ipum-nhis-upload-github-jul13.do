log using "/Users/jerosenbaum/Library/CloudStorage/OneDrive-DownstateMedicalCenter/projects/Sai NHIS/log-jul13.txt", text append

*use "/Users/jerosenbaum/OneDrive - Downstate Medical Center/projects/Sai NHIS/nhis_00009.dta"

use "/Users/jerosenbaum/Library/CloudStorage/OneDrive-DownstateMedicalCenter/projects/Sai NHIS/NHIS-heartdisease.dta"

* Limit to universe of the CHD and angina questions
keep if age>=18 & cheartdiev!=0

tab cheartdiev, missing
gen chd=cheartdiev==2

tab angipecev, missing
gen angina = angipecev==2

tab heartattev, missing
gen ami=heartattev==2

gen heart_disease=heartconev==2

gen any_heart_disease=(heart_disease==1) | (ami==1) | (angina==1) | (chd==1)

 
 *ASTHATAKYR 
 tab asthatakyr, missing
 codebook asthatakyr
gen asthma_episode=asthatakyr==2

*  ASTHMAEV 
gen asthma_ever_told=asthmaev==2


* HAYFEVERYR 
gen hayfever12m=hayfeveryr==2


* ASTHMASTIL 
* 1 = still have asthma, 0= don't still have asthma or never told asthma.  
tab asthmastil asthma_ever_told, missing
gen asthma_still=asthmastil==2

* Demographics

gen female=sex==2

* Race

gen race2 = racenew
replace race2=500 if racenew>=500 | racenew==300
label define racelabel 100 "White" 200 "Black" 400 "Asian" 500 "Other"
label values race2 racelabel
label variable race2 "Race"
tab  racenew race2

gen white=racenew==100
gen black=racenew==200
gen aian=racenew==300
gen asian=racenew==400
gen otherrace=racenew==510
gen multiplerace=racenew==520

gen hispanic=hispeth!=10


gen bornus_mainland=usborn==20
gen bornus_territories=usborn==20 | usborn==11

* Smoker

* This question is only asked to people who have ever smoked 100 cigarettes.  
gen currentsmoker=smokestatus2==11 | smokestatus2==12 | smokestatus2==40
gen formersmoker=(smokestatus2==20)
gen neversmoker=(currentsmoker==0) & (formersmoker==0)


* Diabetes and prediabetes
gen ever_told_diabetes=diabeticev==2
gen ever_told_prediabetes=diabeticev==3 

* Education

gen hsgradgedplus=educ>=201
gen lthighschool=educ<=200 
gen ged=educ==202 
gen hsgrad=educ==201
gen somecoll=educ==301
gen aa=educ==302 | educ==303
gen baplus=educ>=400

gen educ_cat = 1*(hsgrad==1)  + 2*(somecoll==1) + 3*(aa==1) + 4*(baplus==1)
tab  educ educ_cat, missing

gen fpl = (poverty==10) + 0.5*(poverty==11) + 0.625*(poverty==12) + 0.875*(poverty==13) + (poverty==14) + 1.5*(poverty==20) + 1.125*(poverty==21) + 1.375*(poverty==22) + 1.625*(poverty==23) + 1.875*(poverty==24) + 1.5*(poverty==25) + 2*(poverty==30) + 2.25*(poverty==31) + 2.75*(poverty==32) + 3.25*(poverty==33)+ 3.75*(poverty==34) + 4.25*(poverty==35) + 4.75*(poverty==36) + 5.5*(poverty==37) + 2.5*(poverty==38)
replace fpl=. if poverty>90

gen povertyratio=1*(poverty<=14) + 2*(poverty>=20 & poverty<30) + 3*(poverty>=30)
replace povertyratio=. if poverty==98 | poverty==99

gen employment_status = empstat
replace employment_status=. if empstat>900


gen working = employment_status==111
gen working_withoutpay = employment_status==112
gen employed_notatjobpast2weeks = employment_status==120
gen unemployed=employment_status==200
gen out_of_laborforce=employment_status==220

gen medicaid = hipubcov==2
gen priv_insurance = hiprivate==2
gen home_ownership=ownership
gen own_home=home_ownership==10
gen rent_home=home_ownership==20
gen home_otherarrangement=home_ownership==30




* Hypertension in past year: only available for some years.

tab hypertenyr, missing
gen hypertension_year=hypertenyr==2
replace hypertension_year=0 if hypertenyr==1
replace hypertension_year=. if hypertenyr>=7 | hypertenyr==0

* High cholesterol in the past year

gen highcholesterol_year=cholhighyr==2
replace highcholesterol_year=0 if cholhighyr==1
replace highcholesterol_year=. if cholhighyr>=7 | cholhighyr==0

tab highcholesterol_year hypertension_year

gen modactivity = mod10dmin
replace modactivity=. if mod10dmin==0 |  mod10dmin>996

gen vigactivity = vig10dmin
replace vigactivity=. if vig10dmin==0 |  vig10dmin>996

gen weightactivity=strongfwk
replace weightactivity=0 if strongfwk==95 | strongfwk==96
replace weightactivity=.5 if strongfwk==94
replace weightactivity=. if strongfwk==0 | strongfwkt>=97x


* Cardiac health index
Life Simple 7 CVH metrics -- we only have BMI, smoker, physical acctivity, every told hypertension

*CVH metrics were defined according to the American Heart Association Life Simple 7 factors.1 Ideal CVH metrics were defined as follows: (1) Smoking: never or former smoker; (2) Body mass index<23 kg/m2; (3) Physical activity: ≥150 min/wk of moderate-intensity physical activity, ≥75 min/wk of vigorous intensity physical activity, or ≥150 min/wk of moderate or vigorous intensity physical activity; (4) Diet: 4 or 5 healthy dietary components as defined below; For diet, the ideal metric was determined based on intake of the following 5 healthy dietary components: fruits and vegetables (≥450 g/d), fish (≥198 g/wk), fiber-rich whole grains (≥85 g/d), sodium (<1500 mg/d), sugar-sweetened beverages (≤1 liter/wk). (5) Total cholesterol <200 mg/dL; (6) Blood pressure <120/80 mm Hg; (7) Fasting glucose <100 mg/dL.1 

*To calculate the ideal CVH score, each ideal CVH metric was given 1 point and the number of ideal CVH metrics was added for each participant (range 0–7 points). Ideal CVH scores were categorized as 0–1, 2, 3, 4, 5, and 6–7 because only 1671 (2.14%) and 33 (0.04%) participants had scores of 0 and 7, respectively.

*We based a measure of cardiac health from the AHA Life Simple 7 metrics, as the number of characteristics: BMI under 30, no current smoking, at least 150 minutes of moderate physical activity or at least 75 minutes of vigorous physical activity; for later years, we included past year hypertension and past year cholesterol.

For 1997 forward, the variable BMI provides an alternative measure of the body mass index. The meaning of BMICALC and BMI is basically the same, but the values calculated for an individual may differ somewhat between the two variables. BMI was calculated by the National Center for Health Statistics (NCHS) "using the inhouse version of the height and weight variables, which contain the greater range of height and weight values than are available on the public use file" (according to the Codebooks for 1997 forward).
[show more]

Researchers interested only in data for 1997 forward should use BMI rather than BMICALC. Researchers interested in pre-1997 data must use BMICALC or must calculate the Body Mass Index themselves from the WEIGHT and HEIGHT variables. Researchers interested in data from both before and after 1997 may wish to use BMICALC to maximize comparability over time.

Questionnaire design changes introduced in 2019 limit comparability with earlier years. The NHIS questionnaire was substantially redesigned in 2019 to introduce a different data collection structure and new content. For more information on changes in terminology, universes, and data collection methods beginning in 2019, please see the user note.

* Missing 56% of the time.
gen bmi_c = bmi 
replace bmi_c=. if bmi>=96 | bmi==0
histogram bmi_c

gen bmi_miss=bmi_c==.



********* MI: evaluate predictors of missingness
* No missingness: female race2 hispanic
* Replaced with categorical: asthma_episode asthma_ever_told
* Replaced with categorical: hsgradgedplus lthighschool ged hsgrad somecoll aa baplus

mdesc chd angina ami heart_disease any_heart_disease asthma_episode asthma_ever_told hayfever12m asthma_still female race2 white black aian otherrace multiplerace hispanic bornus_mainland bornus_territories asian currentsmoker formersmoker neversmoker ever_told_diabetes ever_told_prediabetes hsgradgedplus lthighschool ged hsgrad somecoll aa baplus educ_cat fpl povertyratio working working_withoutpay employed_notatjobpast2weeks unemployed out_of_laborforce medicaid priv_insurance home_ownership own_home rent_home home_otherarrangement hypertension_year highcholesterol_year bmi_c bmicalc_c





*** Table 1

tab age if chd==1

tab year

gen sampweight20=(sampweight/20)
svyset [pweight=sampweight20], strata(strata) psu(psu)

svy:tab  chd 
svy:tab  angina 
svy:tab  ami 
svy:tab  heart_disease 

svy:tab  any_heart_disease 

tab  asthma_episode
svy:tab  asthma_episode

svy:tab  chd asthma_episode, col
svy:tab  angina asthma_episode, col
svy:tab  ami asthma_episode, col
svy:tab  heart_disease asthma_episode, col
svy:tab  any_heart_disease asthma_episode, col

tab  asthma_ever_told
svy:tab  asthma_ever_told

svy:tab  chd asthma_ever_told, col
svy:tab  angina asthma_ever_told, col
svy:tab  ami asthma_ever_told, col
svy:tab  heart_disease asthma_ever_told, col
svy:tab  any_heart_disease asthma_ever_told, col

tab  hayfever12m
svy:tab  hayfever12m

svy:tab  chd hayfever12m, col
svy:tab  angina hayfever12m, col
svy:tab  ami hayfever12m, col
svy:tab  heart_disease hayfever12m, col
svy:tab  any_heart_disease hayfever12m, col


*** DEMOGRAPHICS
svy:tab  female asthma_episode, col

svy:tab  white asthma_episode, col
svy:tab  black asthma_episode, col
svy:tab  aian asthma_episode, col
svy:tab  asian asthma_episode, col
svy:tab  otherrace asthma_episode, col
svy:tab  multiplerace asthma_episode, col

*svy:tab  povertyratio asthma_episode, col

svy:tab  hispanic asthma_episode, col
svy:tab  bornus_mainland asthma_episode, col
svy:tab  bornus_territories asthma_episode, col



svy:tab  currentsmoker asthma_episode, col
svy:tab  neversmoker asthma_episode, col
svy:tab  formersmoker asthma_episode, col
svy:tab  ever_told_diabetes asthma_episode, col
svy:tab  ever_told_prediabetes asthma_episode, col
svy:tab  year asthma_episode, col

svy:tab  lthighschool asthma_episode, col
svy:tab  ged asthma_episode, col
svy:tab  hsgrad asthma_episode, col
svy:tab  somecoll asthma_episode, col
svy:tab  aa asthma_episode, col
svy:tab  baplus asthma_episode, col

svy:tab  priv_insurance asthma_episode, col
svy:tab  medicaid asthma_episode, col

svy:tab working asthma_episode, col
svy:tab working_withoutpay asthma_episode, col
svy:tab employed_notatjobpast2weeks asthma_episode, col
svy:tab unemployed asthma_episode, col
svy:tab out_of_laborforce asthma_episode, col

svy:tab own_home asthma_episode, col
svy:tab rent_home asthma_episode, col
svy:tab home_otherarrangement asthma_episode, col


svy: mean age, over(asthma_episode) coeflegend
test  _b[age:0] =  _b[age:1]
svy: mean age

svy: mean bmi, over(asthma_episode) 
test  _b[bmi:0] =  _b[bmi:1]
svy: mean bmi

svy: mean fpl, over(asthma_episode) 
test  _b[fpl:0] =  _b[fpl:1]
svy: mean fpl


* EVER TOLD ASTHMA

svy: mean age, over(asthma_ever_told) 
test  _b[age:0] =  _b[age:1]

svy: mean bmi, over(asthma_ever_told) 
test  _b[bmi:0] =  _b[bmi:1]
svy: mean bmi

svy: mean fpl, over(asthma_ever_told) 
test  _b[fpl:0] =  _b[fpl:1]
svy: mean fpl

svy:tab  female asthma_ever_told, col

svy:tab  white asthma_ever_told, col
svy:tab  black asthma_ever_told, col
svy:tab  aian asthma_ever_told, col
svy:tab  asian asthma_ever_told, col
svy:tab  otherrace asthma_ever_told, col
svy:tab  multiplerace asthma_ever_told, col

svy:tab  hispanic asthma_ever_told, col
svy:tab  bornus_mainland asthma_ever_told, col
svy:tab  bornus_territories asthma_ever_told, col

svy:tab  currentsmoker asthma_ever_told, col
svy:tab  neversmoker asthma_ever_told, col
svy:tab  formersmoker asthma_ever_told, col
svy:tab  ever_told_diabetes asthma_ever_told, col
svy:tab  ever_told_prediabetes asthma_ever_told, col
svy:tab  year asthma_ever_told, col

svy:tab  lthighschool asthma_ever_told, col
svy:tab  ged asthma_ever_told, col
svy:tab  hsgrad asthma_ever_told, col
svy:tab  somecoll asthma_ever_told, col
svy:tab  aa asthma_ever_told, col
svy:tab  baplus asthma_ever_told, col

svy:tab  priv_insurance asthma_ever_told, col
svy:tab  medicaid asthma_ever_told, col

svy:tab working asthma_ever_told, col
svy:tab working_withoutpay asthma_ever_told, col
svy:tab employed_notatjobpast2weeks asthma_ever_told, col
svy:tab unemployed asthma_ever_told, col
svy:tab out_of_laborforce asthma_ever_told, col

svy:tab own_home asthma_ever_told, col
svy:tab rent_home asthma_ever_told, col
svy:tab home_otherarrangement asthma_ever_told, col



***** HAY FEVER

svy: mean age, over(hayfever12m) 
test  _b[age:0] =  _b[age:1]

svy: mean bmi, over(hayfever12m) 
test  _b[bmi:0] =  _b[bmi:1]

svy: mean fpl, over(hayfever12m) 
test  _b[fpl:0] =  _b[fpl:1]

svy:tab  female hayfever12m, col

svy:tab  white hayfever12m, col
svy:tab  black hayfever12m, col
svy:tab  aian hayfever12m, col
svy:tab  asian hayfever12m, col
svy:tab  otherrace hayfever12m, col
svy:tab  multiplerace hayfever12m, col

svy:tab  currentsmoker hayfever12m, col
svy:tab  neversmoker hayfever12m, col
svy:tab  formersmoker hayfever12m, col
svy:tab  ever_told_diabetes hayfever12m, col
svy:tab  ever_told_prediabetes hayfever12m, col
svy:tab  year hayfever12m, col

svy:tab  lthighschool hayfever12m, col
svy:tab  ged hayfever12m, col
svy:tab  hsgrad hayfever12m, col
svy:tab  somecoll hayfever12m, col
svy:tab  aa hayfever12m, col
svy:tab  baplus hayfever12m, col

svy:tab  priv_insurance hayfever12m, col
svy:tab  medicaid hayfever12m, col


svy:tab working hayfever12m, col
svy:tab working_withoutpay hayfever12m, col
svy:tab employed_notatjobpast2weeks hayfever12m, col
svy:tab unemployed hayfever12m, col
svy:tab out_of_laborforce hayfever12m, col

svy:tab own_home hayfever12m, col
svy:tab rent_home hayfever12m, col
svy:tab home_otherarrangement hayfever12m, col



*** Overall


svy:tab  female 
svy:tab  white 
svy:tab  black 
svy:tab  aian 
svy:tab  asian 
svy:tab  otherrace 
svy:tab  multiplerace 

svy:tab  hispanic 
svy:tab  bornus_mainland 
svy:tab  bornus_territories 

svy:tab  currentsmoker 
svy:tab  neversmoker 
svy:tab  formersmoker 
svy:tab  ever_told_diabetes 
svy:tab  ever_told_prediabetes 

svy:tab  lthighschool 
svy:tab  ged 
svy:tab  hsgrad 
svy:tab  somecoll 
svy:tab  aa 
svy:tab  baplus 

svy:tab  priv_insurance 
svy:tab  medicaid 

svy:tab working 
svy:tab working_withoutpay 
svy:tab employed_notatjobpast2weeks 
svy:tab unemployed 
svy:tab out_of_laborforce 

svy:tab own_home
svy:tab rent_home 
svy:tab home_otherarrangement 


******* Multiple imputation

mdesc  fpl bmi_c  female white black aian asian  hispanic year  age chd angina ami heart_disease asthma_episode asthma_ever_told hayfever12m   bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes   ged hsgrad somecoll aa baplus home_ownership medicaid priv_insurance unemployed out_of_laborforce

mi set wide
mi register imputed fpl bmi_c

mi describe

* white black aian asian  i.psu i.strata sampweight



mi impute mvn fpl bmi_c = female white black aian asian  hispanic year  age chd angina ami heart_disease asthma_episode asthma_ever_told hayfever12m   bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes   ged hsgrad somecoll aa baplus home_ownership medicaid priv_insurance unemployed out_of_laborforce, add(20)
mi describe
mi varying

mi passive: gen age10=age/10
mi passive: gen age10f=round(age/10)
mi passive: gen year_c = year-1999

  
* Interaction terms

tab black female
tab white female
tab aian female
tab hispanic female
tab asian female

drop raceeth
mi passive: gen raceeth = 1*(white==1 & hispanic==0 & black==0) + 2*(white==1 & hispanic==1 & black==0) + 3*(black==1)
tab raceeth, missing

* 0 = Asian, AIAN, other, 1= white non-Hispanic, 2 = white Hispanic, 3 = Black both Hispanic and non-Hispanic


** Regression
* bornus_mainland

* Outcome: Ever asthma + still asthma


* Outcome: Asthma episode.


chd angina ami heart_disease asthma_episode asthma_ever_told hayfever12m  white black aian asian   bornus_territories currentdailysmoker currentsomedaysmoker formersmoker ever_told_diabetes ever_told_prediabetes   ged hsgrad somecoll aa baplus employment_status    home_ownership medicaid priv_insurance = female any_heart_disease hispanic year 




* Potential mediators?: ever_told_diabetes ever_told_prediabetes 

use "/Users/jerosenbaum/Library/CloudStorage/OneDrive-DownstateMedicalCenter/projects/Sai NHIS/nhis_00009-imputed-may12.dta"

cd "/Users/jerosenbaum/OneDrive - Downstate Medical Center/projects/Sai NHIS/"

* Asthma episode and each of the 5 measures.

mi estimate, or: svy: logistic chd asthma_episode year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c 

estimates store chd_asthma_episode
estimates save "models-may12", append


mi estimate, or: svy: logistic ami asthma_episode year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c

estimates store ami_asthma_episode
estimates save "models-may12", append

mi estimate, or: svy: logistic angina asthma_episode year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c, or

estimates store angina_asthma_episode
estimates save "models-may12", append

mi estimate, or: svy: logistic heart_disease asthma_episode year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c, or

estimates store hd_asthma_episode
estimates save "models-may12", append


mi estimate, or: svy: logistic any_heart_disease asthma_episode year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c, or

estimates store anyhd_asthma_episode
estimates save "models-may12", append


* Lifetime asthma and each fo teh 5 measures


mi estimate, or: svy: logistic chd asthma_ever_told year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or

estimates store chd_asthma_ever
estimates save "models-may12", append

mi estimate, or: svy: logistic ami asthma_ever_told year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c, or

estimates store ami_asthma_ever
estimates save "models-may12", append

mi estimate, or: svy: logistic angina asthma_ever_told year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or

estimates store angina_asthma_ever
estimates save "models-may12", append

mi estimate, or: svy: logistic heart_disease asthma_ever_told year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c, or

estimates store hd_asthma_ever
estimates save "models-may12", append

mi estimate, or: svy: logistic any_heart_disease asthma_ever_told year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or

estimates store anyhd_asthma_ever
estimates save "models-may12", append

* Hay fever and each of the 5 measures

mi estimate, or: svy: logistic chd hayfever12m year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c  , or

estimates store chd_hayfever
estimates save "models-may12", append

mi estimate, or: svy: logistic ami hayfever12m year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c  , or

estimates store ami_hayfever
estimates save "models-may12", append

mi estimate, or: svy: logistic angina hayfever12m year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c  , or

estimates store angina_hayfever
estimates save "models-may12", append

mi estimate, or: svy: logistic heart_disease hayfever12m year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c  , or

estimates store hd_hayfever
estimates save "models-may12", append

mi estimate, or: svy: logistic any_heart_disease hayfever12m year_c age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or

estimates store anyhd_hayfever12m
estimates save "models-may12", append


coefplot (chd_asthma_episode chd_asthma_ever chd_hayfever, label(Coronary heart disease)) (ami_asthma_episode ami_asthma_ever ami_hayfever, label(Heart attack)) (angina_asthma_episode angina_asthma_ever angina_hayfever , label(Angina)) (hd_asthma_episode hd_asthma_ever hd_hayfever , label(Heart disease/condition)) (anyhd_asthma_episode anyhd_asthma_ever anyhd_hayfever12m , label(Any heart disease)), drop(_cons) xline(1) eform sort(,descending) xtitle(Odds ratio) keep(asthma_episode asthma_ever_told hayfever12m ) graphregion(color(white)) bgcolor(white) cismooth


*** CHD:

coefplot chd_asthma_episode, coeflabels(asthma_episode="Past year asthma episode" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: coronary heart disease)
graph save "chd-asthma-episode-regression", replace
graph export "chd-asthma-episode-regression.tif", replace

*** groups(age female black aian asian hispanic bornus_territories="{bf:Demographics}" fpl ged hsgrad somecoll aa baplus unemployed out_of_laborforce rent_home medicaid priv_insurance="{bf:SES}"  currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes bmi_c="{bf:Health}" )


coefplot chd_asthma_ever, coeflabels(asthma_ever_told="Ever diagnosed with asthma" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: coronary heart disease)
graph save "chd-asthma-ever-regression", replace
graph export "chd-asthma-ever-regression.tif", replace


coefplot chd_hayfever, coeflabels(hayfever12m="Past year allergic rhinitis" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: coronary heart disease)
graph save "chd-hayfever-regression", replace
graph export "chd-hayfever-regression.tif", replace



*** AMI:  

coefplot ami_asthma_episode, coeflabels(asthma_episode="Past year asthma episode" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Heart attack)
graph save "ami-asthma-episode-regression", replace
graph export "ami-asthma-episode-regression.tif", replace

coefplot ami_asthma_ever, coeflabels(asthma_ever_told="Ever diagnosed with asthma" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: heart attack)
graph save "ami-asthma-ever-regression", replace
graph export "ami-asthma-ever-regression.tif", replace

coefplot ami_hayfever, coeflabels(hayfever12m="Past year allergic rhinitis" year_c="Year of survey" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: heart attack)
graph save "ami-hayfever-regression", replace
graph export "ami-hayfever-regression.tif", replace



*** Angina:  

coefplot angina_asthma_episode, coeflabels(asthma_episode="Past year asthma episode" year_c="Year of survey" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Angina)
graph save "angina-asthma-episode-regression", replace
graph export "angina-asthma-episode-regression.tif", replace


coefplot angina_asthma_ever, coeflabels(asthma_ever_told="Ever diagnosed with asthma" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Angina)
graph save "angina-asthma-ever-regression", replace
graph export "angina-asthma-ever-regression.tif", replace


coefplot angina_hayfever, coeflabels(hayfever12m="Past year allergic rhinitis" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Angina)
graph save "angina-hayfever-regression", replace
graph export "angina-hayfever-regression.tif", replace


*** Heart disease/condition:   (   , label(Heart disease/condition)) (anyhd_asthma_episode anyhd_asthma_ever anyhd_hayfever12m , label(Any heart disease))



coefplot hd_asthma_episode, coeflabels(asthma_episode="Past year asthma episode" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Heart disease/condition)
graph save "hd-asthma-episode-regression", replace
graph export "hd-asthma-episode-regression.tif", replace


coefplot hd_asthma_ever, coeflabels(asthma_ever_told="Ever diagnosed with asthma" year_c="Year of survey" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Heart disease/condition)
graph save "hd-asthma-ever-regression", replace
graph export "hd-asthma-ever-regression.tif", replace


coefplot hd_hayfever, coeflabels(hayfever12m="Past year allergic rhinitis" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Heart disease/condition)
graph save "hd-hayfever-regression", replace
graph export "hd-hayfever-regression.tif", replace


*** Any heart disease(   , label(Any heart disease))

coefplot anyhd_asthma_episode, coeflabels(asthma_episode="Past year asthma episode" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Any heart disease)
graph save "anyhd-asthma-episode-regression", replace
graph export "anyhd-asthma-episode-regression.tif", replace


coefplot anyhd_asthma_ever, coeflabels(asthma_ever_told="Ever diagnosed with asthma" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Any heart disease)
graph save "anyhd-asthma-ever-regression", replace
graph export "anyhd-asthma-ever-regression.tif", replace


coefplot anyhd_hayfever12m, coeflabels(hayfever12m="Past year allergic rhinitis" year_c="Year of survey (0-19)" age10= "Age (decade)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" bmi_c="Body mass index", notick labgap(0))  drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio) sort(,descending)  title(Outcome: Any heart disease)
graph save "anyhd-hayfever-regression", replace
graph export "anyhd-hayfever-regression.tif", replace


******* These don't look good:

coefplot (chd_asthma_episode, label(Coronary heart disease)) (ami_asthma_episode, label(Heart attack)) (angina_asthma_episode, label(Angina)) (hd_asthma_episode, label(Heart disease/condition)) (anyhd_asthma_episode, label(Any heart disease)), coeflabels(asthma_episode="Past year asthma episode" year="Year" age= "Age (years)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" bmi_c="Body mass index", notick labgap(0)) groups(age female black aian asian hispanic bornus_territories="{bf:Demographics}" fpl ged hsgrad somecoll aa baplus unemployed out_of_laborforce rent_home medicaid priv_insurance="{bf:SES}"  currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes bmi_c="{bf:Education}" ) drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio)


coefplot (chd_asthma_ever, label(Coronary heart disease)) (ami_asthma_ever, label(Heart attack)) (angina_asthma_ever, label(Angina)) (hd_asthma_ever, label(Heart disease/condition)) (anyhd_asthma_ever, label(Any heart disease)), coeflabels(asthma_ever_told="Ever diagnosed with asthma"
year="Year" age= "Age (years)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" bmi_c="Body mass index", notick labgap(0)) groups(age female black aian asian hispanic bornus_territories="{bf:Demographics}" fpl ged hsgrad somecoll aa baplus unemployed out_of_laborforce rent_home medicaid priv_insurance="{bf:SES}"  currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes bmi_c="{bf:Education}" ) drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio)


coefplot (chd_hayfever, label(Coronary heart disease)) (ami_hayfever, label(Heart attack)) (angina_hayfever, label(Angina)) (hd_hayfever, label(Heart disease/condition)) (anyhd_hayfever12m, label(Any heart disease)), coeflabels(hayfever12m="Past year allergic rhinitis"
year="Year" age= "Age (years)" female = "Female" black="Black" aian="American Indian/Native American" asian="Asian" hispanic="Hispanic" bornus_territories="US nativity" currentsmoker="Current smoker" formersmoker="Former smoker" ever_told_diabetes="Diabetes diagnosis" ever_told_prediabetes="Prediabetes diagnosis" fpl="Household income poverty ratio"  ged="GED" hsgrad="High school diploma" somecoll="Some college, no degree" aa="Associates degree" baplus="Bachelors or above" unemployed="Unemployed" out_of_laborforce="Out of labor force" rent_home="Rent home" medicaid="Medicaid insurance" priv_insurance="Private employer insurance" bmi_c="Body mass index", notick labgap(0)) groups(age female black aian asian hispanic bornus_territories="{bf:Demographics}" fpl ged hsgrad somecoll aa baplus unemployed out_of_laborforce rent_home medicaid priv_insurance="{bf:SES}"  currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes bmi_c="{bf:Education}" ) drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio)

**************************************
*************** Interaction
**************************************
mi svyset [pweight=sampweight20], strata(strata) psu(psu)

*Without MI:
miunset
svy: logistic chd asthma_episode#female#black year_c age10 aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or
margins asthma_episode#female#black
marginsplot, graphregion(color(white)) bgcolor(white) title(Estimated probability CHD)


gen age10f=round(age10) 
gen age20f=round(age/20) 
tab age20f

svy: logistic chd asthma_episode#female#i.age10f year_c age10 black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or
margins i.age10f#asthma_episode#female
marginsplot , graphregion(color(white)) bgcolor(white) title(Estimated probability CHD) 

svy: logistic chd asthma_episode#black#i.age10f year_c age10 female aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or
margins i.age10f#asthma_episode#black
marginsplot , graphregion(color(white)) bgcolor(white) title(Estimated probability CHD) 


svy: logistic angina asthma_episode#black#i.age10f year_c age10 female aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c , or
margins i.age10f#asthma_episode#black
marginsplot , graphregion(color(white)) bgcolor(white) title(Estimated probability Angina) 






mi set
mi estimate, or: svy: logistic chd asthma_episode#female#black year_c age10 aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c 


margins asthma_episode#female#black
marginsplot
estimates store chd_asthma_episode2

estimates restore chd_asthma_episode2

**coefplot chd_asthma_episode2, drop(_cons) eform xline(1, lpattern(dash) lwidth(thin)) omitted mlabsize(medium) graphregion(color(white)) bgcolor(white) cismooth msize(vsmall) xtitle(Odds ratio)

***** YEAR

*** CHD


mi svyset [pweight=sampweight], strata(strata) psu(psu)
foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic chd asthma_episode age10 female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store chd_asthma_episode`yeark'
estimates save "models-apr9", append
}

coefplot chd_asthma_episode1999 chd_asthma_episode2000 chd_asthma_episode2001 chd_asthma_episode2002 chd_asthma_episode2003 chd_asthma_episode2004 chd_asthma_episode2005 chd_asthma_episode2006 chd_asthma_episode2007 chd_asthma_episode2008 chd_asthma_episode2009 chd_asthma_episode2010 chd_asthma_episode2011 chd_asthma_episode2012 chd_asthma_episode2013 chd_asthma_episode2014 chd_asthma_episode2015 chd_asthma_episode2016 chd_asthma_episode2017 chd_asthma_episode2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_episode) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Coronary heart disease and past year asthma episode") xlabel(0.55 "1999" 1.45 "2018", add)
graph save "chd-asthma-episode-may10", replace
graph export "chd-asthma-episode-may10.tif", replace

Extra options:
 ciopts(color(black)) levels(99 95 90 80 70)
ciopts(lcolor(*.2 *.4 *.6 *.8 *1)) legend(order(1 "99% CI" 2 "95% CI" 3 "90% CI" 4 "80% CI" 5 "70% CI"))

** CHD and asthma ever

foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic chd asthma_ever_told  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store chd_asthma_ever`yeark'
estimates save "models-apr9", append
}

coefplot chd_asthma_ever1999 chd_asthma_ever2000 chd_asthma_ever2001 chd_asthma_ever2002 chd_asthma_ever2003 chd_asthma_ever2004 chd_asthma_ever2005 chd_asthma_ever2006 chd_asthma_ever2007 chd_asthma_ever2008 chd_asthma_ever2009 chd_asthma_ever2010 chd_asthma_ever2011 chd_asthma_ever2012 chd_asthma_ever2013 chd_asthma_ever2014 chd_asthma_ever2015 chd_asthma_ever2016 chd_asthma_ever2017 chd_asthma_ever2018, drop(_cons) eform keep(asthma_ever_told) yline(1)  ytitle(Odds ratio) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Coronary heart disease and lifetime asthma") xlabel(0.55 "1999" 1.45 "2018", add)
graph save "chd-asthma-diagnosis-may10", replace
graph export "chd-asthma-diagnosis-may10.tif", replace

print chd_asthma_ever1999 chd_asthma_ever2000 chd_asthma_ever2001 chd_asthma_ever2002 chd_asthma_ever2003 chd_asthma_ever2004 chd_asthma_ever2005 chd_asthma_ever2006 chd_asthma_ever2007 chd_asthma_ever2008 chd_asthma_ever2009 chd_asthma_ever2010 chd_asthma_ever2011 chd_asthma_ever2012 chd_asthma_ever2013 chd_asthma_ever2014 chd_asthma_ever2015 chd_asthma_ever2016 chd_asthma_ever2017 chd_asthma_ever2018, b(2) se(2) eform append


foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic chd hayfever12m  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store chd_hayfever`yeark'
estimates save "models-apr9", append
}

coefplot chd_hayfever1999 chd_hayfever2000 chd_hayfever2001 chd_hayfever2002 chd_hayfever2003 chd_hayfever2004 chd_hayfever2005 chd_hayfever2006 chd_hayfever2007 chd_hayfever2008 chd_hayfever2009 chd_hayfever2010 chd_hayfever2011 chd_hayfever2012 chd_hayfever2013 chd_hayfever2014 chd_hayfever2015 chd_hayfever2016 chd_hayfever2017 chd_hayfever2018, drop(_cons) eform keep(hayfever12m) yline(1) sort(,descending) ytitle(Odds ratio) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Coronary heart disease and past year allergic rhinitis")
graph save "chd-hayfever-may10", replace
graph export "chd-hayfever-may10.tif", replace


*** AMI

mi svyset [pweight=sampweight], strata(strata) psu(psu)
foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic ami asthma_episode  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store ami_asthma_episode`yeark'
estimates save "models-apr9", append
}

** redo this plot: 

coefplot ami_asthma_episode1999 ami_asthma_episode2000 ami_asthma_episode2001 ami_asthma_episode2002 ami_asthma_episode2003 ami_asthma_episode2004 ami_asthma_episode2005 ami_asthma_episode2006 ami_asthma_episode2007 ami_asthma_episode2008 ami_asthma_episode2009 ami_asthma_episode2010 ami_asthma_episode2011 ami_asthma_episode2012 ami_asthma_episode2013 ami_asthma_episode2014 ami_asthma_episode2015 ami_asthma_episode2016 ami_asthma_episode2017 ami_asthma_episode2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_episode) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Heart attack and past year asthma episode")
graph save "ami-asthma-episode-may10", replace
graph export "ami-asthma-episode-may10.tif", replace


foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic ami asthma_ever  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store ami_asthma_ever`yeark'
estimates save "models-apr9", append
}

coefplot ami_asthma_ever1999 ami_asthma_ever2000 ami_asthma_ever2001 ami_asthma_ever2002 ami_asthma_ever2003 ami_asthma_ever2004 ami_asthma_ever2005 ami_asthma_ever2006 ami_asthma_ever2007 ami_asthma_ever2008 ami_asthma_ever2009 ami_asthma_ever2010 ami_asthma_ever2011 ami_asthma_ever2012 ami_asthma_ever2013 ami_asthma_ever2014 ami_asthma_ever2015 ami_asthma_ever2016 ami_asthma_ever2017 ami_asthma_ever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_ever_told) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Heart attack and lifetime asthma")
graph save "ami-asthma-ever-may10", replace
graph export "ami-asthma-ever-may10.tif", replace



foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic ami hayfever12m age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store ami_hayfever`yeark'
estimates save "models-apr9", append
}

coefplot ami_hayfever1999 ami_hayfever2000 ami_hayfever2001 ami_hayfever2002 ami_hayfever2003 ami_hayfever2004 ami_hayfever2005 ami_hayfever2006 ami_hayfever2007 ami_hayfever2008 ami_hayfever2009 ami_hayfever2010 ami_hayfever2011 ami_hayfever2012 ami_hayfever2013 ami_hayfever2014 ami_hayfever2015 ami_hayfever2016 ami_hayfever2017 ami_hayfever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(hayfever12m) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Heart attack and past year allergic rhinitis")
graph save "ami-hayfever-may10", replace
graph export "ami-hayfever-may10.tif", replace

*** ANGINA

mi svyset [pweight=sampweight], strata(strata) psu(psu)
foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic angina asthma_episode  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store angina_asthma_episode`yeark'
estimates save "models-apr9", append
}

coefplot angina_asthma_episode1999 angina_asthma_episode2000 angina_asthma_episode2001 angina_asthma_episode2002 angina_asthma_episode2003 angina_asthma_episode2004 angina_asthma_episode2005 angina_asthma_episode2006 angina_asthma_episode2007 angina_asthma_episode2008 angina_asthma_episode2009 angina_asthma_episode2010 angina_asthma_episode2011 angina_asthma_episode2012 angina_asthma_episode2013 angina_asthma_episode2014 angina_asthma_episode2015 angina_asthma_episode2016 angina_asthma_episode2017 angina_asthma_episode2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_episode) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Angina and past year asthma episode")
graph save "angina-asthma-episode-may10", replace
graph export "angina-asthma-episode-may10.tif", replace


foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic angina asthma_ever  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store angina_asthma_ever`yeark'
estimates save "models-apr9", append
}

coefplot angina_asthma_ever1999 angina_asthma_ever2000 angina_asthma_ever2001 angina_asthma_ever2002 angina_asthma_ever2003 angina_asthma_ever2004 angina_asthma_ever2005 angina_asthma_ever2006 angina_asthma_ever2007 angina_asthma_ever2008 angina_asthma_ever2009 angina_asthma_ever2010 angina_asthma_ever2011 angina_asthma_ever2012 angina_asthma_ever2013 angina_asthma_ever2014 angina_asthma_ever2015 angina_asthma_ever2016 angina_asthma_ever2017 angina_asthma_ever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_ever_told) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Angina and lifetime asthma")
graph save "angina-asthma-ever-may10", replace
graph export "angina-asthma-ever-may10.tif", replace


foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic angina hayfever12m  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store angina_hayfever`yeark'
estimates save "models-apr9", append
}

coefplot angina_hayfever1999 angina_hayfever2000 angina_hayfever2001 angina_hayfever2002 angina_hayfever2003 angina_hayfever2004 angina_hayfever2005 angina_hayfever2006 angina_hayfever2007 angina_hayfever2008 angina_hayfever2009 angina_hayfever2010 angina_hayfever2011 angina_hayfever2012 angina_hayfever2013 angina_hayfever2014 angina_hayfever2015 angina_hayfever2016 angina_hayfever2017 angina_hayfever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(hayfever12m) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off)  title("Angina and past year allergic rhinitis")
graph save "angina-hayfever-may10", replace
graph export "angina-hayfever-may10.tif", replace


*** "HEART DISEASE/CONDITION"

mi svyset [pweight=sampweight], strata(strata) psu(psu)
foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic heart_disease asthma_episode  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store hd_asthma_episode`yeark'
estimates save "models-apr9", append
}

coefplot hd_asthma_episode1999 hd_asthma_episode2000 hd_asthma_episode2001 hd_asthma_episode2002 hd_asthma_episode2003 hd_asthma_episode2004 hd_asthma_episode2005 hd_asthma_episode2006 hd_asthma_episode2007 hd_asthma_episode2008 hd_asthma_episode2009 hd_asthma_episode2010 hd_asthma_episode2011 hd_asthma_episode2012 hd_asthma_episode2013 hd_asthma_episode2014 hd_asthma_episode2015 hd_asthma_episode2016 hd_asthma_episode2017 hd_asthma_episode2018, drop(_cons) yline(1) eform ytitle(Odds ratio) keep(asthma_episode) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Heart disease and past year asthma episode")
graph save "hd-asthma-episode-may10", replace
graph export "hd-asthma-episode-may10.tif", replace



foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic heart_disease asthma_ever  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store hd_asthma_ever`yeark'
estimates save "models-apr9", append
}

coefplot hd_asthma_ever1999 hd_asthma_ever2000 hd_asthma_ever2001 hd_asthma_ever2002 hd_asthma_ever2003 hd_asthma_ever2004 hd_asthma_ever2005 hd_asthma_ever2006 hd_asthma_ever2007 hd_asthma_ever2008 hd_asthma_ever2009 hd_asthma_ever2010 hd_asthma_ever2011 hd_asthma_ever2012 hd_asthma_ever2013 hd_asthma_ever2014 hd_asthma_ever2015 hd_asthma_ever2016 hd_asthma_ever2017 hd_asthma_ever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_ever_told) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Heart disease and lifetime asthma")
graph save "hd-asthma-ever-may10", replace
graph export "hd-asthma-ever-may10.tif", replace


foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic heart_disease hayfever12m  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store hd_hayfever`yeark'
estimates save "models-apr9", append
}

coefplot hd_hayfever1999 hd_hayfever2000 hd_hayfever2001 hd_hayfever2002 hd_hayfever2003 hd_hayfever2004 hd_hayfever2005 hd_hayfever2006 hd_hayfever2007 hd_hayfever2008 hd_hayfever2009 hd_hayfever2010 hd_hayfever2011 hd_hayfever2012 hd_hayfever2013 hd_hayfever2014 hd_hayfever2015 hd_hayfever2016 hd_hayfever2017 hd_hayfever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(hayfever12m) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off)  title("Heart disease and past year allergic rhinitis")
graph save "hd-hayfever-may10", replace
graph export "hd-hayfever-may10.tif", replace


*** ANY HEART DISEASE



mi svyset [pweight=sampweight], strata(strata) psu(psu)
foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic any_heart_disease asthma_episode  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store any_hd_asthma_episode`yeark'
estimates save "models-apr9", append
}

coefplot any_hd_asthma_episode1999 any_hd_asthma_episode2000 any_hd_asthma_episode2001 any_hd_asthma_episode2002 any_hd_asthma_episode2003 any_hd_asthma_episode2004 any_hd_asthma_episode2005 any_hd_asthma_episode2006 any_hd_asthma_episode2007 any_hd_asthma_episode2008 any_hd_asthma_episode2009 any_hd_asthma_episode2010 any_hd_asthma_episode2011 any_hd_asthma_episode2012 any_hd_asthma_episode2013 any_hd_asthma_episode2014 any_hd_asthma_episode2015 any_hd_asthma_episode2016 any_hd_asthma_episode2017 any_hd_asthma_episode2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_episode) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Any heart disease and past year asthma episode")
graph save "any_hd-asthma-episode-may10", replace
graph export "any_hd-asthma-episode-may10.tif", replace



foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic any_heart_disease asthma_ever  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store any_hd_asthma_ever`yeark'
estimates save "models-apr9", append
}

coefplot any_hd_asthma_ever1999 any_hd_asthma_ever2000 any_hd_asthma_ever2001 any_hd_asthma_ever2002 any_hd_asthma_ever2003 any_hd_asthma_ever2004 any_hd_asthma_ever2005 any_hd_asthma_ever2006 any_hd_asthma_ever2007 any_hd_asthma_ever2008 any_hd_asthma_ever2009 any_hd_asthma_ever2010 any_hd_asthma_ever2011 any_hd_asthma_ever2012 any_hd_asthma_ever2013 any_hd_asthma_ever2014 any_hd_asthma_ever2015 any_hd_asthma_ever2016 any_hd_asthma_ever2017 any_hd_asthma_ever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(asthma_ever_told) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off) title("Any heart disease and lifetime asthma")
graph save "anyhd-asthma-ever-may10", replace
graph export "anyhd-asthma-ever-may10.tif", replace


*** NEED TO FINISH:

foreach k of numlist 0/19 {
local yeark=1999+`k'

mi estimate, or: svy: logistic any_heart_disease hayfever12m  age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if year==`yeark', or

estimates store any_hd_hayfever`yeark'
estimates save "models-apr9", append
}

coefplot any_hd_hayfever1999 any_hd_hayfever2000 any_hd_hayfever2001 any_hd_hayfever2002 any_hd_hayfever2003 any_hd_hayfever2004 any_hd_hayfever2005 any_hd_hayfever2006 any_hd_hayfever2007 any_hd_hayfever2008 any_hd_hayfever2009 any_hd_hayfever2010 any_hd_hayfever2011 any_hd_hayfever2012 any_hd_hayfever2013 any_hd_hayfever2014 any_hd_hayfever2015 any_hd_hayfever2016 any_hd_hayfever2017 any_hd_hayfever2018, drop(_cons) yline(1) eform sort(,descending) ytitle(Odds ratio) keep(hayfever12m) xtitle(Year) vertical  graphregion(color(white)) bgcolor(white) ciopts(color(black))   cismooth legend(off)  title("Any heart disease and past year allergic rhinitis")
graph save "anyhd-hayfever-may10", replace
graph export "anyhd-hayfever-may10.tif", replace


**************************************
*************** Stratification
**************************************


mi svyset [pweight=sampweight], strata(strata) psu(psu)
foreach var of varlist asthma_episode asthma_ever hayfever12m {

mi estimate, or: svy: logistic chd `var' age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if female==1, or

estimates store chd_`var'_female

mi estimate, or: svy: logistic chd `var' age female black aian asian  hispanic bornus_territories currentsmoker formersmoker ever_told_diabetes ever_told_prediabetes fpl ged hsgrad somecoll aa baplus   unemployed out_of_laborforce rent_home  medicaid priv_insurance bmi_c if female==0, or

estimates store chd_`var'_male

}



