#!/bin/bash
set -e  # Exit on error

# Validate required credentials before doing anything else
if [ -z "$SHEEPIT_USERNAME" ] || [ -z "$SHEEPIT_PASSWORD" ]; then
  echo "Error: SHEEPIT_USERNAME and/or SHEEPIT_PASSWORD are not set."
  echo "Set them under Railway > your service > Variables."
  exit 1
fi

# Allow cores/memory to be overridden without touching the Dockerfile
CORES="${SHEEPIT_CORES:-24}"
MEMORY="${SHEEPIT_MEMORY:-24G}"

# Log environment for debugging
echo "Starting SheepIt client with USERNAME=$SHEEPIT_USERNAME (cores=$CORES, memory=$MEMORY)"

# Check disk space in /cache
echo "Checking disk space in /cache..."
df -h /cache || echo "Error: Failed to check disk space"

# Check permissions in /cache
echo "Checking permissions in /cache..."
ls -ld /cache || echo "Error: Failed to check permissions"

# Check connectivity to SheepIt server
echo "Testing connectivity to SheepIt server..."
curl -s --connect-timeout 10 https://client.sheepit-renderfarm.com || {
  echo "Error: Cannot connect to SheepIt server. Check network or server status."
  exit 1
}

# Retry loop to handle connection failures
for attempt in {1..3}; do
  echo "Attempt $attempt to start SheepIt client..."
  java -cp "sheepit-client.jar:slf4j-nop.jar" -jar sheepit-client.jar \
    -login "$SHEEPIT_USERNAME" \
    -password "$SHEEPIT_PASSWORD" \
    -cores "$CORES" \
    -memory "$MEMORY" \
    -cache-dir /cache \
    -ui text \
    -compute-method CPU \
    -config client.properties \
    --verbose \
    --log-stdout 2> error.log
  if [ $? -eq 0 ]; then
    echo "Client started successfully."
    break
  else
    echo "Client failed to start. See error.log for details."
    cat error.log
    echo "Retrying in 10 seconds..."
    sleep 10
  fi
done

# If all attempts fail, exit with error
echo "Failed to start SheepIt client after $attempt attempts."
cat error.log
exit 1