# WmsTask

## Development

### Requirements
- `Docker`
- `docker-compose`
- `make` (optional)

### Up environment
```bash
make up 
# or
docker-compose up
```
### Down environment
```bash
make down
# or
docker-compose down
```
### Accessing container shell
```bash
make dev_shell
# or
docker exec -it wms_tasks bash
```
### Accessing container shell
```bash
make test
# or
docker exec -it wms_tasks bash -c "mix test"
```

## Production simulation

To simulate production in your development environment, you can use `make build_prod` and `make run_prod` with postgres container still up.
### Requirements
- `Docker` (only for build)


```bash
docker buid . -t wms_task:latest
# or
make build_prod
```

### Simulation

```bash
docker-composer stop postgres
```

```bash
make run_prod
```