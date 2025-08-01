#!/bin/bash



docker run -it --rm \
  -v /Users/kdabke/Documents/Working_Skyline_nextflow_pipeline/Skyline_DockerOnly_testing:/data \
  proteowizard/pwiz-skyline-i-agree-to-the-vendor-licenses \
  wine SkylineCmd \
  --new=test2.sky \
  --full-scan-precursor-analyzer=centroided \
  --full-scan-acquisition-method=DDA \
  --full-scan-precursor-res=10 \
  --full-scan-precursor-isotopes=Count \
  --full-scan-precursor-threshold=2 \
  --full-scan-product-analyzer=centroided \
  --full-scan-product-res=10 \
  --full-scan-rt-filter=none \
  --instrument-min-mz=40 \
  --instrument-max-mz=1500 \
  --save


docker run -it --rm \
  -v /path/to/working/directory:/data \
  proteowizard/pwiz-skyline-i-agree-to-the-vendor-licenses \
  wine SkylineCmd \
  --dir=/data \
  --in=test2.sky \
  --import-file=/data/raw_file_to_analyze.d \
  --import-transition-list=/data/Hilic_transitionList.csv \
  --report-name="Molecule Transition Results" \
  --report-file=/data/output/raw_file_to_analyze.csv
  

