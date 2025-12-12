#Tutorial: https://cran.r-project.org/web/packages/ukbnmr/vignettes/ukbnmr.html#:~:text=library(ukbnmr)%20library(data,sample_qc_flags%20%3C%2D%20extract_sample_qc_flags(exported)

# On terminal
#dx download "exported_121225.csv"

# Install ukbnmr package
remotes::install_github("sritchie73/ukbnmr", dependencies = TRUE, build_vignettes = TRUE)

# Load the package
library(ukbnmr)
library(data.table)

# Load the dataset
exported <- fread("exported_121225.csv")

# Remove technical variation
processed <- remove_technical_variation(exported)

# Saving results
fwrite(processed$biomarkers, file="nmr_biomarker_data_full.csv")
fwrite(processed$biomarker_qc_flags, file="nmr_biomarker_qc_flags_full.csv")
fwrite(processed$sample_processing, file="nmr_sample_qc_flags_full.csv")
fwrite(processed$log_offset, file="nmr_biomarker_log_offset_full.csv")
fwrite(processed$outlier_plate_detection, file="outlier_plate_info_full.csv")

# On terminal
#dx upload "nmr_biomarker_data_full.csv" "nmr_biomarker_qc_flags_full.csv" "nmr_sample_qc_flags_full.csv" "nmr_biomarker_log_offset_full.csv" "outlier_plate_info_full.csv"