# HostAtHome - Project Zomboid Server

Open-world zombie survival game with multiplayer support.

## Quick Start

```bash
hostathome install zomboid
hostathome run zomboid
```

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 1024 | UDP | Player connections |
| 1025 | UDP | Steam query |

## Configuration

Edit `zomboid-server/configs/config.yaml`:

```yaml
server:
  name: "My Zomboid Server"
  description: "Survival with friends"
  password: ""
  max-players: 16
  admin-password: "secret"

gameplay:
  pause-empty: true
  pvp: true

world:
  map: "Muldraugh, KY"
```

## Mods

Edit `zomboid-server/mods/mods.yaml`:

```yaml
workshop:
  - id: "2392709985"
    name: "Brita"
  - id: "2313387159"
    name: "Arsenal"
```

Find mods at the [Steam Workshop](https://steamcommunity.com/app/108600/workshop/).

## Directory Structure

```
zomboid-server/
├── save/           # World saves
├── mods/           # Workshop mods
│   └── mods.yaml   # Mod configuration
├── data/           # Database files
├── configs/
│   └── config.yaml # Server configuration
└── backup/         # Your backups
```

## Docker (Development)

```bash
docker build -t zomboid-server .
docker run -d -p 1024:16261/udp -v $(pwd):/data zomboid-server
```
