

    local Focus             = _G['FocusData']
    local TEXTURE           = [[Interface\AddOns\modui\statusbar\texture\sb.tga]]
    local NAME_TEXTURE      = [[Interface\AddOns\modui\statusbar\texture\name2.tga]]
    local BACKDROP          = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]]}
    local unit, class

    table.insert(MODUI_COLOURELEMENTS_FOR_UI, FocusFrameTexture)

    FocusFrameNameBackground:SetTexture(NAME_TEXTURE)
    FocusFrameNameBackground:SetDrawLayer'BORDER'

    FocusFrameHealthBar:SetBackdrop(BACKDROP)
    FocusFrameHealthBar:SetBackdropColor(0, 0, 0, .6)
    FocusFrameHealthBar:SetStatusBarTexture(TEXTURE)

    FocusFrameManaBar:SetBackdrop(BACKDROP)
    FocusFrameManaBar:SetBackdropColor(0, 0, 0, .6)
    FocusFrameManaBar:SetStatusBarTexture(TEXTURE)

    FocusDeadText:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
    FocusDeadText:SetShadowOffset(0, 0)
    FocusDeadText:SetTextColor(1, 0, 0)

    FocusLevelText:SetJustifyH'LEFT'
    FocusLevelText:SetPoint('LEFT', FocusFrameTextureFrame, 'CENTER', 56, -16)

    FocusPVPIcon:SetWidth(48) FocusPVPIcon:SetHeight(48)
    FocusPVPIcon:ClearAllPoints()
    FocusPVPIcon:SetPoint('CENTER', FocusFrame, 'RIGHT', -42, 16)
    FocusPVPIcon:SetDrawLayer('OVERLAY', 7)

    FocusFrame.Elite = FocusFrameTextureFrame:CreateTexture(nil, 'BORDER')
    FocusFrame.Elite:SetTexture[[Interface\AddOns\modui\unitframe\UI-TargetingFrame-Elite]]
    FocusFrame.Elite:SetWidth(128)
    FocusFrame.Elite:SetHeight(128)
    FocusFrame.Elite:SetPoint('TOPRIGHT', FocusFrame)
    FocusFrame.Elite:Hide()

    FocusFrame.Rare = FocusFrameTextureFrame:CreateTexture(nil, 'BORDER')
    FocusFrame.Rare:SetTexture[[Interface\AddOns\modui\unitframe\UI-TargetingFrame-Rare-Elite]]
    FocusFrame.Rare:SetWidth(128)
    FocusFrame.Rare:SetHeight(128)
    FocusFrame.Rare:SetPoint('TOPRIGHT', FocusFrame)
    FocusFrame.Rare:Hide()

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
        if  f:GetObjectType() == 'StatusBar'  then
            f:SetStatusBarColor(r, g, b)
        elseif
            f:GetObjectType() == 'FontString' then
            if  _G['modui_vars'].db and _G['modui_vars'].db['modWhiteStatusText'] == 0 then
                f:SetTextColor(r*1.5, g*1.5, b*1.5)
            else
                f:SetTextColor(1, 1, 1)
            end
        else
            f:SetVertexColor(r, g, b)
        end
    end

    local CheckFaction = function()
        if Focus:GetData'unitIsPlayer' then
            unit = Focus:GetData'unit'
            _, class = UnitClass(unit)
            local colour = RAID_CLASS_COLORS[class]
            FocusFrameNameBackground:SetVertexColor(colour.r, colour.g, colour.b, 1)
        end
    end

    local CheckClassification = function()
        local c = Focus:GetData'unitClassification'
        FocusFrameTexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame]]
        for _, v in pairs({FocusFrame.Elite, FocusFrame.Rare}) do
            v:Hide()
        end
        if  c == 'worldboss' or c == 'rareelite' or c == 'elite' then
            FocusFrame.Elite:Show()
        elseif c == 'rare' then
            FocusFrame.Rare:Show()
        end
    end

    local HealthUpdate = function()
        local hp, hmax  = Focus.GetHealth()

        if GetCVar'modStatus' == '0' and GetCVar'modBoth' == '0' then
            for _, v in pairs({FocusDeadText, FocusFrameHealthBarText, FocusFrameManaBarText}) do
                v:SetPoint('CENTER', FocusFrame, v == FocusFrameManaBarText and -26 or -75, -3)
            end
        end

        gradient(hp, FocusFrameHealthBarText, 0, hmax)
        gradient(hp, FocusFrameHealthBar, 0, hmax)

        if _G['modui_vars'].db['modWhiteStatusText'] == 0 then
            local pt = Focus:GetData'powerType'

            if class == 'ROGUE' or (class == 'DRUID' and pt == 3) then
                FocusFrameManaBarText:SetTextColor(250/255, 240/255, 200/255)
            elseif (unit and UnitIsPlayer(unit) and class == 'WARRIOR') or (class == 'DRUID' and pt == 1) then
                FocusFrameManaBarText:SetTextColor(250/255, 108/255, 108/255)
            else
                FocusFrameManaBarText:SetTextColor(.6, .65, 1)
            end
        else
            FocusFrameManaBarText:SetTextColor(1, 1, 1)
        end
    end

    local AuraUpdate = function()
        local cv        = _G['modui_vars'].db['modAuraOrientation']
        local buffData  = Focus.GetBuffs()
        local debuffs   = buffData.debuffs
        local debuff, dtype
        local numDebuff = 0

        for i = 1, 16 do
            if unit then
                debuff, _, dtype = UnitDebuff(unit, i)
            else
                debuff = debuffs[i]
                dtype = debuff and debuff.debuffType or nil
            end

            if debuff then
                local colour = DebuffTypeColor[dtype] or DebuffTypeColor['none']

                modSkinColor(_G['FocusFrameDebuff'..i], colour.r*.7, colour.g*.7, colour.b*.7)
                _G['FocusFrameDebuff'..i..'Border']:Hide()

                numDebuff = numDebuff + 1
            end
        end

        if Focus:GetData'unitIsFriend' then
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

    Focus:OnEvent('UNIT_FACTION', CheckFaction)
    Focus:OnEvent('UNIT_CLASSIFICATION_CHANGED', CheckClassification)
    Focus:OnEvent('UNIT_HEALTH_OR_POWER', HealthUpdate)
    Focus:OnEvent('UNIT_AURA', AuraUpdate)

    --
