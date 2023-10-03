FROM alpine:latest

# Update
RUN apk update

# Install packages
RUN apk add rsync openssh-client openssl

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
