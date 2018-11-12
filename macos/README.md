# Introduction
This collection of scripts is designed to provide pihole as a local container. The overall goal is to get the advantage of pihole while traveling without the use of a vpn.

MacOS app files are bundled with the shell scripts to allow for a user friendly interface to running the provided scripts.

This uses the offical pihole container on the offical site: https://hub.docker.com/r/pihole/pihole/

The basics of this were found here: https://www.reddit.com/r/pihole/comments/9k6lzp/run_pihole_on_macos_mojave_with_docker/

**This has only been tested on MacOS 10.14**

## Installation

1. git pull this directory to `~/` creating `~/pihole`
1. Unzip the zip files contained here to `~/pihole`
1. Launch `Start PiHole.app`

## Scripts

### reset_dns.sh && Reset DNS.zip/scpt

This provides a simple function to reset the wireless adapter to the router's provided dns servers.

### start_pihole.sh && Start PiHole.zip/scpt

This performs all of the necessary steps to start pihole as a container

Web Console: `127.0.0.1/admin/`
Password: `~/pihole/wordoftheday.txt` (Randomly generated on container launch)

## Troubleshooting & Error handling

Without an internet connection these scripts will fail. The applescripts perform an internet check function reaching out to Cloudflare dns (1.1.1.1). This check will be performed 10 times before prompting to continue.