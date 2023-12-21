-- [[ This is where you would add custom functionality to PlayerLoaded and other player actions via Game Scripts. ]]

local PlayerManager = {}

function PlayerManager.LoadPlayerServer(player)
    -- Custom Gamemode Data Loading would go here.
    print("PlayerManager LoadPlayerServer Finished! " .. player.Name)
end

-- Calls when player is loaded via remote.
function PlayerManager.PlayerLoaded(player)
    
end

return PlayerManager