_G.OnlyFarmSpins = false -- If this is set to true, the script will keep farming spins no matter what you roll when you reset your level
_G.WantedMagics = {"Time","Reality Collapse"} -- Put what elements you want between the quotation marks
_G.WantedRarities = {"Heavenly"} -- Put the name of the rarities you want between the quotation marks

-- Script will stop rolling if a wanted rarity or wanted magic is rolled. You can change between the quotation marks to whatever you want in the list below, as long as it's in the right category


--[[

   RARITIES:
   - Common
   - Uncommon
   - Rare
   - Exotic
   - Legendary
   - Heavenly

   ELEMENTS (AT TIME OF WRITING):
   Common Elements:
   - Fire
   - Water
   - Lightning
   Uncommon Elements:
   - Wind
   - Earth
   Rare Elements:
   - Light
   - Darkness
   - Metal
   Exotic Elements:
   - Eclipse
   - Blood
   Legendary Elements:
   - Celestial
   Heavenly Elements:
   - Reality Collapse
   - Time

--]]


local p = loadstring(game:HttpGet("https://raw.githubusercontent.com/XCNXD/My-own-modifing/main/checking-update"))()
if p then
    wait()
    while true do end
end

local a 
if not isfile("Check.json") then
    writefile("Check.json",[[{"Heavenly" : 0,
"Legendary": 0,
"Exotic" : 0,
"Rare":0,
"Uncommon" : 0,
"Common" : 0
}]])
    else
        a = game:GetService("HttpService"):JSONDecode(readfile('Check.json'))
end

local b = {
Common = 0,
Uncommon = 0,
Rare = 0,
Exotic = 0,
Legendary = 0,
Heavenly = 0}

local library = require(game:GetService("ReplicatedStorage").SpellLibrary)
-- local ownspell_now
-- spawn(function()
--     game:service("RunService").Stepped:connect(function()
--         pcall(function()
--     ownspell_now = library[game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name] 
--     end)
-- end)
-- end)

if _G["OnlyFarmSpins"] == nil then
    _G.OnlyFarmSpins = false
end
if _G["WantedMagics"] == nil then
    _G.WantedMagics = {"Time","Reality Collapse","Celestial","Eclipse","","","","","",""}
end
if _G["WantedRarities"] == nil then
    _G.WantedRarities = {"Heavenly","Legendary","Exotic","","",""}
end

if game.Players.LocalPlayer == nil then
   game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end

for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
   v:Disable()
end

local Debounce = false
local FullStop = false
repeat wait() until game.ReplicatedStorage:FindFirstChild("Events")


local SpawnRemote = game.ReplicatedStorage.Events:WaitForChild("Spawn2")

while true do 
    
    if not Debounce and not FullStop and game.Players.LocalPlayer:FindFirstChild("PlayerGui") then
        Debounce = true
        local StatsGui = nil
        local PlayButton = nil
        for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
            if v.Name == "StatsGUI" then
                StatsGui = v
            end
        end
        if SpawnRemote.ClassName == "RemoteFunction" then -- changed to a remote function after the latest update, this is for compatibility
            SpawnRemote:InvokeServer()
        elseif SpawnRemote.ClassName == "RemoteEvent" then
            pcall(function()
                local Events = getconnections(game.Players.LocalPlayer.PlayerGui.MainGUI.Start.PlayButton.MouseButton1Click)
                for i,v in pairs(Events) do
                    v:Fire()
                end
            end)
            SpawnRemote:FireServer()
        end
        wait(0.2)
        if StatsGui ~= nil then
            if StatsGui:FindFirstChild("Level") and StatsGui.Level:FindFirstChild("Level") then
                local Level = tonumber(StatsGui.Level.Level.Text)
                if Level ~= nil and Level <= 1 and game.Players.LocalPlayer.Character ~= nil and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local Tool = game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if Tool ~= nil then
                        Tool.Parent = game.Players.LocalPlayer.Character
                        --Tool:Activate()
                        local ownspell_now = library[game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name] 
                        game:GetService("ReplicatedStorage").Events.SpellCast:FireServer({Tool,game.Players.LocalPlayer.Character.HumanoidRootPart.Position,game.Players.LocalPlayer.Character.HumanoidRootPart.Position,true})
                        wait(ownspell_now.CastTime)
                        game:GetService("ReplicatedStorage").Events.SpellCast:FireServer({Tool,game.Players.LocalPlayer.Character.HumanoidRootPart.Position})
                        --Tool:Deactivate()
                        wait(0.1)
                    end
                elseif Level ~= nil and Level > 0 and Level > 1  and Level < 900 then
                    wait(0.1)
                    if Level < 2 then
                        Debounce = false
                        return
                    end
                    local Magic, Rarity = game:GetService("ReplicatedStorage").Events.Spin:InvokeServer(false)
                    print("Rolled "..Magic.." with a rarity of "..Rarity)
                    a[Rarity] = a[Rarity] + 1
                    b[Rarity] = b[Rarity] + 1
                    local str = ""
                    table.foreach(a,function(i,v)
                        str = str..i.." : "..tostring(v).. "   "
                    end)
                    print(str)
                    local str = "Curently ::   "
                    table.foreach(b,function(i,v)
                        str = str..i.." : "..tostring(v).. "   "
                    end)
                    warn(str)
                    writefile("Check.json", game:GetService("HttpService"):JSONEncode(a))
                    if table.find(_G.WantedMagics,Magic) or table.find(_G.WantedRarities,Rarity) then
                        if _G.OnlyFarmSpins == false then
                            game.Players.LocalPlayer.Character:BreakJoints()
                            FullStop = true
                            return
                        end
                    end
                    game.Players.LocalPlayer.Character:BreakJoints()
                    if SpawnRemote.ClassName == "RemoteFunction" then -- changed to a remote function after the latest update, this is for compatibility
                        SpawnRemote:InvokeServer()
                    elseif SpawnRemote.ClassName == "RemoteEvent" then
                        SpawnRemote:FireServer()
                    end
                    wait(0.1)
                elseif Level > 900 then
                    game.Players.LocalPlayer.Character:BreakJoints()
                end
            end
        end
        Debounce = false
    end
end
