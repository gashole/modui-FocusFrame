

    local TEXTURE           = [[Interface\AddOns\modui\statusbar\texture\sb.tga]]
    local NAME_TEXTURE      = [[Interface\AddOns\modui\statusbar\texture\name2.tga]]
    local BACKDROP          = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]]}
    local _, class          = UnitClass'player'
    local orig              = {}

    orig.FocusFrame_CheckFaction    = FocusFrame_CheckFaction
    orig.FocusFrame_HealthUpdate    = FocusFrame_HealthUpdate
    orig.FocusDebuffButton_Update   = FocusDebuffButton_Update

    table.insert(MODUI_COLOURELEMENTS_FOR_UI, FocusFrameTexture)

    FocusFrameNameBackground:SetTexture(NAME_TEXTURE)
    FocusFrameNameBackground:SetDrawLayer'BORDER'

    FocusFrameHealthBar:SetBackdrop(BACKDROP)
    FocusFrameHealthBar:SetBackdropColor(0, 0, 0, .6)
    FocusFrameHealthBar:SetStatusBarTexture(TEXTURE)
    FocusFrameHealthBar.textLockable = 1

    FocusFrameManaBar:SetBackdrop(BACKDROP)
    FocusFrameManaBar:SetBackdropColor(0, 0, 0, .6)
    FocusFrameManaBar:SetStatusBarTexture(TEXTURE)
    FocusFrameManaBar.textLockable = 1

    FocusDeadText:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
    FocusDeadText:SetShadowOffset(0, 0)
    FocusDeadText:SetTextColor(1, 0, 0)
    FocusDeadText:SetPoint('CENTER', FocusFrameHealthBar, 0, 0)

    FocusLevelText:SetJustifyH'LEFT'
    FocusLevelText:SetPoint('LEFT', FocusFrameTextureFrame, 'CENTER', 56, -16)

    FocusPVPIcon:SetWidth(48) FocusPVPIcon:SetHeight(48)
    FocusPVPIcon:ClearAllPoints()
    FocusPVPIcon:SetPoint('CENTER', FocusFrame, 'RIGHT', -42, 16)
    FocusPVPIcon:SetDrawLayer('OVERLAY', 7)

    FocusFrame.cast:SetStatusBarTexture(TEXTURE)
    FocusFrame.cast:SetStatusBarColor(1, .4, 0)
    FocusFrame.cast:SetWidth(142) FocusFrame.cast:SetHeight(8)
    FocusFrame.cast:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                                insets = {left = -1, right = -1, top = -1, bottom = -1}})
    FocusFrame.cast:SetBackdropColor(0, 0, 0)

    FocusFrame.cast.spark:Hide()

    FocusFrame.cast.border:Hide()

    FocusFrame.cast.text:SetFont(STANDARD_TEXT_FONT, 12)
    FocusFrame.cast.text:SetShadowOffset(1, -1)
    FocusFrame.cast.text:SetPoint('TOPLEFT', FocusFrame.cast, 'BOTTOMLEFT', 2, -5)

    FocusFrame.cast.timer:SetFont(STANDARD_TEXT_FONT, 9)
    FocusFrame.cast.timer:SetShadowOffset(1, -1)
    FocusFrame.cast.timer:SetPoint('RIGHT', FocusFrame.cast, -1, 1)
    FocusFrame.cast.timer:SetText'0s'

    FocusFrame.cast.icon:SetWidth(18) FocusFrame.cast.icon:SetHeight(18)
    FocusFrame.cast.icon:SetPoint('RIGHT', FocusFrame.cast, 'LEFT', -8, 0)
    FocusFrame.cast.icon:SetTexCoord(.1, .9, .1, .9)

    local ic = CreateFrame('Frame', nil, FocusFrame.cast)
    ic:SetAllPoints(FocusFrame.cast.icon)

    modSkin(FocusFrame.cast, 12)
    modSkinPadding(FocusFrame.cast, 2, 2, 2, 2, 2, 3, 2, 3)
    modSkinColor(FocusFrame.cast, .2, .2, .2)

    modSkin(ic, 13.5)
    modSkinPadding(ic, 3)
    modSkinColor(ic, .2, .2, .2)

    for i = 1, 5 do
        local bu = _G['FocusFrameBuff'..i]
        modSkin(bu, 16)
        modSkinPadding(bu, 3)
        modSkinColor(bu, .2, .2, .2)
    end

    for i = 1, 16 do
        local bu = _G['FocusFrameDebuff'..i]
        modSkin(bu, 16)
        modSkinPadding(bu, 3)
        modSkinColor(bu, 1, 0, 0)
    end

    local gradient = function(v, f, min, max)
        if _G['modui_vars'].db['modWhiteStatusText'] == 0 then
            if v < min or v > max then return end
            if (max - min) > 0 then
                v = (v - min)/(max - min)
            else
                v = 0
            end
            if v > .5 then
                r = (1 - v)*2
                g = 1
            else
                r = 1
                g = v*2
            end
            b = 0
            f:SetTextColor(r*1.5, g*1.5, b*1.5)
        else
            f:SetTextColor(1, 1, 1)
        end
    end

    local healthUpdate = function(unit, data)
        local v, max    = data.health, data.maxHealth

        if v == 0 or max == 0 then
            return FocusFrameHealthBarText:SetText''
        end

        gradient(v or 100, FocusFrameHealthBarText, 0, max or 100)
    end

    local powerUpdate = function(unit, data)
        local v, max    = data.mana, data.maxMana
        local pt        = data.power
        local npc       = data.npc

        if v == 0 or max == 0 then
            return FocusFrameManaBarText:SetText''
        end

        if _G['modui_vars'].db['modWhiteStatusText'] == 0 then
            if class == 'ROGUE' or (class == 'DRUID' and pt == 3) then
                FocusFrameManaBarText:SetTextColor(250/255, 240/255, 200/255)
            elseif (npc == '1' and class == 'WARRIOR') or (class == 'DRUID' and pt == 1) then
                FocusFrameManaBarText:SetTextColor(250/255, 108/255, 108/255)
            else
                FocusFrameManaBarText:SetTextColor(.6, .65, 1)
            end
        else
            FocusFrameManaBarText:SetTextColor(1, 1, 1)
        end
    end

    function FocusFrame_CheckFaction(unit)
        orig.FocusFrame_CheckFaction(unit)
        if UnitIsPlayer(unit) then
            _, class = UnitClass(unit)
            local colour = RAID_CLASS_COLORS[class]
            FocusFrameNameBackground:SetVertexColor(colour.r, colour.g, colour.b, 1)
        end
    end

    function FocusFrame_HealthUpdate(unit)
        orig.FocusFrame_HealthUpdate(unit)
        local data = FocusFrame_GetFocusData(CURR_FOCUS_TARGET)

        if GetCVar'modStatus' == '0' and GetCVar'modBoth' == '0' then
            for _, v in pairs({FocusDeadText, FocusFrameHealthBarText, FocusFrameManaBarText}) do
                v:SetPoint('CENTER', FocusFrame, v == FocusFrameManaBarText and -26 or -75, -3)
            end
        end

        healthUpdate(unit, data)
        powerUpdate(unit, data)
    end

    function FocusDebuffButton_Update(unit)
        orig.FocusDebuffButton_Update(unit)
        local cv        = _G['modui_vars'].db['modAuraOrientation']
        local data      = FocusFrame_GetFocusData(CURR_FOCUS_TARGET)
        local numDebuff = 0
        local texture, dtype
        local colour

        for i = 1, 16 do
            if unit then
                texture, _, dtype = UnitDebuff(unit, i)
            else
                texture = FSPELLCASTINGCOREgetBuffs(CURR_FOCUS_TARGET)['debuffs'][i]
                dtype = texture and texture.debuffType or nil
            end
            if texture then
                colour = DebuffTypeColor[dtype] or DebuffTypeColor['none']
                modSkinColor(_G['FocusFrameDebuff'..i], colour.r*.7, colour.g*.7, colour.b*.7)
                _G['FocusFrameDebuff'..i..'Border']:Hide()
                numDebuff = numDebuff + 1
            end
        end

        if (data and data.enemy == '1') or (unit and UnitIsFriend('player', unit)) then
            if cv == 0 then
                FocusFrameBuff1:SetPoint('TOPLEFT', FocusFrame, 'BOTTOMLEFT', 7, 32)
                FocusFrameDebuff1:SetPoint('TOPLEFT', _G['FocusFrameBuff1'], 'BOTTOMLEFT', 0, -4)
            else
                FocusFrameBuff1:SetPoint('BOTTOMLEFT', FocusFrame, 'TOPLEFT', 7, -20)
                FocusFrameDebuff1:SetPoint('BOTTOMLEFT', _G['FocusFrameBuff1'], 'TOPLEFT', 0, 5)
            end
        else
            if cv == 0 then
                FocusFrameDebuff1:SetPoint('TOPLEFT', FocusFrame, 'BOTTOMLEFT', 7, 32)
                FocusFrameBuff1:SetPoint('TOPLEFT', _G['FocusFrameDebuff1'], 'BOTTOMLEFT', 0, -4)
            else
                FocusFrameDebuff1:SetPoint('BOTTOMLEFT', FocusFrame, 'TOPLEFT', 7, -20)
                if numDebuff < 5 then
                    FocusFrameBuff1:SetPoint('BOTTOMLEFT', _G['FocusFrameDebuff1'], 'TOPLEFT', 2, 5)
                elseif numDebuff > 4 and numDebuff < 10 then
                    FocusFrameBuff1:SetPoint('BOTTOMLEFT', _G['FocusFrameDebuff6'], 'TOPLEFT', 2, 5)
                elseif numDebuff > 10 then
                    FocusFrameBuff1:SetPoint('BOTTOMLEFT', _G['FocusFrameDebuff11'], 'TOPLEFT', 2, 5)
                end
            end
        end
    end

    --
