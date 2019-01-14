#TUSD Python 3 Docker

This is a custom baked tus image (https://tus.io)

It includes python3 so that you can add custom hooks to using python. IE a JWT Validation hook.

Additionally it installs nginx and exposes 8888. The nginx serves ONLY to disallow GET requests to the /files/ endpoint as it's a debug endpoint in tus that cannot be disabled if you wish to allow file download in a different way.

##Env Vars
S3_ENDPOINT = If you have a non standard s3 endpoint this will be the url that gets passed to the cli arg, omit to use standard s3 endpoint (Useful with minio)

S3_BUCKET = The s3 bucket to use, gets passed to the cli arg

JWT_SECRET = Only used if you use it in a file (i.e. hook) you provide
JWT_AUD = Only used if you use it in a file (i.e. hook) you provide

AWS_ACCESS_KEY_ID = S3 access key
AWS_SECRET_ACCESS_KEY = S3 secret
AWS_REGION = S3 region

##Hooks
put hooks in /srv/tusd-hooks they should be python or bash.