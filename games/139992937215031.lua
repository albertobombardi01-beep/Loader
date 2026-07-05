local randomtoken = math.random(111111,999999)
local uilib = loadstring(game:HttpGet("https://raw.githubusercontent.com/albertobombardi01-beep/Loader/master/ui.lua?t=".. randomtoken))()

local window = uilib:CreateWindow("Drop Balls For Brainrots")
local section = window:addSection("Main")
section:addButton("Click me!", function()
    print("Button clicked!")
end)
