local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local PlayerManager = require(script.Module)
local PlayerLoaded = Framework.Events.Player.Loaded
local PlayerDied = Framework.Events.Player.Died
local PlayerDiedVerification = Framework.Events.Player.DiedVerification

local Loaded = {}

-- The final stage of the Player Loading process.
function Loaded.LoadPlayerServer(player)
    -- Load the Default Game PlayerData here.
    PlayerManager.LoadPlayerServer(player)
    return true
end

-- The function called when a player is loaded,  calls PlayerManager.PlayerLoaded
function Loaded.PlayerLoaded(player)
    -- Do some middleware stuff

    --TODO: Allow support for PlayerLoaded to return variables to the client.
    PlayerManager.PlayerLoaded(player)

    return true
end

local Died = {}

function Died.Verification(player)
    if not player.Character
    or not player.Character.Humanoid
    or not player.Character.Humanoid.Health <= 0
    or not PlayerManager.PlayerDiedVerification(player) then
        return false
    end

    PlayerDied:FireAllClients(player)
    return true
end

function Died.Died()
end

PlayerLoaded.OnServerInvoke = function(player, action, ...)
    return Loaded[action](player, ...)
end

PlayerDiedVerification.OnServerInvoke = Died.Verification