
# Installing microk8s on ubuntu

sudo snap install microk8s --classic
sudo microk8s status

sudo usermod -aG microk8s ubuntu

  vi .bashrc
  . .bashrc


sudo cp .kube/config /home/student20/.kube/
<> ubuntu@bastion ~> sudo chown -R -f student20 /home/student20/.kube/


# In a new shell on bastion

microk8s kubectl get nodes   
#microk8s config > microk8s.config
[ -f ~/.kube/config ] && die "Not overwriting ~/.kube/config"
microk8s config > ~/.kube/config
kubectl get nodes   


ubuntu@bastion:~$ sudo mkdir /home/student1/.kube
ubuntu@bastion:~$ sudo cp .kube/config /home/student1/.kube/
ubuntu@bastion:~$ sudo chown -R -f ubuntu /home/student1/.kube/
ubuntu@bastion:~$ sudo mkdir /home/student2/.kube
ubuntu@bastion:~$ sudo cp .kube/config /home/student2/.kube/
ubuntu@bastion:~$ sudo chown -R -f ubuntu /home/student2/.kube/




