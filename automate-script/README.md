# AUTOMATED INSTALL TOOLS DEVSECOPS


## Introduction
this script will run several tasks related to DevSecOps tools, to install some tools.
it's only coverage for Secret Scanning, Software Compositions Analysis, Static Analysis Security Testing, and Vuln Management.

## Requirement
- VM already install (minimum 2 and optional)
- Ansible already install on VM
- SSH service (Optional for superuser privilege or sudo privilege)

## Tools Include Script
- [Jenkins](https://www.jenkins.io/)
- [Trufflehog](https://trufflesecurity.com/trufflehog)
- [Snyk](https://snyk.io/)
- [Sonarqube](https://www.sonarqube.org/downloads/)
- [ArcherySec](https://www.archerysec.com/)


## Code Ansible Review
### Code for ALL
This script purpose to install common dependencies, namely [java](https://java.com/en/download/help/download_options.html)

```yaml
- name: task for all
  hosts: all
  tasks:
    - name: install java
      command: '{{item}}'
      with_items:
        - apt update -y
        - apt install fontconfig openjdk-11-jre -y
        - java --version
```

### Code for CI

there are several tasks running that aim to install several tools starting from creating a document, adding a key for the repo, adding a new repo, and installing tools, once enabling and restarting the tools.

```yaml
- name: task for CI
  hosts: host-ci
  tasks:
    - name: create directory
      command: '{{item}}'
      with_items:
        - mkdir -p /usr/share/keyrings
        - touch /usr/share/keyrings/jenkins-keyring.asc

    - name: add key
      apt_key:
        url: https://pkg.jenkins.io/debian/jenkins.io.key
        state: present
        keyring: /usr/share/keyrings/jenkins-keyring.asc
      become: true

    - name: add-repo
      apt_repository:
        repo: deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] http://pkg.jenkins.io/debian-stable binary/
        state: present
        filename: jenkins

    - name: install jenkins
      command: '{{item}}'
      with_items:
        - apt update -y
        - apt install jenkins -y

    - name: install go
      command: '{{item}}'
      with_items:
        - tar -C /usr/local -xzf go1.13.5.linux-amd64.tar.gz


    - name: install npm
      command: '{{item}}'
      with_items:
        - apt install nodejs -y
        - apt install npm -y
        - npm install snyk@latest -g -y

    - name: install trufflehog
      command: '{{item}}'
      with_items:
        - apt install python3-pip -y
        - pip install trufflehog
```

### Code for CD

almost the same as the CI task, this CD task is made to perform several tasks but here there is a difference, one of these tasks creates a file system and adds a configuration file.


```yaml
- name: task for CD
  hosts: sonar
  tasks:
    - name: add repo 
      apt_repository:
        repo: deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main
        state: present
        filename: pgdg

    - name: add key
      apt_key:
        url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
        state: present
      become: true

    - name: install postgresql
      command: '{{item}}'
      with_items:
        - apt update -y
        - apt install -y postgresql postgresql-contrib
        - systemctl enable postgresql
        - systemctl start postgresql

    - name: change password
      user:
        name: postgres
        update_password: always
        password: "{{ newpassword|password_hash('sha512') }}"

    - name: install zip
      command: apt-get install zip -y

    - name: download sonarqube
      get_url:
        url: https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.3.0.51899.zip
        dest: /root/sonarqube9.3.0.51899.zip

    - name: unzip sonarqube
      command: '{{item}}'
      with_items:
        - unzip sonarqube*.zip
        - 'mv  sonarqube-* /opt/sonarqube'

    - name: configure sonarqube
      command: '{{item}}'
      with_items:
        - groupadd sonar
        - useradd -d /opt/sonarqube -g sonar sonar
        - chown sonar:sonar /opt/sonarqube -R

    - name: Set user and password Sonar
      blockinfile:
        path: /opt/sonarqube/conf/sonar.properties
        backup: yes
        block: |
          sonar.jdbc.username=sonar
          sonar.jdbc.password=12345678
          sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube

    - name: set user on sonar.sh
      blockinfile:
        path: /opt/sonarqube/bin/linux-x86-64/sonar.sh
        backup: yes
        block: |
          RUN_AS_USER=sonar

    - name: Creating a file with content
      copy:
        dest: "/etc/systemd/system/sonar.service"
        content: |
          [Unit]
          Description=SonarQube service
          After=syslog.target network.target

          [Service]
          Type=forking

          ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
          ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

          User=sonar
          Group=sonar
          Restart=always

          LimitNOFILE=65536
          LimitNPROC=4096

          [Install]
          WantedBy=multi-user.target
    - name: start to sonarqube
      command: '{{item}}'
      with_items:
        - systemctl enable sonar
        - systemctl start sonar
        - systemctl status sonar

    - name: sysctl edit
      blockinfile:
        path: /etc/sysctl.conf
        backup: yes
        block: |
          vm.max_map_count=262144
          fs.file-max=65536
          ulimit -n 65536
          ulimit -u 4096
```

## Before use
You need to prepare something special on the ansible host, it's for the target you want to execute the task.
in the hosts file we found 2 groups for each host, the ci-host group is the host for integrating many tools that can support the DevSecOps lifecycle, the sonar group is the host that contains the sonarqube.

```bash
┌──(root#test)-[~]
└─# cat /etc/ansible/hosts
[host-ci]
192.168.188.145
[sonar]
192.168.188.160
```

## How to use
before you use it, you must put the file in the directory to easy management this playbook
you can place in /etc/ansible/playbook/

```bash
┌──(root#test)-[/etc/ansible/playbook]
└─ ls
install-ci.yaml install-cd.yaml
```

after you put the file, you can run this file with command

```bash
# for CI
┌──(root#test)-[/etc/ansible/playbook]
└─ ansible-playbook install-cd.yaml -vv --extra-vars newpassword=12345678
# for CD
┌──(root💀test)-[/etc/ansible/playbook]
└─ ansible-playbook install-cd.yaml -vv
```


