local Page = {}
Page.__index = Page

function Page.new(name, frame)
    local self = setmetatable({}, Page)
    self.Name = name
    self.Frame = frame
    self.Connections = {}
    self.Var = {}
    return self
end

function Page:Open()
    self:Connect()
    self.Frame.Visible = true
end

function Page:Close()
    self:Disconnect()
    self.Frame.Visible = false
end

function Page:Connect()
end

function Page:Disconnect()
    for _, v in pairs(self.Connections) do
        v:Disconnect()
    end
end

return Page