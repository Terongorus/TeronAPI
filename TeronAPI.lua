--General custom APIs
    --Auto attack - Version 1
    --doesn't correctly trigger the attack; need to fix
    function StartAutoAttack()
        TargetNearestEnemy();
        local isAttacking = false
        for i=1,120 do 
            if IsCurrentAction(i) then 
                isAttacking = true
                break
            end
        end
        
        if not isAttacking then
            CastSpellByName("Attack")
        end
    end

    --AttackTarget - Version 2
    local attacking;
    local f = CreateFrame'Frame';

    f:RegisterEvent'PLAYER_ENTER_COMBAT'
    f:RegisterEvent'PLAYER_LEAVE_COMBAT'
    f:SetScript('OnEvent', function()
        attacking = event == 'PLAYER_ENTER_COMBAT'
        target_change = event == 'PLAYER_TARGET_CHANGED'
    end)
    
    SLASH_ATTACK1 = '/startattack'
    function SlashCmdList.ATTACK(command)
        if not attacking or target_change then
            TargetNearestEnemy();
            CastSpellByName'Attack'
        end
    end

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
    --API for warrior range pull spell
    function WarriorRangePull()
        local _,_,i=strfind(GetInventoryItemLink("player",18),"\124Hitem:(%d+)");
        local _,_,_,_,_,p=GetItemInfo(i);
        local t={};
        t.Bows="Bow"
        t.Guns="Gun"
        t.Crossbows="Crossbow"
        t.Thrown="Throw"

        if CheckInteractDistance("target", 3) and (not PlayerFrame.inCombat) then
            AttackTarget();
        else
            CastSpellByName((string.gsub(t[p],"^([^T])","Shoot %1")));
        end
        
    end

    --API for warrior Charge (in combat) and Intercept (out of combat)
    function WarriorChargeInterceptCast()
        local g = GetShapeshiftFormInfo;
        local c = CastSpellByName;
        t, n, bas = g(1);
        t, n, ber = g(3);
        if UnitAffectingCombat("player") then 
            if ber then 
                c("Intercept")
            else 
                c("Berserker Stance")
            end 
        elseif bas then 
            c("Charge")
        else 
            c("Battle Stance")

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
        if isActive then 
            CastSpellByName("Berserker Rage");
        else 
            CastSpellByName("Berserker Stance");
        end
    end

    --API for warrior Disarm cast (also switches stances)
    function WarriorDisarmCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if isActive then 
            CastSpellByName("Disarm");
        else 
            CastSpellByName("Defensive Stance");
        end
    end

    --API for warrior Mocking Blow cast (also switches stances)
    function WarriorMockingBlowCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(1);
        if isActive then 
            CastSpellByName("Mocking Blow");
        else 
            CastSpellByName("Battle Stance");
        end
    end

    --API for warrior Taunt cast (also switches stances)
    function WarriorTauntCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if isActive then 
            CastSpellByName("Taunt");
        else 
            CastSpellByName("Defensive Stance");
        end
    end

    --API for warrior Thunder Clap cast (also switches stances)
    function WarriorThunderClapCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if isActive then 
            CastSpellByName("Thunder Clap");
        else 
            CastSpellByName("Defensive Stance");
        end
    end

    --API for warrior Sunder Armor cast (also switches stances)
    function WarriorSunderArmorCast()
        local _,_,isActive,_ = GetShapeshiftFormInfo(2);
        if isActive then 
            CastSpellByName("Sunder Armor");
        else 
            CastSpellByName("Defensive Stance");
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
        if isActive then 
            CastSpellByName("Rend");
        else 
            CastSpellByName("Defensive Stance");
        end
    end

