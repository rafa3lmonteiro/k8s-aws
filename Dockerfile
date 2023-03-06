FROM ubuntu:latest
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="America/Sao_Paulo" \
    apt-get install ansible wget unzip python3-pip -y && \
    pip3 install boto && \
    wget https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_amd64.zip -O /tmp/terraform_1.3.9_linux_amd64.zip && \
    unzip /tmp/terraform_1.3.9_linux_amd64.zip -d /usr/bin
