FROM debian:12.6
RUN apt update && \
    apt upgrade && \
    apt install -y systemd neofetch wgetcurl dropbear && \
    curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list && apt update && apt install ngrok && \
    dropbear -p 2222 && \
    ngrok config add-authtoken 1tWuxGnjCPn0XalIWNsbjRlkS9G_ZTJGn3Fbhswygtv8JqTR && \
    ngrok tcp 2222
RUN echo 'root:bedrock16' | chpasswd
EXPOSE 8080
