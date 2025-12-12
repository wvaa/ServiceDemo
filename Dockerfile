FROM jenkins/jenkins:lts

USER root

# Instalar dependencias y Docker CLI
RUN apt-get update && apt-get install -y ca-certificates curl gnupg lsb-release && \
    mkdir -p /usr/share/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y docker-ce-cli

# --- ESTA ES LA PARTE CLAVE PARA LOS PERMISOS ---
# Creamos un grupo docker (si no existe) y añadimos al usuario jenkins
RUN groupadd -g 999 docker || true && \
    usermod -aG docker jenkins

USER jenkins