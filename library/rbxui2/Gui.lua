local Component = require(script.Parent.Component)
local Shared = require(script.Parent.Shared)

local Gui = {}

function Gui.new(name, rbxprop)
    assert(name, "Must specify a name for the Gui.")
    rbxprop = rbxprop or {}

    local instance = Instance.new("ScreenGui", game.ReplicatedStorage)
    local self = Component.new(instance, rbxprop, {
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        Enabled = false
    })

    self = setmetatable(self, Gui)
    self.Name = name
    self.Folders = {Pages = true}
    Shared.initComponentFolders(self, self.Folders) -- Inits as self.Folders[i] (for instances) and self[i] (for components)

    self.CurrentPage = false

    return self
end

--@function Parent a gui to a player's playergui.
function Gui:Parent(player: Player?)
    player = player or game.Players.LocalPlayer
    self.Instance.Parent = player.PlayerGui
end

function Gui:Enable()
    if self.EnableOpenMainPage and self.Pages.MainPage then
        self.Pages.MainPage:Open()
    end
    self.Instance.Enabled = true
    self.Enabled = true
end

function Gui:Disable()
    if self.CurrentPage then
        self.CurrentPage:Close()
    end
    self.Instance.Enabled = false
    self.Enabled = false
end

--@function Set the Gui's background to an image
function Gui:SetBackgroundImage(imgid, color)
    imgid = Shared.fillAssetID(imgid)
    local imglabel
    if not self.Instance:FindFirstChild("BACKGROUND_IMAGE") then
        imglabel = Instance.new("ImageLabel", self.Instance)
        imglabel.Name = "BACKGROUND_IMAGE"
        imglabel.Size = UDim2.fromScale(1, 1)
        imglabel.AnchorPoint = Vector2.new(0.5,0.5)
        imglabel.Position = UDim2.fromScale(0.5,0.5)
    end
    if color then
        imglabel.ImageColor3 = color
    end
    imglabel.Image = imgid
    imglabel.Visible = true
    return imglabel
end

function Gui:Destroy()
    --Tag.RemoveAllTags(self)
    self:Disable()
    for i, v in pairs(self.Pages) do
        v:Close()
    end
    self.Instance:Destroy()
    self = nil
end

--@enum Preset Gui Sizes
Gui.SizeEnum = {
    Full = UDim2.fromScale(1, 1),
    Half = UDim2.fromScale(0.5, 0.5),
    Quarter = UDim2.fromScale(0.25, 0.25),
    Point = UDim2.fromScale(0.1, 0.1)
}

--@enum Preset Gui Positions
Gui.PosEnum = {
    Middle = {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5)},
    Top = {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0)},
    Bottom = {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 1)}
}

return Gui