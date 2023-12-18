local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local Module = require(script:WaitForChild("Module"))
local states = require(Framework.Modules.States)

local ClientGameState: states.State = Framework.States:GetState("ClientGame")
local GameStateChangedConn = ClientGameState:changed(function(key, prev, new)
    print(key)
    print(prev)
    print(new)
end)

task.wait(1)
--print(ClientGameState)