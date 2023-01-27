FROM redhat/ubi9:9.1.0-1750

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN dnf -y install java-11 && dnf -y clean all && rm -rf /var/cache

ENV KAFKA_URL https://archive.apache.org/dist/kafka/2.8.1/kafka_2.12-2.8.1.tgz
ENV AWS_MSK_IAM_AUTH_URL https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.5/aws-msk-iam-auth-1.1.5-all.jar

RUN curl "${KAFKA_URL}" --output - | tar -xzf -
RUN curl --remote-name --output-dir kafka_2.12-2.8.1/libs "${AWS_MSK_IAM_AUTH_URL}"

USER 1000
WORKDIR /kafka_2.12-2.8.1
ENTRYPOINT ["/bin/bash", "-l", "-c"]
