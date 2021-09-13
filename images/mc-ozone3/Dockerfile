FROM debian:stretch-slim AS builder

RUN apt-get update && apt-get install -y curl unzip
WORKDIR /
RUN curl -fL -o po3.zip https://media.forgecdn.net/files/3077/771/PO3+-+3.3.61server.zip
RUN unzip po3.zip -d /srv

# Latest one with JRE 8
FROM debian:stretch-slim AS runner
RUN apt-get update && apt-get install -y openjdk-8-jre 

WORKDIR /srv/mc
COPY --from=builder /srv/ ./
RUN echo eula=true > eula.txt

CMD java -Xmx6144M -Xms1024M -jar forge-1.12.2-14.23.5.2854.jar nogui 