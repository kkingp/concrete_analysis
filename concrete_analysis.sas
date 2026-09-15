title height=16pt bold "Predictive Modeling of Concrete Compressive Strength and Curing Age";
title2 height=14pt bold "Kenshi King";
title3 " ";
*imports;
data concreteratios;
	infile "/home/u64323947/concreteratios.csv" dlm=",";
	input cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
	agegroup= 5;
	if age<28 then agegroup=1;
	else if age<56 then agegroup=2;
	else if age<90 then agegroup=3;
	else if age<180 then agegroup=4;
	else agegroup=5;
run;

*Section 1;
title4 height=12pt bold "Section 1: Descriptive Statistics";
ods text="We begin our analysis by examining this data's characteristics via descriptive statistics. We make sure to examine these 
		various statistics to ensure that the data meets statistical assumptions that allows us to then interpret the data with accuracy. 
		Based on the Normality assessment, all continuous predictors yielded p < 0.01 on the formal normality tests, providing strong 
		evidence against normality. The bar charts and probability plots show that the variables are all right-skewed, coinciding with 
		our normality analysis. This analysis does make sense logically as concrete strength cannot be negative and a majority of the 
		strengths are around a common range, typical strength level, with only a few high-strength outliers. For example, looking at 
		fly ash and superplasticizer statistics, some observations have small amounts with others occasionally having higher amounts, 
		resulting in producing the long right tails visualized in those variables graphics.";

*Full normality test;
ods text=" ";
ods text="It is worth mentioning that with a sample size of this scale (n ≈ 1030), formal normality tests are very sensitive and will 
		reject normality even for negligible deviations; the histogram and probability plots will yield a more interpretable picture of 
		the actual distributional strength.";
proc univariate data=concreteratios normal;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
	ods select Moments TestsForNormality;
run;

*Illustrative graphics;
proc univariate data=concreteratios normal;
	var age superplasticizerwater compressivestrength;
	histogram age superplasticizerwater compressivestrength/normal;
	probplot age superplasticizerwater compressivestrength;
	ods select Histogram Probplot;
run;

*Since our analysis rejects normality, we will refer to the Spearman Correlation tests to observe if any variables exhibit high correlation between each other, in other words, multicollinearity;
ods text="The Spearman correlation analysis revealed insight into how the component-to-water ratios, age, and compressive strength 
		relate to one another. As the aforementioned Abrams' Law states, the cement-to water-ratio is strongly positively correlated 
		with compressive strength (ρ ~ 0.52, p < 0.0001), while age shows an even stronger steady relationship (ρ ~ 0.60, p < 0.0001), 
		confirming that both mixture composition and curing time are major contenders of concrete performance. The remaining component 
		ratios display only weak to moderate correlations with strength, suggesting their effects are less influential predictors. 
		Moderate positive correlations appear among several mix ratios. For instance, coarsewater and finewater (ρ ~ 0.62) and 
		superplasticizerwater with other components (ρ ranging from ~0.47 to ~0.58). These relationships are expected since certain 
		components tend to be modified together in concrete production. Importantly, no pair of predictors exceeds an absolute 
		correlation of 0.7, indicating no immediate signs of multicollinearity. Additionally, age is nearly uncorrelated with 
		components ratios (|ρ| < 0.09), suggesting that curing time is largely independent of mix composition. Overall, the correlation 
		pattern highlights cement content and age as the most influential variables for strength while showing that the set of 
		predictors maintain a reasonable level of independence.";
proc corr data=concreteratios Spearman;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
	ods select SpearmanCorr;
run;
*Age groupings for section 1 & clarity note;
ods text="In order to examine how compressive strength develops over time, the concrete samples were split into 5 different age groups. 
		As expected, compressive strength increases with curing age: the youngest concretes (<28 days, Group 1 ) have the lowest mean 
		strength (23.54 MPa) and the largest variability (SD ~ 12.41 MPa), reflecting early-stages in strength development. 
		Strength rises exceptionally in Group 2 (28-55 days, mean ~ 36.75 MPa).  Group 3 (56-89 days), Groups 4 (90-179 days) and 5 
		(>= 180 days) maintain relatively high strengths (51.89 MPa, 48.24 MPa and 44.16 MPa, respectively) with slightly lower 
		variability, indicating that concrete strength stabilizes as it cures longer. The pattern confirms that both curing time 
		and mixture composition strongly influence compressive strength, with strength increasing rapidly in early ages and 
		leveling in older samples.";
