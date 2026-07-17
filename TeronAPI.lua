--General custom APIs
    --f:SetScript('OnUpdate', function()
        --f:SetScript('OnUpdate', nil)
        --for i = 1, GetNumMacros() do
           --if GetMacroInfo(i) == 'attack' then
                --EditMacro(i, 'attack', 140, '/startattack', 1)
                --return
            --end
       --end
        --CreateMacro('attack', 140, '/startattack', 1)
    --end)

    --API to get current talent IDs
    function GetCurrentClassTalentIDs()
        for tab = 1, GetNumTalentTabs() do
            for idx = 1, GetNumTalents(tab) do
                local name, _, _, _, _, _, id = GetTalentInfo(tab, idx)
                if name then
                    local msg = "Talent: " .. name
                    if id then
                        msg = msg .. " | ID: " .. id
                    else
                        msg = msg .. " | ID: (not available)"
                    end
                    DEFAULT_CHAT_FRAME:AddMessage(msg)
                end
            end
        end
    end
    -- Priority list of Greater Blessings based on Vanilla base mana costs.
    -- Greater Blessing of Kings (150 mana) is universally the cheapest.
    -- We specify Rank 1 for the others to prevent down-ranking the mana pool instantly.
    local GB_PRIORITY = {
        "Greater Blessing of Kings", 
        "Greater Blessing of Might(Rank 1)",     
        "Greater Blessing of Light(Rank 1)",
        "Greater Blessing of Wisdom(Rank 1)",
        "Greater Blessing of Salvation",
        "Greater Blessing of Sanctuary"
    }

    function CastThreatBlessing()
        local classCounts = {}
        local classRepresentatives = {}
        
        local numRaid = GetNumRaidMembers()
        local numParty = GetNumPartyMembers()
        
        -- Helper function to tally units that are alive and in buff range
        local function TallyUnit(unit)
            if UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
                -- CheckInteractDistance(unit, 4) checks the 28-yard follow distance.
                -- This acts as a highly reliable proxy to ensure the unit is actually 
                -- close enough to receive the 30-yard blessing buff.
                if CheckInteractDistance(unit, 4) or unit == "player" then
                    local _, enClass = UnitClass(unit)
                    if enClass then
                        classCounts[enClass] = (classCounts[enClass] or 0) + 1
                        classRepresentatives[enClass] = unit
                    end
                end
            end
        end

        -- 1. Scan the Group and Tally Classes
        if numRaid > 0 then
            for i = 1, numRaid do
                TallyUnit("raid" .. i)
            end
        elseif numParty > 0 then
            TallyUnit("player")
            for i = 1, numParty do
                TallyUnit("party" .. i)
            end
        else
            TallyUnit("player") -- Solo fallback
        end
        
        -- 2. Determine the Class with the Most Members in Range
        local maxCount = 0
        local targetClass = nil
        for class, count in pairs(classCounts) do
            if count > maxCount then
                maxCount = count
                targetClass = class
            end
        end

        if not targetClass then return end

        -- 3. Scan Spellbook to Validate Known Blessings
        local knownSpells = {}
        local spellIndex = 1
        while true do
            local spellName, spellRank = GetSpellName(spellIndex, BOOKTYPE_SPELL)
            if not spellName then break end
            
            -- Store exact macro names (e.g., "Greater Blessing of Might(Rank 1)")
            local fullName = spellName
            if spellRank and spellRank ~= "" then
                fullName = spellName .. "(" .. spellRank .. ")"
            end
            
            knownSpells[fullName] = true
            knownSpells[spellName] = true -- Fallback for unranked spells like Kings
            spellIndex = spellIndex + 1
        end

        -- 4. Select the Cheapest Available Blessing
        local spellToCast = nil
        for _, blessing in ipairs(GB_PRIORITY) do
            if knownSpells[blessing] then
                spellToCast = blessing
                break
            end
        end
        
        if not spellToCast then 
            DEFAULT_CHAT_FRAME:AddMessage("TeronAPI: No suitable Greater Blessing found.")
            return 
        end

        -- 5. Cast and Force Target (Without losing current hostile target)
        CastSpellByName(spellToCast)
        
        if SpellIsTargeting() then
            -- Force the pending spell cursor onto a representative of the target class
            SpellTargetUnit(classRepresentatives[targetClass])
            
            -- Failsafe: If the cursor is STILL targeting (e.g., unit broke line of sight 
            -- in the last millisecond), cancel the cast so the tank can still use abilities.
            if SpellIsTargeting() then
                SpellStopTargeting()
            end
        end
    end
