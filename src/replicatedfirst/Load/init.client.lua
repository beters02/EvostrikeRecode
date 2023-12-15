local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local Loaded = Framework.Events.Player.Loaded

function PrepareEnums()
    local Loads = {}
    for __, v in pairs(require(script.Enums)) do
        for _, c in pairs(v:GetChildren()) do
            table.insert(Loads, c)
        end
    end
    return Loads
end

ContentProvider:PreloadAsync(PrepareEnums(), function()
    local success, var = Loaded:InvokeServer()
    if not success then
        
    end
    print("LOADDED BITCHES")
    -- Loaded!
end)

print('ASDJNA')