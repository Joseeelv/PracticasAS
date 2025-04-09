FROM debian:latest

# Instala OpenSSH Server
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Crea el usuario
RUN useradd -m user

# Creamos el directorio .ssh y añadimos la clave pública
RUN mkdir -p /home/user/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtvo+rxnP9PaY/+yfU/u61SkNJNushpsS8CTEDsjrYLKLSnqordhn77WFEhyFOP9NEMANibbZSrVfgIFYtq9Ngef0f5nJbvBPtr1dOPnbY+AiUFjZAZTbOSVQXodZdDu5b1rRoalHLDdkMN3Pxhn3SD+YAz14L5N0efBBtL1Df4Rgk+y88RUOh3uAvyTeFIzzAj6DCLHPGzLtJ/6qnSC+PrSXIPZaFNHuN2VE8/CW42ydhOdVHii9K0VemTMWdH0d+Yw0X/4ZsBG72llVVJqBIedTX+SHrG+pJqOlC5jNaioG7dLw2d+H+P+qh0WORcUjKrD9rV5sBnzB9/w9ZNEqUqroi4r18LAVvzjAUvF4qxc7NTk1/OxmvKsYbID+4c6cM6gK03fLIz5db8ejknxGACvBwpjEW679brPZ3LNYHDERS0/RH0YEmEjuz7HYG1RcFs0IFQNutmJY2fJp7A1+IXH0vrnuM5C7PqHagbw4Lzw5teORsai1qRce3PLxP0dGsdNYZ5p52M58MXovMv70MPD3RAmfylkGWgzDRnHzMRUjSKa9zcBHSUbGvHqxvaPjw0ChI33ZbcdVZBps/omluE0I8C6Q2YupfrryXHFE/VIwmGAccRvIsKIPTfW255auRnSTT0NLfg0TE0ia9OLCYxTgvhAv0nszF0WM+XkyTBw== pablo@Pablo" > /home/user/.ssh/authorized_keys && \
    chown -R user:user /home/user/.ssh && \
    chmod 700 /home/user/.ssh && \
    chmod 600 /home/user/.ssh/authorized_keys

# Configura el SSHD para permitir acceso del usuario
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    echo "AllowUsers user" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config && \
    echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config

# Generar claves del host SSH
RUN ssh-keygen -A

# Expone el puerto SSH
EXPOSE 22

# Comando por defecto
CMD ["/usr/sbin/sshd", "-D"]
