# Work from latest LTS ubuntu release
FROM ubuntu:18.04

MAINTAINER Kenny Workman (kworkman@lbl.gov)

# Run update and install necessary packages
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

# Download the suite of tools (C-based binaries)
WORKDIR /usr/local/bin/
RUN wget https://github.com/samtools/samtools/releases/download/${samtools_version}/samtools-${samtools_version}.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/${bcftools_version}/bcftools-${bcftools_version}.tar.bz2

# Extract files for the suite of tools (C-based binaries)
RUN tar -xjf /usr/local/bin/samtools-${samtools_version}.tar.bz2 -C /usr/local/bin/
RUN tar -xjf /usr/local/bin/bcftools-${bcftools_version}.tar.bz2 -C /usr/local/bin/

# Run make on the source (C-based binaries)
RUN cd /usr/local/bin/samtools-${samtools_version}/ && ./configure
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make
RUN cd /usr/local/bin/samtools-${samtools_version}/ && make install

RUN cd /usr/local/bin/bcftools-${bcftools_version}/ && make
RUN cd /usr/local/bin/bcftools-${bcftools_version}/ && make install

# Copy project source code into container
COPY ./pipe /usr/local/pipeline/pipe
COPY ./app /usr/local/pipeline/app

# Install dependencies
WORKDIR /usr/local/
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

EXPOSE 5000

# Make container run when built
#CMD ["sleep","3600"]
