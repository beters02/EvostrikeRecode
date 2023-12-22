local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))
local Assets = require(Framework.Assets.UI)
local rbxui = require(Framework.Libraries.RBXUI)

local Pages = {}

function Create()
    local gui = rbxui.Gui.new({Name = "MainMenu"})

    -- Init all Pages as Pages before their initialization functions.
    for i, _ in pairs(Pages) do
        rbxui.Page.new(gui, {Name = i, BackgroundTransparency = 1})
        print('made page ' .. tostring(i))
    end
    for _, v in pairs(Pages) do
        v(gui)
    end

    gui:SetBackgroundImage(Assets.IMG_MAIN_MENU_BG, Color3.fromRGB(63, 85, 104))
    gui:Parent()
    gui:Enable()
    return gui
end

function Pages.MainPage(gui, page)
    local mainPage = gui.Pages.MainPage

    local playButton = IconButton(mainPage, "PLAY", Assets.ICON_MENU_BURGER)
    playButton:SetPos(UDim2.fromScale(0.118,0.386))

    local settingsButton = IconButton(mainPage, "SETTINGS", Assets.ICON_SETTINGS_GEAR)
    settingsButton:SetSize(UDim2.fromScale(0.117, 0.041))
    settingsButton:SetPos(UDim2.fromScale(0.118, 0.505))
    settingsButton.FitText:SetSize(UDim2.fromScale(0.656, 0.89))
    settingsButton.FitText:SetPos(UDim2.fromScale(0.282, 0.051), Vector2.zero)
    settingsButton:LinkPage("SettingsPage")

    local inventoryButton = IconButton(mainPage, "INVENTORY", Assets.ICON_SETTINGS_GEAR)
    inventoryButton:SetSize(UDim2.fromScale(0.117, 0.041))
    inventoryButton:SetPos(UDim2.fromScale(0.239, 0.505))
    inventoryButton.FitText:SetSize(UDim2.fromScale(0.656, 0.89))
    inventoryButton.FitText:SetPos(UDim2.fromScale(0.282, 0.051), Vector2.zero)
end

function Pages.SoloPage()
    
end

function Pages.InventoryPage()
    
end

function Pages.SettingsPage(gui)
    local settingsPage = gui.Pages.SettingsPage
    local _TEMP_SETTINGS = {keybinds = {jump = "Space"}, crosshair = {}, camera = {}}
    require(script.Pages.Settings)(settingsPage, _TEMP_SETTINGS)
end

-- Components

function IconButton(page, text, icon)
    text = text or "ICON"
    local buttonLabel = rbxui.ButtonLabel.new(page, {
        Name = text .. "Button",
        Size = UDim2.fromScale(0.238, 0.106),
        BackgroundColor3 = Color3.fromRGB(96, 112, 139),
        BorderSizePixel = 0
    },
    {
        Text = text,
        Font = Enum.Font.Michroma,
        TextColor3 = Color3.new(0,0,0),
        Size = UDim2.fromScale(0.656,0.89),
        Position = UDim2.fromScale(0.292, 0),
        AnchorPoint = Vector2.zero
    })
    local image = rbxui.Image.new(buttonLabel, {
        Name = "ButtonIcon",
        Position = UDim2.fromScale(0.055,0.185),
        Size = UDim2.fromScale(0.158,0.63),
        AnchorPoint = Vector2.zero,
        ImageTransparency = 0,
        BackgroundTransparency = 1
    })
    image:SetImage(icon)
    buttonLabel.Instance.Modal = true
    return buttonLabel
end

return Create()