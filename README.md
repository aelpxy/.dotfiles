# .dotfiles

A collection of my config files.

## Setup (Arch Linux)

```sh
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

## License

Licensed under [MIT](./LICENSE)
