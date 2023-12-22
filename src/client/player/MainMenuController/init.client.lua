
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local FrTypes = Framework.TypeEnums
local states = require(Framework.Modules.States)

-- Wait until Loading Screen is finished.
local ClientGameState = Framework.States:GetState("ClientGame") :: states.State
local currentLState = ClientGameState:get("LoadingScreenState") :: FrTypes.Enum_LoadingScreenState
if currentLState ~= "FINISH" then
    local conn
    local loaded = false
    conn = ClientGameState:changed(function(key, prev, new)
        print(key, prev, new)
        if key == "LoadingScreenState" and new == "FINISH" then
            loaded = true
            conn:Disconnect()
        end
    end)
    repeat task.wait() until loaded
end

-- Init Main Menu UI
local mainMenuGui = require(script:WaitForChild("UI"))

-- Init Keybinds
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.M then
        if mainMenuGui.Enabled then
            mainMenuGui:Disable()
        else
            mainMenuGui:Enable()
        end
    end
end)