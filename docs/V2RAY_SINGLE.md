# V2Ray Docker Compose for Single Server

V2Ray is a proxy tool equipped with advanced functionalities and supports protocols such as Shadowsocks, VMess, and Trojan.

Currently, [V2Fly](https://www.v2fly.org/) maintains V2Ray.

## Setup

The easiest way to get V2Ray up and running is by using Docker and Docker Compose.
To install V2ray using Docker Compose you can follow the steps below.

1. Install Docker and Docker-compose ([Official Documanetation](https://docs.docker.com/engine/install/#supported-platforms)).
1. Run `git clone https://github.com/miladrahimi/v2ray-docker-compose.git` to download this repository.
1. Run `cd v2ray-docker-compose/v2ray-single-server` to change the directory.
1. Replace `<UPSTREAM-PASSWORD>` in `v2ray.json` with a Shadowsocks password like `FR33DoM`.
1. Run `docker compose up -d`.
1. Run `./clients.py` to generate client configurations and links.
1. (Optional) Run `./../utils/bbr.sh` to setup BBR and speed up the server network.

Currently, this setup supports only the Shadowsocks protocol.
You can modify the configuration file to add other protocols, as detailed in the official documentation.

## Advanced Solutions

Using V2Ray on a single server might not always be efficient,
especially in networks with more restrictions where protocols like Shadowsocks directly may not work as expected.
To set up V2Ray effectively in such environments, check the main documentation in this repository for advanced solutions:

[https://github.com/miladrahimi/v2ray-docker-compose](../README.md)
