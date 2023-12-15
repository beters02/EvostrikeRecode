local PlayerManager = {}

-- Calls when player is loaded via remote.
function PlayerManager.Loaded(player)
    print("PlayerManager Player Loaded! {player.Name}")
end

return PlayerManager