local TweenService = game:GetService("TweenService")
-- Animations Addon for RBXUI

local Animation = {}

type AnimObject = {
    instance: any,
    tween: Tween,
    defaults: {[number]: any},
    properties: {[number]: any}
}

function clone(tab)
    local self = {}
    for i, v in pairs(tab) do
        if typeof(v) == "table" then
            self[i] = clone(v)
        else
            self[i] = v
        end
    end
    return self
end

-- Init Component Functions
function initAnimObject(inst, defaults, tweenInfo, tweenProp)
    return {
        instance = inst,
        tween = TweenService:Create(inst, tweenInfo, tweenProp),
        defaults = defaults,
        properties = tweenProp
    }
end

function initPageAnim(anima, page, tweenInfo, propFunc, defFunc)
    local function insert(v)
        table.insert(anima.animObjects, initAnimObject(v.Instance, defFunc(v.Instance), tweenInfo, propFunc(v.Instance)))
    end
    local function insertText(v)
        table.insert(anima.animObjects, initAnimObject(v.FitText.Instance, defFunc(v.FitText.Instance, true), tweenInfo, propFunc(v.FitText.Instance, true)))
    end
    local function insertImg(v)
        table.insert(anima.animObjects, initAnimObject(v.Instance, defFunc(v.Instance, false, true), tweenInfo, propFunc(v.Instance, false, true)))
    end

    insert(page)
    for _, v in pairs(page.Buttons) do
        if v.FitText then
            insertText(v.FitText)
        end
        insert(v)
    end
    for _, v in pairs(page.Labels) do
        insert(v.FitText)
        insert(v)
    end
    for _, v in pairs(page.Images) do
        insertImg(v)
    end
end

-- Presets
Animation._Presets = {}

--FadeIn
Animation._Presets.FadeIn = {}
function Animation._Presets.FadeIn._getProp(inst, isText, isImg)
    local def = {BackgroundTransparency = inst.BackgroundTransparency}
    if isText then
        def.TextTransparency = inst.TextTransparency
        def.TextStrokeTransparency = inst.TextStrokeTransparency
    elseif isImg then
        def.ImageTransparency = inst.ImageTransparency
    end
    return def
end

function Animation._Presets.FadeIn._getDef(inst, isText, isImg)
    local def = {BackgroundTransparency = 1}
    if isText then
        def.TextTransparency = 1
        def.TextStrokeTransparency = 1
    elseif isImg then
        def.ImageTransparency = 1
    end
    return def
end

function Animation._Presets.FadeIn._getTweenInfo(length)
    return TweenInfo.new(length)
end

--FadeOut
Animation._Presets.FadeOut = {}
Animation._Presets.FadeOut._getProp = Animation._Presets.FadeIn._getDef
Animation._Presets.FadeOut._getDef = Animation._Presets.FadeIn._getProp
Animation._Presets.FadeOut._getTweenInfo = Animation._Presets.FadeIn._getTweenInfo

-- Animation Class
Animation.__index = Animation
Animation.new = function(component, preset: "FadeIn" | "FadeOut", length)
    local animPreset = Animation._Presets[preset]
    local self = setmetatable({}, Animation)
    self.component = component
    self.animObjects = {} :: {AnimObject}
    if component.UIType == "Page" then
        initPageAnim(self, component, animPreset._getTweenInfo(length), animPreset._getProp, animPreset._getDef)
    end
    return self
end

function Animation:Play()
    --[[for _, v in pairs(self.animObjects) do
        for di, def in pairs(v.defaults) do
            v[di] = def
            print(di, def)
        end
    end]]
    for _, v in pairs(self.animObjects) do
        v.tween:Play()
    end
end

function Animation:Resume()
    for _, v in pairs(self.animObjects) do
        v.tween:Play()
    end
end

function Animation:Stop()
    for _, v in pairs(self.animObjects) do
        v.tween:Stop()
    end
end

function Animation:Pause()
    for _, v in pairs(self.animObjects) do
        v.tween:Pause()
    end
end

function Animation:Finish()
    for _, v in pairs(self.animObjects) do
        v.tween:Stop()
        for di, def in pairs(v.properties) do
            v[di] = def
        end
    end
end

return Animation