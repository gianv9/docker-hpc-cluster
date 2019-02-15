# docker ps | grep mpi_head --color=none | sed 's/.*0.0.0.0://g' | sed 's/->22.*//g'
#docker ps|awk '{print $11}'|grep -oP '(?<=\:)\w\w\w\w\w'
#docker ps|grep -oP '(?<=\:)\d\d\d\d\d'
docker service ls|grep -oP "(?<=:)\d{5}"
