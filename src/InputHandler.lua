--[[
	InputHandler.lua
	Manages player input and communicates with PlayerController
]]

local InputHandler = {}
InputHandler.__index = InputHandler

local UserInputService = game:GetService("UserInputService")

function InputHandler.new(playerController)
	local self = setmetatable({}, InputHandler)
	
	self.playerController = playerController
	self.keysPressed = {}
	self.lastInputDirection = nil
	
	-- Key bindings
	self.keyBindings = {
		left = {Enum.KeyCode.A, Enum.KeyCode.Left},
		right = {Enum.KeyCode.D, Enum.KeyCode.Right},
		jump = {Enum.KeyCode.Space, Enum.KeyCode.W},
		dash = {Enum.KeyCode.E, Enum.KeyCode.LeftShift},
	}
	
	self:SetupInputConnections()
	
	return self
end

function InputHandler:SetupInputConnections()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		self.keysPressed[input.KeyCode] = true
	end)
	
	UserInputService.InputEnded:Connect(function(input, gameProcessed)
		self.keysPressed[input.KeyCode] = nil
	end)
end

function InputHandler:IsKeyPressed(keyList)
	for _, keyCode in ipairs(keyList) do
		if self.keysPressed[keyCode] then
			return true
		end
	end
	return false
end

function InputHandler:GetInputDirection()
	-- Check each direction
	if self:IsKeyPressed(self.keyBindings.left) then
		return "left"
	elseif self:IsKeyPressed(self.keyBindings.right) then
		return "right"
	elseif self:IsKeyPressed(self.keyBindings.jump) then
		return "jump"
	elseif self:IsKeyPressed(self.keyBindings.dash) then
		return "dash"
	end
	
	return nil
end

function InputHandler:Update(deltaTime)
	local inputDirection = self:GetInputDirection()
	self.playerController:Update(inputDirection, deltaTime)
	self.playerController:CheckGroundCollision()
end

function InputHandler:Cleanup()
	-- Connections are automatically cleaned up
end

return InputHandler
