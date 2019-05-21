#work from latest LTS ubuntu release
FROM ubuntu:18.04

MAINTAINER Kenny Workman (kworkman@lbl.gov)

# set the environment variables
ENV samtools_version 1.9
ENV bcftools_version 1.9
ENV htslib_version 1.9

# run update and install necessary packages
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnss-sss \
    libbz2-dev \
    liblzma-dev \
    vim \
    less \
    libcurl4-openssl-dev \
    wget \
    python3-pip

# download the suite of tools (C-based binaries)
WORKDIR /usr/local/bin/
RUN wget https://github.com/samtools/samtools/releases/download/${samtools_version}/samtools-${samtools_version}.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/${bcftools_version}/bcftools-${bcftools_version}.tar.bz2
RUN wget https://github.com/samtools/htslib/releases/download/${htslib_version}/htslib-${htslib_version}.tar.bz2

# extract files for the suite of tools (C-based binaries)
RUN tar -xjf /usr/local/bin/samtools-${samtools_version}.tar.bz2 -C /usr/local/bin/
RUN tar -xjf /usr/local/bin/bcftools-${bcftools_version}.tar.bz2 -C /usr/local/bin/
RUN tar -xjf /usr/local/bin/htslib-${htslib_version}.tar.bz2 -C /usr/local/bin/

# run make on the source (C-based binaries)
RUN cd /usr/local/bin/htslib-${htslib_version}/ && ./configure
RUN cd /usr/local/bin/htslib-${htslib_version}/ && make
RUN cd /usr/local/bin/htslib-${htslib_version}/ && make install

RUN cd /usr/local/bin/samtools-${samtools_version}/ && ./configure
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make install

RUN cd /usr/local/bin/bcftools-${bcftools_version}/ && make
RUN cd /usr/local/bin/bcftools-${bcftools_version}/ && make install

WORKDIR /usr/local/
COPY ./data_pipe ./pipeline
COPY ./app ./pipeline


# Make container run when built
CMD ["sleep","3600"]
