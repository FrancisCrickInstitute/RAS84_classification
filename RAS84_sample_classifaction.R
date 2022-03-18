
library( tidyverse )
library( caret )

set.seed( 1000 )

RAG_name_map <- c( RASsig_0 = "RAG-0",
                  RASsig_1 = "RAG-1",
                  RASsig_2 = "RAG-2",
                  RASsig_3 = "RAG-3",
                  RASsig_max = "RAG-4" )

lognorm_matrix_path <- commandArgs( trailingOnly = TRUE )[ 1 ]

if( !file.exists( lognorm_matrix_path ) )
    sys.exit( paste( lognorm_matrix_path, "does not exist" ) )

feature_id_map_file <- file.path( "data", "RAS84_feature_map.txt" )
feature_id_map <- read.delim( feature_id_map_file )

lognorm_mat <- read.delim( file = lognorm_matrix_path )
lognorm_mat <- scale( lognorm_mat )
lognorm_mat <- t( scale( t( lognorm_mat ) ) )
lognorm_ras84_mat <- lognorm_mat[ feature_id_map$TCGA_feature_id, ]
rownames( lognorm_ras84_mat ) <- feature_id_map$svm

model_svm_ras84 <- readRDS( file.path( "data", "svmRadialSigma_TCGA-LUAD_RAS84.rds" ) )
model_svm_ras55 <- readRDS( file.path( "data", "svmRadialSigma_TCGA-LUAD_RAS55.rds" ) )

classes_df <- data.frame( class_ras84 = predict( model_svm_ras84, t( lognorm_ras84_mat ) ),
                          class_ras55 = predict( model_svm_ras55, t( lognorm_ras84_mat ) ),
                         sample_id = colnames( lognorm_mat ) ) %>%
    mutate( class_ras84 = RAG_name_map[ class_ras84 ] )

classes_df %>%
    write.table( file = "RAS_classes_df.txt",
                sep = "\t",
                quote = FALSE,
                row.names = FALSE )
