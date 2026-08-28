# Linux Dotfiles

Intended setup for Arch Linux.

Installation:

```bash
git clone https://github.com/tyr4nux/Dotfiles.git ~/.dotfiles
cd dotfiles
./install.sh
```

---

<details>
<summary><h2>💾 Disk</h2></summary>

Partitions for 1 TB drive:

| **Device**       | **Size**   | **Type**                     |
|------------------|------------|------------------------------|
| `/dev/zram0`     | ≈16 GiB    | `[SWAP]`                     |
| `/dev/nvme0n1p1` | ≈206 MiB   | EFI system `/boot`           |
| `/dev/nvme0n1p2` | ≈16 MiB    | Microsoft reserved           |
| `/dev/nvme0n1p3` | ≈463.4 GiB | Microsoft basic data         |
| `/dev/nvme0n1p4` | ≈2 GiB     | Windows recovery environment |
| `/dev/nvme0n1p5` | ≈488.3 GiB | Linux ext4 filesystem `/`    |

**📂 File:** `/boot/loader/loader.conf`

```ini
default arch.conf
timeout 3
console-mode keep
editor no
```

**📂 File:** `/boot/loader/entries/arch.conf`

```ini
title	Arch Linux
linux	/vmlinuz-linux
initrd	/amd-ucode.img
initrd	/initramfs-linux.img
options	root=UUID=f4e598d4-d4e4-4a7b-b900-9818373c699c rw
```

**📂 File:** `/etc/sysctl.d/99-vm-zram-parameters.conf`

```ini
vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
```

**📂 File:** `/etc/systemd/zram-generator.conf`

```ini
[zram0]
zram-size = min(ram / 2, 16384)
```

</details>

---

<details>
<summary><h2>🔗 Git</h2></summary>

**📂 File:** `~/.git-credentials`

```text
https://USER:TOKEN@codeberg.org
https://USER:TOKEN@github.com
```

</details>

---

<details>
<summary><h2>✏️ Nano</h2></summary>

**📂 File:** `/root/.nanorc`

```nanorc
set titlecolor bold,white,red
```

</details>

---

<details>
<summary><h2>📦 Pacman</h2></summary>

**📂 File:** `/etc/pacman.conf`

```ini
[options]
HoldPkg = pacman glibc
CleanMethod = KeepInstalled
Architecture = auto

Color
ILoveCandy
CheckSpace
VerbosePkgLists
ParallelDownloads = 10
DownloadUser = alpm

SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional
RemoteFileSigLevel = Required

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[blackarch]
Include = /etc/pacman.d/blackarch-mirrorlist
```

Save fastest servers:

```bash
rate-mirrors --protocol https --entry-country US --max-mirrors-to-output 5 --disable-comments arch --fetch-first-tier-only | sudo tee /etc/pacman.d/mirrorlist

rate-mirrors --protocol https --entry-country US --max-mirrors-to-output 5 --disable-comments blackarch | sudo tee /etc/pacman.d/blackarch-mirrorlist
```

</details>
