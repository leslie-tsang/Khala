FROM centos:7

# Args
ARG VAR_ANSIBLE_URL
ARG VAR_ANSIBLE_VERSION

WORKDIR /root

RUN yum install -y wget openssh-clients \
 && wget ${VAR_ANSIBLE_URL}/${VAR_ANSIBLE_VERSION} \
 && yum install -y ${VAR_ANSIBLE_VERSION} \
 && yum clean all \
 && rm -rf *.rpm

COPY entrypoint.sh .

ENTRYPOINT [ "/bin/bash", "/root/entrypoint.sh" ]
