# input from user
args <- commandArgs(trailingOnly = TRUE)


input_rmd <- args[1]
skyline_report_csv <- args[2]
function_script <- args[3]
molecular_formula <- args[4]
logo <- args[5]

library(stringr)
filename <- args[2]

filename <- str_split(filename[1], "\\.")[[1]][1]

pdffilename <- paste0(filename, ".pdf")

# Render the RMarkdown file
#Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools/aarch64")
rmarkdown::render(input_rmd, params = list(skyline_report_csv = skyline_report_csv,
                                           function_script = function_script,
                                           molecular_formula = molecular_formula,
                                           logo = logo),
                  output_file = pdffilename)

