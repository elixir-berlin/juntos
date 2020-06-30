# Juntos

> Build communities with people who share your interests.




[![](https://github.com/elixir-berlin/juntos/workflows/Unit%20Test/badge.svg)](https://github.com/elixir-berlin/juntos/actions?query=workflow%3A%22Unit+Test%22+branch%3Amaster) | 
[![](https://github.com/elixir-berlin/juntos/workflows/Code%20Quality/badge.svg)](https://github.com/elixir-berlin/juntos/actions?query=workflow%3A%22Code+Quality%22+branch%3Amaster) | 
 [![codecov](https://codecov.io/gh/elixir-berlin/juntos/branch/master/graph/badge.svg)](https://codecov.io/gh/elixir-berlin/juntos)



## Description

TODO: Describe goals of the project


## Architecture

Web: [Phoenix Framework]() & [Phoenix LiveView]()



## Development

For development, we recommend to use [docker-compose](https://docs.docker.com/compose/).

First run `docker-compose up --build` and wait until containers are up.
Juntos is reachable at [http://localhost:4000/](http://localhost:4000/)

In case you want to running it as a single docker image:

1) Build the combo docker image with

```shell
docker build -t juntos:dev .
```

2) Start container:

```shell
docker run --name juntos-dev -e PORT=3030 -p 3030:3030 -e DATABASE_URL="postgres://postgres:postgres@<YOUR LOCAL IP>:5432/postgres" juntos:dev
# eg.
docker run --name juntos-dev -e PORT=3030 -p 3030:3030 -e DATABASE_URL="postgres://postgres:postgres@192.168.0.12:5432/postgres" juntos:dev
```

3) Stop container

```shell
docker stop juntos-dev && docker container rm juntos-dev
```

Running postgres within a docker image:

```shell
docker run --rm --name pg-docker -d -p 5432:5432 postgres:9.6-alpine
```

## Deployment

TODO: setup containerised deployment


## License
Released under the [MIT License](./LICENSE).
TODO: add license file


[Phoenix Framework]: https://www.phoenixframework.org
[Phoenix LiveView]: https://github.com/phoenixframework/phoenix_live_view

