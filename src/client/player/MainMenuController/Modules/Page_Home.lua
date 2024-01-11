local Page = require(script.Parent.Parent.Components.Page)
local Home = {}

function Home:init(frame)
    Home = setmetatable(Page.new("Home", frame), Home)
    return Home
end

function Home:Connect()
    
end

return Home