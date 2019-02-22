# docker-hpc-cluster
HPC cluster deployment solution for different environments, requirements and devices
The main goal of this project is to provide a single docker solution that spans accross multiple use cases, depending on: 
hardware requirements or availability,
environment needs.

The different flavours/versions offer an HPC environment that is meant to be used for testing (as a sandbox), developing or 
for research porpuses. Its use on a prodution environment is not supported by the authors of this project or the authors of the
projects the images were based upon.

The images/flavours offered by this projects are as follows:
- alpine-mpich: built upon the project by Software engineer [Nikyle Nguyen](https://github.com/NLKNguyen/alpine-mpich). After fixing networking issues preventing the comunication between the master node and the salve nodes on the original image, parallel python script execution support was added by installing mpi4py.
- ubuntu-opemmpi: build upon the project by Data Architect [Rosa Filgueira](https://github.com/dispel4py/docker.openmpi). The ubuntu version was updated, the dockerfile was rewritten and the mpiversion has been upgraded. Python support was already present, and it still works after the upgrade process previously described.

Mentioned Authors Info/Websites:
Rosa Filgueira
https://www.rosafilgueira.com/
Nikyle Nguyen
https://www.linkedin.com/in/nlknguyen/
