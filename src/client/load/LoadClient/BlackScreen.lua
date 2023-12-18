local RBXUI = require(script.Parent.RBXUI) -- We use the Child UI module so it loads as fast as possible
local gui = RBXUI.Gui.new({Name = "LoadingBlackScreen"})
RBXUI.Page.new(gui, {Name = "MainPage", Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(0.5,0.5), AnchorPoint = Vector2.new(0.5,0.5), BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0,0,0)})
gui:Parent()
return gui