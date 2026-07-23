# Storage Benchmarks

- ssd-r1 (LVM thin)

  ```
  Random Read/Write IOPS: 84.1k/75.9k. BW: 507MiB/s / 492MiB/s
  Average Latency (usec) Read/Write: 151.94/83.04
  Sequential Read/Write: 515MiB/s / 493MiB/s
  Mixed Random Read/Write IOPS: 64.8k/21.6k
  ```

- ssd-r1 (ZFS thin, ashift=9)

  ```
  Random Read/Write IOPS: 109k/51.2k. BW: 1896MiB/s / 215MiB/s
  Average Latency (usec) Read/Write: 45.30/108.91
  Sequential Read/Write: 1982MiB/s / 281MiB/s
  Mixed Random Read/Write IOPS: 54.8k/18.3k
  ```

- ssd-r1 (LVM thin, on Talos LUKS-backed `RawVolume`)

  ```
  Random Read/Write IOPS: 77.7k/63.1k. BW: 504MiB/s / 497MiB/s
  Average Latency (usec) Read/Write: 128.44/72.17
  Sequential Read/Write: 510MiB/s / 503MiB/s
  Mixed Random Read/Write IOPS: 54.3k/18.1k
  ```

- ssd-r2 (LVM thin, read-balancing)

  ```
  Random Read/Write IOPS: 79.7k/37.7k. BW: 1011MiB/s / 438MiB/s
  Average Latency (usec) Read/Write: 279.98/427.94
  Sequential Read/Write: 790MiB/s / 487MiB/s
  Mixed Random Read/Write IOPS: 36.9k/12.3k
  ```

- ssd-r2 (ZFS thin, ashift=9)

  ```
  Random Read/Write IOPS: 85.1k/18.1k. BW: 1764MiB/s / 222MiB/s
  Average Latency (usec) Read/Write: 62.00/883.05
  Sequential Read/Write: 1818MiB/s / 222MiB/s
  Mixed Random Read/Write IOPS: 35.7k/11.9k
  ```

- ssd-r2 (LVM thin, no read-balancing, on Talos LUKS-backed `RawVolume`)

  ```
  Random Read/Write IOPS: 80.6k/22.8k. BW: 508MiB/s / 368MiB/s
  Average Latency (usec) Read/Write: 127.08/369.11
  Sequential Read/Write: 517MiB/s / 430MiB/s
  Mixed Random Read/Write IOPS: 54.3k/18.0k
  ```
