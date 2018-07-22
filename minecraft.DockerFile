FROM ubuntu:latest

# requires software-properties-common package to use ppas
RUN apt-get update -y
RUN apt-get install software-properties-common -y
RUN apt-get update -y
RUN apt-add-repository ppa:webupd8team/java
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install oracle-java8-installer -y

RUN mkdir minecraft
RUN useradd -r -U minecraft
RUN chown -R minecraft:minecraft /minecraft && chmod -R 700 /minecraft
WORKDIR /minecraft
USER minecraft
ADD --chown=minecraft:minecraft minecraft.server.properties server.properties
ADD --chown=minecraft:minecraft whitelist.json whitelist.json

# Accept the end-user license agreement
RUN echo "eula=true" > eula.txt

# Download the server jar
# You can find the latest version at the following site
# https://minecraft.net/en-us/download/server
RUN wget https://launcher.mojang.com/mc/game/1.12.2/server/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar

EXPOSE 9999/tcp

CMD java -Xmx1024M -Xms1024M -jar server.jar nogui