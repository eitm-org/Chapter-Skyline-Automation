#!/bin/bash -ue
echo -n 'msconvert_version: ' >> msconvert_versions.yml
wine msconvert 2>&1 | grep 'release' | awk '{print $3}' >> msconvert_versions.yml
echo "msconvert_container_tag: proteowizard/pwiz-skyline-i-agree-to-the-vendor-licenses" >> msconvert_versions.yml
