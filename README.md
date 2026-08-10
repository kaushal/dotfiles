# dotfiles

Portable shell + tooling config for **macOS** (work/personal laptop) and
**Ubuntu** (snaxbox, the home server / dev box). One `bootstrap.sh` symlinks
everything into place so both machines feel identical.

```sh
git clone git@github.com:kaushal/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
```

| Path | What it is |
|---|---|
| `bootstrap.sh` | Detects the OS, installs packages, symlinks configs. Safe to re-run. |
| `zsh/zshrc` | Shell: history, completions, aliases, prompt, tool init. **No secrets.** |
| `git/` | `gitconfig` + global ignore. |
| `herdr/config.toml` | [Herdr](https://herdr.dev) — terminal workspace manager for coding agents. |
| `packages/` | `Brewfile` (macOS) and `apt.txt` (Ubuntu). |
| `bin/devday` | Morning greeting: Claude token spend, git state, commute. |

## Secrets

Nothing secret lives here — this repo is public. Machine-local values
(credentials, work paths, tokens) go in **`~/.zshrc.local`**, which `zshrc`
sources at the end and `.gitignore` blocks. Start from
`zsh/zshrc.local.example`.

## History

The 2013 incarnation (bash + pathogen vim) is preserved at the
[`legacy-2013`](../../tree/legacy-2013) tag.
