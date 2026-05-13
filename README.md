# Kube Commander 🚢

**Learn Kubernetes by playing a card game.**

Deploy Pods. Scale Deployments. Route traffic through Ingress. Manage resources. All while learning real Kubernetes concepts through gameplay.

## Quick Start

```bash
# Open in Godot 4.6
godot --path ~/Projects/kube-commander

# Or open directly: Godot → Import → Select project.godot
```

## Project Status

- [x] Game design document
- [x] Core scripts (GameManager, CardDatabase, AdManager)
- [x] Card system with 10 Kubernetes concepts
- [x] Android SDK + NDK configured
- [ ] Scene files (open in Godot to create)
- [ ] Card art assets
- [ ] Sound effects
- [ ] AdMob integration (test)

## Development Tools

| Tool | Purpose |
|------|---------|
| Godot 4.6.2 | Game engine |
| Blender 5.1 | 3D assets |
| Inkscape | Vector art / icons |
| OpenCode / Claude Code | AI-assisted scripting |
| OpenClaw | AI content generation |
| Android SDK 34 | Mobile builds |

## Build for Android

```bash
# In Godot Editor:
# Project → Export → Android → Export Project
# Output: kube-commander.apk

# Or command line:
godot --headless --export-release "Android" kube-commander.apk
```

## License

MIT — Educational use. Go deploy some Pods!
