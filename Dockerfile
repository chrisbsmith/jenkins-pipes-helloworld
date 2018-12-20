FROM golang:1.11-alpine
COPY hello-world.go /go/src/hello-world/hello-world.go
RUN go build -tags netgo

FROM scratch
COPY --from=0 /go/src/hello-world/hello-world /hello-world
EXPOSE 8080 8888
USER 1001
ENTRYPOINT ["/hello-world"]