print(game.PlaceId)
local gameslist = loadstring(game:HttpGet("https://raw.githubusercontent.com/albertobombardi01-beep/Loader/refs/heads/main/gameslist.lua"))()

local isInGame = false
for _, gameListed: number in gameslist do
    if game.PlaceId == gameListed then  
        isInGame = true
    end
end

if not isInGame then return end

print("Allah akbar")