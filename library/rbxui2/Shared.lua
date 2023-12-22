local sh = {}

--@function Apply RBX & SizePreset/PositionPreset properties to an instance
function sh.applyRBXPropertiesInstance(instance, rbxprop, defaults)
    rbxprop = rbxprop or {}
    sh.inheritDefaultProperties(defaults, rbxprop)
    sh.applyRBXProperties(instance, rbxprop)
    if rbxprop.SizePreset then instance.Size = sh.SizeEnum[rbxprop.SizePreset] end
    if rbxprop.PositionPreset then
        instance.Position = sh.PosEnum[rbxprop.PositionPreset].Position
        instance.AnchorPoint = sh.PosEnum[rbxprop.PositionPreset].AnchorPoint
    end
end

--@function Apply RBX properties to a table
function sh.applyRBXProperties(tab, prop)
    if not tab or not prop then return end
    for i, v in pairs(prop) do
        pcall(function() tab[i] = v end)
    end
end

--@function Has an already existing rbxprop inherit defaults
function sh.inheritDefaultProperties(defaults, rbxprop)
    if not defaults or not rbxprop then return end
    for i, v in pairs(defaults) do
        if rbxprop[i] ~= nil then continue end
        rbxprop[i] = v
    end
    return rbxprop
end

function sh.fillAssetID(id)
    if not string.match(tostring(id), "assetid") then
        id = "rbxassetid://" .. tostring(id)
    end
    return id
end

function sh.initComponentFolders(component, folders)
    component.Folders = folders or {Buttons = true, Labels = true, Images = true}
    for i, _ in pairs(component.Folders) do
        component.Folders[i] = Instance.new("Folder", component.Instance)
        component.Folders[i].Name = i
        component[i] = {}
    end
end

--@enum Preset Gui Sizes
sh.SizeEnum = {
    Full = UDim2.fromScale(1, 1),
    Half = UDim2.fromScale(0.5, 0.5),
    Quarter = UDim2.fromScale(0.25, 0.25),
    Point = UDim2.fromScale(0.1, 0.1)
}

--@enum Preset Gui Positions
sh.PosEnum = {
    Middle = {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5)},
    Top = {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0)},
    Bottom = {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 1)}
}

return sh