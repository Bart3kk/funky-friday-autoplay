local function getexecutor()
    local Body = game:service("HttpService"):JSONDecode((request or http_request or (syn and syn.request))({Url = "https://httpbin.org/get", Method = "GET"}).Body)
    for i, v in next, Body.headers do
        if type(i) == "string" and (i:lower():match("user") or i:lower():match("agent") or i:lower():match("user-agent")) then
            return v
        end
    end
end

local a = getexecutor()

if a == "Roblox/WinInet" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bart3kk/funky-friday-autoplay/main/script_wave.lua"))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Bart3kk/funky-friday-autoplay/main/script.lua"))()
end
