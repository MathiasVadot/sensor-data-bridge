FROM eclipse-temurin:21.0.8_9-jre-alpine

LABEL maintainer="MV m@thias.eu"
LABEL org.opencontainers.image.source="https://github.com/MathiasVadot/sensor-data-bridge/"
LABEL org.opencontainers.image.description="Receives sensor data over TTN and forwards it to sensor.community"
LABEL org.opencontainers.image.licenses="MIT"

ADD sensor-data-bridge/build/distributions/sensor-data-bridge.tar /opt/

RUN chmod +x /opt/sensor-data-bridge/bin/sensor-data-bridge

EXPOSE 8080

WORKDIR /opt/sensor-data-bridge
ENTRYPOINT ["/opt/sensor-data-bridge/bin/sensor-data-bridge"]

