FROM rocker/verse:latest

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    libnetcdf-dev \
    ## rgl support
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    ## tcl tk support
    tcl8.6-dev \
    tk8.6-dev \
  && rm -rf /var/lib/apt/lists/* \
  && R -e "BiocManager::install(c('xcms','IPO','sva','WGCNA', 'KEGGREST', 'KEGGgraph', 'SSPA','Rdisop', 'qvalue', 'GlobalAncova', 'globaltest', 'siggenes', 'Rgraphviz','ChemmineR','metaMS', 'msPurity', 'mixOmics', 'fgsea', 'Rita','lumi','CompoundDb','MetaboAnnotation','MsBackendMgf','MsBackendMsp','genefilter','metapone'))" \
  && install2.r --error \
    RAMClustR \
    ChemoSpec \
    webchem \
    InterpretMSSpectrum \
    tcltk2 \
    plotly \
    caret \ 
    caretEnsemble \
    && rm -rf /tmp/downloaded_packages \
    && strip /usr/local/lib/R/site-library/*/libs/*.so

# added the installation in a separate Dockerfile after compiling above
# adding it here for complete Dockerfile if needed to run next time
# Install other R packages from CRAN
RUN R -e "install.packages(c('kableExtra', 'formattable', 'ggpmisc'), repos='https://cloud.r-project.org/')"

RUN R -e "tinytex::install_tinytex(force = TRUE)"

RUN R -e "tinytex::tlmgr_install(c( \
  'titling', 'fancyhdr', 'multirow', 'wrapfig', 'colortbl', 'pdflscape', \
  'varwidth', 'tabu', 'trimspaces', 'makecell', \
  'environ', 'ulem', 'threeparttable', 'threeparttablex' \
))"

# Clean up
RUN apt-get clean