--Shaman custom APIs
    --Magma Totem casting function--
    --function CastMagmaTotem()
    --local rule_1 = "Magma Totem";
    --local rule_2 = "Teronstorm's Creation";
    --text_target = nil;
    --sub_text_target = nil;
    --distance_check = nil;

    --text_target = TargetByName("Magma Totem", true)
    --TargetByName("Teronstorm's Creation", true)
    --- func descif not text_target == rule_1 and not sub_text_target == rule_2 and not distance_check then
        --print(UnitName("target"))
        --CastSpellByName("Magma Totem")
    --else  
        --TargetNearestEnemy()
        
    --end
    --end

    --Searing Totem casting function--
    --function CastSearingTotem()
    --TargetByName("Searing Totem Teronblood", true) 
    --if not CheckInteractDistance("target",2) then
        --CastSpellByName("Searing Totem") 
    --else 
        --TargetNearestEnemy() 
    --end
    --end

    --function MagmaTotemCooldown()
    --TargetByName("Magma Totem", true)
    --if Ttwist == nil or (GetTime()-Ttwist>20) then 
        --Ttwist=GetTime() 
        --CastSpellByName("Magma Totem")
    --elseif not CheckInteractDistance("target",2) then
        --Ttwist=GetTime() 
        --CastSpellByName("Magma Totem")
    --else
        --TargetNearestEnemy()
    --end
    --end

    --function SearingTotemCooldown()
    --i = nil
    --TargetByName("Searing Totem", true) 
    --if Ttwist == nil or (GetTime()-Ttwist>55) then
        --Ttwist=GetTime()
        --CastSpellByName("Searing Totem")
    --elseif not CheckInteractDistance("target",2) then
        --Ttwist=GetTime()
        --CastSpellByName("Searing Totem") 
    --else 
        --TargetNearestEnemy() 
    --end
    --for 
    --end

