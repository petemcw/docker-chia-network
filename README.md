# petemcw/docker-chia-network

[Chia Network](https://www.chia.net/) is a new blockchain and smart transaction platform that is easier to use, more efficient, decentralized, and secure. Chia Network was founded by [Bram Cohen](https://www.linkedin.com/in/cohenbram/), the inventor of the BitTorrent network.

![](https://www.chia.net/android-chrome-384x384.png)

## Usage

```bash
docker run -d --name="chia" \
    -v <path to data>:/farm/plots \
    -v <path to data>:/farm/tmp \
    -v <path to keys file>:/farm/keys.txt \
    -p 8444:8444 \
    -p 8555:8555 \
    -e TZ="America/Chicago" \
    -e KEYS="/farm/keys.txt" \
    ghcr.io/petemcw/chia-network:latest
```

The time zone defaults to `America/Chicago`. You can configure a timezone using the `TZ` environment variable. Check the [list of supported time zones](https://manpages.ubuntu.com/manpages/focal/man3/DateTime::TimeZone::Catalog.3pm.html).

## Example Commands

For complete reference, visit the [official CLI documentation](https://github.com/Chia-Network/chia-blockchain/wiki/CLI-Commands-Reference) pages.

### Check Status

`docker exec -it chia venv/bin/chia show -s -c`

### Create a Plot

Create a single, standard `k-32` plot using an 8GiB memory buffer, 2 threads, and a bucket size of 32.

`docker exec -it chia venv/bin/chia plots create -k 32 -n 1 -b 8000 -r 2 -u 32 -t /farm/tmp -d /farm/plots`
