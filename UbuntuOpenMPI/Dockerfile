# Build this image:  docker build -t mpi .
#

FROM ubuntu:14.04
MAINTAINER Ole Weidner <ole.weidner@ed.ac.uk>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y openssh-server python-mpi4py python-numpy \
            python-virtualenv python-scipy gcc gfortran openmpi-checkpoint binutils \
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
# Set-Up SSH with our Github deploy key
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

RUN export LD_LIBRARY_PATH=/usr/lib/openmpi/lib/


# copy project contents to image
COPY ./project /home/mpiuser