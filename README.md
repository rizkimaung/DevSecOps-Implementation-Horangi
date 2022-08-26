# Cyberops DevSecOps Service

## Up and Running

### Virtualbox

1. Install Virtualbox (6.1 or greater)

    https://www.virtualbox.org/wiki/Downloads

### Vagrant

1. Install Vagrant

    https://www.vagrantup.com/downloads

2. Turn on the Vagrant Machines

    ```
    vagrant --version
    # Vagrant 2.2.18
    vagrant up
    # Also inspect the .vagrant directory
    ```

3. SSH to Vagrant Machines

    ```
    # Manual ssh
    ssh -i .vagrant/machines/devsecops_apps/virtualbox/private_key vagrant@192.168.56.103 -vvv
    # Automatic ssh login
    vagrant ssh devsecops_ci_server
    # Check the Vagrant ssh config
    vagrant ssh-config
    ```

### Ansible

1. Install Ansible

    https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

2. Ansible Ping host

    ```
    ansible --version
    ### ansible [core 2.12.3]
    ### ...
    ansible -i hosts -m ping all
    ```

3. Run Playbooks

    ```
    # all
    ansible-playbook -i hosts automate-script/install-all.yaml --become -vv
    # ci
    ansible-playbook -i hosts automate-script/install-ci.yaml --become -vv
    # cd
    ansible-playbook -i hosts automate-script/install-cd.yaml --become -vv
    ```

4. References

    - https://docs.ansible.com/ansible/2.3/guide_vagrant.html
