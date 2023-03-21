# Laptop duplication with Terraform

## Install Ubuntu with a start-up disk
Create a start-up disk of the prefered version of Ubuntu and provision the machine.
Once the install is completed install git and terraform.
Clone the repo containing the terraform file.
cd to the file containing the main.tf file
 - run terraform init, terraform plan & terraform apply 


### Install git    
```
sudo apt install git
```
```
git clone https://github.com/Riaankl/tf.git
```

### Install Terraform
```
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
```
```
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```
```
sudo apt update && sudo apt install terraform
```
### Go to Terraform directory and run terraform
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

### Copy file via ssh to the new laptop
#### Copy google chrome config directly via ssh:
Close Chrome before copy, open chrome after copy

`sudo scp -r ~/.config/google-chrome test@test.local:~/.config/google-chrome`
#### Copy ssh keys directly via ssh:
`sudo scp -r ~/.ssh test@test.local:~/.ssh`
### Copy Docments directory via ssh:
`sudo scp -r ~/Documents test@test.local:~/Documents`

