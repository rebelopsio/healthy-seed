FROM golang:alpine AS build
RUN apk update && \
    apk add curl \
            git \
            bash \
            make \
            ca-certificates && \
    rm -rf /var/cache/apk/* \

# TODO: Include migration installation for DB migration
RUN mkdir src/app
WORKDIR /src/app

# copy module files first so that they don't need to be downloaded again if no change
COPY go.* ./
RUN go mod download
RUN go mod verify

# copy source files and build the binary
COPY . .
RUN make build

FROM alpine:latest
RUN apk --no-cache add ca-certificates bash
RUN mkdir -p /var/log/app
WORKDIR /app/
# TODO: Add COPY --from:build to copy necessary files from above
COPY --from=build /src/app/server .
COPY --from=build /src/app/cmd/server/init.sh .
COPY --from=build /src/app/config/*.yml ./config/
RUN ls -la
# TODO: Update ENTRYPOINT later on
ENTRYPOINT ["./init.sh"]