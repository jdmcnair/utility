docker-machine stop default
docker-machine rm default
docker-machine create --driver virtualbox default
eval "$(docker-machine env default)"

VBoxManage controlvm "default" natpf1 "forward 9000,tcp,127.0.0.1,9000,,9000"
VBoxManage controlvm "default" natpf1 "forward 9001,tcp,127.0.0.1,9001,,9001"
