FROM Ubuntu 20.04.5

WORKDIR /tmp

RUN yum -y update && \
    yum -y install wget bzip2 make gcc zlib-devel

RUN wget https://repo.anaconda.com/archive/Anaconda3-2023.03-1-Linux-x86_64.sh && \
    bash Anaconda3-2023.03-1-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm Anaconda3-2023.03-1-Linux-x86_64.sh

ENV PATH="/opt/anaconda3/bin:${PATH}"

RUN conda update -y conda \
    && conda update numpy \
    && conda update matplotlib \
    && conda update sys \
    && conda update re \


RUN wget https://github.com/pFindStudio/pDeep/archive/refs/heads/master.zip \
    && unzip master.zip

    

