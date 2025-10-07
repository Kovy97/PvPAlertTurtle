-- PvPAlertTurtle (Vanilla 1.12) v1.7
-- Alert ONLY when your target (player OR NPC) is PvP-flagged AND belongs to the opposing faction.
-- ASCII-only messages for Vanilla clients.

PvPAlertTurtle_Config = {
  soundEnabled     = true,
  throttleSeconds  = 1.0,
  fallbackEnemyIfNoFaction = false, -- if true: when UnitFactionGroup(target) is nil (some NPCs), use UnitIsEnemy as fallback
}

-- ===== Utils =====
local function unitExists(u) return UnitExists and UnitExists(u) end
local function isEnemy(u)  return UnitIsEnemy and UnitIsEnemy("player", u) end
local function isPlayer(u) return UnitIsPlayer and UnitIsPlayer(u) end

local function isPvPFlagged(u)
  local v1 = UnitIsPVP and UnitIsPVP(u)
  local v2 = UnitIsPVPFreeForAll and UnitIsPVPFreeForAll(u)
  return (v1 == 1 or v1 == true) or (v2 == 1 or v2 == true)
end

local function faction(u)
  if not UnitFactionGroup then return nil end
  return UnitFactionGroup(u)
end

local function isOpposingFaction(u)
  local me = faction("player")
  local tg = faction(u)
  if me and tg then return me ~= tg end
  if not tg and PvPAlertTurtle_Config.fallbackEnemyIfNoFaction then
    -- Some NPCs return nil for faction. Optionally fall back to hostility.
    return isEnemy(u) or false
  end
  return false
end

local function alert(msg)
  if RaidWarningFrame and RaidWarningFrame.AddMessage then
    RaidWarningFrame:AddMessage(msg, 1.0, 0.1, 0.1)
  elseif PvPAlertTurtleMessage and PvPAlertTurtleMessage.AddMessage then
    PvPAlertTurtleMessage:AddMessage(msg, 1.0, 0.1, 0.1, 1.0)
  end
  if UIErrorsFrame and UIErrorsFrame.AddMessage then
    UIErrorsFrame:AddMessage(msg, 1.0, 0.1, 0.1, 1.0)
  end
  if PvPAlertTurtle_Config.soundEnabled and PlaySound then
    PlaySound("igQuestFailed")
  end
end

-- Anti-spam
local lastKey, lastTime = nil, 0
local function shouldAnnounce(key)
  local now = GetTime and GetTime() or 0
  if key == lastKey and (now - lastTime) < (PvPAlertTurtle_Config.throttleSeconds or 1) then
    return false
  end
  lastKey, lastTime = key, now
  return true
end

local function handleTarget()
  if not unitExists("target") then return end

  if isPvPFlagged("target") and isOpposingFaction("target") then
    local name = (UnitName and UnitName("target")) or "Unknown"
    local typ  = isPlayer("target") and "Player" or "NPC"
    local fac  = faction("target") or "Faction unknown"
    local key  = "PVPFLAG_OPP:"..name
    if shouldAnnounce(key) then
      alert("[PvPAlertTurtle] PvP-flagged target: "..name.." ("..typ..", "..fac..")")
    end
  end
end

function PvPAlertTurtle_OnEvent(event, unit)
  if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or (event == "UNIT_FACTION" and unit == "target") then
    handleTarget()
  end
end

-- ===== Slash commands =====
-- Provide both a long and a short alias for convenience
SLASH_PVPALERTTURTLE1 = "/pvpalertturtle"
SLASH_PVPALERTTURTLE2 = "/pvpalert"
SlashCmdList["PVPALERTTURTLE"] = function(msg)
  if not msg then msg = "" end
  if string and string.lower then msg = string.lower(msg) elseif strlower then msg = strlower(msg) end

  if msg == "sound" then
    PvPAlertTurtle_Config.soundEnabled = not PvPAlertTurtle_Config.soundEnabled
    DEFAULT_CHAT_FRAME:AddMessage("PvPAlertTurtle: soundEnabled = "..tostring(PvPAlertTurtle_Config.soundEnabled))
  elseif msg == "fallback" then
    PvPAlertTurtle_Config.fallbackEnemyIfNoFaction = not PvPAlertTurtle_Config.fallbackEnemyIfNoFaction
    DEFAULT_CHAT_FRAME:AddMessage("PvPAlertTurtle: fallbackEnemyIfNoFaction = "..tostring(PvPAlertTurtle_Config.fallbackEnemyIfNoFaction))
  else
    DEFAULT_CHAT_FRAME:AddMessage("PvPAlertTurtle commands:")
    DEFAULT_CHAT_FRAME:AddMessage("  /pvpalertturtle sound   - toggle sound on/off")
    DEFAULT_CHAT_FRAME:AddMessage("  /pvpalertturtle fallback - when target has no faction, use hostility as fallback")
  end
end
