FROM s390x/ubuntu:20.04 AS builder

LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/community/z/usergroups/opensource)"

ARG TERRAFORM_VERSION=1.0.4
ARG GO_VERSION=1.16.5

ENV GOPATH=/root
ENV PATH=$GOPATH/bin:/usr/local/go/bin:$PATH

RUN apt-get update && apt-get install -y git wget tar gcc && \
    cd $GOPATH && \
    wget https://golang.org/dl/go${GO_VERSION}.linux-s390x.tar.gz && \
    tar -C /usr/local -xvzf go${GO_VERSION}.linux-s390x.tar.gz && \
    mkdir -p $GOPATH/src/github.com/hashicorp && \
    cd $GOPATH/src/github.com/hashicorp && \
    git clone https://github.com/hashicorp/terraform.git && \
    cd terraform && \
    git checkout v${TERRAFORM_VERSION} && \
    go install .  && \
    mv ${GOPATH}/bin/terraform /usr/bin/


FROM s390x/ubuntu:20.04

LABEL maintainer="LoZ Open Source Ecosystem (https://www.ibm.com/community/z/usergroups/opensource)"

WORKDIR /root

COPY --from=builder /usr/bin/terraform /usr/bin/terraform

ENTRYPOINT ["/usr/bin/terraform"]
