local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage.Framework)
local String = require(Framework.Libraries.String)
local Skins = require(Framework.Modules.Skins)
local Shop = require(Framework.Modules.Shop)

local Page = require(script.Parent.Parent.Components.Page)
local Inventory = {SubPages = {}}

-- [[ CLASSES ]]

-- Contents will be the frame that stores the skin/case/key ItemFrames
local Content = {}
Content.__index = Content

function Content.new(container, index)
    local frame = container.Frame.ContentTemplate:Clone()
    frame.Parent = container.Frame
    frame.Name = "Content" .. tostring(index)
    frame.Visible = false
    local self = setmetatable(Page.new("CC_"..tostring(index), frame), Content)
    self.Container = container
    self.Items = {}
    return self
end

function Content:Destroy()
    self.Frame:Destroy()
end

-- ContentContainers are the Inventory Category SubPages (SkinPage, CasePage, KeyPage)
local ContentContainer = {}
ContentContainer.__index = ContentContainer

function ContentContainer.new(name, frame)
    local self = setmetatable({}, ContentContainer)
    self.Name = name
    self.Frame = frame
    self.Var = {CurrentOpenContent = false}
    self.Connections = {}
    self.Contents = {}
    self.Properties = {MaxFramesPerContent = 15}
    return self
end

ContentContainer.Open = Page.Open
ContentContainer.Close = Page.Close
ContentContainer.Connect = Page.Connect
ContentContainer.Disconnect = Page.Disconnect

