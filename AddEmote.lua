-- AddEmote 2.2.2
-- by Travis S. Casey (efindel@gmail.com)

-- create a namespace for our functions and variables
AddEmote = {}

-- debugging functions
AddEmote.Debug = false

local function DebugPrint(string)
  if AddEmote.Debug then
    print(string)
  end
end

-- utility function for iterating through a table in key order
-- some code borrowed from wowwiki
-- utility function to sort a table by the keys, returns an iterator
-- usage:  for title, value in AddEmote.PairsByKeys(sometable) do ... end
function AddEmote.PairsByKeys (t, f)
  local a = {}
  local n
  
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a,f)
  local i = 0
  local iter = function()
    i = i+1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end

local PairsByKeys = AddEmote.PairsByKeys

-- tables to hold the emotes
  -- for all characters
AddEmote_Emotes = {}
  -- specific to this character
AddEmote_CharacterEmotes = {}

-- get the text for an emote, letting character-specific ones
-- take priority
function AddEmote.EmoteText (emotename)
  return (AddEmote_CharacterEmotes[emotename] or AddEmote_Emotes[emotename])
end

-- okay, here's a big one.  When we have a bunch of alternatives,
-- figure out which one we want to use.  The logic is:
--   if there aren't any alternatives, return the one thing we have
--   check the alternatives to see if we have all the units needed
--   if we do, add it to the list of ones we found valid, with a
--     rank according to how many units it used
--   if none of them were valid, return everything, and let the
--     "everyone", "no class", etc. fallbacks handle it
--   if some were valid, take the highest ranked alternatives and
--     return them for the caller to pick from
function AddEmote.GetValidStrings (emotename)
  local text = AddEmote.EmoteText(emotename)

  -- if there's only one option, get back out
  -- but return it as a table, so the "unpack" will succeed
  if not string.find(text, "|") then
    return { text }
  end

  local emotestrings = { strsplit("|", text) }
  local tempstrings = {}
  local i, line, count, maxcount, foundvalid
  maxcount = 0
  foundvalid = false

  for i, line in ipairs(emotestrings) do
    if line ~= "" then 
      DebugPrint("AddEmote considering: "..line)
      count = ChatSubs.ValidUnits(line)
      if count then
        foundvalid = true
        DebugPrint("valid - "..count.." units")
        if count > maxcount then
          maxcount = count
        end
        if not tempstrings[count] then 
          tempstrings[count] = {} 
        end
        table.insert(tempstrings[count], line)
      end
    end
  end

  -- if tempstrings is empty, nothing was valid... so we just try anything
  if not foundvalid then
    return emotestrings
  else
    -- okay, we have valid tempstrings.  Now, we want to use the
    -- set of valid alternatives with the most variables
    return tempstrings[maxcount]
  end
end

-- we just created a new emote, or loaded an existing one at load time
-- now, make it be a /command
function AddEmote.Register (emotename)
  SlashCmdList["ADDEMOTE_"..emotename] = function(text)
    ChatSubs.SetText(text)
    SendChatMessage( GetRandomArgument(unpack(AddEmote.GetValidStrings(emotename))), "EMOTE" )
    ChatSubs.SetText(nil)
  end
  _G["SLASH_ADDEMOTE_"..emotename.."1"] = "/"..emotename
  print("AddEmote: registered emote "..emotename)
end

-- add a global emote
function AddEmote.AddOne (emotename, emotestring)
  AddEmote_Emotes[emotename] = emotestring
  AddEmote.Register(emotename)
end

-- add a character emote
function AddEmote.AddOneCharacter (emotename, emotestring)
  AddEmote_CharacterEmotes[emotename] = emotestring
  AddEmote.Register(emotename)
end

-- delete the emote named emotename.  Deletes character emotes first.
function AddEmote.DeleteOne (emotename)
  if not AddEmote_Emotes[emotename] and not AddEmote_CharacterEmotes[emotename] then
    print("No such AddEmote emote defined: "..emotename)
    return
  else 
    if AddEmote_CharacterEmotes[emotename] then
       AddEmote_CharacterEmotes[emotename] = nil
       print("Deleted character-specific emote: "..emotename)
    else
      AddEmote_Emotes[emotename] = nil
      print("Deleted global emote: "..emotename)
    end
    _G["SLASH_ADDEMOTE_"..emotename] = nil
    SlashCmdList["ADDEMOTE_"..emotename] = nil
  end
end

-- set up the /addemote command
SlashCmdList["ADDEMOTE_ADDEMOTE"] = function(msg)
  local command, rest = msg:match("^(%S*)%s*(.-)$")
  if command ~="" and rest ~= "" then
    AddEmote.AddOne( command, rest )
  else
    print("Syntax: /addemote emotename message")
  end
end

-- set up the /charemote command
SlashCmdList["ADDEMOTE_CHAREMOTE"] = function(msg)
  local command, rest = msg:match("^(%S*)%s*(.-)$")
  if command ~="" and rest ~= "" then
    AddEmote.AddOneCharacter( command, rest )
  else
    print("Syntax: /charemote emotename message")
  end
end

-- set up the /delemote command
SlashCmdList["ADDEMOTE_DELETEEMOTE"] = AddEmote.DeleteOne

-- set up the /listemotes command
SlashCmdList["ADDEMOTE_LISTEMOTES"] = function()
  local name, string, printthis

  local printer = function(emotetable, header)
    local name, printthis
    print(header)
    printthis = ""
    for name, _ in PairsByKeys(emotetable) do
      printthis = printthis.."/"..name..", "
      if (strlen(printthis) > 60) then
        print(printthis)
        printthis = ""
      end
    end
    if (strlen(printthis) > 0) then
      print(printthis)
    end
  end

  if next(AddEmote_Emotes) == nil then
    print("AddEmote has no global emotes defined.") 
  else
    printer(AddEmote_Emotes, "AddEmote global emotes:")
  end
  if next(AddEmote_CharacterEmotes) == nil then
    print("AddEmote has no character emotes defined.")
  else
    printer(AddEmote_CharacterEmotes, "AddEmote character emotes:")
  end
end

-- set up the /showemote command
SlashCmdList["ADDEMOTE_SHOWEMOTE"] = function(emotename)
  print(emotename.." : "..AddEmote.EmoteText(emotename))
end

-- actually add all those commands to the game
SLASH_ADDEMOTE_ADDEMOTE1 = "/addemote"
SLASH_ADDEMOTE_CHAREMOTE1 = "/charemote"
SLASH_ADDEMOTE_DELETEEMOTE1 = "/delemote"
SLASH_ADDEMOTE_LISTEMOTES1 = "/listemotes"
SLASH_ADDEMOTE_SHOWEMOTE1 = "/showemote"

-- at login time, we need to turn all the saved emotes into
-- slash commands.  This does that.
function AddEmote.OnEvent(self, event)
  local name, string

  print("AddEmote: variables loaded")
  for name, string in pairs(AddEmote_Emotes) do
    AddEmote.Register(name)
  end
  for name, string in pairs(AddEmote_CharacterEmotes) do
    AddEmote.Register(name)
  end
end

-- in order to get an event, we have to have a frame to 
-- register the event to, so create one and register
-- our event handler to it.
local frame = CreateFrame("FRAME", "AddEmote_Frame")
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent", AddEmote.OnEvent)
