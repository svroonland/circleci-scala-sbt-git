# Scala and sbt Dockerfile

[Scala](http://www.scala-lang.org), [sbt](http://www.scala-sbt.org) and [git](https://git-scm.com/) container.

Useful for building in environments like CircleCI v2.


## Base Docker Image ##

* [openjdk:8-jre-alpine](https://hub.docker.com/_/openjdk)


## Installation ##

1. Install [Docker](https://www.docker.com)
2. Pull [automated build](https://hub.docker.com/r/codestar/circleci-scala-sbt-git/) from public [Docker Hub Registry](https://hub.docker.com):
3. See [tags](https://hub.docker.com/r/codestar/circleci-scala-sbt-git/tags/) for built specific versions (not the latest ones)
```
docker pull codestar/circleci-scala-sbt-git
```
Alternatively, you can build an image from Dockerfile:
```
docker build -t circleci-scala-sbt-git github.com/codestar/circleci-scala-sbt-git
```
Or with specific versions:
```
docker build \
  -t circleci-scala-sbt-git \
  --build-arg SCALA_VERSION=2.12.2 \
  --build-arg SBT-VERSION=0.13.15 \
  --build-args GIT_VERSION=2.13.2 \
  github.com/codestar/circleci-scala-sbt-git
```

## Usage ##

```
docker run -it --rm spikerlabs/scala-sbt /bin/bash
```

### Example .circleci/config.yml:

```
version: 2
jobs:
  build:
    working_directory: ~/my-project
    docker:
      - image: codestar/circleci-scala-sbt-git:scala-2.12.2-sbt-0.13.15
    steps:
      - checkout

      - restore_cache:
          keys:
            - my-project-{{ checksum "project/build.sbt" }}-{{ checksum "build.sbt" }}
            - my-project

      - run: sbt compile test:compile

      - save_cache:
          key: my-project-{{ checksum "project/build.sbt" }}-{{ checksum "build.sbt" }}
          paths:
            - target/resolution-cache
            - target/streams
            - project/target/resolution-cache
            - project/target/streams
            - ~/.sbt
            - ~/.iv2/cache
            - ~/.m2
      - save_cache:
          # Changing this to a different key is the only way to remove old dependencies from the cache
          key: my-project
          paths:
            - ~/.sbt
            - ~/.iv2/cache
            - ~/.m2

      - run: sbt test

      - store_test_results:
          path: target/test-reports
```


## Contribution policy ##

Contributions via GitHub pull requests are gladly accepted from their original author. Along with any pull requests, please state that the contribution is your original work and that you license the work to the project under the project's open source license. Whether or not you state this explicitly, by submitting any copyrighted material via pull request, email, or other means you agree to license the material under the project's open source license and warrant that you have the legal authority to do so.


## License ##

This code is open source software licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

This fork is based on [spikerlabs/scala-sbt](https://github.com/spikerlabs/scala-sbt) and [hseeberger/scala-sbt](https://github.com/hseeberger/scala-sbt).
