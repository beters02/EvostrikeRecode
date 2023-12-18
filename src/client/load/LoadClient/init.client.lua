local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local RBXUI = require(Framework.Libraries.RBXUI)
local Loaded = Framework.Events.Player.Loaded

-- Init Loading GUI
local loadingGui = RBXUI.Gui.new({Name = "LoadingGui"})
RBXUI.Page.new(loadingGui, {Name = "MainPage", Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 0})
loadingGui:SetBackgroundImage(require(Framework.Assets.HUD).MAIN_MENU_BG)
loadingGui:Parent()
loadingGui:Enable()

-- Wait for Framework AssetManager to load
if not Framework:IsLoaded() then
    print('Load: Waiting for framework load')
    Framework.Loaded.OnClientEvent:Wait()
end

function PrepareEnums() -- Prepare Assets to load via Location Enums
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

Framework.States:Set("ClientGame", "LoadingScreenState", "Loading_Assets")
ContentProvider:PreloadAsync(PrepareEnums(), function()
    print("ContentProvider loaded asset.")
end)

Framework.States:Set("ClientGame", "LoadingScreenState", "Loading_Server")
local success = Loaded:InvokeServer() -- success, var?
if success then
    print("Client Loaded")
    loadingGui:Destroy()
    Framework.States:Set("ClientGame", "LoadingScreenState", "FINISH")
end