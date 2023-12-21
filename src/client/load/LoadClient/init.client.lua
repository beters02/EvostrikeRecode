local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [[ CONFIGURATION ]]

local LOAD_CONTENT = {
    ReplicatedStorage:WaitForChild("Assets"),
    workspace.Map
}

-- Init Black Screen
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()
local cRBXUI = require(script:WaitForChild("RBXUI")) -- We use the Child UI module so it loads as fast as possible
local blackScreenGui = cRBXUI.Gui.new({Name = "LoadingBlackScreen"})
cRBXUI.Page.new(blackScreenGui, {Name = "MainPage", Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0,0,0)})
blackScreenGui:Parent()
blackScreenGui:Enable()

-- Init Framework and Var
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local RBXUI = require(Framework.Libraries.RBXUI) -- We use the main ui module here so LoadingScreen is entered into the main UI tag list.
local Loaded = Framework.Events.Player.Loaded
local rbxuiAnim = require(Framework.Libraries.RBXUI_Animations)

-- Wait for Framework AssetManager to load
if not Framework:IsLoaded() then
    print('Load: Waiting for framework load')
    Framework.Loaded.OnClientEvent:Wait()
end

-- Init Loading GUI
local loadingScreenGui = RBXUI.Gui.new({Name = "LoadingGui"})
local feetPage = RBXUI.Page.new(loadingScreenGui, {Name = "MainPage", Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0,0,0)})
local feetImage = RBXUI.Image.new(feetPage, {Name = "Feet", Size = UDim2.fromScale(0.6,0.6), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1, ImageTransparency = 0})
feetImage:SetImage(require(Framework.Assets.UI).IMG_LOADING_FEET)
loadingScreenGui:Parent()
loadingScreenGui:Enable()
blackScreenGui:Disable() -- Loading screen was displaying over black screen no matter the ZIndex...
blackScreenGui:Enable()

-- Init Animations
local loadFadeIn = rbxuiAnim.new(loadingScreenGui.Pages.MainPage, "FadeIn", 2)
local loadFadeOut = rbxuiAnim.new(loadingScreenGui.Pages.MainPage, "FadeOut", 2)
local blackFadeIn = rbxuiAnim.new(blackScreenGui.Pages.MainPage, "FadeIn", 2)
local blackFadeOut = rbxuiAnim.new(blackScreenGui.Pages.MainPage, "FadeOut", 2)
loadingScreenGui.Pages.MainPage.Instance.ZIndex = 2
blackScreenGui.Pages.MainPage.Instance.ZIndex = 10

-- Init Animation Sequence
local function sequence()
    task.wait(1)
    blackFadeOut:Play()
    task.wait(4)
    blackFadeIn:Play()
    task.wait(2)
    blackFadeOut:Play()
end

local seqThread = task.spawn(sequence)

-- Play Intro Music
local introSound = Framework.AssetManager:Insert("UI", "SOUND_CSL_INTRO")
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
    for _, v in pairs(LOAD_CONTENT) do
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
local success = Loaded:InvokeServer("LoadPlayerServer") -- success, var?
if success then
    print("Client Loaded")
    local skipconn = false
    local skip = false
    local skipdt = 0
    if introSound.Playing then
        --TODO: display "Hold space to skip" ui
        skipconn = RunService.RenderStepped:Connect(function(dt)
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                skipdt += dt
            else
                skipdt = 0
            end
            if skipdt >= 1 then
                skip = true
                skipconn:Disconnect()
            end
        end)
        print('Waiting for intro')
        repeat task.wait() until not introSound.Playing or skip
    end

    print('Intro finished')
    if seqThread then
        task.cancel(seqThread)
    end

    -- Player finished loading. Lets let the server know.
    Loaded:InvokeServer("PlayerLoaded")

    loadFadeOut:Play()
    task.delay(1, function()
        blackScreenGui:Destroy()
        loadingScreenGui:Destroy()
        Framework.States:Set("ClientGame", "LoadingScreenState", "FINISH")
    end)
end