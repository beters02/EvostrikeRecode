local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local PlayerManager = require(script.PlayerManager)
local PlayerLoaded = Framework.Events.Player.Loaded

-- The function called when a player is loaded,  calls PlayerManager.PlayerLoaded
function _playerLoaded(player)
    -- Do some middleware stuff

    --TODO: Allow support for PlayerLoaded to return variables to the client.
    PlayerManager.PlayerLoaded(player)

    return true
end

PlayerLoaded.OnServerInvoke = _playerLoaded