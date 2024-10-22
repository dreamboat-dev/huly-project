# Huly - Docker

This is a docker-compose stack for the project management tool "[Huly](https://huly.io/)".  
It includes Nginx Webserver.

<!-- TODO (dreamboat-dev) toc -->

## Installation

### Complete Repository

```bash
git clone https://github.com/dreamboat-dev/huly-project.git
```

### Only `huly` subdirectory

```bash
git clone --no-checkout https://github.com/dreamboat-dev/huly-project.git
cd huly-project
git sparse-checkout init --cone
git sparse-checkout set huly
git checkout
```

## Usage

1. Configure `.env`-File
   - If hostnames have been changed, you have to adjust them in `nginx.conf`
2. Execute `subvolume_creation.sh`
3. `docker compose up -d`