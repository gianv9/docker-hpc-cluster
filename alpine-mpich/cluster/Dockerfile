# FROM gianv9/alpine-mpich:onbuild
FROM gianv9/docker-hpc:alpine-mpich-onbuild

# # ------------------------------------------------------------
# # Build MPI project
# # ------------------------------------------------------------

# Put all build steps and additional package installation here

# Note: the current directory is ${WORKDIR:=/project}, which is
# also the default directory where ${USER:=mpi} will SSH login to

# Copy the content of `project` directory in the host machine to 
# the current working directory in this Docker image
# COPY ./programs .

# RUN sudo chown -R mpiuser:mpiuser ./*

# RUN sudo chmod +x *.py
# Normal build command
# RUN mpicc -o mpi_hello_world mpi_hello_world.c

# ####################
# For Docker beginner:

# After Docker syntax `RUN`, you can execute any command available in 
# the current shell of the image.

# To switch to root:    USER root
# To switch back to default user: USER ${USER}

# create the python virtual env on the main directory
RUN python3.6 -m venv /project/pyVirtEnv
RUN source /project/pyVirtEnv/bin/activate && pip3 install simple-crypt && pip3 install mpi4py && deactivate