# hello_world

The smallest possible image: `busybox` that prints a message and exits. Useful as a first check that Docker builds and runs images.

## Usage

```bash
docker build -t hello-world-busybox .
docker run --rm hello-world-busybox
```

Output:

```text
Hello world from docker
```

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | `FROM busybox`, `CMD echo "Hello world from docker"` |
