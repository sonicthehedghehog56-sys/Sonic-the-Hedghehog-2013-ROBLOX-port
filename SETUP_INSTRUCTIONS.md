# Setup Instructions - Sonic-Like Platformer Roblox Port

## Quick Start

Follow these steps to get your sonic-like platformer game running in Roblox Studio:

### 1. **Create the Game Structure**

Copy all the Luau files from the `src/` directory into your Roblox game as ModuleScripts:
- `PlayerController.lua`
- `InputHandler.lua`
- `SpriteConfig.lua`
- `GameManager.lua`

Place these in **ServerScriptService** or a folder within it.

### 2. **Create the Player Character**

Create a humanoid character model with the following structure:

```
Character
├── HumanoidRootPart (Part - this is the main body)
├── Humanoid
├── Head (optional)
└── Other body parts (optional)
```

### 3. **Add Sprite Assets**

Configure your sprite images in `SpriteConfig.lua`:

```lua
SpriteConfig.Sprites = {
	idle = {
		"rbxassetid://YOUR_IDLE_SPRITE_1",
		"rbxassetid://YOUR_IDLE_SPRITE_2",
		-- ... more frames
	},
	run = {
		"rbxassetid://YOUR_RUN_SPRITE_1",
		-- ... more frames
	},
	-- ... other animations
}
```

To get image IDs:
1. Upload your sprite images to Roblox
2. Use them in a project and note their asset IDs (format: `rbxassetid://12345678`)

### 4. **Initialize the Game**

Create a `LocalScript` in **StarterPlayer > StarterCharacterScripts** with this code:

```lua
local GameManager = require(game.ServerScriptService:WaitForChild("GameManager"))

local gameManager = GameManager.new()
gameManager:InitializePlayer(script.Parent)
gameManager:StartGameLoop()

script.Parent.Humanoid.Died:Connect(function()
	gameManager:Cleanup()
end)
```

### 5. **Controls**

- **A / Left Arrow**: Move left
- **D / Right Arrow**: Move right
- **Space / W**: Jump
- **E / Left Shift**: Dash (special move with speed boost)

---

## Complete Initialization Command

Run this in the **Command Bar** in Roblox Studio to create the module structure:

```lua
-- Create all necessary module scripts in ServerScriptService
local sss = game:GetService("ServerScriptService")

-- PlayerController Module
local playerController = Instance.new("ModuleScript")
playerController.Name = "PlayerController"
playerController.Parent = sss

-- InputHandler Module
local inputHandler = Instance.new("ModuleScript")
inputHandler.Name = "InputHandler"
inputHandler.Parent = sss

-- SpriteConfig Module
local spriteConfig = Instance.new("ModuleScript")
spriteConfig.Name = "SpriteConfig"
spriteConfig.Parent = sss

-- GameManager Module
local gameManager = Instance.new("ModuleScript")
gameManager.Name = "GameManager"
gameManager.Parent = sss

print("✓ Module structure created!")
print("✓ Copy source code from GitHub to each module")
print("✓ Create LocalScript in StarterPlayer > StarterCharacterScripts to initialize")
```

---

## File Structure

```
src/
├── PlayerController.lua     # Character movement & sprite handling
├── InputHandler.lua         # Input processing
├── SpriteConfig.lua        # Sprite asset configuration
└── GameManager.lua         # Main game loop & initialization

README.md                   # Project overview
SETUP_INSTRUCTIONS.md       # This file
```

---

## Customization

### Adjust Movement Physics

Edit the `CONFIG` table in `PlayerController.lua`:

```lua
local CONFIG = {
	MAX_SPEED = 100,        -- Maximum horizontal speed
	ACCELERATION = 2000,    -- How fast you accelerate
	FRICTION = 1500,        -- How fast you decelerate
	JUMP_POWER = 50,        -- Jump height multiplier
	GRAVITY = 100,          -- Gravity strength
	DASH_BOOST = 150,       -- Dash speed boost
	SPRITE_SCALE = 3,       -- Sprite size multiplier
}
```

### Change Key Bindings

Edit the `keyBindings` table in `InputHandler.lua`:

```lua
self.keyBindings = {
	left = {Enum.KeyCode.A, Enum.KeyCode.Left},
	right = {Enum.KeyCode.D, Enum.KeyCode.Right},
	jump = {Enum.KeyCode.Space, Enum.KeyCode.W},
	dash = {Enum.KeyCode.E, Enum.KeyCode.LeftShift},
}
```

### Add Custom Animations

In `SpriteConfig.lua`:

```lua
SpriteConfig.Sprites.customAnimation = {
	"rbxassetid://12345678",
	"rbxassetid://87654321",
	-- ... more frames
}
```

Then use in `PlayerController:SetAnimation("customAnimation")`.

---

## Troubleshooting

**Sprites not showing?**
- Ensure sprite image IDs are correct in `SpriteConfig.lua`
- Check that images are uploaded to Roblox and are publicly accessible
- Verify ImageLabel is properly created in PlayerController

**Movement not working?**
- Verify all ModuleScripts are in `ServerScriptService`
- Check that key bindings match your keyboard layout
- Ensure LocalScript is placed in `StarterPlayer > StarterCharacterScripts`

**Physics feel off?**
- Adjust the `CONFIG` values in `PlayerController.lua`
- Increase/decrease `ACCELERATION`, `GRAVITY`, and `MAX_SPEED` to tune feel
- Try adjusting `FRICTION` for different stopping speeds

**Ground collision not detecting?**
- Verify HumanoidRootPart exists and is the main body
- Check that floor/platform parts are in workspace
- Raycasting may need adjustment if platforms are thin

---

## Documentation References

- [Roblox Luau Docs](https://create.roblox.com/docs)
- [Humanoid Object](https://create.roblox.com/docs/reference/engine/classes/Humanoid)
- [ImageLabel GUI](https://create.roblox.com/docs/reference/engine/classes/ImageLabel)
- [UserInputService](https://create.roblox.com/docs/reference/engine/classes/UserInputService)
- [RunService](https://create.roblox.com/docs/reference/engine/classes/RunService)
- [Raycasting](https://create.roblox.com/docs/reference/engine/classes/WorldRoot)

---

## Module System Overview

### PlayerController
- Handles movement physics with acceleration and friction
- Manages sprite animations and displays
- Detects ground collision via raycasting
- Flips sprite based on facing direction
- Properties: velocity, speed, isGrounded, currentAnimation

### InputHandler
- Captures keyboard input using UserInputService
- Converts input to directional commands
- Communicates with PlayerController each frame
- Customizable key bindings

### SpriteConfig
- Centralized sprite asset management
- Animation frame sequences
- Supports dynamic sprite swapping
- Easy configuration for custom animations

### GameManager
- Main game loop using RunService.Heartbeat
- Initializes player controller and input handler
- Updates sprite display each frame
- Manages game state and cleanup

---

**Ready to play!** 🎮

For questions or issues, check the README.md or the inline comments in each module.
