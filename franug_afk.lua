-- Change the time in seconds on the next line
AFK_Seconds = 40 



require("util.timers")

afkPos = {}

function OnRoundStartAFK(event)

    Timers:RemoveTimer("AFK_Timer")

    for i = 1, 64 do
        local hController = EntIndexToHScript(i)
        if hController ~= nil and hController:GetPawn() ~= nil then
            local v = hController:GetPawn()
            if v:IsAlive() then
                --ScriptPrintMessageChatAll("anterior vivo")
                afkPos[v] = v:GetAbsOrigin()
                --ScriptPrintMessageChatAll("anterior vivo despues")
            else
                afkPos[v] = nil
            end
        end
    end

    Check_AFK()
end

function Check_AFK()
    local AFK_Countdown = AFK_Seconds
    --ScriptPrintMessageChatAll("primero")
    if not Timers:TimerExists(AFK_Timer) then
        Timers:CreateTimer("AFK_Timer", {
            callback = function()
                if AFK_Countdown <= 0 then
                    Timers:RemoveTimer("AFK_Timer")
                    Move_AFK() 
                end
                AFK_Countdown = AFK_Countdown - 1
                return 1
            end,
        })
    end
end

function Move_AFK() 
    --ScriptPrintMessageChatAll("segundo")
    for i = 1, 64 do
        local hController = EntIndexToHScript(i)

        if hController ~= nil and hController:GetPawn() ~= nil then
            local v = hController:GetPawn()
            if v:IsAlive() then
                --ScriptPrintMessageChatAll("esta vivo")
                --ScriptPrintMessageChatAll("vivo con "..v:GetAbsOrigin())
                if afkPos[v] ~= nil and CompareVectors(afkPos[v], v:GetAbsOrigin()) then
                    --ScriptPrintMessageChatAll("cogido")
                    v:SetTeam(1)
                end
            end
        end
    end
end

function CompareVectors(v1, v2)
    if v1.x == v2.x and v1.y == v2.y then
        return true
    end
    return false
end

tListenerIds = {
    ListenToGameEvent("round_start", OnRoundStartAFK, nil),
}