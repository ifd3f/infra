# Project Ozone 3 is a Minecraft modpack.
FROM debian:stretch-slim AS builder

RUN apt-get update && apt-get install -y curl unzip
WORKDIR /

# The modpack is at https://www.curseforge.com/minecraft/modpacks/project-ozone-3-a-new-way-forward
RUN curl -fL -o po3.zip https://media.forgecdn.net/files/3077/771/PO3+-+3.3.61server.zip
RUN unzip po3.zip -d /out

# Rename the forge jar to something more manageable
RUN mv /out/forge-1.12.2-14.23.5.2854.jar /out/forge.jar 

# Stretch is the last Debian version with JRE 8
FROM debian:stretch-slim AS runner
RUN apt-get update && apt-get install -y openjdk-8-jre 

WORKDIR /srv/mc
COPY --from=builder /out/ ./
RUN echo eula=true > eula.txt

CMD java -Xmx6144M -Xms1024M -jar forge.jar nogui 
