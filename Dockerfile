FROM debian:latest
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl dropbear wget neofetch
CMD ["/bin/bash"]
RUN echo 'root:bedrock16' | chpasswd
EXPOSE 8080
