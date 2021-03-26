# petemcw/docker-chia-network

[Chia Network](https://www.chia.net/) is a new blockchain and smart transaction platform that is easier to use, more efficient, decentralized, and secure. Chia Network was founded by [Bram Cohen](https://www.linkedin.com/in/cohenbram/), the inventor of the BitTorrent network.

![](https://www.chia.net/android-chrome-384x384.png)

## Usage

```bash
docker run -d --name="chia" \
    -v <path to data>:/farm/plots \
    -v <path to data>:/farm/tmp \
    -p 8444:8444 \
    -p 8555:8555 \
    -e TZ=<timezone> \
    -e KEYS="24 word mnemonic phrase" \
    ghcr.io/petemcw/chia-network:latest
```

## Example Commands

For complete reference, visit the [official CLI documentation](https://github.com/Chia-Network/chia-blockchain/wiki/CLI-Commands-Reference) pages.

### Check Status

`docker exec -it chia venv/bin/chia show -s -c`

### Create a Plot

Create a single, standard `k-32` plot using an 8GiB memory buffer, 2 threads, and a bucket size of 32.

`docker exec -it chia venv/bin/chia plots create -k 32 -n 1 -b 8000 -r 2 -u 32 -t /farm/tmp -d /farm/plots`