--Warrior custom APIs
    --API for warrior range pull spell. Auto-attack toggle-safety is delegated to
    --TeronAutoCombat (falls back to a bare AttackTarget() if that addon isn't loaded).
    --The ranged branch below is also toggle-guarded automatically once TeronAutoCombat is
    --loaded, since it hooks CastSpellByName globally for every "Shoot X"/"Throw" name.
    function WarriorRangePull()
        if GetInventoryItemLink("player",18) ~= nil then
            local _,_,i=strfind(GetInventoryItemLink("player",18),"\124Hitem:(%d+)");
            local _,_,_,_,_,p=GetItemInfo(i);
            local t={};
            t.Bows="Bow"
            t.Guns="Gun"
            t.Crossbows="Crossbow"
            t.Thrown="Throw"

            if CheckInteractDistance("target", 3) then
                if TeronAutoCombat then
                    TeronAutoCombat.StartAttack();
                else
                    AttackTarget();
                end
            else
                CastSpellByName((string.gsub(t[p],"^([^T])","Shoot %1")));
            end
        else
            UIErrorsFrame:AddMessage("You don't have a ranged weapon equipped!", 1.0, 0.0, 0.0, 1.0, 2.0);
        end
    end
    --API for warrior Charge (in combat) and Intercept (out of combat)
    function WarriorChargeInterceptCast()
        local g = GetShapeshiftFormInfo;
        local c = CastSpellByName;
        t, n, bas = g(1);
        t, n, ber = g(3);
        if UnitAffectingCombat("player") then 
            if not ber then 
                c("Berserker Stance")
            else 
                c("Intercept")
            end 
        elseif not bas then 
            c("Battle Stance")
        else 
            c("Charge")
        end         
    end

    --API for warrior Intervene cast without targeting (uses target of target)
    function WarriorInterveneCast()
        local t_dead = UnitIsDeadOrGhost("targettarget");
        local t_party = UnitInParty("targettarget");
        local t_friendly = UnitIsFriend("player", "targettarget");
        local stance = GetShapeshiftFormInfo(2);

        if not t_dead and t_party and t_friendly then 
            CastSpellByName("Intervene");
        end
        
    end
    --API for warrior Battle Shout on 2 min cooldown
    --function ()
        --run local z=0 for i=1,27 do t=UnitBuff("player",i) if (t and strfind(t,"ThunderBolt")) then z=1 break end end if z==1 then CastSpellByName("Judgement") else CastSpellByName("Seal of Righteousness") end 
    --end

    --API for warrior Heroic Strike, that's usable only above a certain amount of rage
    function WarriorSpecifiedHeroicStrike()
        if n~= 1 and UnitMana("player")>=40 then
            CastSpellByName("Heroic Strike") n=1;
        else 
            SpellStopCasting() n=0;
        end
    end

    --API for warrior Berserker Rage cast (also switches stances)
    function WarriorBerserkerRageCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(3);
        if not isActive then 
            CastSpellByName("Berserker Stance");
        else 
            CastSpellByName("Berserker Rage");
        end
    end

    --API for warrior Disarm cast (also switches stances)
    function WarriorDisarmCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if not isActive then 
            CastSpellByName("Defensive Stance");
        else 
            CastSpellByName("Disarm");
        end
    end

    --API for warrior Mocking Blow cast (also switches stances)
    function WarriorMockingBlowCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(1);
        if not isActive then 
            CastSpellByName("Battle Stance");
        else 
            CastSpellByName("Mocking Blow");
        end
    end

    --API for warrior Taunt cast (also switches stances)
    function WarriorTauntCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if not isActive then 
            CastSpellByName("Defensive Stance");
        else 
            CastSpellByName("Taunt");
        end
    end

    --API for warrior Thunder Clap cast (also switches stances)
    function WarriorThunderClapCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if not isActive then 
            CastSpellByName("Defensive Stance");
            
        else 
            CastSpellByName("Thunder Clap");
        end
    end

    --API for warrior Sunder Armor cast (also switches stances)
    function WarriorSunderArmorCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if not isActive then 
            CastSpellByName("Defensive Stance");
        else 
            CastSpellByName("Sunder Armor");
        end
    end

    --API for warrior Sunder Armor (with 5 stacks rule) cast (also switches stances)
    --doesn't correctly display the ability in-game; need to fix
    function WarriorFiveSunderRule()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2)
        if isActive then 
            local b;
            local c;
            local i;
            for i = 1, 100 do b = UnitDebuff("target", i)
                if b and strfind(b, "Ability_Warrior_Sunder") then 
                    b, c = UnitDebuff("target", i);
                    break; 
                end
            end
            if not c or c < 5 then 
                CastSpellByName("Sunder Armor");
            end
        else 
            CastSpellByName("Defensive Stance");
        end
    end

    --API for warrior Rend cast (also switches stances)
    function WarriorRendCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if not isActive then 
            CastSpellByName("Defensive Stance");
        else 
            CastSpellByName("Rend");
        end
    end
