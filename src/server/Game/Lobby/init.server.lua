print('Gamemode Lobby Started Successfully!')

local PlayerManager = require(script.Parent.Parent.PlayerManager.Module)
PlayerManager.PlayerLoaded = function(player)
    player:LoadCharacter()
end