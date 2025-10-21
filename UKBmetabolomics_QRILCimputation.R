# Install packages
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("impute")
BiocManager::install("pcaMethods")

install.packages('imputeLCMD')

# Load packages
library(data.table)
library(imputeLCMD)

# Load the dataset
df <- fread("knn_imputed_metabolomics.csv")

# Separate eid column from the metabolites
eid <- df$eid
met <- df[, 2:ncol(df)]

# Change to numeric
met <- as.data.frame(sapply(met, as.numeric))

# Transform to make it closer to normal distribution
# (QRILC take from the normal distribution)
log_met <- log2(met)

# QRILC tutorial: https://www.rdocumentation.org/packages/imputeLCMD/versions/2.0/topics/impute.QRILC
# Impute the dataset
imputed <- impute.QRILC(as.matrix(log_met))
imputed <- as.data.frame(imputed[[1]])

# Back-transform
imputed_back <- 2^imputed

# Transfer imputed values to the original dataset
# (instead of taking the back transformed non missing values,
# better to use the original to avoid any shifts due to transformations )
met[is.na(met)] <- imputed_back[is.na(met)]

# Check the results, if there is any missing values
any(is.na(met))

# Merge to ids back
imputed_full <- cbind(eid, met)

# Export the imputed dataset
write.csv(imputed_full, 'qrilc_imputed_metabolomics.csv', row.names = FALSE)