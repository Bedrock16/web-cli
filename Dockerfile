FROM debian:latest
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl dropbear wget neofetch shellinabox
RUN echo 'root:bedrock16' | chpasswd
RUN curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && \
    echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && \
    apt-get update && \
    apt-get install -y ngrok
EXPOSE 2222 2223
CMD dropbear -p 2222 & \
    shellinaboxd -p 2223 & \
    ngrok config add-authtoken 2nWmBZpne4A5M8gk7qD8WHDtU7e_4yinEauRBD2n7itnV5e1V && \
    ngrok tcp 2222 && \
    /bin/bash
