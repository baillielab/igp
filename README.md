# igp_script_reduced.r
R script computing in-group proportions [PMID: 16613834] and associated p-values between cluster prototypes (````training_data_reduced.Rds````) and testing data.

## Dependencies
parallel 3.6.0.

## Input files
Normalised expression values as a CSV file:
- header: HGNC gene identifiers
- index: sample/patient identifiers

## Output files
Rds file (rna_data_reduced_clusterRepro.Rds) containing in-group proportion values and p-values.

## Arguments
The first argument corresponds to the testing data path and the second to the number of cores that will be used to run the permutations.

## Example
From a terminal window, navigate to the igp_folder_reduced_parallel and run ````Rscript igp_script_reduced.r test_data.csv num_cores````