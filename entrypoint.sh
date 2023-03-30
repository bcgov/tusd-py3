echo "starting tusd"

ENDARG="-s3-endpoint $S3_ENDPOINT"
if [ -z "$S3_ENDPOINT" ]; then
    ENDARG=""
fi

BUCKETARG="-s3-bucket $S3_BUCKET"
if [ -z "$S3_BUCKET" ]; then
    BUCKETARG=""
fi

tusd --hooks-dir /srv/tusd-hooks $ENDARG $BUCKETARG