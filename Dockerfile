FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    rsync \
    openssh-server \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    supervisor \
    jq \
    tmux \
    tzdata \
    ca-certificates \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd /root/.ssh && chmod 700 /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Antigravity CLI Installation from official Google bootstrapper
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- -d /usr/local/bin && \
    chmod +x /usr/local/bin/agy

RUN mkdir -p /opt/hermes && \
    git clone https://github.com/NousResearch/Hermes-Agent.git /opt/hermes/hermes-agent || true

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 9119 8642

ENTRYPOINT ["/entrypoint.sh"]
