# Huly Docker

## Requirements

- Docker
- Docker Compose
- Git

## Setup

### Clone the Repository

> You need to clone the v2 branch, since the main branch is not the latest stable version.  
> The repository will be cleaned up soon!

> Replace `${HULY_DIR}` with your desired path.

```bash
sudo mkdir -p ${HULY_DIR} \
  && cd ${HULY_DIR} \
  && git clone -b v2 https://github.com/dreamboat-dev/huly-project .
```

### Create Volume Directories

Either create them using the provided script:

> Ensure the environment variable `STORAGE_BASE_PATH` is set!

```bash
sudo ./directory-creation.sh
```

Or create them manually:

> Replace `${STORAGE_BASE_PATH}` with your desired base path.

```bash
mkdir -p ${STORAGE_BASE_PATH} \
  && mkdir -p ${STORAGE_BASE_PATH}/elastic \
  && mkdir -p ${STORAGE_BASE_PATH}/mongodb \
  && mkdir -p ${STORAGE_BASE_PATH}/minio
```

Now you need to set the permissions for files accessed by Elasticsearch:

> Replace ${ELASTICSEARCH_YML} with the path to your `elasticsearch.yml` file.

```bash
sudo chown -R 0:0 ${STORAGE_BASE_PATH}/elastic \
  && sudo chown -R 0:0 ${ELASTICSEARCH_YML}
```

### Start the Services

Now you can start the services using Docker Compose:

```bash
sudo docker compose -f ${HULY_DIR}$/docker-compose.yml up -d
```

### Access the Web Interface

Open your web browser and navigate to `${YOUR_HULY_URL}`:`${HTTP_PORT}`.  
`${HTTP_PORT}` is set in `docker/nginx.compose.yml`.