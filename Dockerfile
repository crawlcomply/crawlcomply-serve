FROM rustlang/rust:nightly-alpine

RUN apk add --no-cache musl-dev postgresql16-dev

WORKDIR /src
COPY . .

RUN cargo build

ENTRYPOINT ["cargo", "run"]