-- Populate a ContentContainer with Contents from an ARRAY!!! of items
-- Returns an Array of Populated ContentFrames
function ContentContainer:Populate(items, itemFrameCreationCallback, ignoreDestroy)
    local populated = {}

    -- Destroy current contents if neccessary
    if #self.Contents > 0 and not ignoreDestroy then
        for _, c in pairs(self.Contents) do
            c:Destroy()
        end
    end
    self.Var.CurrentOpenContent = false

    -- get number of contents from items
    local num = math.ceil(#items/self.Properties.MaxFramesPerContent)

    -- init contents & populate frames
    local itemIndex = 0
    for pageIndex = 1, num do
        print(pageIndex)
        self.Contents[pageIndex] = Content.new(self, pageIndex)
        populated[pageIndex] = self.Contents[pageIndex]

        -- populate
        for _ = 1, self.Properties.MaxFramesPerContent do
            print(items)
            print(itemIndex)
            itemIndex += 1
            if items[itemIndex] then
                itemFrameCreationCallback(self, items[itemIndex], pageIndex)
            end
        end
    end

    return populated
end

-- Open Content & Set the CurrentOpenContent
function ContentContainer:OpenContent(index)
    if self.Var.CurrentOpenContent then
        self.var.CurrentOpenContent:Close()
    end
    self.Var.CurrentOpenContent = self.Contents[index]

    self.Contents[index]:Open()
    self:Connect()
    return self.Contents[index]
end

-- Connects Currently Opened Content
function ContentContainer:Connect()
    self:Disconnect()
    if not self.Var.CurrentOpenContent then return end
    for _, item in pairs(self.Var.CurrentOpenContent.Items) do
        table.insert(self.Connections, item.Button.MouseButton1Click:Connect(function()
            self:ItemClicked(item)
        end))
    end
end

-- Override Content Item Clicked Func
function ContentContainer:ItemClicked(itemFrame)
end

-- [[ SUBPAGE OBJECTS (ContentContainer) ]]

local CCSkin = {}
function CCSkin:init(frame)
    print(CCSkin)
    self = setmetatable(ContentContainer.new("Skin", frame), CCSkin)
    print(CCSkin)
    CCSkin.PopulateSkins(self)
    return CCSkin
end

function CCSkin:PopulateSkins()
    local inventory = {"ak103_ak103_knight_1000"} -- pretend i got this from playerData
    local equippedInventory = {ak103 = "ak103_ak103_default_0"} -- { skinStr: "weapon_model_skin_uuid" }

    -- init equipped skins as array of parsed skins so we can set them to equipped later
    local equippedArray = {}
    for _, v in pairs(equippedInventory) do
        table.insert(equippedArray, Skins.ParseSkinString(v))
        if not table.find(inventory, v) then
            table.insert(inventory, v)
        end
    end

    -- init inventory array as parsed
    for i, v in pairs(inventory) do
        inventory[i] = Skins.ParseSkinString(v)
    end

    -- populate
    ContentContainer.Populate(self, inventory, createSkinFrame, true)

    -- create equipped content frames
    --local equippedContentFrames = ContentContainer.Populate(self, equippedArray, createSkinFrame)
    --TODO: set all equipped frames to equipped
end

-- CCSkin Config
local skinCustomWeaponPositions
skinCustomWeaponPositions = {
    Get = function(invSkin)
        local par = false
        if invSkin.weapon == "knife" then
            par = skinCustomWeaponPositions.knife[invSkin.model]
        else
            par = skinCustomWeaponPositions[invSkin.weapon]
        end
        return par
    end,

    knife = {
        vec = Vector3.new(1, 0, -3),
        karambit = {vec = Vector3.new(-0.026, -0.189, -1.399)},
        default = {vec = Vector3.new(0.143, -0.5, -2.1)},
        m9bayonet = {vec = Vector3.new(-0.029, -0, -1.674)},
    },
    glock17 = {vec = Vector3.new(0.15, 0.15, -1.4)},
    deagle = {vec = Vector3.new(0, 0, -1.5)},
    intervention = {vec = Vector3.new(0.5, 0, -7)},
    vityaz = {vec = Vector3.new(0.5,0,-2.3)}
}

function createSkinFrame(self, invSkin: Skins.ParsedSkin, pageIndex: number)
    local displayName = String.firstToUpper(invSkin.model) .. " | " .. String.firstToUpper(invSkin.skin)

    local frame = self.Frame.ContentTemplate.ItemFrame:Clone()
    frame:WaitForChild("NameLabel").Text = displayName
    frame.Name = "SkinFrame_" .. displayName
    frame.Parent = self.Frame["Content" .. tostring(pageIndex)]
    frame.BackgroundColor3 = frame:GetAttribute("unequippedColor")

    if (invSkin.weapon == "knife" and invSkin.model ~= "default") or (invSkin.weapon ~= "knife" and invSkin.skin ~= "default") then
        frame:SetAttribute("rarity", Shop.GetSkinFromInvStr(invSkin.unsplit).rarity)
    end

    frame:SetAttribute("weapon", invSkin.weapon)
    frame:SetAttribute("model", invSkin.model)
    frame:SetAttribute("skin", invSkin.skin)
    frame:SetAttribute("uuid", invSkin.uuid)
    frame:SetAttribute("Equipped", false)

    local weaponModel = createSkinFrameModel(invSkin.unsplit)
    weaponModel.Parent = frame:WaitForChild("ViewportFrame")
    frame.Visible = true
    return frame
end

function createSkinFrameModel(skinStr: Skins.SkinString)
    local weaponModelObj, invSkin = Skins.InsertSkin(skinStr, "server")
    weaponModelObj.PrimaryPart = weaponModelObj.PrimaryPart or weaponModelObj.GunComponents.WeaponHandle

    -- get custom weapon positions
    local cf: CFrame = weaponModelObj.PrimaryPart.CFrame
    local pos = skinCustomWeaponPositions.Get(invSkin)
    pos = pos and pos.vec or Vector3.new(0.5,0,-3)
    weaponModelObj:SetPrimaryPartCFrame(CFrame.new(pos) * cf.Rotation)

    return weaponModelObj
end

local CCCase = {}
function CCCase:init(frame)
    return ContentContainer.new("Case", frame)
end

local CCKey = {}
function CCKey:init(frame)
    return ContentContainer.new("Key", frame)
end

-- [[ MODULE ]]

function Inventory:init(frame)
    Inventory = setmetatable(Page.new("Inventory", frame), Inventory)
    Inventory.ContentContainers = {
        Skin = CCSkin:init(frame.Skin),
        Case = CCCase:init(frame.Case),
        Key = CCKey:init(frame.Key)
    }
    return Inventory
end

function Inventory:Open()
    if not self.CurrentOpenContentContainer then
        self.CurrentOpenContentContainer = self.ContentContainers.Skin
    end

    Page.Open(self)
    self:OpenContentContainer(self.CurrentOpenContentContainer.Name)
    self.CurrentOpenContentContainer:Open()
end

function Inventory:Close()
    if self.CurrentOpenContentContainer then
        self.CurrentOpenContentContainer:Close()
    end
    Page.Close(self)
end

function Inventory:Connect()
end

function Inventory:OpenContentContainer(name: string)
    if self.CurrentOpenContentContainer then
        self.CurrentOpenContentContainer:Close()
    end
    self.CurrentOpenContentContainer = self.ContentContainers[name]
    self.ContentContainers[name]:Open()
    return self.ContentContainers[name]
end

return Inventory