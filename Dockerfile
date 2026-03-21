# ===== Stage 1: build =====
FROM eclipse-temurin:21-jdk AS build

LABEL maintainer="MV"
LABEL org.opencontainers.image.source="https://github.com/MathiasVadot/sensor-data-bridge/"
LABEL org.opencontainers.image.description="Receives sensor data over TTN and forwards it to sensor.community"
LABEL org.opencontainers.image.licenses="MIT"

# Installer outils nécessaires pour le build
RUN apt-get update && apt-get install -y bash unzip curl git && rm -rf /var/lib/apt/lists/*

# Copier projet
WORKDIR /opt/sensor-data-bridge
COPY . .

# Rendre gradlew exécutable
RUN chmod +x gradlew

# Build du jar sans tests et sans dépendre de Git
RUN ./gradlew build -x test --no-daemon -Pgit.failOnNoGitDirectory=false

# ===== Stage 2: runtime =====
FROM eclipse-temurin:21-jre

WORKDIR /opt/sensor-data-bridge

# Copier uniquement le jar depuis l'étape build
COPY --from=build /opt/sensor-data-bridge/build/libs/sensor-data-bridge.jar .

# Exposer le port
EXPOSE 8080

# Entrypoint
ENTRYPOINT ["java","-jar","sensor-data-bridge.jar"]
