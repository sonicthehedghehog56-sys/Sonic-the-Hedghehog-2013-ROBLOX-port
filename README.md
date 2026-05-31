# Sonic-Like Platformer - Roblox Port

A high-speed, sprite-based platformer game for Roblox, ported from WebAssembly using Luau scripting with ImageLabel sprite rendering.

## Features

- **Fast-Paced Platforming**: Smooth acceleration, deceleration, and momentum-based movement
- **Sprite Animation System**: Dynamic sprite rendering via ImageLabels with configurable animations
- **Dash Mechanic**: Speed boost ability with cooldown management
- **Physics-Based Movement**: Gravity, jump mechanics, and ground collision detection
- **Input Handling**: Responsive keyboard controls with customizable key bindings

## Quick Start

1. Copy all files from `src/` to your Roblox ServerScriptService as ModuleScripts
2. Configure sprite images in `SpriteConfig.lua`
3. Create a LocalScript in StarterPlayer > StarterCharacterScripts to initialize
4. See `SETUP_INSTRUCTIONS.md` for complete setup guide

## Controls

| Action | Keys |
|--------|------|
| Move Left | A / Left Arrow |
| Move Right | D / Right Arrow |
| Jump | Space / W |
| Dash | E / Left Shift |

## File Structure

```
src/
├── PlayerController.lua      # Movement physics & sprite management
├── InputHandler.lua          # Input processing & key bindings
├── SpriteConfig.lua         # Sprite asset configuration
└── GameManager.lua          # Main game loop & initialization
```

## Configuration

### Movement Physics
Edit `CONFIG` in `PlayerController.lua` to adjust:
- `MAX_SPEED`: Maximum horizontal velocity
- `ACCELERATION`: How quickly you reach max speed
- `FRICTION`: How quickly you stop
- `JUMP_POWER`: Jump height
- `GRAVITY`: Gravity strength
- `DASH_BOOST`: Dash speed boost

### Sprite Images
Update asset IDs in `SpriteConfig.lua` for:
- `idle`: Idle animation frames
- `run`: Running animation frames
- `jump`: Jump animation frames
- `dash`: Dash animation frames
- `fall`: Falling animation frames

### Key Bindings
Customize controls in `InputHandler.lua`:
```lua
self.keyBindings = {
	left = {Enum.KeyCode.A, Enum.KeyCode.Left},
	right = {Enum.KeyCode.D, Enum.KeyCode.Right},
	jump = {Enum.KeyCode.Space, Enum.KeyCode.W},
	dash = {Enum.KeyCode.E, Enum.KeyCode.LeftShift},
}
```

## Documentation

See `SETUP_INSTRUCTIONS.md` for:
- Detailed setup guide
- Troubleshooting
- Customization examples
- References to Roblox documentation

## Architecture

### GameManager
Central manager handling game loop initialization and update cycles using `RunService.Heartbeat`.

### PlayerController
Manages:
- Character movement and velocity
- Gravity and ground collision detection via raycasting
- Animation state and frame management
- ImageLabel sprite display

### InputHandler
Manages:
- Keyboard input capture via `UserInputService`
- Input direction detection
- Communication with PlayerController

### SpriteConfig
Centralized asset management for:
- Animation frame sequences
- Sprite asset IDs
- Dynamic sprite retrieval

## Valid Luau Syntax

All code uses proper Luau syntax including:
- Type annotations (comments for documentation)
- Metatables and OOP patterns
- Proper scoping and module structure
- Valid Roblox API calls

## References

- [Roblox Luau Docs](https://create.roblox.com/docs)
- [ImageLabel Class](https://create.roblox.com/docs/reference/engine/classes/ImageLabel)
- [Raycasting](https://create.roblox.com/docs/reference/engine/classes/WorldRoot)
- [UserInputService](https://create.roblox.com/docs/reference/engine/classes/UserInputService)
- [RunService](https://create.roblox.com/docs/reference/engine/classes/RunService)

---

**Created for high-speed platformer gameplay in Roblox** 🏃‍♂️
