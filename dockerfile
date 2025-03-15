# Use a reliable Ubuntu base image
FROM ubuntu

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install essential packages, including a shell
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    bash \
    adduser \
    && echo "root:root" | chpasswd \
    && adduser --disabled-password --gecos "" azure \
    && echo "azure:azure" | chpasswd \
    && usermod -aG sudo azure \
    && apt-get clean

# Ensure /bin/sh exists and link it to /bin/bash
RUN ln -sf /bin/bash /bin/sh

# Create the "practice" folder in the azure user's home directory
RUN mkdir -p /home/azure/practice && chown -R azure:azure /home/azure/practice

# Switch to azure user
USER azure

# Download and extract the file, and install dependencies
RUN curl -o /home/azure/practice/vsts-agent-linux-x64-4.252.0.tar.gz https://vstsagentpackage.azureedge.net/agent/4.252.0/vsts-agent-linux-x64-4.252.0.tar.gz && \
    tar zxvf /home/azure/practice/vsts-agent-linux-x64-4.252.0.tar.gz -C /home/azure/practice && \
    rm /home/azure/practice/vsts-agent-linux-x64-4.252.0.tar.gz && \
    echo "azure" | sudo -S sudo /home/azure/practice/bin/installdependencies.sh

RUN chown -R azure:azure /home/azure/practice && chmod -R u+rwx /home/azure/practice

# Set the default shell explicitly
CMD ["/bin/bash"]
