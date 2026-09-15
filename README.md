# Concrete Compressive Strength Analysis

A statistical analysis of concrete mix design data, prepared for a mock client (a construction manager) to support decisions on mixture design, safety evaluation, and quality control.

This project was originally developed as the final project for **STAT 448: Advanced Data Analysis** at the **University of Illinois Urbana-Champaign**, built around a mock-client scenario in which the analysis and recommendations were framed as a deliverable for a construction manager. It has since been revised and expanded for portfolio purposes, with corrections to several methodological issues identified during a deeper review (see `report/report.md` for details, including notes on data leakage, model validation, and statistical corrections applied throughout).

## Overview

This project examines how concrete composition and curing age relate to compressive strength, and builds a set of validated predictive models to answer three client questions:

1. What compressive strength can be expected from concrete cured at least 100 days?
2. How likely is concrete cured 90–100 days to reach a 50 MPa safety threshold?
3. Can concrete age be estimated from its composition and strength?

## Repository Structure

```
concrete-analysis/
├── README.md              <- you are here
├── report/
│   └── report.md           <- full client-facing report
├── code/
│   └── concrete_analysis.sas   <- full SAS analysis code
├── figures/
│   └── (diagnostic plots, charts, and visualizations referenced in the report)
└── data/
    └── (data source info; raw data not included -- see note below)
```

## Data

This analysis uses concrete mix design data (component-to-water ratios, curing age, and compressive strength) resembling the widely used [UCI Concrete Compressive Strength dataset](https://archive.ics.uci.edu/dataset/165/concrete+compressive+strength). The dataset (`concreteratios.csv`) was provided by the course instructor for STAT 448 and consists solely of numeric mix-design values (no personal or sensitive information).

The raw data file is **not included** in this repository, since it was distributed for coursework rather than public use. See `data/data_source.md` for details on structure and how to reproduce the analysis with your own copy of the data.

## Methods

Descriptive statistics, Spearman correlation, hierarchical clustering, multiple linear regression, logistic regression (including Firth's penalized likelihood correction), and quadratic discriminant analysis, all implemented in SAS. Model validation includes residual diagnostics, train/test splits, and cross-validation where appropriate.

## Author

Kenshi King
