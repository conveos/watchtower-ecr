FROM alpine:3.20.3 AS build

# https://github.com/awslabs/amazon-ecr-credential-helper#installing
RUN apk add --no-cache libc6-compat gcc g++ git go \
	&& go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

# Final image has to be alpine, scratch doesn't support our env vars or credentials file
FROM alpine:3.20.3
COPY --from=containrrr/watchtower:latest / /
COPY --from=build /root/go/bin/docker-credential-ecr-login /bin/docker-credential-ecr-login
COPY config.json /config.json

ENTRYPOINT ["/watchtower"]
