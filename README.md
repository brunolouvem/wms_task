# WmsTask

## Development

#### Requirements
- `Docker`
- `docker-compose`
- `make` (optional)

#### Up environment
```sh
make up 
# or
docker-compose up
```
#### Down environment
```sh
make down
# or
docker-compose down
```
#### Accessing container shell
```sh
make dev_shell
# or
docker exec -it wms_tasks bash
```
#### Accessing container shell
```sh
make test
# or
docker exec -it wms_tasks bash -c "mix test"
```

## Production simulation

To simulate production in your development environment, you can use `make build_prod` and `make run_prod` with postgres container still up.
#### Requirements
- `Docker` (only for build)


#### Build

```bash
docker buid . -t wms_task:latest
# or
make build_prod
```

#### Running Simulation

Start development containers or provide a database connection.

```sh
docker-composer up -d
```

Stop development elixir container if it is running to release `4000` port.

```sh
docker-composer stop elixir
```

Run make command to start production simulation.
```sh
make run_prod
```

After that access `http://localhost:4000/orders/live` to get a live order list or `http://localhost:4000/orders` to get a database order list.