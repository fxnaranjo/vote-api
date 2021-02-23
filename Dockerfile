FROM golang:latest as builder

WORKDIR /build
ADD . /build/

RUN export GARCH="$(uname -m)" 
RUN if [[ ${GARCH} == "x86_64" ]]; then export GARCH="amd64"; fi
RUN GOOS=linux GOARCH=${GARCH} CGO_ENABLED=0
RUN go build -mod=vendor -o api-server .

FROM scratch

WORKDIR /app
COPY --from=builder /build/api-server /app/api-server

CMD [ "/app/api-server" ]
