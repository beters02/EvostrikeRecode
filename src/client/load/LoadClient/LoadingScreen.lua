local framework = require(game.ReplicatedStorage.Framework)
local RBXUI = require(framework.Libraries.RBXUI) -- We use the main ui module here so LoadingScreen is entered into the main UI tag list.
local loadingGui = RBXUI.Gui.new({Name = "LoadingGui"})

local feetPage = RBXUI.Page.new(loadingGui, {Name = "MainPage", Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 1})
local teamPage

loadingGui:SetBackgroundImage(require(framework.Assets.HUD).IMG_MAIN_MENU_BG)
loadingGui:Parent()
return loadingGui