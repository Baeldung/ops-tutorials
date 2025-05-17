ARG GOLANG_VER=1.8
FROM golang:${GOLANG_VER} as builder
WORKDIR /go/src/app
COPY . .
RUN go-wrapper download 
RUN go-wrapper install

FROM scratch
COPY --from=builder /go/bin/app /app
CMD ["/app"]
