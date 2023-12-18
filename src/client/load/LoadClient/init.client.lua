-- Init Black Screen
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
local blackScreenGui = require(script:WaitForChild("BlackScreen"))
blackScreenGui:Enable()

-- Init Framework and Var
local Framework = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"))
local Loaded = Framework.Events.Player.Loaded

-- Wait for Framework AssetManager to load
if not Framework:IsLoaded() then
    print('Load: Waiting for framework load')
    Framework.Loaded.OnClientEvent:Wait()
end

-- Init Loading GUI
local loadingScreenGui = require(script:WaitForChild("LoadingScreen"))

-- Play Intro Music
local introSound = Framework.AssetManager:Insert("HUD", "SOUND_CSL_INTRO")
introSound = Framework.AssetManager:Seperate(introSound)
introSound.Parent = loadingScreenGui.Instance
introSound:Play()

-- Prepare Assets to load via Location Enums
function PrepareEnums()
    local Loads = {}
    local function recurse(instance)
        for _, v in pairs(instance:GetChildren()) do
            if v:IsA("Model") or v:IsA("Folder") then
                recurse(v)
                continue
            end
            table.insert(Loads, v)
        end
    end
    for _, v in pairs(require(script.Enums)) do
        for _, c in pairs(v:GetChildren()) do
            recurse(c)
        end
    end
    return Loads
end

-- Loading Assets
Framework.States:Set("ClientGame", "LoadingScreenState", "Loading_Assets")
game:GetService("ContentProvider"):PreloadAsync(PrepareEnums(), function()
    print("ContentProvider loaded asset.")
end)

-- Invoking server for loading confirmation
Framework.States:Set("ClientGame", "LoadingScreenState", "Loading_Server")
local success = Loaded:InvokeServer() -- success, var?
if success then
    print("Client Loaded")
    blackScreenGui:Destroy()
    loadingScreenGui:Destroy()
    Framework.States:Set("ClientGame", "LoadingScreenState", "FINISH")
end