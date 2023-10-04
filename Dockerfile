FROM alpine:edge

# Install packages & Update
RUN apk add --no-cache --update rsync openssh-client openssl && \
    rm -rf /var/cache/apk/*

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
