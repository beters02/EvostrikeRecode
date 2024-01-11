-- SkinString : "weapon_model_skin_uuid" (uuid 0 = default skin, -1 = not player owned)
export type SkinString = string

-- If ParsedSkin weapon is not knife, typically weapon and model will be the same.
export type ParsedSkin = {
    weapon: string,
    model: string,
    skin: string,
    uuid: string,
    unsplit: string
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Framework = require(ReplicatedStorage.Framework)
local String = require(Framework.Libraries.String)

local Skins = {}

function Skins.ParseSkinString(skinStr: SkinString): ParsedSkin
    local split = string.split(skinStr, "_")
    return {weapon = split[1], model = split[2], skin = split[3], uuid = split[4], unsplit = skinStr}
end

function Skins.InsertSkin(skinStr: SkinString, net: "client" | "server"): (Model, ParsedSkin)
    local parsed = Skins.ParseSkinString(skinStr)
    local assetStr = "MODEL_" .. string.upper(parsed.weapon) .. "_"
    if parsed.weapon == "knife" then
        assetStr = assetStr .. string.upper(parsed.model) .. "_"
    end
    assetStr = assetStr .. string.upper(parsed.skin) .. "_" .. string.upper(net)
    return Framework.AssetManager:InsertSeperate("Weapons", assetStr), parsed
end

return Skins