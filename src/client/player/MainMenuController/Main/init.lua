local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage:WaitForChild("Framework"))

local player = Players.LocalPlayer

local MainMenu = { UI = false }
local Pages = {}
local Modules = script.Parent.Modules

function MainMenu:init()
    if self.didInit then return end
    
    self.UI = Framework.AssetManager:InsertSeperate("UI", "UI_MAIN_MENU")
    self.UI.Parent = player.PlayerGui

    initPages(self)

    self.didInit = true

    return MainMenu
end

function MainMenu:Open()
    
end

function MainMenu:Close()
    
end

function MainMenu:OpenPage()
    
end

function MainMenu:ClosePage()
    
end

--

function initPages(self)
    local _psf = Instance.new("Folder", self.UI)
    _psf.Name = "Pages"

    for _, pf in pairs(self.UI:GetChildren()) do
        if not string.match(pf.Name, "Frame") then continue end
        local pn = string.gsub(pf.Name, "Frame", "")
        pf.Name = pn
        pf.Parent = _psf
        local pm, err = getPageModule(pn)
        if err then warn(err) continue end
        Pages[pn] = require(pm):init(pf)
    end
end

function getPageModule(name: string)
    local pm = Modules:FindFirstChild("Page_" .. name)
    if not pm then
        return false, name .. " Page does not have a Module in Modules."
    end
    return pm
end

return MainMenu