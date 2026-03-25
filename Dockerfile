# ---------- Build ----------
FROM eclipse-temurin:21-jdk AS builder

WORKDIR /app

# Installer git (important pour ton plugin)
RUN apt-get update && apt-get install -y git

# Cloner le projet
RUN git clone https://github.com/MathiasVadot/sensor-data-bridge.git .

# Rendre gradlew exécutable
RUN chmod +x gradlew

# Supprimer le plugin git-version (qui casse sans .git)
RUN sed -i '/com.palantir.git-version/d' sensor-data-bridge/build.gradle

# Build du bon module
RUN ./gradlew :sensor-data-bridge:installDist -x test --no-daemon


# ---------- Runtime ----------
FROM eclipse-temurin:21-jre

WORKDIR /app

# Copier le build
COPY --from=builder /app/sensor-data-bridge/build/install/sensor-data-bridge /app

ENTRYPOINT ["bin/sensor-data-bridge"]
