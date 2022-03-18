# Classify lung adenomacarcinoma transcriptomes using RAS84 SVM

1. Clone repository

`git clone https://github.com/FrancisCrickInstitute/RAS84_classification.git`

2. Run script

`Rscript RAS84_sample_classification.R [path to log normalised counts matrix]

3. Output. A tab delimited text file containing three columns, **class_ras84**, **class_ras55** and **smple_id**.

`RAS_classes_df.txt`

## Details

The gene identifiers (matrix row names) need to be compatible with those used in the SVM. The file `RAS84_feature_map.txt` provides a lookup table to go from common gene identifiers to those used in the SMV. The SVM id column is called `svm`.
