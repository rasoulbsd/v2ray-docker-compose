# V2Ray Docker Compose

This repository contains V2Ray-based solutions for bypassing firewalls in highly restricted networks where direct access to upstream servers (servers with free internet access) is unavailable.

## Table of contents

  * [Server Solutions](#server-solutions)
    * [V2Ray Upsream and Relay Servers](#v2ray-upsream-and-relay-servers)
    * [V2Ray Behind a CDN Service](#v2ray-behind-a-cdn-service)
    * [V2Ray as Relay for Outline](#v2ray-as-relay-for-outline)
  * [Client Applications](#client-applications)
    * [Shadowsocks Protocol](#shadowsocks-protocol)
    * [VMess Protocol](#vmess-protocol)
    * [HTTP and SOCKS Protocols](#http-and-socks-protocols)
  * [More](#more)

## Server Solutions

### V2Ray Upsream and Relay Servers

This solution is stable and supports Shadowsocks and VMess protocols by default.

You will need two types of servers:

* **Upstream Server**: A server with access to the free internet, likely located in a foreign data center.
* **Relay Server**: A server that can connect to the upstream server and is accessible to users, likely located in the same region as the users.

```
(Users) <-> [ Relay Server ] <-> [ Upstream Server ] <-> (Internet)
```

**Step 1: Setup Upstream Server**

1. Install Docker and Docker-compose.
1. Copy the `v2ray-upstream-server` and the `utils` directories into the upstream server.
1. Run ```./utils/bbr.sh``` to speed up server network.
1. Run ```cat /proc/sys/kernel/random/uuid``` in your terminal to generate a UUID.
1. Replace `<UPSTREAM-UUID>` in `v2ray/config/config.json` with the generated UUID.
1. Run `docker-compose up -d`.

**Step 2: Setup Relay Server**

1. Install Docker and Docker-compose.
1. Copy the `v2ray-relay-server` and the `utils` directories into the relay server.
1. Run ```./utils/bbr.sh``` to speed up server network.
1. Replace the following variables in `v2ray/config/config.json` with appropriate values.
    * `<SHADOWSOCKS-PASSWORD>`: A password for Shadowsocks users like `FR33DoM`.
    * `<BRIDGE-UUID>`: A new UUID for relay server (Run ```cat /proc/sys/kernel/random/uuid```).
    * `<UPSTREAM-IP>`: The upstream server IP address (like `13.13.13.13`).
    * `<UPSTREAM-UUID>`: The upstream server UUID from the previous step.
1. Run `docker-compose up -d`.
1. Run `./clients.py` to generate client configurations and links.

### V2Ray Behind a CDN Service

This solution is recommended only if you don't have relay server to implement other solutions.

In this solution, you need one server (upstream) and a domain/subdomain added to a CDN service.

* Upstream Server: A server that has free access to the Internet.
* CDN Service: A Content delivery network like [Cloudflare](//cloudflare.com), [ArvanCloud](//arvancloud.ir) or [DerakCloud](//derak.cloud).

```
(Users) <-> [ CDN Service ] <-> [ Upstream Server ] <-> (Internet)
```

This solution provides VMESS over Websockets + TLS + CDN.
[Read more...](https://guide.v2fly.org/en_US/advanced/wss_and_web.html)

Follow these steps to set up V2Ray + Caddy (Web server) + CDN:

1. On your CDN, create an `A` record pointing to your server IP with the proxy option turned off.
1. Install Docker and Docker-compose on your server.
1. Copy the `v2ray-caddy-cdn` and the `utils` directories into the server.
1. Run ```./utils/bbr.sh``` to speed up server network.
1. Run ```cat /proc/sys/kernel/random/uuid``` to generate a UUID.
1. Replace `<UPSTREAM-UUID>` in `v2ray/config/config.json` with the generated UUID.
1. Replace `<EXAMPLE.COM>` in `caddy/Caddyfile` with your domain/subdomain.
1. Run `docker-compose up -d`.
1. Visit your domain/subdomain in your web browser.
   Wait until the [homepage](https://github.com/miladrahimi/v2ray-docker-compose/blob/master/v2ray-caddy-cdn/caddy/web/index.html) is loaded.
1. (Optional) In your CDN, turn the proxy option on for the record.
1. Run `./vmess.py` to generate client configuration (link).

If you prefer NGINX as the web server, read [V2RAY_NGINX_CDN](docs/V2RAY_NGINX_CDN.md) instead.

Some CDN services don't offer unlimited traffic for free plans.
Please check [CDN Free Plans](https://github.com/miladrahimi/v2ray-docker-compose/discussions/89).

You don't need to turn the cloud (proxy) on in your CDN (step 10) when the Internet is not blocked.
When it's off, clients connect to the server directly and CDN services also don't charge you any fee.

### V2Ray as Relay for Outline

This **highly recommended** solution is stable and easy to set up.
Using the Outline Manager app, you can create and manage multiple users and track their traffic.
It supports Shadowsocks protocol and offers the easy-to-use Outline client app.

Read more: [Outline Bridge Server](https://github.com/miladrahimi/outline-bridge-server)

## Client Applications

### Shadowsocks Protocol

This is the list of recommended applications to use the Shadowsocks protocol:

* [Outline](https://getoutline.org/get-started/#step-3) for all platforms
* [ShadowsocksX-NG](https://github.com/shadowsocks/ShadowsocksX-NG/releases) for macOS
* [shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev) for Linux
* [shadowsocks-windows](https://github.com/shadowsocks/shadowsocks-windows/releases)
* [shadowsocks-android](https://github.com/shadowsocks/shadowsocks-android/releases)
* [ShadowLink](https://apps.apple.com/us/app/shadowlink-shadowsocks-vpn/id1439686518) for iOS

### VMess Protocol

This is the list of recommended applications to use the VMess and other protocols:

* [Nekoray](https://github.com/MatsuriDayo/nekoray/releases) for macOS, Windows, and Linux
* [FoXray](https://foxray.org/#download) for macOS, iOS, and Android
* [V2Box](https://apps.apple.com/us/app/v2box-v2ray-client/id6446814690) for macOS and iOS
* [V2Box](https://play.google.com/store/apps/details?id=dev.hexasoftware.v2box) for Android
* [ShadowLink](https://apps.apple.com/us/app/shadowlink-shadowsocks-vpn/id1439686518) for iOS
* [v2rayNG](https://github.com/2dust/v2rayNG) for Android
* [v2rayN](https://github.com/2dust/v2rayN/releases) for Windows

### HTTP and SOCKS Protocols

Moved here: [HTTP_SOCKS](docs/HTTP_SOCKS.md)

## More

* [Outline Bridge Server](https://github.com/miladrahimi/outline-bridge-server)
* [V2Ray Config Examples](https://github.com/xesina/v2ray-config-examples)
* [NekoRay Installer (for Linux)](https://github.com/ohmydevops/nekoray-installer)
* [V2Ray Ansible](https://github.com/ohmydevops/v2ray-ansible)
* [V2Fly (V2Ray)](https://www.v2fly.org)
* [V2Fly (V2Ray) configurations](https://guide.v2fly.org)
