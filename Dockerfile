FROM ubuntu

# URL of repository the runner should be linked to
ENV url=

# Token used for registering runner
ENV token=

# Name of the runner
ENV name="GitHub Actions Runner"

# Group the runner should be added to
ENV group=


ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Berlin"

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install unzip tar git curl ca-certificates gnupg -y

# Add docker apt repository
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update -y

# Install docker and docker-compose
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Install GitHub Action Runner
WORKDIR actions-runner
RUN curl -o actions-runner-linux-x64-2.310.2.tar.gz -L https://github.com/actions/runner/releases/download/v2.310.2/actions-runner-linux-x64-2.310.2.tar.gz
RUN echo "fb28a1c3715e0a6c5051af0e6eeff9c255009e2eec6fb08bc2708277fbb49f93  actions-runner-linux-x64-2.310.2.tar.gz" | shasum -a 256 -c
RUN tar xzf ./actions-runner-linux-x64-2.310.2.tar.gz && rm -f ./actions-runner-linux-x64-2.310.2.tar.gz
RUN ./bin/installdependencies.sh

COPY daemon.json /etc/docker/daemon.json
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Creating work directory and new user
RUN adduser --disabled-password --disabled-login actions-runner
RUN usermod -a -G docker actions-runner
RUN mkdir -p /tmp/actions-runner
RUN chown -R -f actions-runner /actions-runner /tmp/actions-runner
RUN chmod -R 777 /tmp/actions-runner /home/actions-runner

# Files that should be mounted
# /var/run/docker.sock:/var/run/docker.sock

CMD sh -c "./entrypoint.sh"