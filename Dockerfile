# Use a specific Debian version (e.g., bullseye) instead of 'latest' for reproducibility
FROM debian:bullseye

# Combine apt-get operations to reduce layers and improve efficiency
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        curl \
        dropbear \
        wget \
        neofetch \
        shellinabox \
    && rm -rf /var/lib/apt/lists/* # Clean up apt cache

# Set the root password (consider using environment variables for sensitive data in production)
RUN echo 'root:bedrock16' | chpasswd

# Install ngrok with improved formatting and error handling
RUN curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
    && echo "deb https://ngrok-agent.s3.amazonaws.com bullseye main" | tee /etc/apt/sources.list.d/ngrok.list \
    && apt-get update \
    && apt-get install -y ngrok \
    && rm -rf /var/lib/apt/lists/* # Clean up apt cache after ngrok installation

# Expose ports (consider if both 2222 and 2223 need to be exposed)
EXPOSE 2222 2223

# Use a shell script for the CMD to handle multiple processes with proper supervision
# Consider using a process manager like supervisord for production environments
CMD ["/bin/sh", "-c", "\
    dropbear -p 2222 & \
    shellinaboxd -b -p 2223 & \
    ngrok config add-authtoken 2vmGcApVa52erz7M2T4lBzN4qHw_8JFDJkzgxdTTd4q5ye3i && \
    ngrok tcp 2222 && \
    /bin/bash"]
