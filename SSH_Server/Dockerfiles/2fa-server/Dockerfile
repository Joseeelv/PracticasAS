FROM debian:latest

# Instala OpenSSH Server y Google Authenticator
RUN apt update && \
    apt install -y openssh-server libpam-google-authenticator whois && \
    mkdir /var/run/sshd

# Crear usuario con contraseña
RUN useradd -m user && \
    echo "user:1234" | chpasswd && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configurar Google Authenticator para el usuario
RUN mkdir -p /home/user/.ssh && \
    chown -R user:user /home/user

# Forzar 2FA con Google Authenticator
RUN echo "auth required pam_google_authenticator.so nullok" >> /etc/pam.d/sshd && \
    sed -i 's/^ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^UsePAM no/UsePAM yes/' /etc/ssh/sshd_config && \
    echo "KbdInteractiveAuthentication yes" >> /etc/ssh/sshd_config


# Generar claves del host SSH
RUN ssh-keygen -A

# Exponer puerto SSH
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