--Paladin Custom APIs
    --Seal of Righteousness cast (cannot be cast again while the buff is active; combine with /cast Judgement in your macro)
    function CastSealOfRigheousness()
        local z=0;
        --CastSpellByName("Judgement");

        for i=1,40 do
            t=UnitBuff("player",i);
            if (t and strfind(t,"Ability_ThunderBolt")) then 
                z=1; 
                break;
            end 
        end 

        if z==0 then 
            CastSpellByName("Seal of Righteousness");
        end
    end
    --Seal of Wisdom cast (cannot be cast again while the buff is active; combine with /cast Judgement in your macro)
    function CastSealOfWisdom()
        local z=0;

        for i=1,40 do
            t=UnitBuff("player",i);
            if (t and strfind(t,"Spell_Holy_RighteousnessAura")) then 
                z=1; 
                break;
            end 
        end 

        if z==0 then 
            CastSpellByName("Seal of Wisdom");
        end

    end
    --Seal of Light cast (cannot be cast again while the buff is active; combine with /cast Judgement in your macro)
    function CastSealOfLight()
        local z=0;

        for i=1,40 do
            t=UnitBuff("player",i);
            if (t and strfind(t,"Spell_Holy_HealingAura")) then 
                z=1; 
                break;
            end 
        end 

        if z==0 then 
            CastSpellByName("Seal of Light");
        end

    end
    --Seal of Justice cast (cannot be cast again while the buff is active; combine with /cast Judgement in your macro)
    function CastSealOfJustice()
        local z=0;

        for i=1,40 do
            t=UnitBuff("player",i);
            if (t and strfind(t,"Spell_Holy_SealOfWrath")) then 
                z=1; 
                break;
            end 
        end 

        if z==0 then 
            CastSpellByName("Seal of Justice");
        end

    end
    --Seal of Command cast (cannot be cast again while the buff is active; combine with /cast Judgement in your macro)
    function CastSealOfCommand()
        local z=0;

        for i=1,40 do
            t=UnitBuff("player",i);
            if (t and strfind(t,"Ability_Warrior_InnerRage")) then 
                z=1; 
                break;
            end 
        end 

        if z==0 then 
            CastSpellByName("Seal of Command");
        end

    end
    --Seal of the Crusader cast (cannot be cast again while the buff is active; combine with /cast Judgement in your macro)
    function CastSealOfTheCrusader()
        local z=0;

        for i=1,40 do
            t=UnitBuff("player",i);
            if (t and strfind(t,"Spell_Holy_HolySmite")) then 
                z=1; 
                break;
            end 
        end 

        if z==0 then 
            CastSpellByName("Seal of the Crusader");
        end

    end
    --Divine Shield cast (upon pressing the button, it will cast the spell and then cancel it; this is useful for tanks)
    function CastDivineShield()
        local i=0;

        g=GetPlayerBuff 
        
        while not (g(i) == -1) do 
            if(strfind(GetPlayerBuffTexture(g(i)), "Spell_Holy_DivineIntervention"))then 
                CancelPlayerBuff(g(i))
            end i = i + 1; 
        end
    end
    --Divine Protection cast (upon pressing the button, it will cast the spell and then cancel it; this is useful for tanks)
    function CastDivineProtection()
        local i=0 

        g=GetPlayerBuff 

        while not (g(i) == -1) do 
            if(strfind(GetPlayerBuffTexture(g(i)), "Spell_Holy_Restoration"))then 
                CancelPlayerBuff(g(i))
            end i = i + 1; 
        end
    end

--Warlock custom APIs
    --Damage over time rotation
    function WarlockDoTRotation()
        local cast = CastSpellByName 
        local b = UnitDebuff;
        local k = "Spell_Fire_Immolation";
        for index=1,40 do 
            if strfind(tostring(UnitDebuff("target",index)),k) then
                return 1 
            end 
        end 
    
        --Immolate
        if not b("Spell_Fire_Immolation") then 
            cast("Immolate");
        --Siphon Life   
        elseif not b("Spell_Shadow_Requiem") then
            cast("Siphon Life");
        --Curse of Agony
        --elseif not b("Spell_Shadow_CurseOfSargeras") then 
            c("Curse of Agony");
        --Curse of Weakness
        elseif not b("spell_shadow_CurseOfMannoroth") then
            c("Curse of Weakness");
        --Curse of Recklessness
        --elseif not b("Spell_Shadow_UnholyStrength") then
            c("Curse of Recklessness");
        --Curse of Shadow
        --elseif not b("Spell_Shadow_CurseOfAchimonde") then 
            c("Curse of Shadow");
        --Curse of Elements
        --elseif not b("Spell_Shadow_ChillTouch") then
            c("Curse of Elements");
        --Curse of Tongues    
        --elseif not b("Spell_Shadow_CurseOfTounges") then
            c("Curse of Tongues");
        --Curse of Exhaustion    
        --elseif not b("Spell_Shadow_GrimWard") then
            c("Curse of Exhaustion");
        elseif not b("Spell_Shadow_AbominationExplosion") then 
            c("Corruption") 
        else 
            Attack();
        end
    end

