-- Script will handle everything but Movement

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local PlayerDiedVerification = Framework.Events.Player.DiedVerification

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

hum.Died:Connect(function()
    PlayerDiedVerification:InvokeServer()
end)