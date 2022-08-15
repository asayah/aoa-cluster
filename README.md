# How to use 

Clone this repo - and create a branch for your work, then you can modify the waves template files, finally make sure your changes are pushed to your remote repository then run the following script: 

```bash 
./deploy.sh <cluster_name> <cluster_context> <mgmt_context>
```
Verify if the configuration is correct, and enter Y/N: 

```
----------------------------------------
Usage: deploy.sh <cluster_name> <cluster_context> <mgmt_context>
----------------------------------------
✔ - Your local branch is in sync with the remote repository
----------------------------------------
----------------------------------------
This configuration will be used to install:
cluster_name=cluster1
cluster_context=cluster1
mgmt_context=mgmt
repo=https://github.com/asayah/aoa-cluster.git
branch=main
----------------------------------------
Do you want to continue [Y/N] ?

```

# TODO
 - Add more details in readme


