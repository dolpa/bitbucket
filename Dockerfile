FROM dolpa/ubuntu-upgraded:18.04

LABEL maintainer="pavel.dolinin@gmail.com"

# Labels
LABEL os="ubuntu"
LABEL os-version="18.04"
LABEL app="bitbucket"
LABEL app-version="${version}"

# Arguments
ARG user=bitbucket
ARG group=bitbucket
ARG app=bitbucket
ARG uid=2036
ARG gid=2036
ARG http_port=3000
ARG version="7.5.0"

# Environmrnt
ENV user=${user}
ENV group=${group}
ENV app=${app}
ENV uid=${uid}
ENV gid=${gid}
ENV http_port=${http_port}
ENV version=${version}

# Tini arguments
ENV TINI_VERSION v0.19.0
ENV TINI_SHA c5b0666b4cb676901f90dfcb37106783c5fe2077b04590973b885950611b30ee

# App Environment variables
ENV BITBUCKET_HOME /var/atlassian/application-data/${app}
ENV BITBUCKET_INSTALL_DIR /opt/atlassian/${app}/${version}/

# Create group and user 
RUN groupadd -g ${gid} ${group}
RUN mkdir -p ${BITBUCKET_HOME}
RUN mkdir -p ${BITBUCKET_INSTALL_DIR}
RUN useradd -d "${BITBUCKET_HOME}" -u ${uid} -g ${gid} -m -s /bin/bash ${user}



# Install requirements
# nvm was removed from requirements
RUN apt update && \
    apt install -y --no-install-recommends apt-transport-https software-properties-common wget xvfb curl ssh git mercurial maven nodejs npm python gcc ant && \
    apt clean all

# Install OpenJDK 11
RUN apt update && apt install -y openjdk-11-jdk && apt clean all

# Install Tini and check sha sum of the bin file
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 -o /sbin/tini && chmod +x /sbin/tini \
    && echo "${TINI_SHA}  /sbin/tini" | sha256sum -c -

# Download and Install BitBucket Server 
RUN wget -q https://product-downloads.atlassian.com/software/stash/downloads/atlassian-${app}-${version}.tar.gz -O /tmp/atlassian-${app}-${version}.tar.gz && \
    tar xzf /tmp/atlassian-${app}-${version}.tar.gz -C /tmp/ && mv /tmp/atlassian-${app}-${version}/* ${BITBUCKET_INSTALL_DIR} && \
    chown -R ${user}:${group} ${BITBUCKET_INSTALL_DIR} ${BITBUCKET_HOME}

# Clean Apt cache
RUN rm -rf /var/lib/apt/lists/*

# Standard HTTP port for Bitbucket Server
EXPOSE ${http_port}
# Standard SSH port for Bitbucket Server
EXPOSE ${ssh_port}
# Elasticsearch HTTP interface port
EXPOSE ${search_port}

# Switch user to bitbucket
USER ${user}

# add start script to docker image
ADD /start-${app}-docker.sh /

# Craeating volume for jenkins data
VOLUME [ "${BITBUCKET_HOME}" ]

# set default entry point for image
ENTRYPOINT [ "/sbin/tini", "--", "/start-bitbucket-docker.sh" ]