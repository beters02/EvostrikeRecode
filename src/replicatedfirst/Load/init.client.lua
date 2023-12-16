local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local RBXUI = require(Framework.Libraries.RBXUI)
local Loaded = Framework.Events.Player.Loaded

print('start init')

-- Init Loading GUI
local loadingGui = RBXUI.Gui.new({Name = "LoadingGui"})
RBXUI.Page.new(loadingGui, {Name = "MainPage", Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5)})
loadingGui:Parent()
loadingGui:Enable()

-- Wait for Framework AssetManager to load
if not Framework:IsLoaded() then
    print('Not loaded. Waiting for fr load')
    Framework.Loaded.OnClientEvent:Wait()
end

function PrepareEnums()
    local Loads = {}
    for _, v in pairs(require(script.Enums)) do
        for _, c in pairs(v:GetChildren()) do
            table.insert(Loads, c)
        end
    end
    return Loads
end

print('init')

ContentProvider:PreloadAsync(PrepareEnums(), function()
    print("ContentProvider loaded asset.")
end)

local success, var = Loaded:InvokeServer()
if not success then
else
    print("Loaded!")
end