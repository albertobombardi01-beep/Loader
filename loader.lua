print(game.PlaceId)
local randomtoken = math.random(111111,999999)
local gameslist = loadstring(game:HttpGet("https://raw.githubusercontent.com/albertobombardi01-beep/Loader/master/gameslist.lua?t=".. randomtoken))()

local isInGame = false
for _, gameListed: number in gameslist do
    if game.PlaceId == gameListed then  
        isInGame = true
    end
end

if isInGame then return end
print("Allah akbar")