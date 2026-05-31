--[[
	PlayerController.lua
	Handles player movement, speed mechanics, and sprite animation
	Ported from WebAssembly game logic to Luau
]]

local PlayerController = {}
PlayerController.__index = PlayerController

-- Configuration
local CONFIG = {
	MAX_SPEED = 100,
	ACCELERATION = 2000,
	FRICTION = 1500,
	JUMP_POWER = 50,
	GRAVITY = 100,
	DASH_BOOST = 150,
	SPRITE_SCALE = 3,
}

function PlayerController.new(character, humanoidRootPart)
	local self = setmetatable({}, PlayerController)
	
	self.character = character
	self.humanoidRootPart = humanoidRootPart
	self.humanoid = character:WaitForChild("Humanoid")
	
	-- Movement state
	self.velocity = Vector3.new(0, 0, 0)
	self.isGrounded = false
	self.isFacingRight = true
	self.currentSpeed = 0
	self.isDashing = false
	self.dashCooldown = 0
	
	-- Sprite references
	self.spriteGui = nil
	self.spriteImageLabel = nil
	
	-- Animation state
	self.currentAnimation = "idle"
	self.animationFrameIndex = 0
	self.animationSpeed = 0.1
	
	-- Create sprite UI
	self:CreateSpriteUI()
	
	return self
end

function PlayerController:CreateSpriteUI()
	-- Create ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpriteGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = self.character:WaitForChild("Head")
	
	-- Create ImageLabel for sprite
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "SpriteImageLabel"
	imageLabel.Size = UDim2.new(0, 64 * CONFIG.SPRITE_SCALE, 0, 64 * CONFIG.SPRITE_SCALE)
	imageLabel.Position = UDim2.new(0.5, -32 * CONFIG.SPRITE_SCALE / 2, 0, -50)
	imageLabel.BackgroundTransparency = 1
	imageLabel.ScaleType = Enum.ScaleType.Fit
	imageLabel.Parent = screenGui
	
	self.spriteGui = screenGui
	self.spriteImageLabel = imageLabel
end

function PlayerController:SetSpriteImage(imageId)
	if self.spriteImageLabel then
		self.spriteImageLabel.Image = imageId
	end
end

function PlayerController:SetAnimation(animationName, frameIndex)
	self.currentAnimation = animationName
	self.animationFrameIndex = frameIndex or 0
end

function PlayerController:UpdateAnimation(deltaTime)
	self.animationSpeed = self.animationSpeed + deltaTime
	
	-- Animation frame updates based on current animation
	if self.currentAnimation == "run" then
		if self.animationSpeed >= 0.1 then
			self.animationFrameIndex = (self.animationFrameIndex + 1) % 8
			self.animationSpeed = 0
		end
	elseif self.currentAnimation == "jump" then
		self.animationFrameIndex = 1
	elseif self.currentAnimation == "idle" then
		if self.animationSpeed >= 0.2 then
			self.animationFrameIndex = (self.animationFrameIndex + 1) % 4
			self.animationSpeed = 0
		end
	elseif self.currentAnimation == "dash" then
		self.animationFrameIndex = 2
	end
end

function PlayerController:Update(inputDirection, deltaTime)
	-- Update dash cooldown
	if self.dashCooldown > 0 then
		self.dashCooldown = self.dashCooldown - deltaTime
	end
	
	-- Handle dash
	if inputDirection == "dash" and self.dashCooldown <= 0 and self.isGrounded then
		self.isDashing = true
		self.dashCooldown = 1.0
		self.currentSpeed = CONFIG.DASH_BOOST
		self:SetAnimation("dash")
	end
	
	-- Horizontal movement
	if inputDirection == "left" then
		self.isFacingRight = false
		if self.currentSpeed > -CONFIG.MAX_SPEED then
			self.currentSpeed = math.max(self.currentSpeed - CONFIG.ACCELERATION * deltaTime, -CONFIG.MAX_SPEED)
		end
	elseif inputDirection == "right" then
		self.isFacingRight = true
		if self.currentSpeed < CONFIG.MAX_SPEED then
			self.currentSpeed = math.min(self.currentSpeed + CONFIG.ACCELERATION * deltaTime, CONFIG.MAX_SPEED)
		end
	else
		-- Apply friction
		if self.currentSpeed > 0 then
			self.currentSpeed = math.max(self.currentSpeed - CONFIG.FRICTION * deltaTime, 0)
		elseif self.currentSpeed < 0 then
			self.currentSpeed = math.min(self.currentSpeed + CONFIG.FRICTION * deltaTime, 0)
		end
	end
	
	-- Handle jump
	if inputDirection == "jump" and self.isGrounded then
		self.velocity = self.velocity + Vector3.new(0, CONFIG.JUMP_POWER, 0)
		self.isGrounded = false
		self:SetAnimation("jump")
	end
	
	-- Apply gravity
	self.velocity = self.velocity - Vector3.new(0, CONFIG.GRAVITY * deltaTime, 0)
	
	-- Update velocity based on current speed
	self.velocity = Vector3.new(self.currentSpeed, self.velocity.Y, 0)
	
	-- Apply velocity to character
	self.humanoidRootPart.CFrame = self.humanoidRootPart.CFrame + self.velocity * deltaTime
	
	-- Flip sprite based on direction
	if self.spriteImageLabel then
		self.spriteImageLabel.Rotation = self.isFacingRight and 0 or 180
	end
	
	-- Update animation
	self:UpdateAnimation(deltaTime)
	
	-- Update animation state display
	if self.isGrounded then
		if math.abs(self.currentSpeed) > 5 then
			self:SetAnimation("run")
		else
			self:SetAnimation("idle")
		end
	end
end

function PlayerController:CheckGroundCollision()
	local rayOrigin = self.humanoidRootPart.Position
	local rayDirection = Vector3.new(0, -10, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {self.character}
	
	local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if rayResult and rayResult.Distance < 5 then
		self.isGrounded = true
		if self.velocity.Y < 0 then
			self.velocity = Vector3.new(self.velocity.X, 0, self.velocity.Z)
		end
	else
		self.isGrounded = false
	end
end

function PlayerController:Cleanup()
	if self.spriteGui then
		self.spriteGui:Destroy()
	end
end

return PlayerController
