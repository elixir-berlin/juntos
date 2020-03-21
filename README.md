# junto

> Build communities with people who share your interests.


## Description

TODO: Describe goals of the project


## Architecture

API: [Phoenix Framework]() & [Absinthe GraphQL]()

FE: [Vue.js]() [Vuex]() & [NUXTJS]()


## Development

For development, we recommend to use [docker-compose](https://docs.docker.com/compose/).

First run `docker-compose up --build` and wait until containers are up.
The frontend is accessible using [http://localhost:3030/](http://localhost:3030/) and the api is reachable at [http://localhost:3030/api/](http://localhost:3030/api/)

In case you want to running it as a single docker image:

1) Build the combo docker image with

```shell
docker build -t junto:dev .
```

2) Start container:

```shell
docker run --name junto-dev -e PORT=3030 -p 3030:3030 -e DATABASE_URL="postgres://postgres:postgres@<YOUR LOCAL IP>:5432/postgres" junto:dev
# eg.
docker run --name junto-dev -e PORT=3030 -p 3030:3030 -e DATABASE_URL="postgres://postgres:postgres@192.168.0.12:5432/postgres" junto:dev
```

3) Stop container

```shell
docker stop junto-dev && docker container rm junto-dev
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
[Absinthe GraphQL]: https://github.com/absinthe-graphql/absinthe
[Vue.js]: https://vuejs.org
[Vuex]: https://vuex.vuejs.org
[NUXTJS]: https://nuxtjs.org
