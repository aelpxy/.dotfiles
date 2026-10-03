# .dotfiles

A collection of my config files.

## Setup (Arch Linux)

```sh
sudo pacman -S --needed git
git clone https://github.com/aelpxy/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/arch.sh
```

Installs packages, AUR helper, dev tools and GUI apps (on desktop systems), then copies the configs into place. Existing files that differ are saved as `<name>.bak`.

## Sync

```sh
./scripts/sync.sh
```

Compares the configs in this repo with the ones on the current device. When a file differs it shows the diff and asks whether to keep the repo or device version, or skip it.

Tracked files are listed in `scripts/files.txt`. Private SSH hosts go in `~/.ssh/config.local`, which is never committed.

## Mount a disk

```sh
./scripts/mount.sh
```

Lists partitions, asks which one to mount and where, then adds it to `/etc/fstab` by UUID so it mounts on every boot.

## License

Licensed under [MIT](./LICENSE)
