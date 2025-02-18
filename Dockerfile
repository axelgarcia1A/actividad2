FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VNC_PASSWORD=password
ENV DISPLAY=:1
ENV RESOLUTION=1920x1080
ENV COLOR_DEPTH=24
ENV USER=agh
# Crea un usuari no root
RUN useradd -m -s /bin/bash agh && \
    echo "agh:${VNC_PASSWORD}" | chpasswd && \
    usermod -aG sudo agh  # Opcional: permetre l'ús de sudo

# Instal·la dependències
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    openssh-server \
    wget \
    git \
    python3 \
    python3-pip \
    python3-venv \
    nano \
    dbus-x11 \
    sudo \
    && apt-get clean

# Instal·la Visual Studio Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
    && install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update \
    && apt-get install -y code

# Configura SSH per a l'usuari agh
RUN mkdir -p /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && echo "AllowUsers agh" >> /etc/ssh/sshd_config \
    && ssh-keygen -A

# Configura VNC per a l'usuari agh
RUN mkdir -p /home/agh/.vnc \
    && echo "$VNC_PASSWORD" | vncpasswd -f > /home/agh/.vnc/passwd \
    && chmod 600 /home/agh/.vnc/passwd \
    && chown -R agh:agh /home/agh/.vnc

# Configura l'entorn per a Visual Studio Code
RUN mkdir -p /home/agh/Desktop && \
    echo "[Desktop Entry]\n\
    Name=Visual Studio Code\n\
    Comment=Code Editing. Redefined.\n\
    Exec=code --no-sandbox --user-data-dir=/home/agh/.vscode\n\
    Icon=/usr/share/code/resources/app/resources/linux/code.png\n\
    Terminal=false\n\
    Type=Application\n\
    Categories=Development;IDE;" > /home/agh/Desktop/vscode.desktop && \
    chmod +x /home/agh/Desktop/vscode.desktop && \
    chown -R agh:agh /home/agh

# Copia l'script d'inici de VNC
COPY xstartup /home/agh/.vnc/xstartup
RUN chmod +x /home/agh/.vnc/xstartup && \
    chown agh:agh /home/agh/.vnc/xstartup

# Instal·la paquets Python
RUN apt-get update && \
    apt-get install -y python3-pip python3-numpy python3-pandas python3-matplotlib

# Obre els ports
EXPOSE 5901 22

# Inicia els serveis
CMD service ssh start && \
    su - agh -c "vncserver :1 -geometry $RESOLUTION -depth $COLOR_DEPTH" && \
    tail -f /dev/null
