FROM alpine:edge

# Install packages & Update
RUN apk add --no-cache --update rsync openssh-client openssl && \
    rm -rf /var/cache/apk/*

RUN addgroup -S appgroup && adduser -S app -G appgroup

USER app

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