ods text=" ";
ods text="Note: Age groupings used for this descriptive analysis differ from the specific age thresholds later used in Section 3 
		(e.g., >= 100 days, 90-100 days), which were defined for a separate task.";

proc means data=concreteratios n mean std maxdec=2;
	class agegroup;
	var compressivestrength;
run;

*Section 2;
title4 height=12pt bold "Section 2: Clustering";
ods text="To explore natural groupings of concrete compositions and ages, hierarchical clustering was performed using the 
		component-to-water ratios and age. Two procedural choices are worth noting: all variables were standardized prior to clustering, 
		since the ratios and age are measured on very different metric scales and would otherwise let age dominate the grouping due to 
		its larger numeric range; and compressive strength was deliberately withheld from the clustering variables themselves. 
		The variable added back only afterward to describe each group, so that the resulting clusters represent a genuine, independent 
		pattern in mix composition and curing time rather than one that superficially 'explains' strength by construction."; 
ods text=" ";
ods text="Based on the pseudo F statistics, the analysis peaked at four clusters (134, compared to 89.2 at three clusters), 
		and the pseudo t^2 statistic jumped sharply when merging from four to three clusters. These support a four-cluster solution 
		as the best-choice grouping. Cluster 1 (n=73) represents a high-performing mix profile, combining high cement and slag content 
		with minimal fly ash, achieving the greatest average compressive strength (55.46 MPa) at a curing age (~36 days) comparable to 
		the much larger dominant cluster. Cluster 2 (n=904) represents standard concrete mixes with lower cement content and moderate 
		fly ash, averaging at a considerably lower strength (33.71 MPa) at a similar age. Cluster 3 (n=5) describes a more peculiar and 
		small mixture with very high fly ash and aggregate content, as well as the lowest strength ( 24.38 MPa). Given its very small 
		size, this probably reflects a handful of observations that are outliers rather than a specific, rare mixing strategy. 
		Cluster 4 (n=48) is described by having high cement content, minimal additives, and a very long curing period (~281 days), 
		achieving the greatest overall strength (46.75 MPa). These results suggest that composition, not just age, distinguishes great 
		and poor-performing mixes even within similar curing periods. With regards to efficiency, cluster 1 in particular represents a 
		proven strategy for achieving high early-to-moderate strength without the need of prolonged curing time.";
proc cluster data=concreteratios method=average std ccc pseudo print=15 plots(maxpoints=1030) outtree=concrete_avg plots=all;	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age;
	copy cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
	ods select ClusterHistory CccPsfAndPsTSqPlot;
run;

*Investigating tied minimum distances warning in code log;
proc sort data=concreteratios out=dup nodupkey dupout=duplicates;
	by cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age;
run;

proc contents data=duplicates;
run;
ods text="When running the program, a great number of tied minimum distances were flagged during the clustering process 
		(389 under average linkage). Investigation confirmed only a small number of exact duplicate observations (34 out of ≈1,030) 
		among the clustering variables, suggesting the ties are a normal consequence of how the clustering method handles many closely 
		related mixtures, not a sign of a problem with the data itself.";

proc tree data=concrete_avg nclusters=4 out=clusters noprint;
	copy cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
run;

proc sort data=clusters;
	by cluster;
run;

proc means data=clusters n mean std maxdec=2;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age compressivestrength;
	by cluster;
run;

*Section 3;
title4 height=12pt bold "Section 3: Predictive Modeling I - Compressive Strength for Long-Cured Concrete";
ods text="In this section, we are tasked with building various predictive models to provide useful insights for concrete performance 
		and aging. Specifically, we aim to 1) predict the compressive strength of concrete that has cured for at least 100 days, 2) 
		determine the likelihood that concrete cured between 90 and 100 days will achieve a strength of at least 50 MPa (for safety), 
		and 3) estimate the approximate age of concrete samples based on their composition and observed strength data. 
		These models will help the construction manager make informed decisions about concrete quality, curing timelines, 
		and project efficiency. We will also assess model performance, identify the most influential factors, and highlight any 
		limitations in predicting specific outcomes; we will begin with part 1).";
data concrete100up;
	set concreteratios;
	if age >=100;
run;

