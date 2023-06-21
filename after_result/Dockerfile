FROM centos:7.2

WORKDIR /app

RUN yum -y update && \
    yum -y install wget bzip2 make gcc zlib-devel

RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh && \
    bash Anaconda3-2023.03-1-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm Anaconda3-2023.03-1-Linux-x86_64.sh

ENV PATH="/opt/anaconda3/bin:${PATH}"

RUN conda update -y conda && \
    conda update numpy

RUN conda install cython && \
    conda install cykhash && \
    conda install simde && \
    conda install python-dev && \
    conda install -c bioconda bedtools && \
    conda install -c bioconda bowtie2 && \
    conda install -c bioconda samtools
       
RUN pip install macs3



