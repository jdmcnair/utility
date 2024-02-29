# This got group policy working for wsl again, 
# See discussion: https://teams.microsoft.com/l/message/19:3a8bb7a5-70ee-47d5-9986-ce9d633ac048_84ecb408-24aa-4abe-8ca5-604d0938edb7@unq.gbl.spaces/1709154353063?context=%7B%22contextType%22%3A%22chat%22%7D

net stop vmcompute
net stop LxssManager
net start LxssManager
net start vmcompute