ods text=" ";
ods text="Because compressive strength is a continuous variable, we apply a multiple linear regression model in order to predict 
		compressive strength for concrete cured at least 100 days. While Section 1 identified non-normality in the raw predictor 
		variables, regression validity is dependent on the normality of the model residuals rather than the predictors themselves, 
		so this is tested below.";
*Checking residual normality after fit, since Section 1 only adressed normality on the raw predictors;
proc reg data=concrete100up;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age / vif;
	ods select ParameterEstimates;
run;

ods text="When looking at the parameter estimates, Coarse-to-water ratio was not statistically significant in the full model 
		(p = 0.399) and it showed an elevated variance inflation factor (VIF = 10.56). Given its lack of significance, it was 
		removed from the model going forward, which is consistent with its exclusion in the subsequent stepwise-selected model 
		in the next section.";
ods text= " ";
ods text="Note: Superplasticizer-to-water ratio shows a considerably larger coefficient and standard error than the other predictors, 
		indicating that its much more restricted measurement range rather than an extreme estimate. To further add, its t-value (4.69) 
		confirms this remains one of the most accurate estimates and statistically significant predictor in the model.";
proc reg data=concrete100up;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater finewater age / vif;
	output out=residual_check r=residual p=predicted;
	ods select ParameterEstimates;
run;

*Testing whether the model residuals are moderately normal, to readdress the normality flags in Section 1;
ods text="When viewing the residuals from this model, significant disparity from normality was not present 
		(Shapiro-Wilk p = 0.102; Kolmogorov-Smirnov, Cramer-von Mises, and Anderson-Darling tests all yielded p > 0.15), 
		supporting the validity of this model's inference despite the skew present within Section 1.";
proc univariate data=residual_check normal;
	var residual;
	histogram residual/normal;
	ods select TestsForNormality Histogram;
run;

*Train/Test Split using simple random sampling;
ods text="In order to assess how well this model generalizes beyond the data it was fit on, the sample was randomly split into a 
		training set (70% and 80%) and a test set (30% and 20%, respectively). The stepwise regression below was fit on the 
		training data, and then evaluted on the withheld test set.";
*70/30 Split;
proc surveyselect data=concrete100up out=concrete100up_sample70 seed=777 samprate=0.7 outall method=srs;
	run; 

data concrete100up_train70 concrete100up_test30;
	set concrete100up_sample70;
	if selected = 1 then output concrete100up_train70;
	else output concrete100up_test30;
run;

proc reg data=concrete100up_train70;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater finewater age / selection=stepwise sle=.05 sls=.05;
run;


*80/20 Split;
proc surveyselect data=concrete100up out=concrete100up_sample80 seed=777 samprate=0.8 outall method=srs;
	run; 

data concrete100up_train80 concrete100up_test20;
	set concrete100up_sample80;
	if selected = 1 then output concrete100up_train80;
	else output concrete100up_test20;
run;

proc reg data=concrete100up_train80;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater finewater age / selection=stepwise sle=.05 sls=.05;
run;

