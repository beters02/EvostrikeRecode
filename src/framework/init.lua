if not game:IsLoaded() then
    game.Loaded:Wait()
end

local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Framework = { -- # Add easy access to files here.
    Modules = ReplicatedStorage.Modules,
    Libraries = ReplicatedStorage.Libraries,
    Services = ReplicatedStorage.Services,
    Events = ReplicatedStorage.Events,
    Assets = ReplicatedStorage.Assets,

    Loaded = script.Loaded,
    _statesRF = script.States
}

local states = require(Framework.Modules.States)
local tables = require(Framework.Libraries.Table)

-- Prepare States
--@summary Relies on States Module. Framework-organized states will be stored here.
Framework.States = {
    Stored = {
        Game = {properties = {replicated = true, clientReadOnly = true}, def = { Loaded = false }}
    }
}

function Framework.States:init()
    if RunService:IsServer() then
        for i, v in pairs(Framework.States.Stored) do
            Framework.States.Stored[i] = states:Create(tables.combine({id = i}, v.properties), v.def)
        end
    end
end

function Framework.States:Get(state)
    return states:Get(state) -- States does all the Replicated Variable Networking for you!
end

-- Prepare AssetManager
--@summary AssetManager Tree: { Category: ModuleScript = {assetid...} }
--                          Turns AssetIDs into Models that are children of the ModuleScript
Framework.AssetManager = {}

local function initAssetManagerServer()
    for _, category in pairs(Framework.Assets) do
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

function Framework.AssetManager:init()
    if RunService:IsServer() then
        initAssetManagerServer()
    end
end

-- Run Script
Framework.States:init()
Framework.AssetManager:init()

if RunService:IsServer() then
    Framework.Loaded:FireAllClients()
end

return Framework