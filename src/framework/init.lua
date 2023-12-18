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

    Loaded = script.Loaded
}
local states = require(Framework.Modules.States)
local tables = require(Framework.Libraries.Table)

-- Prepare States
--@summary Framework-organized Server States
Framework.States = {
    Stored = {
        Game = {properties = {replicated = true, clientReadOnly = true}, def = { Loaded = false }}
    }
}

--@summary Client States
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

-- Module Functions
function Framework:IsLoaded()
    return Framework.States:Get("Game", "Loaded")
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
            local _mc = _m:GetChildren()
            if #_mc == 1 then
                _m:GetChildren()[1].Parent = category
                _m:Destroy()
                continue
            end
            _m.Parent = category
            _m.Name = assetName
        end
    end
end

-- Run Script
if RunService:IsServer() then
    initStatesServer()
    initAssetManagerServer()
    Framework.States:Set("Game", "Loaded", true)
    Framework.Loaded:FireAllClients()
    return Framework
end

initStatesClient()

return Framework