ods text="In both scenarios, cement-to-water ratio, slag-to-water ratio and superplasticizer-to-water ratio were consistently chosen, 
		and the overall model fit remained alike (R^2 = 0.541 - 70% training split, R^2 = 0.534 - 80% training split, versus the full 
		sample's: R^2 = 0.557). However, the fourth variable selected differed between the runs as fine-to-water ratio was selected 
		in the 70% split, while fly ash-to-water was selected in the 80% training split. Fine-to-water ratio was actually removed 
		partially through the run as well. It is known that stepwise selection has its limitations in terms of variable selection at 
		times, so it is good practice to keep this in mind when interpreting which predictors are marked as most influential.";
ods text="Note: Going forward, we will use only the 80/20 split data for simplicity.";

*Refit on the 80% training sample;
proc reg data=concrete100up_train80 outest=coefs80;
	model compressivestrength = cementwater slagwater superplasticizerwater flyashwater;
	ods select ParameterEstimates;
run;

*Scoring manually since proc score did not work properly;
data scored80;
	set concrete100up_test20;
	predicted = 9.60923	+ 18.36783*cementwater
						+ 21.51132*slagwater
						+ 110.12872*superplasticizerwater
						+ 9.32032*flyashwater;
	resid=compressivestrength - predicted;
run;

proc means data=scored80 n mean;
	var compressivestrength;
	output out=meanstat mean=mean_actual;
run;

*Manual out-of-sample R2 calculation;
*Note: Table was manually produced to show output;
data oos_result;
	if _n_=1 then set meanstat;
	set scored80 end=last;
	retain ss_resid ss_total 0;
	ss_resid + resid**2;
	ss_total + (compressivestrength - mean_actual)**2;
	if last then do;
		oos_r_square = 1-(ss_resid/ss_total);
		output;
	end;
	keep oos_r_square;
run;

proc print data=oos_result noobs label;
	label oos_r_square = "Out-of-Sample R-square";
run; 

ods text="In order to evaluate how well this model generalizes beyond the data it was originally fit on, it was tested on the 
		withheld 20% test set. The out-of-sample R^2 was 0.500, which in comparison with 0.534 produced by the training set and 
		0.557 by the full set, depicts an expected decline. This is a good indicator that the model is not overfitting when using 
		the training data and that it performs arguably well on new observations.";
ods text=" ";
ods text="Based on this validation process, it is concluded that the recommended model for estimating compressive strength in 
		concrete cured at least 100 days uses cement-to-water, slag-to-water, superplasticizer-to-water, and fly ash-to-water ratios 
		as its predictors. This is consistent with the aforementioned Abrams' Law, with cement and superplasticizer ratios yielding 
		the greatest positive effects on strength, with slag and fly ash contributing positively as well. And to recap, this model 
		explains roughly half of the variability in strength on new data (out-of-sample R^2 = 0.500), providing a practical tool for 
		estimating expected strength in older concrete based on its material composition. Notably, age did not enter any stepwise 
		model, but this is to be expected given the sample is already restricted to concrete cured at least 100 days, which in turn 
		leaves limited variation in age to detect a relationship.";

*Section 4;
title4 height=12pt bold "Section 4: Predictive Modeling II - Safety Threshold Classification";
ods text="For this task, the client requested an assessment of whether concrete cured within 90 and 100 days is likely to reach a 
		compressive strength of 50MPa, a threshold which is important for reaching safety evaluation standards. Since the outcome is 
		binary (i.e., reaching 50 MPa or not), logistic regression is appropriate, with the component-to-water ratios and age as 
		predictors.";

data concrete90to100;
	set concreteratios;
	if age >= 90 and age <=100;
	high_strength = (compressivestrength >= 50);
run;

*Reviewing sample size and class balance before modeling, given the narrow 11-day age window;
ods text="Within the 90-100 day curing period, 128 concrete samples were accessible, of which 51 (39.8%) achieved the 50 MPa strength 
		threshold and 77 (60.2%) did not. This sample size is acceptable and supported for the use of logistic regression going forward.";
proc freq data=concrete90to100;
	tables high_strength;
run;

*Viewing VIF values before fitting the logistic model to assess potential multicollinearity;
ods text="Before fitting the logistic regression models, predictor collinearity is assessed via a linear regression VIF diagnostic, 
		since the variance inflation factors are not directly accessible when using the proc logistic call.";
ods text=" ";
ods text="Since this is purely to view the variance inflation factors, we will omit discussion of the parameter estimates for now. 
	All predictors showed variance inflation factors below 10 (ranging from 3.24 to 7.89), indicating no serious multicollinearity 
	concerns within this subset. At this point, all component-to-water ratios and age were retained for the logistic models that follow.";
proc reg data=concrete90to100;
	model compressivestrength = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age / vif;
	ods select ParameterEstimates;
run;

*Implementing the logistic regression models;
ods text="A full logistic model was first fit using all component-to-water ratios as predictors (age withheld from this initial model). 
		Global tests confirm that the model significantly improves prediction over an intercept-only model, and the odds ratios show that 
		increases in key components increase the likelihood of reaching 50 MPa strength.";
proc logistic data=concrete90to100;
	model high_strength(event='1') = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater;
	ods select OddsRatios ParameterEstimates GlobalTests ModelInfo FitStatistics;
run;

*Now, this is a textbook example of a quasi-complete separation!;
ods text="When looking at the outputs, an unusual pattern appears in the output: the odds ratios and confidence intervals yield some 
		extremely large values. We can see that this occurs with the addition of superplasticizer water, given its extreme coefficient, 
		but we shall assess this next.";
ods text=" ";
ods text="Before modeling, a cross-tabulation of high_strength versus superplasticizer-to-water ratio revealed a quasi-complete 
		separation pattern (i.e., when one predictor almost perfectly predicts the outcome variable, with minimal overlap in the middle). 
		At low values, basically all observations are high_strength = 0, and at high values, basically all are high_strength = 1, with 
		minimal overlap in the mid-range. This explains the extremely large odds ratios and unstable confidence intervals initially 
		observed.";
proc freq data=concrete90to100;
	table high_strength * superplasticizerwater / norow nocol;
run;

*Stepwise selection, including age;
ods text="Here, stepwise selection is implemented, including age as an additional predictor.";
proc logistic data=concrete90to100 plots=influence;
	model high_strength(event='1') = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age / selection=stepwise sle=.05 sls=.05 lackfit;
	output out = diagnostics cbar=cookd;
run;
ods text=" ";
ods text="Influence diagnostics were reviewed in an effort to see if any individual observations were disproportionately controlling 
		the model's results. A small number of observations showed modestly elevated influence, but none exceeded a Cook's Distance of 0.7, 
		suggesting no single observation had a concerning impact on the model.";

ods text="The Hosmer-Lemeshow goodness-of-fit test was statistically significant (Chi-square = 16.63, p = 0.034), indicating some 
		evidence of some misalignment between the observed and predicted probabilities across risk groups. Despite this, the model's 
		overall classification performance remained strong (concordance = 95.1%), and this limitation is noted for transparency 
		rather than treated as nullifying the model's usefulness.";

ods text=" ";
ods text="Age did not enter the stepwise model at any step, due to that restricted 11-day curing window we discussed prior.";

*Firth-corrected model;
ods text="In an attempt to address this quasi-complete separation, Firth's penalized likelihood was used to correct for this; 
		unlike standard maximum likelihood estimation, Firth's method adds a small penalty term that keeps coefficient estimates 
		finite and stable even when a predictor nearly perfectly separates the outcome classes. However, when applied to the full 
		six-predictor model, the odds ratios for several variables (particularly superplasticizer-to-water ratio) remained extreme. 
		This indicates that fitting all six predictors simultaneously left too little independent information for the correction to 
		fully stabilize each estimate. Because Firth's correction cannot be combined with automated stepwise selection in proc 
		logistics, the variable already identified as most influential by stepwise procedure (cement-to-water, slag-to-water, and 
		superplasticizer-to-water ratios) were used to instead fit a smaller, more parsimonious Firth-corrected model. Reducing the 
		number of predictors lessens the shared collinear signal driving the instability, and is expected to produce more stable, 
		interpretable estimates than the full model.";
proc logistic data=concrete90to100;
	model high_strength(event='1') = cementwater slagwater superplasticizerwater / firth;
	ods select OddsRatios ParameterEstimates GlobalTests ModelInfo FitStatistics;
run;

*Train/Test split;
ods text="In order to stay consistent with previous procedures, we will split this data into a train/test split, in order to assess 
	its ability to generalize on data beyond its original fit.";
proc surveyselect data=concrete90to100 out=concrete90to100_sample80 seed=777 samprate=0.8 outall method=srs;
run;

data concrete90to100_train80 concrete90to100_test20;
	set concrete90to100_sample80;
	if selected = 1 then output concrete90to100_train80;
	else output concrete90to100_test20;
run;

*Refit Firth model on the training data;
proc logistic data=concrete90to100_train80;
	model high_strength(event='1') = cementwater slagwater superplasticizerwater / firth;
	ods select ParameterEstimates;
run;

*Manual computation;
ods text="Since this is a model using logistic regression, we will need to calculate the scoring using a different method: the 
	inverse-logit transformation. This is done to give us a valid probability between 0 to 1 that we can interpret.";
data scored90to100;
	set concrete90to100_test20;
	logit = -10.1232 + 4.2726*cementwater
					 + 4.7152*slagwater
					 + 56.2495*superplasticizerwater;
	predicted_prob = 1/(1+exp(-logit));
	predicted_class = (predicted_prob>=0.5);
run;


ods text="Based on the confusion matrix, the withheld 20% test split correctly classified 22 of 25 observations (88.0% accuracy). 
	The sensitivity (i.e., correctly identifying concrete that reached 50 MPa) was 81.8%; the specificity (correctly identifying 
	concrete that did not reach the threshold) was 92.9%. This is a solid out-of-sample performance that backs the model's 
	interpretability for classifying concrete samples within this curing period. However, it is good to note that the small test set 
	size (n=25) means this should be used as a suggestive estimate rather than definitive.";
proc freq data=scored90to100;
	tables high_strength*predicted_class / norow nocol nopercent;
run;

ods text="All things considered, the reduced three-predictor Firth model, which uses cement-to-water, slag-to-water, and 
	superplasticizer-to-water ratios, is recommended as the final tool for examining whether concrete cured within 90-100 days is likely 
	to meet that 50 MPa safety standard. All three of these predictors remain strongly positive, though the exact magnitude of the 
	superplasticizer effect could not be precisely assessed due to the separation discussed earlier. The model's strong out-of-sample 
	performance (88.0% accuracy, 81.8% sensitivity, 92.9% specificity) supports its practical use, even with the small sample size. 
	For the client, the greatest takeaway is that increasing cement, slag, and superplasticizer contents meaningfully increases the 
	likelihood of reaching the 50 MPa safety threshold, given the curing window. However, precise probability estimates should be 
	examined with some caution given both the separation issue and the limited sample size.";

*Section 5;
title4 height=12pt bold "Section 5: Predictive Modeling III - Estimating Concrete Age";
ods text="For our final task (3), we aim to develop a model that classifies concrete samples into one of the five age ranges specified 
		based on their component-to-water ratios and compressive strength. The manager is interested in estimating the approximate age 
		of concrete when the composition is fixed, which can help guide project timelines and quality control measures. To achieve this, 
		we will use a logistic regression approach, allowing us to handle the multiple age categories and assess which concrete 
		characteristics are most predictive of age. Model performance will be evaluated using classification accuracy and an analysis 
		of which age groups are more difficult to distinguish";
ods text="A linear regression of concrete component ratios, compressive strength and age explains 72% of the variability in 
		age (R^2 = 0.721). Compressive strength is highly significant, while most component-to-water ratios are not, suggesting strength 
		is the leading factor. Multicollinearity was not an apparent issue (all VIFs < 10).";
ods text=" ";
ods text="A corrected linear regression predicting continuous age from component-to-water ratios and compressive strength explains 
		approximately 34% of the variability in age (R^2 ~ 0.343). Age was excluded as a predictor since it would create a 
		methodological circularity with the derived age-group variable used later in this section. This is substantially lower than the 
		reported (R^2 = 0.721), which is a result of data leakage by using age to predict a variable directly derived from age 
		(circular logic). The corrected model therefore provides a more appropriate estimate of predictive performance based solely 
		on concrete composition and compressive strength.";

*original model;
proc reg data=concreteratios;
	model agegroup = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age / vif;
	ods select ParameterEstimates FitStatistics;
run;

ods text="Compressive strength is a statistically significant positive predictor of age (t = 20.36), (p < 0.0001), which is 
		consistent with the assumption that concrete generally increases in strength as it cures over time. Cement-to-water, 
		slag-to-water, and fly ash-to-water ratios were statistically significant as well, showing a negative association with age. 
		On the other hand, superplasticizer-to-water and coarse-to-water ratios were not statistically significant. These relationships 
		most likely show variation in mix-compositions for specific situations. Example, mixtures used for faster curing may differ 
		structurally in composition from those created for longer curing periods. Variance inflation factors were also well below the 
		10 value threshold, with a maximum of 3.12; no multicollinearity concerns.";
*correct model;
proc reg data=concreteratios;
	model age = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength / vif;
	ods select ParameterEstimates FitStatistics;
run;

*Model with Agegroup and Age variables;
ods text="To further add to the claim of this circular logic, with the addition of Age as a predictor with Agegroup being our response 
		variable, we notice that this triggers a complete separation of data points. This is a prime example of the data `leakage` 
		discussed previously.";
proc logistic data=concreteratios plots=influence;
	model agegroup = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater age / selection=stepwise sle=.05 sls=.05 lackfit;
	output out = diagnostics cbar=cookd;
run;

*Model without Age variable;
proc logistic data=concreteratios plots=influence;
	model agegroup = cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength / selection=stepwise sle=.05 sls=.05 lackfit;
	output out = diagnostics cbar=cookd;
run;
ods text="After removal of age as a predictor, plus including compressive strength with the component-to-water ratios, cumulative 
		logistic regression converged normally and yielded an acceptable discrimination (c = 0.890). Yet, two concerns still remain 
		relevant which are 1. the Hosmer-Lemeshow test suggests a significant lack of fit (χ² = 113.27, p < 0.0001) for especially 
		higher age groups, and 2. the score test for the proportional odds assumption was significant at each step (χ² = 312.10, 
		p < 0.0001), suggesting that the assumption of each predictor's effect being consistent across all age-groups was potentially 
		infringed. With these concerns in mind, discriminant analysis was explored as an alternative means that does not rely on the 
		proportional odds assumption.";

*discrimanant analysis;
proc discrim data=concreteratios method=normal pool=test;
	class agegroup;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength;
run;

ods text="Before choosing between Linear and Quadratic discriminant analysis (LDA and QDA, respectively), we assessed whether the 
		covariance structure of the predictors was the same across all five age groups. The results showed that they are not 
		(χ² = 2725.66, df = 112, p < 0.0001), which supports the use of QDA over LDA. QDA allows each group to its own covariance 
		structure. Intriguingly, age group 5 stands out as its covariance matrix had a lower rank (5 versus 7 from the other groups), 
		suggesting one or more predictors barely varied within that group.";

proc means data=concreteratios n mean std maxdec=3;
	class agegroup;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength;
run;
ods text="As previously suggested, age group 5's reduced covariance matrix rank was traced back to two predictors, fly ash-to-water 
		ratio and superplasticizer-to-water ratio. These both yielded zero variance within the group (all 59 observations show a 
		value of exactly 0 for each). This is an indicator that concrete mixes classified into this age group (cured 180+ days) 
		consistently used zero fly ash or superplasticizer at all. This is a notable distinction of the composition compared to 
		other age groups. This is a great tell of why QDA classifies group 5 with very high accuracy; the mixes are differentiable from 
		the others based on composition alone, independent of curing time. This mirrors Cluster 4 from section 2, which consisted of 
		long-cured, fly-ash free, high-cement mixes, indicating the two analyses are detecting the same grouping. Overall, the 
		cross-validated misclassification rate is approximately 44%, indicating that although the model captures general trends, 
		there is significant overlap among groups 1, 2, and 4 in particular. This displays the limitations of the current selection of 
		variables for classifying age with precision.";

*QDA approach;
ods text="The quadratic discriminant analysis (QDA) performed on the dataset demonstrates a statistically significant ability to 
		distinguish between the five age groups based on the component-to-water ratios and compressive strength. Multivariate tests, 
		including Wilks’ Lambda, Pillai’s Trace, Hotelling-Lawley Trace, and Roy’s Greatest Root, all indicate highly significant 
		differences among the groups (p < 0.0001), confirming that the predictor variables collectively have distinguishing power. 
		The cross-validation classification results show that QDA correctly classifies a substantial portion of observations in some 
		age groups, particularly age groups 3 and 4, but struggles with groups 1, 2, and 5. The overall misclassification rate is 
		approximately 44%, suggesting that while the model captures some patterns in the data, certain age groups have overlapping 
		characteristics, making them difficult to differentiate reliably. This outcome highlights why QDA is preferred over LDA in 
		our case, the significant differences in the within-group covariance matrices violates the equal-covariance assumption needed 
		for LDA, whereas QDA allows each age group to have its own covariance structure, improving the model's flexibility for 
		classification.";
proc discrim data=concreteratios method=normal pool=no crossvalidate manova;
	class agegroup;
	var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength;
	ods select ChiSq MultStat ClassifiedCrossVal ErrorCrossVal;
run;

ods text="Stepwise discriminant analysis was performed to identify the most important predictors for classifying the concrete age 
		groups based on component-to-water ratios and compressive strength. Using a significance level of 0.05 for entry and stay, 
		the procedure sequentially added predictors that most improved discrimination between the age groups. Compressive strength was 
		the first variable entered, explaining the largest portion of variation (partial R² = 0.338, F = 130.76, p < 0.0001), 
		indicating it is highly informative for distinguishing age groups. Cement-to-water ratio and slag-to-water ratio followed, 
		both contributing significantly to group separation (partial R² = 0.275 and 0.154, respectively, p < 0.0001). Subsequent 
		variables—flyash-to-water ratio, fine water, superplasticizer-to-water ratio, and coarse water—also significantly improved 
		classification, though their incremental contributions were smaller. Wilks’ Lambda decreased with each step, confirming that 
		each added variable enhances the model’s ability to discriminate between groups. The average squared canonical correlation 
		increased with each step, indicating that the model’s overall predictive power improves as more relevant variables are included. 
		This stepwise QDA model thus identifies the combination of component ratios and compressive strength that best distinguishes 
		concrete age groups, with compressive strength being the dominant factor.";
	
proc stepdisc data=concreteratios sle=0.05 sls=0.05;
    class agegroup;
    var cementwater slagwater flyashwater superplasticizerwater coarsewater finewater compressivestrength;
    ods select Summary;
run;

ods text="Using Quadratic Discriminant Analysis (QDA) with compressive strength and component-to-water ratios as predictors, we 
		attempted to classify concrete samples into five age groups. The cross-validated classification results indicate that the 
		model performs reasonably well for some groups but struggles with others. For instance, age groups 1, 2, and 3 show moderate 
		classification accuracy, with 49%, 51%, and 63% of samples correctly classified, respectively. Age group 4 is more difficult 
		to distinguish, with only 18% correctly classified. Age group 5 was classified correctly 100% of the time, due to 
		the zero variance in fly ash-to-water and superplasticizer-to-water ratios within this group. This suggests that while the model captures general trends, there are significant 
		overlaps between certain age groups. This indicates that age group 4 is particularly challenging to differentiate using these 
		predictors, displaying the limits of the current set of variables for precise age classification.";
ods text=" ";
		
*Conclusion;
title5 height=12pt bold "Conclusion";
ods text="This analysis examined how concrete analysis confirmed that composition and curing age relate to compressive strength, and 
		developed a set of predictive models to support the client's decision-making around mixture design, safety thresholds, and 
		quality control.";
ods text=" ";
ods text="Descriptive and correlation analysis proved that cement content and curing age are the two greatest drivers of compressive 
		strength, which is consistent with Abrams' Law. The predictor group overall did not show any major signs of multicollinearity 
		concerns. Clustering pinpointed four distinct mix profiles, most notably a high-cement, high-slag, low-fly-ash, mixture 
		(Cluster 1) which achieved strength akin to the longest-cured mixtures at a fraction of the curing age.";
ods text=" ";
ods text="With regards to predicting the compressive strength of concrete cured at least 100 days, a validated stepwise regression 
		model using cement, slag, superplasticizer, and fly ash ratios explained about half of the variability in strength on new, 
		unseen data (out-of-sample R^2 = 0.500). This leaves us with a practical tool for estimating the expected strength in older 
		concrete.";
ods text=" ";
ods text="For checking whether concrete cured within a 90-100 days window reaches the 50 MPa safety threshold, an initial logistic 
		model revealed quasi-complete separation driven by superplasticizer-to-water ratio. After applying Firth's penalized likelihood 
		correction and validating the held-out test set, the final three-predictor model achieved a strong out-of-sample performance 
		(88.0% accuracy), supporting cement, slag, and superplasticizer content as key components of reaching the strength threshold. 
		However, the probability estimates should be interpreted with slight caution given the separation detected.";
ods text=" ";
ods text="For estimating concrete age, an initial regression revealed data leakage from having agegroup as the response alongside age 
		as a predictor variable. Once corrected, composition and strength explained a more modest but valid 34% of age's variability. 
		A parallel attempt at logistic classification of age groups confirmed the same leakage issue through complete separation. 
		After removing age, it showed reasonable discrimination but still violated a key modeling assumption. Quadratic discriminant 
		analysis was then chosen since it does not rely on that assumption, and it classified age groups with an overall accuracy of 
		roughly 56% (44% misclassification), performing the best for age groups 3 and 4 and most reliably for age group 5. Age group 
		5's distinct composition consisting of fly-ash-free and long-cured quality falls in line with Cluster 4 from the clustering 
		analysis section, also making it more easily distinguishable from other groups.";
ods text=" ";
ods text="To conclude everything, these analyses confirm that both mixture composition and curing time purposefully influence concrete 
		performance, despite their relative importance varying by task. Composition dominates in differentiating high-performing mixes 
		and safety thresholds, while age remains only somewhat predictable based off composition and strength alone. Many models 
		required correcting for methodological issues identified during analysis, including data leakage, quasi-complete separation, 
		and violated model assumptions, all of which emphasize the importance of diagnostic validation before choosing any given model's 
		results. The corrected, validated models presented here provide the client with a practical, evidential foundation for mixture 
		design, safety evaluation and quality control decisions.";