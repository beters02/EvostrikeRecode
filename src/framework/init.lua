local RunService = game:GetService("RunService")
if RunService:IsClient() and not game:IsLoaded() then game.Loaded:Wait() end

local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Framework = {
    Modules = ReplicatedStorage.Modules,
    Libraries = ReplicatedStorage.Libraries,
    Services = ReplicatedStorage.Services,
    Events = ReplicatedStorage.Events,
    Assets = ReplicatedStorage.Assets,

    Loaded = script.Loaded,

    TypeEnums = require(script:WaitForChild("TypeEnums"))
}
local states = require(Framework.Modules.States)
local tables = require(Framework.Libraries.Table)

-- Prepare States
Framework.States = {}

--Server States
Framework.States.Stored = {
    Framework = {properties = {replicated = true, clientReadOnly = true}, def = { Loaded = false }},
    Game = {properties = {replicated = true, clientReadOnly = true}, def = { Loaded = false }},
}

--Client States
Framework.States.StoredClient = {
    ClientGame = {properties = {replicated = false}, def = { LoadingScreenState = "Loading_Game" }},
    HUD = {properties = {replicated = false}, def = { currentOpenUI = {} }}
}

function Framework.States:GetState(state): states.State
    return states:Get(state):: states.State -- States does all the Replicated Variable Networking for you!
end

function Framework.States:Get(state, key): any
    return states:Get(state):get(key)
end

function Framework.States:Set(state, key, value)
    return states:Get(state):set(key, value)
end

-- Prepare AssetManager
--@summary AssetManager Tree: { Category: ModuleScript = {assetid...} }
--                          Turns AssetIDs into Models that are children of the ModuleScript
Framework.AssetManager = {}

--@summary Returns a model with the desired Instance
function Framework.AssetManager:Insert(parent, asset): Model
    local assetInstance = Framework.Assets[parent][asset]
    assetInstance = assetInstance:Clone()
    assetInstance.Parent = ReplicatedStorage
    return assetInstance
end

--@summary Seperate a returned Insert Model which only has 1 child.
function Framework.AssetManager:Seperate(model): any
    local c = model:GetChildren()
    if #c ~= 1 then
        warn("Cannot seperate an Insert Model with more or less than 1 child.")
        return false
    end
    local newModel = c[1]
    newModel.Parent = ReplicatedStorage
    model:Destroy()
    return newModel
end

-- Module Functions
function Framework:IsLoaded()
    return Framework.States:Get("Framework", "Loaded")
end
--

function initStatesServer()
    for i, v in pairs(Framework.States.Stored) do
        Framework.States.Stored[i] = states:Create(tables.combine({id = i}, v.properties), v.def)
    end
end

function initStatesClient()
    for i, v in pairs(Framework.States.StoredClient) do
        Framework.States.StoredClient[i] = states:Create(tables.combine({id = i}, v.properties), v.def)
    end
end

local function initAssetManagerServer()
    for _, category in pairs(Framework.Assets:GetChildren()) do
        for assetName, assetId in pairs(require(category)) do
            local _m = InsertService:LoadAsset(assetId)
            _m.Parent = category
            _m.Name = assetName
            handleAssetTypeCreation(assetName, assetId, _m)
        end
    end
end

function handleAssetTypeCreation(assetName, assetId, model)
    local fixedid = assetId
    if not string.match(tostring(assetId), "assetid") then
        fixedid = "rbxassetid://" .. tostring(assetId)
    end
    if string.match(assetName, "IMG") then
        Instance.new("ImageLabel", model).Image = fixedid
    elseif string.match(assetName, "SOUND") then
        Instance.new("Sound", model).SoundId = fixedid
    end
end

-- Run Script
if RunService:IsServer() then
    initStatesServer()
    initAssetManagerServer()
    Framework.States:Set("Framework", "Loaded", true)
    Framework.Loaded:FireAllClients()
    return Framework
end

initStatesClient()
return Framework