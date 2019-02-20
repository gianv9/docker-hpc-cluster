# 
#

FROM ubuntu:18.04
#MAINTAINER Ole Weidner <ole.weidner@ed.ac.uk> All credit goes to him, his image served a great inspiration for this project.
MAINTAINER José Francisco Hernández Balestrini <jfhernandezb.11@est.ucab.edu.ve>

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
ADD ssh/id_rsa.mpi /home/mpiuser/.ssh/id_rsa
ADD ssh/id_rsa.mpi.pub /home/mpiuser/.ssh/id_rsa.pub
ADD ssh/id_rsa.mpi.pub /home/mpiuser/.ssh/authorized_keys

RUN chmod -R 600 /home/mpiuser/.ssh/* && \
    chown -R mpiuser:mpiuser /home/mpiuser/.ssh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
ADD get_hosts /get_hosts
RUN chmod +x get_hosts

#---------------------------------------------------------------
#LD_LIBRARY_PATH
#---------------------------------------------------------------

RUN export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/openmpi/lib/

#---------------------------------------------------------------
#Copy project contents to containers
#---------------------------------------------------------------

COPY ./project/* /home/mpiuser

#---------------------------------------------------------------
#Add BTL TCP MCA Params to OMPI and compile Hello World
#---------------------------------------------------------------

RUN echo 'btl_tcp_if_exclude = lo,eth1,eth2' > /etc/openmpi/openmpi-mca-params.conf
RUN mpicc -o /home/mpiuser/HW /home/mpiuser/HW.c && mpicc -o /home/mpiuser/Send1 /home/mpiuser/CEDS.c
RUN chown -R mpiuser:mpiuser /home/mpiuser
RUN echo 'Why, Hello there!'