--Hunter custom APIs
    --Immolation Trap
    function Hunter_ImmolationTrap()
        local f = CreateFrame"Frame";
        local in_combat = PlayerFrame.inCombat;
        local event_in_combat;
        local event_not_in_combat;

        f:RegisterEvent"PLAYER_LEAVE_COMBAT";
        f:RegisterEvent"PLAYER_ENTER_COMBAT";
        f:SetScript("OnEvent", function()
            event_in_combat = event == "PLAYER_ENTER_COMBAT";
            event_not_in_combat = event == "PLAYER_LEAVE_COMBAT";
        end)
        
        if event_in_combat and in_combat and not event_not_in_combat then
            CastSpellByName("Feign Death");
        elseif event_not_in_combat and not event_in_combat and not in_combat then
            CastSpellByName("Immolation Trap");
        else
            return;
        end
    end
    --Freezing Trap
    function Hunter_FreezingTrap()
        local f = CreateFrame"Frame";
        local in_combat = PlayerFrame.inCombat;
        local event_in_combat;
        local event_not_in_combat;

        f:RegisterEvent"PLAYER_LEAVE_COMBAT";
        f:RegisterEvent"PLAYER_ENTER_COMBAT";
        f:SetScript("OnEvent", function()
            event_in_combat = event == "PLAYER_ENTER_COMBAT";
            event_not_in_combat = event == "PLAYER_LEAVE_COMBAT";
        end)
        
        if event_in_combat and in_combat and not event_not_in_combat then
            CastSpellByName("Feign Death");
        elseif event_not_in_combat and not event_in_combat and not in_combat then
            CastSpellByName("Freezing Trap");
        else
            return;
        end
    end
    --Frost Trap
    function Hunter_FrostTrap()
        local f = CreateFrame"Frame";
        local in_combat = PlayerFrame.inCombat;
        local event_in_combat;
        local event_not_in_combat;

        f:RegisterEvent"PLAYER_LEAVE_COMBAT";
        f:RegisterEvent"PLAYER_ENTER_COMBAT";
        f:SetScript("OnEvent", function()
            event_in_combat = event == "PLAYER_ENTER_COMBAT";
            event_not_in_combat = event == "PLAYER_LEAVE_COMBAT";
        end)
        
        if event_in_combat and in_combat and not event_not_in_combat then
            CastSpellByName("Feign Death");
        elseif event_not_in_combat and not event_in_combat and not in_combat then
            CastSpellByName("Frost Trap");
        else
            return;
        end
    end
    --Explosive Trap
    function Hunter_ExplosiveTrap()
        local f = CreateFrame"Frame";
        local in_combat = PlayerFrame.inCombat;
        local event_in_combat;
        local event_not_in_combat;

        f:RegisterEvent"PLAYER_LEAVE_COMBAT";
        f:RegisterEvent"PLAYER_ENTER_COMBAT";
        f:SetScript("OnEvent", function()
            event_in_combat = event == "PLAYER_ENTER_COMBAT";
            event_not_in_combat = event == "PLAYER_LEAVE_COMBAT";
        end)
        
        if event_in_combat and in_combat and not event_not_in_combat then
            CastSpellByName("Feign Death");
        elseif event_not_in_combat and not event_in_combat and not in_combat then
            CastSpellByName("Explosive Trap");
        else
            return;
        end

    end

