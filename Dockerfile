# Use a specific Debian version for consistency and reproducibility
FROM debian:bullseye

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

# Update the system and install necessary dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        curl \
        wget \
        gnupg \
        build-essential \
        tmux \
        neofetch \
        sudo \
        git \
        cmake \
        pkg-config \
        libwebsockets-dev \
        libjson-c-dev \
        libssl-dev && \
    rm -rf /var/lib/apt/lists/*  # Clean up apt cache to reduce image size

# Install ttyd - web terminal
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make && \
    make install

# Create a non-root user that we'll use for the shell
RUN useradd -m -s /bin/bash termuser && \
    echo 'termuser:bedrock16' | chpasswd && \
    echo 'termuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Create a welcome message
RUN echo -e "#!/bin/bash\n\
echo \"\"\n\
echo \"  ___ ___ ___ ___ ___ ___ ___ ___ ___ \"\n\
echo \" |   |   |   |   |   |   |   |   |   |\"\n\
echo \" | W | E | L | C | O | M | E | ! | ! |\"\n\
echo \" |___|___|___|___|___|___|___|___|___|\"\n\
echo \"\"\n\
echo \"Welcome to the Web Terminal running on Hugging Face Space\"\n\
echo \"You are logged in as user 'termuser' with password 'bedrock16'\"\n\
echo \"Use 'sudo' for root privileges\"\n\
echo \"\"\n\
echo \"Run 'neofetch' to see system information\"\n\
echo \"\"\n\
echo \"By @bedrock16\"\n\
echo \"\"\n" > /home/termuser/welcome.txt

# Set up welcome message to display on login
RUN echo "cat /home/termuser/welcome.txt" >> /home/termuser/.bashrc

# Create a startup script with ttyd
RUN echo '#!/bin/bash\n\
echo "Starting ttyd web terminal on port 7860..."\n\
\n\
# Start ttyd with login shell for termuser\n\
ttyd -p 7860 -t fontSize=18 -t theme={"background":"#000000","foreground":"#ffffff"} su - termuser &\n\
\n\
echo "ttyd started!"\n\
\n\
# Keep the container alive with a periodic log message\n\
while true; do\n\
  echo "Container is alive at $(date)"\n\
  sleep 300\n\
done\n\
' > /start.sh && chmod +x /start.sh

# Expose port 7860
EXPOSE 7860

# Command to start the web terminal
CMD ["/start.sh"]
