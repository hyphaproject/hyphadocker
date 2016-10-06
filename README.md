# hyphadocker
Docker containers for hypha

## run with docker-compose

```sh
git clone https://github.com/hyphaproject/hyphadocker
cd hyphadocker
docker-compose up -d mysql
docker-compose up -d hypha
chromium-browser "http://localhost:8080"
```
