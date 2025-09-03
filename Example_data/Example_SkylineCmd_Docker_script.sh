#!/bin/bash



docker run -it --rm \
  -v /path/to/cloned/repository/Chapter-Skyline-Automation/Example_data:/data \
  proteowizard/pwiz-skyline-i-agree-to-the-vendor-licenses \
  wine SkylineCmd \
  --new=template.sky \
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


  

