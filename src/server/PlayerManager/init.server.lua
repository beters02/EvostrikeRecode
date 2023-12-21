local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local PlayerManager = require(script.Module)
local PlayerLoaded = Framework.Events.Player.Loaded

local RemoteScope = {}

-- The final stage of the Player Loading process.
function RemoteScope.LoadPlayerServer(player)
    -- Load the Default Game PlayerData here.
    PlayerManager.LoadPlayerServer(player)
    return true
end

-- The function called when a player is loaded,  calls PlayerManager.PlayerLoaded
function RemoteScope.PlayerLoaded(player)
    -- Do some middleware stuff

    --TODO: Allow support for PlayerLoaded to return variables to the client.
    PlayerManager.PlayerLoaded(player)

    return true
end

PlayerLoaded.OnServerInvoke = function(player, action, ...)
    return RemoteScope[action](player, ...)
end