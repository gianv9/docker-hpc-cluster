## docker.openmpi

With the code in this repository, you can build a Docker container that provides 
the OpenMPI runtime and tools along with various supporting libaries, 
including the MPI4Py Python bindings. The container also runs an OpenSSH server
so that multiple containers can be linked together and used via `mpirun`.


## Start an MPI Container Cluster

While containers can in principle be started manually via `docker run`, we suggest that your use 
[Docker Compose](https://docs.docker.com/compose/), a simple command-line tool 
to define and run multi-container applications. We provde a sample `docker-compose.yml`
file in the repository:

```
mpi_head:
  image: openmpi
  ports: 
   - "22"
  links: 
   - mpi_node

mpi_node: 
  image: openmpi

```

The file defines an `mpi_head` and an `mpi_node`. Both containers run the same `openmpi` image. 
The only difference is, that the `mpi_head` container exposes its SHH server to 
the host system, so you can log into it to start your MPI applications.


The following command will start one `mpi_head` container and three `mpi_node` containers: 

```
$> docker-compose up -d
$> docker-compose scale mpi_node=16 mpi_head=1
```
And to /etc/hosts file compiled from docker-compose automagically

```
$> docker-compose stop mpi_head
$> yes | docker-compose rm -v mpi_head
$> docker-compose up -d
```
Once all containers are running, connect to mpi_head with:


```
$> chmod 400 ssh/id_rsa.mpi
$> ssh -i ssh/id_rsa.mpi -p $( source echo_head_port.sh ) tutorial@192.168.99.100
```

For testing an mpi4py example using the mpi_nodes:
	
	cd mpi4py_benchmarks
	cat /etc/hosts | grep mpi_node --color=none | awk '{print $1}' | sort -u > machines && cat ./machines
	mpiexec -hostfile machines -n 16 python helloworld.py   	

For testing dispel4py with mpi mapping:
     
	mpiexec -n 6 -hostfile machines dispel4py mpi dispel4py.examples.graph_testing.pipeline_test	

