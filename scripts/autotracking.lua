-- Configuration --------------------------------------
AUTOTRACKER_ENABLE_DEBUG_LOGGING = false
-------------------------------------------------------

------------------------------------------------------
-- DEBUG LOGGING
------------------------------------------------------
print("")
print("Active Auto-Tracker Configuration")
print("---------------------------------------------------------------------")
if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
    print("Enable Debug Logging:        ", "true")
end
print("---------------------------------------------------------------------")
print("")

--
-- Script variables
--

--
-- Invoked when the auto-tracker is activated/connected
--
function autotracker_started()

end

-- Print a debug message if debug logging is enabled
-- Debug messages will be printed to the developer console.
--
function printDebug(message)

  if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
    print(message)
  end

end


----------------------------------------------------------------------------------------------
--OUTSIDE GAME CLEAR
----------------------------------------------------------------------------------------------
--Clears item checks on reset (looks for an item existing in Ness's first item slot since he always has to have at least 1 (ATM card))
function toggleItem(name)
if name == "clear" then
Tracker:FindObjectForCode("meteorite").Active = false
Tracker:FindObjectForCode("shackkey").Active = false
Tracker:FindObjectForCode("shynessbook").Active = false
Tracker:FindObjectForCode("policebadge").Active = false
Tracker:FindObjectForCode("bills").Active = false
Tracker:FindObjectForCode("pencileraser").Active = false
Tracker:FindObjectForCode("bluekey").Active = false
Tracker:FindObjectForCode("franklinbadge").Active = false
Tracker:FindObjectForCode("zombiepaper").Active = false
Tracker:FindObjectForCode("flyhoney").Active = false
Tracker:FindObjectForCode("skyrunner").Active = false
Tracker:FindObjectForCode("gum").Active = false
Tracker:FindObjectForCode("eraser").Active = false
Tracker:FindObjectForCode("talahramah").Active = false
Tracker:FindObjectForCode("diamond").Active = false
Tracker:FindObjectForCode("troutyogurt").Active = false
Tracker:FindObjectForCode("banana").Active = false
Tracker:FindObjectForCode("tinyruby").Active = false
Tracker:FindObjectForCode("heiroglyph").Active = false
Tracker:FindObjectForCode("hawkeye").Active = false
Tracker:FindObjectForCode("tendakraut").Active = false
Tracker:FindObjectForCode("carrotkey").Active = false
else
item = Tracker:FindObjectForCode(name)
  if item then
    item.Active = true
  else
    printDebug("Unable to find item: " .. name)
  end
end
end


------------------------------------
-- TELEPORT CHECKS
------------------------------------

function toggleTeleport(byteValue, flag, name)

  teleport = Tracker:FindObjectForCode(name)
  if teleport then
    teleport.Active = (byteValue & flag) ~= 0
  else
    printDebug("Unable to find teleport: " .. name)
  end

end

function updateTeleport1(segment)

  local teleByte1 = segment:ReadUInt8(0x7E9C22)
  local teleByte2 = segment:ReadUInt8(0x7E9C23)

    toggleTeleport(teleByte1, 0x01, "onett")
    toggleTeleport(teleByte1, 0x02, "twoson")
    toggleTeleport(teleByte1, 0x04, "threed")
    toggleTeleport(teleByte1, 0x08, "winters")
    toggleTeleport(teleByte1, 0x10, "saturnvalley")
    toggleTeleport(teleByte1, 0x20, "fourside")
    toggleTeleport(teleByte1, 0x40, "summers")
    toggleTeleport(teleByte1, 0x80, "dalaam")
    toggleTeleport(teleByte2, 0x01, "scaraba")
    toggleTeleport(teleByte2, 0x02, "deepdarkness")
    toggleTeleport(teleByte2, 0x04, "tendavillage")
    toggleTeleport(teleByte2, 0x08, "lostunderworld")

end

function updateTeleport2(segment)

  local teleByte3 = segment:ReadUInt8(0x7E9C52)

    toggleTeleport(teleByte3, 0x08, "dustydunes")

end

function updateTeleport3(segment)


  local teleByte4 = segment:ReadUInt8(0x7E9C12)

    toggleTeleport(teleByte4, 0x80, "magicant")

end


-------------------------------------------------------------------------------
--ACCESS CHECKS (leverages teleport toggle function since it's the same method)
-------------------------------------------------------------------------------

--Check to see if threed tunnels open/Belch's base boss defeated
function updateSaturn(segment)


  local accessByte1 = segment:ReadUInt8(0x7E9C10)

    toggleTeleport(accessByte1, 0x40, "mrsaturn")

end


--Check to see if Scaraba's boat is available(post Cake-lady)
function updateBoat(segment)


  local accessByte2 = segment:ReadUInt8(0x7EB60C)

    toggleTeleport(accessByte2, 0x01, "cakelady")

end

--Check to see if twoson/north Onett open in rando start (Police Boss Defeated)
function updateCop(segment)


  local accessByte3 = segment:ReadUInt8(0x7E9C15)

    toggleTeleport(accessByte3, 0x01, "nonett")

end

--Check to see if Police Badge turned in (fix for if defeated and saved/reloaded)
function updateCopBadge(segment)


  local accessByte4 = segment:ReadUInt8(0x7EB600)

    toggleTeleport(accessByte4, 0x40, "policebadge")

end

--Check to see if Yogurt Machine turned in (fix for if turned in but Monotoli building not completed and saved/reloaded)
function updateYogurt(segment)


  local accessByte5 = segment:ReadUInt8(0x7E9C19)

    toggleTeleport(accessByte5, 0x10, "troutyogurt")

end
------------------------------------------------------
-- SANCTUARY CHECKS
------------------------------------------------------

function updateSanctuary(segment)

  local sancByte1 = segment:ReadUInt8(0x7E9C1E)
  local sancByte2 = segment:ReadUInt8(0x7E9C1F)

    toggleTeleport(sancByte1, 0x20, "giantstep")
    toggleTeleport(sancByte1, 0x40, "lilliput")
    toggleTeleport(sancByte1, 0x80, "rainycircle")
    toggleTeleport(sancByte2, 0x01, "milkywell")
    toggleTeleport(sancByte2, 0x02, "magnethill")
    toggleTeleport(sancByte2, 0x04, "pinkcloud")
    toggleTeleport(sancByte2, 0x08, "luminehall")
	toggleTeleport(sancByte2, 0x10, "firespring")
end


------------------------------------------------------
-- PARTY CHECKS
------------------------------------------------------

--Iterates through party slots for member values (adds check for Poo/Jeff in party before revealing their items)

function updateParty(segment)
		for i = 0, 2 do

  local partyCheck = segment:ReadUInt8(0x7E988C + i)
	if partyCheck == 2 then
  PaulaParty = 1
  Tracker:FindObjectForCode("paula").Active = true
  else
  printDebug("Not Paula.")
  end
    if partyCheck == 3 then
  JeffParty = 1
  ScriptHost:AddMemoryWatch("JeffItems", 0x7E9AAF, 14, updateJeffItems)
  Tracker:FindObjectForCode("jeff").Active = true
  Tracker:FindObjectForCode("@Jeff/Jeff's Item").AvailableChestCount = 0
  else
  printDebug("Not Jeff.")
  end
    if partyCheck == 4 then
  PooParty = 1
  ScriptHost:AddMemoryWatch("PooItems", 0x7E9B0E, 14, updatePooItems)
  Tracker:FindObjectForCode("poo").Active = true
  Tracker:FindObjectForCode("@Poo/Poo's Item").AvailableChestCount = 0
  else
  printDebug("Not Poo.")
  end
end
--Clears party members checks and their items if Ness is not in first character slot
  local notInGame = segment:ReadUInt8(0x7E988B)
  if notInGame ~= 1 then
  PaulaParty = 0
  JeffParty = 0
  PooParty = 0
  Tracker:FindObjectForCode("paula").Active = false
  Tracker:FindObjectForCode("jeff").Active = false
  Tracker:FindObjectForCode("poo").Active = false
  Tracker:FindObjectForCode("@Jeff/Jeff's Item").AvailableChestCount = 1
  Tracker:FindObjectForCode("@Poo/Poo's Item").AvailableChestCount = 1
  end
end

---------------------------------------------------------
--ITEM CHECKS
---------------------------------------------------------

--NESS ITEMS (also if first slot empty clears all checks, see Outside Game Clear section at top
function updateNessItems(segment)

	if segment:ReadUInt8(0x7E99F1) == 0 then
    toggleItem("clear")
	end
		for i = 0, 13 do

  local nessByte = segment:ReadUInt8(0x7E99F1 + i)

		if nessByte == 193 then
    toggleItem("meteorite")
	end
		if nessByte == 170 then
    toggleItem("shackkey")
	end
		if nessByte == 164 then
    toggleItem("shynessbook")
	end
		if nessByte == 172 then
    toggleItem("policebadge")
	end
		if nessByte == 180 then
    toggleItem("bills")
	end
		if nessByte == 184 then
    toggleItem("pencileraser")
	end
		if nessByte == 171 then
    toggleItem("bluekey")
	end
		if nessByte == 1 then
    toggleItem("franklinbadge")
	end
		if nessByte == 174 then
    toggleItem("zombiepaper")
	end
		if nessByte == 105 then
    toggleItem("flyhoney")
	end
		if nessByte == 203 then
    toggleItem("skyrunner")
	end
		if nessByte == 104 then
    toggleItem("gum")
	end
		if nessByte == 210 then
    toggleItem("eraser")
	end
		if nessByte == 173 then
    toggleItem("talahramah")
	end
		if nessByte == 182 then
    toggleItem("diamond")
	end
		if nessByte == 139 then
    toggleItem("troutyogurt")
	end
		if nessByte == 183 then
    toggleItem("banana")
	end
		if nessByte == 208 then
    toggleItem("tinyruby")
	end
		if nessByte == 185 then
    toggleItem("heiroglyph")
	end
		if nessByte == 175 then
    toggleItem("hawkeye")
	end
		if nessByte == 211 then
    toggleItem("tendakraut")
	end
		if nessByte == 253 then
    toggleItem("carrotkey")
	end
		end
end

--PAULA'S ITEMS

function updatePaulaItems(segment)

		for i = 0, 13 do

  local paulaByte = segment:ReadUInt8(0x7E9A50 + i)

		if paulaByte == 193 then
    toggleItem("meteorite")
	end
		if paulaByte == 170 then
    toggleItem("shackkey")
	end
		if paulaByte == 164 then
    toggleItem("shynessbook")
	end
		if paulaByte == 172 then
    toggleItem("policebadge")
	end
		if paulaByte == 180 then
    toggleItem("bills")
	end
		if paulaByte == 184 then
    toggleItem("pencileraser")
	end
		if paulaByte == 171 then
    toggleItem("bluekey")
	end
		if paulaByte == 1 then
    toggleItem("franklinbadge")
	end
		if paulaByte == 174 then
    toggleItem("zombiepaper")
	end
		if paulaByte == 105 then
    toggleItem("flyhoney")
	end
		if paulaByte == 203 then
    toggleItem("skyrunner")
	end
		if paulaByte == 104 then
    toggleItem("gum")
	end
		if paulaByte == 210 then
    toggleItem("eraser")
	end
		if paulaByte == 173 then
    toggleItem("talahramah")
	end
		if paulaByte == 182 then
    toggleItem("diamond")
	end
		if paulaByte == 139 then
    toggleItem("troutyogurt")
	end
		if paulaByte == 183 then
    toggleItem("banana")
	end
		if paulaByte == 208 then
    toggleItem("tinyruby")
	end
		if paulaByte == 185 then
    toggleItem("heiroglyph")
	end
		if paulaByte == 175 then
    toggleItem("hawkeye")
	end
		if paulaByte == 211 then
    toggleItem("tendakraut")
	end
		if paulaByte == 253 then
    toggleItem("carrotkey")
	end
		end
end

--JEFF'S ITEMS

function updateJeffItems(segment)

		for i = 0, 13 do

  local jeffByte = segment:ReadUInt8(0x7E9AAF + i)
  if JeffParty == 1 then
		if jeffByte == 193 then
    toggleItem("meteorite")
	end
		if jeffByte == 170 then
    toggleItem("shackkey")
	end
		if jeffByte == 164 then
    toggleItem("shynessbook")
	end
		if jeffByte == 172 then
    toggleItem("policebadge")
	end
		if jeffByte == 180 then
    toggleItem("bills")
	end
		if jeffByte == 184 then
    toggleItem("pencileraser")
	end
		if jeffByte == 171 then
    toggleItem("bluekey")
	end
		if jeffByte == 1 then
    toggleItem("franklinbadge")
	end
		if jeffByte == 174 then
    toggleItem("zombiepaper")
	end
		if jeffByte == 105 then
    toggleItem("flyhoney")
	end
		if jeffByte == 203 then
    toggleItem("skyrunner")
	end
		if jeffByte == 104 then
    toggleItem("gum")
	end
		if jeffByte == 210 then
    toggleItem("eraser")
	end
		if jeffByte == 173 then
    toggleItem("talahramah")
	end
		if jeffByte == 182 then
    toggleItem("diamond")
	end
		if jeffByte == 139 then
    toggleItem("troutyogurt")
	end
		if jeffByte == 183 then
    toggleItem("banana")
	end
		if jeffByte == 208 then
    toggleItem("tinyruby")
	end
		if jeffByte == 185 then
    toggleItem("heiroglyph")
	end
		if jeffByte == 175 then
    toggleItem("hawkeye")
	end
		if jeffByte == 211 then
    toggleItem("tendakraut")
	end
		if jeffByte == 253 then
    toggleItem("carrotkey")
	end

else
  printDebug("Jeff not in party.")
  end
end
end

--POO'S ITEMS

function updatePooItems(segment)

		for i = 0, 13 do

  local pooByte = segment:ReadUInt8(0x7E9B0E + i)
  if PooParty == 1 then
		if pooByte == 193 then
    toggleItem("meteorite")
	end
		if pooByte == 170 then
    toggleItem("shackkey")
	end
		if pooByte == 164 then
    toggleItem("shynessbook")
	end
		if pooByte == 172 then
    toggleItem("policebadge")
	end
		if pooByte == 180 then
    toggleItem("bills")
	end
		if pooByte == 184 then
    toggleItem("pencileraser")
	end
		if pooByte == 171 then
    toggleItem("bluekey")
	end
		if pooByte == 1 then
    toggleItem("franklinbadge")
	end
		if pooByte == 174 then
    toggleItem("zombiepaper")
	end
		if pooByte == 105 then
    toggleItem("flyhoney")
	end
		if pooByte == 203 then
    toggleItem("skyrunner")
	end
		if pooByte == 104 then
    toggleItem("gum")
	end
		if pooByte == 210 then
    toggleItem("eraser")
	end
		if pooByte == 173 then
    toggleItem("talahramah")
	end
		if pooByte == 182 then
    toggleItem("diamond")
	end
		if pooByte == 139 then
    toggleItem("troutyogurt")
	end
		if pooByte == 183 then
    toggleItem("banana")
	end
		if pooByte == 208 then
    toggleItem("tinyruby")
	end
		if pooByte == 185 then
    toggleItem("heiroglyph")
	end
		if pooByte == 175 then
    toggleItem("hawkeye")
	end
		if pooByte == 211 then
    toggleItem("tendakraut")
	end
		if pooByte == 253 then
    toggleItem("carrotkey")
	end
else
  printDebug("Poo not in party.")
  end
  end
end

--STORAGE ITEMS (normally not needed but in the case of a long seed where the tracker is reopened and a key item is in storage, it won't be missed)

function updateXpressItems(segment)
		for i = 0, 23 do

  local xpressByte = segment:ReadUInt8(0x7E984B + i)

		if xpressByte == 193 then
    toggleItem("meteorite")
	end
		if xpressByte == 170 then
    toggleItem("shackkey")
	end
		if xpressByte == 164 then
    toggleItem("shynessbook")
	end
		if xpressByte == 172 then
    toggleItem("policebadge")
	end
		if xpressByte == 180 then
    toggleItem("bills")
	end
		if xpressByte == 184 then
    toggleItem("pencileraser")
	end
		if xpressByte == 171 then
    toggleItem("bluekey")
	end
		if xpressByte == 1 then
    toggleItem("franklinbadge")
	end
		if xpressByte == 174 then
    toggleItem("zombiepaper")
	end
		if xpressByte == 105 then
    toggleItem("flyhoney")
	end
		if xpressByte == 203 then
    toggleItem("skyrunner")
	end
		if xpressByte == 104 then
    toggleItem("gum")
	end
		if xpressByte == 210 then
    toggleItem("eraser")
	end
		if xpressByte == 173 then
    toggleItem("talahramah")
	end
		if xpressByte == 182 then
    toggleItem("diamond")
	end
		if xpressByte == 139 then
    toggleItem("troutyogurt")
	end
		if xpressByte == 183 then
    toggleItem("banana")
	end
		if xpressByte == 208 then
    toggleItem("tinyruby")
	end
		if xpressByte == 185 then
    toggleItem("heiroglyph")
	end
		if xpressByte == 175 then
    toggleItem("hawkeye")
	end
		if xpressByte == 211 then
    toggleItem("tendakraut")
	end
		if xpressByte == 253 then
    toggleItem("carrotkey")
	end
	end
end

------------------------------------------------------
--EVENT/LOCATION CHECKS
------------------------------------------------------

function updateEvent(name, segment, address, flag)

  local trackerItem = Tracker:FindObjectForCode(name)

  if trackerItem then

    local value = segment:ReadUInt8(address)
    if (value & flag) ~= 0 then
      trackerItem.AvailableChestCount = 0
    else
      trackerItem.AvailableChestCount = 1
    end
  else
    printDebug("Update Event: Unable to find tracker item: " .. name)
  end
end

function checkEvents(segment)

updateEvent("@Pokey's House/Buzz Buzz", segment, 0x7EB600, 0x02)
updateEvent("@Lier's House/Lier's basement", segment, 0x7EB600, 0x20)
updateEvent("@Hill Top/Meteorite", segment, 0x7EB600, 0x01)
updateEvent("@Onett Library/Bookshelf", segment, 0x7EB600, 0x04)
updateEvent("@Burglin Park/Burglin Boss", segment, 0x7EB602, 0x08)
updateEvent("@Apple Kid in the Park/Apple Kid's Invention", segment, 0x7EB602, 0x01)
updateEvent("@Threed North Graveyard/Threed Prisoner", segment, 0x7EB606, 0x01)
updateEvent("@Moonside/Moonside Reward", segment, 0x7EB60A, 0x04)
updateEvent("@Monotoli Building/Monotoli Prisoner", segment, 0x7EB60A, 0x01) --prisoner
updateEvent("@Monotoli Building/Monotoli Prisoner", segment, 0x7EB60A, 0x02) --item
updateEvent("@Fourside Museum/Museum Sewers", segment, 0x7EB609, 0x80)
updateEvent("@Cabin in the valley/Cabin Prisoner", segment, 0x7EB604, 0x04)
updateEvent("@Cabin in the valley/Prisoner's Item", segment, 0x7EB604, 0x02)
updateEvent("@Happy Happy Village/BlueBlue Leader", segment, 0x7EB603, 0x80)
updateEvent("@Winters Shop/Bubblegum Saleswoman", segment, 0x7EB615, 0x80)
updateEvent("@Stonehenge/Stonehenge Base", segment, 0x7EB616, 0x40)
updateEvent("@Andonut's Lab/Nameless Mouse", segment, 0x7EB616, 0x02)
updateEvent("@Saturn Valley/Saturn Coffee", segment, 0x7EB607, 0x80)
updateEvent("@Phase Distorter/Star Master", segment, 0x7EB608, 0x20)
updateEvent("@Monkey Caves/Talah Ramah Reward", segment, 0x7EB60B, 0x02) --old man
updateEvent("@Monkey Caves/Talah Ramah Reward", segment, 0x7EB60B, 0x04) --monkey
updateEvent("@Mole Cave Mines/Mine Treasure", segment, 0x7EB60A, 0x80)
updateEvent("@Stoic Club/Magic Cake", segment, 0x7EB60C, 0x01)
updateEvent("@Summers Museum/Summers Museum", segment, 0x7EB60B, 0x80)
updateEvent("@Outside Pyramid/Star Master", segment, 0x7EB60E, 0x01)
updateEvent("@Mu Training/Trial of Nothingness", segment, 0x7EB618, 0x01)
updateEvent("@Tenda Tea/Tenda Experience", segment, 0x7EB611, 0x80)
updateEvent("@Lost Underworld/Talking Rock", segment, 0x7EB613, 0x80)
updateEvent("@Dalaam Palace/Dalaam Royalty", segment, 0x7EB617, 0x80)
updateEvent("@Topollo Theater/Runaway Debt 2", segment, 0x7EB60A, 0x10)

end

function checkEvents2(segment)

updateEvent("@Town Hall/Mayor's Gift", segment, 0x7E9C11, 0x80)
updateEvent("@Threed Tent/Tent Boss", segment, 0x7E9C12, 0x40)
updateEvent("@Pyramid/Pyramid Treasure", segment, 0x7E9C33, 0x08)
updateEvent("@Tenda Village/Tenda Chief", segment, 0x7E9C1B, 0x04)
updateEvent("@Magicant/Magicant Nightmare", segment, 0x7E9C11, 0x02)

end

function checkEvents3(segment)

updateEvent("@Deep Darkness/Swamp Kid", segment, 0x7EB60F, 0x80)

end

--------------------------------------------
--NOTES
--------------------------------------------

--There are so many things in this script that could be better in terms of optimization and even coding basics.
--I've never worked with Lua before this and I'm not really a coder. I just wanted to make this randomizer more accessible to people so don't judge too harshly! :)

--Known Issues
----------------

-- (Confirm FIXED?) If Police badge turned in but failed and saved after. police badge will not reappear automatically since it isn't returned after turning it in. (need to add check to police badge for (0x7EB600, 0x40 is badge turned in)
-- (Confirm FIXED?) If Yogurt machine is turned in but Monotoli not completed and a save/reload is done then yougurt machine is not tracked again automatically, similar to police badge issue above, (9C19 0x10)
-- Same this as above for Hawkeye, need to find revealed DD map check
-- Check what other items this could apply to...

--Check into the checks for Monotoli, have them split like cabin prisoner/kid     (No fix needed currently since always getting both at the same time, but may be worth doing at some point, Check tracks off Monotoli himself, maybe leave alone incase runner saving time by not getting character (if Teddybear or something??))
--Check into the checks for Monkey Cave, have them split like cabin prisoner/kid  (No fix needed currently since always getting both at the same time, but may be worth doing at some point, Check tracks off Monkey which would be more likely to miss for new players)


--Debug notes

--Magic cake, (fixed with boat check? or same issue as topollo/museum) (should be ok)
--Character Item "Locations" (Poo and Jeff) (fixed?)

--summers museum (fixed?)
--dalaam kid check (fixed?)
--key swap (fixed?)

--new kid check in DD (B60F 0x80?)
--needs cop beated check 0x7E9C15 0x01
--not confirmed, star master desert, magicant

--Early check work, For Deletion
-- Lier's Basement 0x7EB600, 0x20 (0x7EB600, 0x08 is talk at door, 0x7EB600, 0x10 is talk at the ladder)
-- Meteorite 0x7EB600, 0x01
-- Library 0x7EB600, 0x04  (0x7EB600, 0x40 is badge turn in)
-- Everdred 0x7EB602, 0x08 (0x7EB602, 0x04 beat)
-- Applekid 0x7EB602, 0x01 (0x7EB602, 0x02 is fed,  0x7EB601, 0x80 is paid)
-- Threed Prison 0x7EB606, 0x01 (0x7EB606, 0x04 is knocked out, 0x7EB605, 0x80 is door unbolted, 0x7EB606, 0x04 is sky runner crash)
-- Moonside  0x7EB60A, 0x04  (0x7EB609, 0x80?) 2CAB GOES FROM 3 TO 255 X80 AND X40 BOTH TRIGGER ??? no
-- Monotoli Prisoner 0x7EB60A 0x01
-- Monotoli Item 0x7EB60A 0x02
-- Topollo Theatre 0x7EB60A 0x10
-- Museum Sewer 0x7EB609, 0x80
-- Cabin Prisoner 0x7EB604, 0x04
-- Cabin Item 0x7EB604, 0x02
-- Blue Blue Leader 0x7EB603, 0x80
-- Bubblegum Saleswoman (0x7EB60A, 0x04?,  0x7EB609, 0x80?)
-- Stonehenge B616 0x40  (1225 0x04 (Tony given? backup?))
-- Nameless Mouse (0x7EB616 x02)
-- Saturn Coffee B607 0x80 (also B623 0x80 seemed to trigger as well)
-- Star Master (Giygas) B608 0x20
-- Monkey Caves x2 - Old man B60B 0x02 - monkey B60B 0x04
-- Mines 0x7EB60A 0x80
-- Magic Cake 0x7EB60C, 0x01
-- Summers Museum 0x7EB60B, 0x80
-- Star Master (Desert) (0x7E5E3C, 0x02 (OFF!?)) B60E 0x01
-- Mu Training (0x7EB618, 0x01, Doesn't retrigger but maybe ok indicator?)
-- Tenda Tea B611 0x80
-- Talking Rock (0x7EB613, 0x80)
-- Dalaam Royalty B620 0x04 (0x04 for jeff, 0x08 for poo, not reliable) B617 0x80 seems correct?

-- Belch's Base Boss (hidden check, move to/use items/teleport section?) 9C10 0x40
-- Mayor 0x7E9C11, 0x80
-- Boogey Tent 0x7E9C12 0x40
-- Pyramid Treasure 0x7E9C33, 0x08
-- Tenda Chief 9C1B 0x04
-- Magicant Nightmare 0x7E9C11, 0x02


--------------------------------------
--MEMORY WATCHES
--------------------------------------
printDebug("Adding memory watches")
ScriptHost:AddMemoryWatch("Teleport1", 0x7E9C22, 2, updateTeleport1)
ScriptHost:AddMemoryWatch("Teleport2", 0x7E9C52, 1, updateTeleport2)
ScriptHost:AddMemoryWatch("Teleport3", 0x7E9C12, 1, updateTeleport3)
ScriptHost:AddMemoryWatch("BelchCheck", 0x7E9C10, 1, updateSaturn)
ScriptHost:AddMemoryWatch("BoatCheck", 0x7EB60C, 1, updateBoat)
ScriptHost:AddMemoryWatch("CopCheck", 0x7E9C15, 1, updateCop)
ScriptHost:AddMemoryWatch("CopBadgeCheck", 0x7EB600, 1, updateCopBadge)
ScriptHost:AddMemoryWatch("YogurtCheck", 0x7E9C19, 1, updateYogurt)
ScriptHost:AddMemoryWatch("NessItems", 0x7E99F1, 14, updateNessItems)
ScriptHost:AddMemoryWatch("PaulaItems", 0x7E9A50, 14, updatePaulaItems)
ScriptHost:AddMemoryWatch("JeffItems", 0x7E9AAF, 14, updateJeffItems)
ScriptHost:AddMemoryWatch("PooItems", 0x7E9B0E, 14, updatePooItems)
ScriptHost:AddMemoryWatch("XpressItems", 0x7E984B, 24, updateXpressItems)
ScriptHost:AddMemoryWatch("Events", 0x7EB600, 33, checkEvents)
ScriptHost:AddMemoryWatch("Events2", 0x7E9C10, 52, checkEvents2)
ScriptHost:AddMemoryWatch("Events3", 0x7EB60F, 1, checkEvents3)
ScriptHost:AddMemoryWatch("Sanctuary", 0x7E9C1E, 2, updateSanctuary)
ScriptHost:AddMemoryWatch("PartyCheck", 0x7E988B, 4, updateParty)
