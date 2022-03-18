
library( tidyverse )
library( caret )

lognorm_matrix_path <- commandArgs( trailing.only = TRUE )[ 1 ]

if( !file.exists( lognorm_matrix_path ) )
    sys.exit( paste( lognorm_matrix_path, "does not exist" ) )

feature_id_map_file <- "RAS84_feature_map.txt"
feature_id_map <- read.delim( feature_id_map_file )

lognorm_mat <- read.delim( file = lognorm_matrix_path )
lognorm_mat <- scale( lognorm_mat )
lognorm_mat <- t( scale( t( lognorm_mat ) ) )
lognorm_ras84_mat <- lognorm_mat[ feature_id_map$TCGA_feature_id, ]
rownames( lognorm_ras84_mat ) <- feature_id_map$svm

model_svm_ras84 <- readRDS( "svmRadialSigma_TCGA-LUAD_RAS84.rds" )
model_svm_ras55 <- readRDS( "svmRadialSigma_TCGA-LUAD_RAS55.rds" )

set.seed( 1000 )

classes_df <- data.frame( class_ras84 = predict( model_svm_ras84, t( lognorm_ras84_mat ) ),
                          class_ras55 = predict( model_svm_ras55, t( lognorm_ras84_mat ) ),
                         colnames( lognorm_mat ) )

classes_df %>%
    write.table( file = "RAS_classes_df.txt",
                sep = "\t",
                quote = FALSE,
                row.names = FALSE )
