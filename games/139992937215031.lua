local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "Shoot niggers",
   ShowText = "Hateiggers", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)
})

local Tab = Window:CreateTab("Niggers Tab")
local Section = Tab:CreateSection("Fuck niggers")

local sprayenabled = false
local Spraying = Tab:CreateToggle({
   Name = "Spraying",
   CurrentValue = false,
   Flag = "s",
   Callback = function(Value)
      sprayenabled = value
   end,
})

local isSpraying = false
game