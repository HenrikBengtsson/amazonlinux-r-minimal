## Source: https://github.com/HenrikBengtsson/amazonlinux-r-minimal
## Copyright: Henrik Bengtsson (2017)
## License: GPL (>= 2.1) [https://www.gnu.org/licenses/gpl.html]

FROM amazonlinux:latest

MAINTAINER Henrik Bengtsson "henrikb@braju.com"

ENV R_VERSION=3.3.2
ENV R_READLINE=yes

RUN yum install -y diffutils         ## make: 'cmp'; required for modules/lapack
RUN yum install -y findutils         ## make: 'find'; required for library/translations
RUN yum install -y which             ## R needs it at runtime, e.g. Sys.which()
RUN yum install -y gcc-c++
RUN yum install -y gcc-gfortran
RUN yum install -y zlib-devel
RUN yum install -y bzip2-devel
RUN yum install -y xz-devel          ## liblzma
RUN yum install -y pcre-devel
RUN yum install -y curl-devel

## Optional
RUN yum install -y libpng-devel

RUN yum install -y readline-devel ## Required by --with-readline=yes

## Build and install R from source
RUN cd /tmp; curl -O https://cloud.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz
RUN cd /tmp; tar -zxf R-${R_VERSION}.tar.gz
RUN cd /tmp/R-${R_VERSION}; ./configure --with-readline=${R_READLINE} --without-x --without-libtiff --without-jpeglib --without-cairo --without-lapack --without-ICU --without-recommended-packages --disable-R-profiling --disable-java --disable-nls
RUN cd /tmp/R-${R_VERSION}; make
RUN cd /tmp/R-${R_VERSION}; make install

## R runtime properties
RUN mkdir /usr/local/lib64/R/site-library  ## Where to install packages

RUN echo "R_BIOC_VERSION=3.4" >> .Renviron
RUN echo 'options(repos = c(CRAN="https://cloud.r-project.org", BioCsoft="https://bioconductor.org/packages/3.4/bioc", BioCann="https://bioconductor.org/packages/3.4/data/annotation", BioCexp="https://bioconductor.org/packages/3.4/data/experiment", BioCextra="https://bioconductor.org/packages/3.4/extra"))' >> .Rprofile
