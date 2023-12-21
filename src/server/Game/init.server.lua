--[[

    There will be two places:
    Lobby and Game

    if game.placeid == Place.Game (we get gamemode from player joined)
    if game.placeid == Place.Lobby (always lobby gamemode, which is deathmatch)

]]



local Players = game:GetService("Players")
Players.CharacterAutoLoads = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))

function StartGamemode(gamemodeStr)
    local gamemodeScript = script:FindFirstChild(gamemodeStr)
    if not gamemodeScript then
        return false
    end

    local currentScript = script:FindFirstChild("CurrentScript")
    if currentScript then
        require(script.Interface):Stop()
        currentScript:Destroy()
    end
    
    currentScript = gamemodeScript:Clone()
    currentScript.Parent = gamemodeScript.Parent
    currentScript.Enabled = true

    print('GamemodeScript enabled from GameScript.')
end

-- if game.placeid check, for now its lobby.
StartGamemode("Lobby")