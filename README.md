# Scala, sbt and Node Dockerfile

[Scala](http://www.scala-lang.org), [sbt](http://www.scala-sbt.org), [git](https://git-scm.com/) and yarn

Useful for building in environments like CircleCI v2.


## Base Docker Image ##

* [openjdk:8-jre-alpine](https://hub.docker.com/_/openjdk)


## Installation ##

1. Install [Docker](https://www.docker.com)
2. Pull [automated build](https://hub.docker.com/r/codestar/circleci-scala-sbt-node-git/) from public [Docker Hub Registry](https://hub.docker.com):
3. See [tags](https://hub.docker.com/r/codestar/circleci-scala-sbt-node-git/tags/) for built specific versions (not the latest ones)
```
docker pull codestar/circleci-scala-sbt-node-git
```
Alternatively, you can build an image from Dockerfile:
```
docker build -t circleci-scala-sbt-node-git github.com/codestar/circleci-scala-sbt-node-git
```
Or with specific versions:
```
docker build \
  -t circleci-scala-sbt--nodegit \
  --build-arg SCALA_VERSION=2.12.3 \
  --build-arg SBT_VERSION=0.13.15 \
  --build-arg YARN_VERSION=1.3.2-r0 \
  github.com/code-star/circleci-scala-sbt-node-git
```

## Usage ##

```
docker run -it --rm codestar/circleci-scala-sbt-node /bin/bash
```

### Example .circleci/config.yml:

```
version: 2
jobs:
  build:
    working_directory: ~/my-project
    docker:
      - image: codestar/circleci-scala-sbt-node-git:scala-2.12.2-sbt-0.13.15
    steps:
      - checkout

      - restore_cache:
          keys:
            - my-project-{{ checksum "project/build.sbt" }}-{{ checksum "build.sbt" }}
            - my-project

      - run:
          # TODO: For some reason circleci gets stuck in the shell if we don't add exit to sbt
          command:
            sbt compile test:compile exit

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
          # Changing this to a different key is the only way to remove old dependencies from the cache and/or generate a more up-to-date cache
          key: my-project
          paths:
            - ~/.sbt
            - ~/.iv2/cache
            - ~/.m2

      - run:
          command:
            sbt test exit

      - store_test_results:
          path: target/test-reports
```


## Contribution policy ##

Contributions via GitHub pull requests are gladly accepted from their original author. Along with any pull requests, please state that the contribution is your original work and that you license the work to the project under the project's open source license. Whether or not you state this explicitly, by submitting any copyrighted material via pull request, email, or other means you agree to license the material under the project's open source license and warrant that you have the legal authority to do so.


## License ##

This code is open source software licensed under the [Apache 2.0 License](http://www.apache.org/licenses/LICENSE-2.0.html).

This fork is based on [spikerlabs/scala-sbt](https://github.com/spikerlabs/scala-sbt), [hseeberger/scala-sbt](https://github.com/hseeberger/scala-sbt) and [mhart/alpine-node](https://github.com/mhart/alpine-node)