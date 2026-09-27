# Data Source

This analysis uses a concrete mix design dataset containing component-to-water ratios (cement, slag, fly ash, superplasticizer, 
coarse aggregate, fine aggregate), curing age (days), and measured compressive strength (MPa) for 1,030 concrete samples.

The dataset resembles the [UCI Machine Learning Repository's Concrete Compressive Strength dataset]
(https://archive.ics.uci.edu/dataset/165/concrete+compressive+strength). The specific file used here (`concreteratios.csv`) 
was provided by the instructor for STAT 448 (Advanced Data Analysis, UIUC) as coursework data.

Raw data is not included in this repository, since it was distributed for coursework rather than public redistribution. 
If you have your own copy of the CSV (or a similar dataset with matching columns), place it in this folder and update the `infile` 
path in `code/concrete_analysis.sas` accordingly.
