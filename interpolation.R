
# ===============
# interpolation.R
# ===============
# This script is written to capture HWE filtered LD pruned SNP
# marker panel obtained from 1000Genome data that falls within the exome
# targets. This script takes two inputs,'parsed_exome_target' and
# 'marker_genomic_distance', both intermediate files created during
# implementation of the main pipeline. Since this is a packrate
# project, make sure R package dplyr is installed and 'init.R' is available in
# the 'packrat' directory. This script is called by main script. Do not
# implement it separately.

if (!file.exists("packrat/init.R")){
    stop("It does not look a packrat project.")
}

source("packrat/init.R")

require(dplyr)

sessionInfo()

# Input file from pipeline
exome_target_data <- read.table("parsed_exome_target")
snp_panel <- read.table("marker_genomic_distance")

cat(paste0("AUXILIARY FILES: parsed_exome_target and marker_genomic_distance"))

# Specify vector of exome target start, exome target end and SNP physical position
exome_target_start <- sort(exome_target_data[["V2"]])
exome_target_end <- sort (exome_target_data[["V3"]])
SNP_POS <- snp_panel[["V3"]]

# Find the index for SNPs intervals either within start vector (lower _limit)
# and end vector (upper_limit) of the exome target. Since, first inverval of
# end vector does not have lower limit as does in start vector, add +1 to end
# vector
table1 <- data.frame(SNP_POS, loc_lower = findInterval(SNP_POS, exome_target_start),
    loc_upper = findInterval(SNP_POS, exome_target_end + 1))

table2 <- data.frame(
# Find the index numbers for values above the lower limits
    loc_lower = findInterval(exome_target_start, exome_target_start),
# Find the index numbers for values above the upper limits
    loc_upper = findInterval(exome_target_start, exome_target_end + 1),
    exome_target_start,
    exome_target_end
)

# Find SNPs that fall under exome_target from start to end
table3 <- left_join(table1, table2, by = c("loc_lower", "loc_upper"))

# Select and filter the output table
table4 <- (table3%>%select(SNP_POS, exome_target_start, exome_target_end)
    %>%filter(exome_target_start != 'NA'))

# Write the output file
write.table(table4,file="rOutput", row.names=FALSE, col.names=FALSE)
