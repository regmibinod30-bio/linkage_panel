# legacy_linkage.git

## Overview
This repository contains input data and scripts required to reproduce SNPs
linkage marker panel. This analysis uses VCF file of 1000Genome combined SNP
of Omni2.5 and Affy6.0. The analysis included non-founder invidivuals of GBR
and CEU populations. The main goal of this analysis was to generate a
reference panel to evaluate the possible linkage of variants discovered from
the current analysis.
The scripts directory contains two scripts linkage_markerp_panel.pbs and
interpolation.R. interpolation.R is embedded in the PBS script. The PBS
script should be submitted from script directory using flowing command:

qsub `linkage_marker_panel.pbs`


## Repository Map
### input/
The input directory contains the following data files.

File/Directory  |    Description
:---------------|:----------------------
`1000_Genome_unrelSamples.txt` | This is a sample description file of several populations with non-founder individuals obtained from 1000Genome project website. https://www.internationalgenome.org/data-portal/sample.
`nimblegen_solution_V2refseq2010.HG19.list` | This is a local copy of git-annex file with the list of exome target with chr#, start and end positions. The main script parses this file, and inputs the base positions to R script `interpolation.R`.
`rutgers_map` | rutgers map file was obtained from
http://compgen.rutgers.edu/downloads/rutgers_map_v3a.zip, and reformated with awk and sed commands before concatenating as a single input
file with relevant columns (i.e. chr#, Marker_name and sex_averaged_haldane_map_position). The size of this file has been dramatically reduced removing many original columns that this anlysis does not use.
`INPUT_VCF` | This is a intermediate file of SNP data (SNP combined Omni2.5 and Affy6.0) obtained from: ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/supporting/hd_genotype_chip/ALL.chip.omni_broad_sanger_combined.20140818.snps.genotypes.vcf.gz. Being a large VCF file, the script checks the URL, downloads the file, filters the noises, runs the analysis and ultimately deletes this file.

### scripts/
This directory contains all the scripts and packages used for implementing this analysis.

File/Directory  |   Description
:---------------|:------------------------
`interpolation.R`  | An embedded script for finding the intervals (exome targets) for each SNP physical position. It uses R package dplyr
`linkage_marker_panel.pbs` | This is the main script for implementing filtering, joining, pruning, bridging, and rearranging data
through several analysis steps.
`packrat/` | directory that contains 'init.R', 'lock.R' files and private library  for managing packages in a stand-alone environment. 

### output/
This directory contains the log and output files.

File/Directory  |   Description
:---------------|:-------------------------
`Linkage_marker_panel`    | This is the main output file containing markers ID, markers physical position, exome target start positions, exome target end position, and more importantly, genomic distance of SNP marker (cM).
`linkage_panel.log`   | contains analysis description, stdout and stderr of the script implementation.
`interpolation.Rout`  | out file of `interpolation.R` script.

## software/packages
1. [PLINK 1.90b6.13]: for filtering, pruning, and manipulating the varaints and VCF file.
2. [R/3.1.3]: running interpolation.R script.
3. [packrat]: for managing R libraries.
