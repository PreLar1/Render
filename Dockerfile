# Use official Java 17 image (SheepIt requirement)
FROM eclipse-temurin:17-jdk-jammy

# Install required tools and Blender dependencies
RUN apt-get update && \
    apt-get install -y wget lshw procps curl \
    libx11-6 libgl1 libxrender1 libxi6 libxxf86vm1 libglu1-mesa \
    libxkbcommon0 libxext6 libsm6 && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Download latest SheepIt client with fallback
RUN wget -O sheepit-client.jar "https://www.sheepit-renderfarm.com/media/applet/latest.php?file=client" || \
    wget -O sheepit-client.jar "https://www.sheepit-renderfarm.com/media/applet/client-latest.php"

# Download SLF4J NOP provider to suppress warnings
RUN wget -O slf4j-nop.jar "https://repo1.maven.org/maven2/org/slf4j/slf4j-nop/2.0.16/slf4j-nop-2.0.16.jar" && \
    chmod 644 slf4j-nop.jar

# Copy configuration files
COPY start.sh .
COPY client.properties .

# Set permissions and create cache directory
RUN chmod +x start.sh && \
    mkdir /cache && chmod 777 /cache

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD pgrep java || exit 1

# Start the client
CMD ["./start.sh"]