# Always get latest because we are building and pushing to Docker Hub regularly
# trunk-ignore(hadolint/DL3006)
FROM redhat/ubi9

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN dnf -y install java-11 && dnf -y clean all && rm -rf /var/cache

# See https://docs.aws.amazon.com/msk/latest/developerguide/create-serverless-cluster-client.html
# Versions have been updated to newer available ones than those referenced in the documentation
ENV KAFKA_VERSION 2.8.2
ENV AWS_MSK_IAM_AUTH_VERSION 1.1.5

ENV KAFKA_URL https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_2.12-${KAFKA_VERSION}.tgz
ENV AWS_MSK_IAM_AUTH_URL https://github.com/aws/aws-msk-iam-auth/releases/download/v${AWS_MSK_IAM_AUTH_VERSION}/aws-msk-iam-auth-${AWS_MSK_IAM_AUTH_VERSION}-all.jar

RUN curl --location "${KAFKA_URL}" --output - | tar -xzf -
RUN curl --location --remote-name --output-dir kafka_2.12-${KAFKA_VERSION}/libs "${AWS_MSK_IAM_AUTH_URL}"

WORKDIR /kafka_2.12-${KAFKA_VERSION}
COPY client.properties bin

USER 1000
CMD [ "/bin/bash", "-l" ]
