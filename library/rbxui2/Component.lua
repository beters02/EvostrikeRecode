local Shared = require(script.Parent.Shared)

local Component = {}
Component.__index = Component

function Component.new(instance, rbxprop, def)
    local self = setmetatable({}, Component)
    self.Instance = instance
    Shared.applyRBXPropertiesInstance(self.Instance, rbxprop, def)
end

function Component:Enable()
    self.Instance.Visible = true
end

function Component:Disable()
    self.Instance.Visible = false
end

function Component:SetPos(pos, anchorPoint)
    if pos then self.Instance.Position = pos end
    if anchorPoint then self.Instance.AnchorPoint = anchorPoint end
end

function Component:SetSize(size)
    self.Instance.Size = size
end

return Component