# 
#

FROM ubuntu:18.04

LABEL mantainer=["Gianfranco A. Verrocchi C.","José F. Hernández B."] creator="Ole Weidner <ole.weidner@ed.ac.uk>"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y openssh-server python-mpi4py python-numpy \
            python-virtualenv python-scipy gcc gfortran openmpi-doc binutils \
	    nano net-tools dnsutils zip git openmpi-bin openmpi-common libopenmpi-dev
RUN mkdir /var/run/sshd
RUN echo 'root:mpi' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# ------------------------------------------------------------
# Add a generic user
# ------------------------------------------------------------

RUN adduser --disabled-password --gecos "" mpiuser && \
    echo "mpiuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/mpiuser
RUN echo 'mpiuser:123456' | chpasswd

# ------------------------------------------------------------
# Set-Up SSH & Add "get_hosts" script
# ------------------------------------------------------------

RUN mkdir /home/mpiuser/.ssh/
ADD ssh/config /home/mpiuser/.ssh/config
ADD ssh/id_rsa /home/mpiuser/.ssh/id_rsa
ADD ssh/id_rsa.pub /home/mpiuser/.ssh/id_rsa.pub
ADD ssh/id_rsa.pub /home/mpiuser/.ssh/authorized_keys

RUN chmod -R 600 /home/mpiuser/.ssh/* && \
    chown -R mpiuser:mpiuser /home/mpiuser/.ssh

EXPOSE 22
ADD find_workers /usr/local/bin/find_workers
RUN chmod +x /usr/local/bin/find_workers
ADD auto_update_hosts /usr/local/bin/auto_update_hosts
RUN chmod +x /usr/local/bin/auto_update_hosts

#---------------------------------------------------------------
#LD_LIBRARY_PATH
#---------------------------------------------------------------

RUN export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/openmpi/lib/

#---------------------------------------------------------------
#Copy project contents to containers
#---------------------------------------------------------------

COPY ./programs /home/mpiuser
RUN chmod +x /home/mpiuser/*.py

#---------------------------------------------------------------
#Compiling Hello World and MPI-Splitter
#---------------------------------------------------------------

RUN mpicc -o /home/mpiuser/MPI-Splitter/HW /home/mpiuser/MPI-Splitter/HW.c && mpicc -o /home/mpiuser/MPI-Splitter/Send1 /home/mpiuser/MPI-Splitter/CEDS.c
RUN chown -R mpiuser:mpiuser /home/mpiuser
RUN echo 'Why, Hello there!'
