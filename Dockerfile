FROM ubuntu:latest
#COPY . /usr/src/myapp
#WORKDIR /usr/src/myapp
# RUN apt-get install -y openjdk-8-jre
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y curl gnupg git
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" |  tee /etc/apt/sources.list.d/sbt.list
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian /" |  tee /etc/apt/sources.list.d/sbt_old.list
RUN curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y sbt
RUN git clone https://github.com/enoriega/ScienceParseReader.git && cd ScienceParseReader && sbt assembly && echo $PWD && cp target/scala-2.12/ScienceParseReader-assembly-0.1.jar ..
RUN git clone https://github.com/clulab/reach.git && cd reach && git checkout frailty && sbt assembly && cp target/scala-2.12/reach-1.6.3-SNAPSHOT-FAT.jar ..
RUN mkdir txt_files
RUN echo "/usr/bin/java -jar ScienceParseReader-assembly-0.1.jar input txt_files" > run.sh
RUN echo "cd reach && sbt -J-Xmx16g -DpapersDir=/txt_files -DoutDir=/output -DthreadLimit=16  \"runMain org.clulab.reach.RunReachCLI\"" >> run.sh
CMD ["/bin/bash", "run.sh"]
# CMD ["/usr/bin/java", "-cp", "reach-1.6.3-SNAPSHOT-FAT.jar", "-DpapersDir=/txt_files", "-DoutDir=/output", "-DoutputTypes=\[\"arizona\'\]" "-DthreadLimit=16", "org.clulab.reach.RunReachCLI"]

#CMD ["java", "Main"]