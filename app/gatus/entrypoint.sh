#!/usr/bin/env sh
set -eu

CONFIG_DIR="/app/config"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"

mkdir -p "${CONFIG_DIR}"

if [ -z "${GATUS_CONFIG_SSM_PARAMETER:-}" ]; then
  echo "ERROR: GATUS_CONFIG_SSM_PARAMETER is not set"
  exit 1
fi

if [ -z "${AWS_REGION:-}" ]; then
  echo "ERROR: AWS_REGION is not set"
  exit 1
fi

echo "Fetching Gatus config from SSM parameter: ${GATUS_CONFIG_SSM_PARAMETER}"

aws ssm get-parameter \
  --name "${GATUS_CONFIG_SSM_PARAMETER}" \
  --with-decryption \
  --region "${AWS_REGION}" \
  --query 'Parameter.Value' \
  --output text > "${CONFIG_FILE}"

echo "Config written to ${CONFIG_FILE}"
echo "Starting Gatus on port ${GATUS_PORT:-8080}"

exec /usr/local/bin/gatus --config-path "${CONFIG_FILE}"
