FROM fedora:44

# Install packages and clean the cache in the same layer to keep the image small
RUN dnf -y upgrade && \
    dnf -y install openssh-server openssh-clients sudo && \
    dnf clean all

# Generate SSH host keys (normally done by systemd on first boot)
RUN ssh-keygen -A

# Publish with: docker run -p 8022:22 ...
EXPOSE 22

# Run sshd in the foreground, logging to stderr
CMD ["/usr/sbin/sshd", "-D", "-e"]
