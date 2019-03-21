# docker-hpc-cluster
HPC cluster deployment solution for different environments, requirements and devices. The main goal of this project is to provide a single docker solution, consisting of several images, that spans accross multiple use cases (one for each case), depending on: 
hardware requirements or availability,
environment needs.

The different flavours/versions offer an HPC environment that is meant to be used for testing (as a sandbox), developing or 
for research purposes. Its use on a production environment is not supported by the authors of this project, or the authors of the
projects the images were based upon.

The images/flavours offered by this projects are as follows:
- alpine-mpich: built upon the project by Software engineer [Nikyle Nguyen](https://github.com/NLKNguyen/alpine-mpich). After fixing networking issues preventing the comunication between the master node and the slave nodes on the original image, parallel python script execution support was added by installing mpi4py.
- ubuntu-opemmpi: built upon the project by Data Architect [Rosa Filgueira](https://github.com/dispel4py/docker.openmpi). The Ubuntu version was updated, the dockerfile was rewritten and the OpenMPI version has been upgraded. Python support was already present, and it still works after the upgrade process previously described.

Roadmap:
- Adding Local Storage support.
- Standarizing the launching process for all the flavours.
- Installing the Slurm Scheduler and resource manager.
- Running and comparing the performance of different programs within the different flavours and a traditional cluster environment.
- Installing More runtimes for parallel computing, such as Erlang, Scala and Julia.
- More comparisons.

The flavours are pushed to a [Docker Hub](https://hub.docker.com/r/gianv9/docker-hpc) repository as tags.

Mentioned Author's Info/Websites:
- Rosa Filgueira
  - https://www.rosafilgueira.com/
  - https://www.linkedin.com/in/rosa-filgueira-vicente-8b2b2227/
- Nikyle Nguyen
  - https://www.linkedin.com/in/nlknguyen/

