#
# Scala and sbt Dockerfile
#
# https://github.com/code-star/circleci-scala-sbt-git (based on https://github.com/spikerlabs/scala-sbt)
#

# Pull base image
FROM  openjdk:8-jre-alpine

ARG SCALA_VERSION
ARG SBT_VERSION
ARG GIT_VERSION

ENV SCALA_VERSION ${SCALA_VERSION:-2.12.2}
ENV SBT_VERSION ${SBT_VERSION:-0.13.15}
ENV GIT_VERSION ${GIT_VERSION:-2.13.2}

RUN \
  echo "scala $SCALA_VERSION sbt $SBT_VERSION git $GIT_VERSION" && \
  mkdir -p /usr/lib/jvm/java-1.8-openjdk/jre && \
  touch /usr/lib/jvm/java-1.8-openjdk/jre/release && \
  apk add --no-cache bash && \
  apk add --no-cache curl && \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/local && \
  ln -s /usr/local/scala-$SCALA_VERSION/bin/* /usr/local/bin/ && \
  scala -version && \
  scalac -version

RUN \
  curl -fsL http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz | tar xfz - -C /usr/local && \
  $(mv /usr/local/sbt-launcher-packaging-$SBT_VERSION /usr/local/sbt || true) \
  ln -s /usr/local/sbt/bin/* /usr/local/bin/ && \
  sbt sbt-version

RUN \
  apk add --no-cache git=${GIT_VERSION}-r0
