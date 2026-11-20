# nixos-config

Configuration files for my personal laptop (Framework 16), built with NixOS and
Home Manager using flakes.

## Overview

- **OS**: [NixOS](https://github.com/NixOS)
- **Compositor**: [Niri](https://github.com/niri-wm/niri)
- **Desktop shell**: [Noctalia](https://github.com/noctalia-dev/noctalia)
- **Shell**: [Zsh](https://github.com/zsh-users/zsh)
- **Terminal**: [Kitty](https://github.com/kovidgoyal/kitty)
- **Editor**: [Neovim](https://github.com/neovim/neovim) and
  [VSCodium](https://github.com/VSCodium/vscodium)
- **File manager**: [Yazi](https://github.com/sxyazi/yazi)
- **Browser**: [Firefox](https://github.com/mozilla-firefox/firefox)
- **Theme**: [Rosé Pine](https://github.com/rose-pine/rose-pine-theme)

## Philosophy

- **Declarative**: Define the entire system in code. NixOS handles system-level
  configuration and Home Manager manages user-level programs and dotfiles.
- **Reproducible**: Rebuild the exact same environment consistently, making it
  straightforward to reinstall or migrate to new hardware.
- **Rollbacks**: Retain previous NixOS generations so a working boot option is
  always available if an update breaks something.
- **Open source**: Prioritize free and open-source software, keeping unfree
  packages behind an explicit allowlist.
- **Keyboard-driven**: Minimize mouse usage with keyboard-centric tools like
  Niri, Kitty, Neovim, and Yazi.

## Usage

### Install

1. Clone this repository:

   ```bash
   nix-shell -p git --run "git clone https://github.com/jasoneliu/nixos-config ~/nixos-config"
   ```

2. Build your system:

   ```bash
   sudo nixos-rebuild switch --flake ~/nixos-config#fw16
   ```

### Update

Rebuild and switch to the new generation:

```bash
nh os switch
```

Or update flake inputs first, then rebuild and switch:

```bash
nh os switch -u
```

### Noctalia

Noctalia lets you configure it interactively through its GUI, saving changes
locally. Once you're happy with how it looks, persist your changes
declaratively:

1. Export your local settings as a Nix attribute set:

   ```bash
   nix eval --expr "builtins.fromTOML ''$(noctalia config export)''"
   ```

2. Paste the exported settings into `home-manager/noctalia.nix`:

   ```nix
   programs.noctalia = {
     enable = true;

     settings = /* paste exported settings here */;
   };
   ```

3. Rebuild and switch to the new generation:

   ```bash
   nh os switch
   ```

4. Remove the local settings:

   ```bash
   rm ~/.local/state/noctalia/settings.toml
   ```
