# Getting Docker, Kind and Coder up and running with Terraform

## Create a VM with Ubuntu

## Install git    
```
sudo apt install git
```
```
git clone https://github.com/Riaankl/tf.git
```

## Install Terraform
```
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```
```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```
```
sudo apt update && sudo apt install terraform
```
## Go to Terraform directory and run terraform
```
cd ~/Riaankl/tf.git
```
```
terraform init
```
```
terraform plan
```
```
terraform apply 
```
