local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local Assets = require(Framework.Assets.UI)
local rbxui = require(Framework.Libraries.RBXUI)

local function setting(page, index, value)
    local settingObject = rbxui.SubPage.new(page, {Name = index})
    local indexLabel = rbxui.Label.new(settingObject, {
        Name = "IndexLabel",
        Size = UDim2.fromScale(0.5, 1),
        Position = UDim2.fromScale(0,0.5),
        AnchorPoint = Vector2.zero
    }, {Text = index, Size = UDim2.fromScale(0.9, 0.8), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5)})
    local valueInsLabel = rbxui.InsertLabel.new(settingObject, {
        Name = "ValueInsLabel",
        Size = UDim2.fromScale(1, 0.5),
        Position = UDim2.fromScale(0,0),
        AnchorPoint = Vector2.zero
    }, {Text = value, Size = UDim2.fromScale(0.9, 0.8), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5)})
    return settingObject
end

local function category(mainPage, index, tabl)
    local catPage = rbxui.SubPage.new(mainPage, {
        Name = index,
        BackgroundColor3 = Color3.fromRGB(65, 65, 65),
        BackgroundTransparency = 0.9,
    })

    for i, v in pairs(tabl) do
        setting(catPage, i, v)
    end
    return catPage
end

return function(pageGui, data)
    for cati, catv in pairs(data) do
        category(pageGui, cati, catv)
    end
end
