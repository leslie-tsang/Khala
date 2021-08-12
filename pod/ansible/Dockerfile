FROM centos:7

# args
ARG VAR_ANSIBLE_URL
ARG VAR_ANSIBLE_VERSION

WORKDIR /root

# install deps
RUN yum install -y openssh-clients \
 && yum install -y vim make \
 && yum install -y ${VAR_ANSIBLE_URL}/${VAR_ANSIBLE_VERSION} \
 && yum clean all

# install extension modules
RUN ansible-galaxy collection install ansible.posix

# init startup wizard
COPY entrypoint.sh /
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
