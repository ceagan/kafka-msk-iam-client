# Always get latest because we are building and pushing to Docker Hub regularly
# trunk-ignore(hadolint/DL3006)
FROM redhat/ubi9

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN dnf -y install java-11 && dnf -y clean all && rm -rf /var/cache

# See https://docs.aws.amazon.com/msk/latest/developerguide/create-serverless-cluster-client.html
ENV KAFKA_URL https://archive.apache.org/dist/kafka/2.8.1/kafka_2.12-2.8.1.tgz
ENV AWS_MSK_IAM_AUTH_URL https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.1/aws-msk-iam-auth-1.1.1-all.jar

RUN curl "${KAFKA_URL}" --output - | tar -xzf -
RUN curl --remote-name --output-dir kafka_2.12-2.8.1/libs "${AWS_MSK_IAM_AUTH_URL}"

WORKDIR /kafka_2.12-2.8.1
COPY client.properties bin

USER 1000
CMD [ "/bin/bash", "-l" ]
