FROM python:slim 
MAINTAINER Kenny Workman (kworkman@lbl.gov)

ENV TOOL_VERSION 1.9

# Compress source code into temporary tar file in /tmp/ directory
ADD https://github.com/samtools/samtools/releases/download/${TOOL_VERSION}/samtools-${TOOL_VERSION}.tar.bz2 /tmp/
ADD https://github.com/samtools/bcftools/releases/download/${TOOL_VERSION}/bcftools-${TOOL_VERSION}.tar.bz2 /tmp/

# Download samtools/bcftools library dependencies
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    autoconf \
    automake \
    perl \
    gcc \
    make \
    ncurses-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    libssl-dev
    
# Make samtools/bcftools binaries from tar
# Make samtools
RUN cd /tmp/ && tar --bzip2 -xjvf samtools-${TOOL_VERSION}.tar.bz2 \
    && cd /tmp/samtools-${TOOL_VERSION} && make \
    && mv /tmp/samtools-${TOOL_VERSION}/samtools /usr/bin \
    # Make bcftools 
    && cd /tmp/ && tar --bzip2 -xjvf bcftools-${TOOL_VERSION}.tar.bz2 \
    && cd /tmp/bcftools-${TOOL_VERSION} && make \
    && mv /tmp/bcftools-${TOOL_VERSION}/bcftools /usr/bin 

# COPY source code into container (cannot be done in different layers) 
COPY visualize /usr/local/visualize/
COPY ./pipe /usr/local/visualize/pipe
COPY requirements.txt /tmp/

# Install python dependencies and make bash script executable
RUN pip3 install -r /tmp/requirements.txt \
    && cd /usr/local/visualize && chmod +x visualize

# Temporary copy of a test directory, may want to remove
COPY sample_alignment /tmp/sample_alignment


#ENV python python3


