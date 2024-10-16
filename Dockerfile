FROM debian:12.6
RUN apt update && \
    apt upgrade && \
    apt install -y systemd neofetch wget curl dropbear
RUN echo 'root:bedrock16' | chpasswd
EXPOSE 8080
