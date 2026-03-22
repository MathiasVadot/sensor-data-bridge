# ---------- Stage 1: Build ----------
FROM eclipse-temurin:21-jdk-jammy AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y git

# Clone repo
RUN git clone https://github.com/MathiasVadot/sensor-data-bridge.git .

RUN chmod +x ./gradlew

# Supprimer le plugin git-version
RUN sed -i '/com.palantir.git-version/d' sensor-data-bridge/sensor-data-bridge/build.gradle

# ⚠️ Build du BON module
RUN ./gradlew :sensor-data-bridge:installDist -x test --no-daemon

# ---------- Stage 2: Runtime ----------
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

COPY --from=builder /app/sensor-data-bridge/sensor-data-bridge/build/install/sensor-data-bridge /app/sensor-data-bridge

WORKDIR /app/sensor-data-bridge

ENTRYPOINT ["./bin/sensor-data-bridge"]
