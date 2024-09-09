if [ -z "$S3_BUCKET" ]; then
  echo "You need to set the S3_BUCKET environment variable."
  exit 1
fi

if [ -z "$POSTGRES_DATABASE" ]; then
  echo "You need to set the POSTGRES_DATABASE environment variable."
  exit 1
fi

if [ -z "$POSTGRES_HOST" ]; then
  # https://docs.docker.com/network/links/#environment-variables
  if [ -n "$POSTGRES_PORT_5432_TCP_ADDR" ]; then
    POSTGRES_HOST=$POSTGRES_PORT_5432_TCP_ADDR
    POSTGRES_PORT=$POSTGRES_PORT_5432_TCP_PORT
  else
    echo "You need to set the POSTGRES_HOST environment variable."
    exit 1
  fi
fi

if [ -z "$POSTGRES_USER" ]; then
  echo "You need to set the POSTGRES_USER environment variable."
  exit 1
fi

# Check if POSTGRES_PASSWORD is set, otherwise read from POSTGRES_PASSWORD_FILE
if [ -z "$POSTGRES_PASSWORD" ]; then
  if [ -f "$POSTGRES_PASSWORD_FILE" ]; then
    POSTGRES_PASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
  else
    echo "You need to set the POSTGRES_PASSWORD environment variable or provide POSTGRES_PASSWORD_FILE."
    exit 1
  fi
fi

if [ -z "$S3_ENDPOINT" ]; then
  aws_args=""
else
  aws_args="--endpoint-url $S3_ENDPOINT"
fi

# Check if S3_ACCESS_KEY_ID is set, otherwise read from S3_ACCESS_KEY_ID_FILE
if [ -z "$S3_ACCESS_KEY_ID" ]; then
  if [ -f "$S3_ACCESS_KEY_ID_FILE" ]; then
    S3_ACCESS_KEY_ID=$(cat "$S3_ACCESS_KEY_ID_FILE")
  else
    echo "You need to set the S3_ACCESS_KEY_ID environment variable or provide S3_ACCESS_KEY_ID_FILE."
    exit 1
  fi
fi

# Check if S3_SECRET_ACCESS_KEY is set, otherwise read from S3_SECRET_ACCESS_KEY_FILE
if [ -z "$S3_SECRET_ACCESS_KEY" ]; then
  if [ -f "$S3_SECRET_ACCESS_KEY_FILE" ]; then
    S3_SECRET_ACCESS_KEY=$(cat "$S3_SECRET_ACCESS_KEY_FILE")
  else
    echo "You need to set the S3_SECRET_ACCESS_KEY environment variable or provide S3_SECRET_ACCESS_KEY_FILE."
    exit 1
  fi
fi

export AWS_ACCESS_KEY_ID=$S3_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$S3_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=$S3_REGION
export PGPASSWORD=$POSTGRES_PASSWORD
