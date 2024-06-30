print("Credits to mstudio45 for the ported UI lib of Linoria")
print("Credits to Wally-RBLX and his devs for making this amazing script")
print("I DO NOT OWN ANY OF THIS CODE. CREDITS TO THIS CODE AND UI LIBS ETC GO TO THEIR OWNERS.")
print("Also this comes preloaded with a legit config")

local virtualInputManager = game:GetService('VirtualInputManager')

virtualInputManager:SendKeyEvent(true, Enum.KeyCode.F9, false, game)
task.wait(0.1)
virtualInputManager:SendKeyEvent(false, Enum.KeyCode.F9, false, game)

local start = tick()
local client = game:GetService('Players').LocalPlayer;
local set_identity = (type(syn) == 'table' and syn.set_thread_identity) or setidentity or setthreadcontext
local executor = identifyexecutor and identifyexecutor() or 'Unknown'

local function fail(r) return client:Kick(r) end

-- gracefully handle errors when loading external scripts
-- added a cache to make hot reloading a bit faster
local usedCache = shared.__urlcache and next(shared.__urlcache) ~= nil

shared.__urlcache = shared.__urlcache or {}
local function urlLoad(url)
    local success, result

    if shared.__urlcache[url] then
        success, result = true, shared.__urlcache[url]
    else
        success, result = pcall(game.HttpGet, game, url)
    end

    if (not success) then
        return fail(string.format('Failed to GET url %q for reason: %q', url, tostring(result)))
    end

    local fn, err = loadstring(result)
    if (type(fn) ~= 'function') then
        return fail(string.format('Failed to loadstring url %q for reason: %q', url, tostring(err)))
    end

    local results = { pcall(fn) }
    if (not results[1]) then
        return fail(string.format('Failed to initialize url %q for reason: %q', url, tostring(results[2])))
    end

    shared.__urlcache[url] = result
    return unpack(results, 2)
end

-- attempt to block imcompatible exploits
-- rewrote because old checks literally did not work
if type(set_identity) ~= 'function' then return fail('Unsupported exploit (missing "set_thread_identity")') end
if type(getconnections) ~= 'function' then return fail('Unsupported exploit (missing "getconnections")') end
if type(getloadedmodules) ~= 'function' then return fail('Unsupported exploit (misssing "getloadedmodules")') end
if type(getgc) ~= 'function' then   return fail('Unsupported exploit (misssing "getgc")') end

local getinfo = debug.getinfo or getinfo;
local getupvalue = debug.getupvalue or getupvalue;
local getupvalues = debug.getupvalues or getupvalues;
local setupvalue = debug.setupvalue or setupvalue;

if type(setupvalue) ~= 'function' then return fail('Unsupported exploit (misssing "debug.setupvalue")') end
if type(getupvalue) ~= 'function' then return fail('Unsupported exploit (misssing "debug.getupvalue")') end
if type(getupvalues) ~= 'function' then return fail('Unsupported exploit (missing "debug.getupvalues")') end

-- free exploit bandaid fix
if type(getinfo) ~= 'function' then
    local debug_info = debug.info;
    if type(debug_info) ~= 'function' then
        -- if your exploit doesnt have getrenv you have no hope
        if type(getrenv) ~= 'function' then return fail('Unsupported exploit (missing "getrenv")') end
        debug_info = getrenv().debug.info
    end
    getinfo = function(f)
        assert(type(f) == 'function', string.format('Invalid argument #1 to debug.getinfo (expected %s got %s', 'function', type(f)))
        local results = { debug.info(f, 'slnfa') }
        local _, upvalues = pcall(getupvalues, f)
        if type(upvalues) ~= 'table' then
            upvalues = {}
        end
        local nups = 0
        for k in next, upvalues do
            nups = nups + 1
        end
        -- winning code
        return {
            source      = '@' .. results[1],
            short_src   = results[1],
            what        = results[1] == '[C]' and 'C' or 'Lua',
            currentline = results[2],
            name        = results[3],
            func        = results[4],
            numparams   = results[5],
            is_vararg   = results[6], -- 'a' argument returns 2 values :)
            nups        = nups,     
        }
    end
end

local IsMobile = table.find({Enum.Platform.IOS, Enum.Platform.Android}, game:GetService("UserInputService"):GetPlatform())
local DevicePlatform = Enum.Platform.None;
local UIRepo = 'https://raw.githubusercontent.com/Bart3kk/LinLib/main/'
local ScriptRepo = 'https://raw.githubusercontent.com/Bart3kk/funky-friday-autoplay/main/'
local UI = ''

if IsMobile then
    UI = loadstring(game:HttpGet(UIRepo .. 'MobileLibrary.lua'))
else
    UI = loadstring(game:HttpGet(UIRepo .. 'Library.lua'))()

local metadata = loadstring(game:HttpGet(ScriptRepo .. 'metadata.lua'))()
local httpService = game:GetService('HttpService')
local ThemeManager = {} do
	ThemeManager.Folder = 'LinoriaLibSettings'
	-- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end

	ThemeManager.Library = UI
	ThemeManager.BuiltInThemes = {
		['Default'] 		= { 1, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}') },
		['BBot'] 			= { 2, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}') },
		['Fatality']		= { 3, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}') },
		['Jester'] 			= { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Mint'] 			= { 5, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Tokyo Night'] 	= { 6, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}') },
		['Ubuntu'] 			= { 7, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}') },
		['Quartz'] 			= { 8, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}') },
	}

	function ThemeManager:ApplyTheme(theme)
		local customThemeData = self:GetCustomTheme(theme)
		local data = customThemeData or self.BuiltInThemes[theme]

		if not data then return end

		-- custom themes are just regular dictionaries instead of an array with { index, dictionary }

		local scheme = data[2]
		for idx, col in next, customThemeData or scheme do
			self.Library[idx] = Color3.fromHex(col)
			
			if Options[idx] then
				Options[idx]:SetValueRGB(Color3.fromHex(col))
			end
		end

		self:ThemeUpdate()
	end

	function ThemeManager:ThemeUpdate()
		-- This allows us to force apply themes without loading the themes tab :)
		local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
		for i, field in next, options do
			if Options and Options[field] then
				self.Library[field] = Options[field].Value
			end
		end

		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
		self.Library:UpdateColorsUsingRegistry()
	end

	function ThemeManager:LoadDefault()		
		local theme = 'Default'
		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')

		local isDefault = true
		if content then
			if self.BuiltInThemes[content] then
				theme = content
			elseif self:GetCustomTheme(content) then
				theme = content
				isDefault = false;
			end
		elseif self.BuiltInThemes[self.DefaultTheme] then
		 	theme = self.DefaultTheme
		end

		if isDefault then
			Options.ThemeManager_ThemeList:SetValue(theme)
		else
			self:ApplyTheme(theme)
		end
	end

	function ThemeManager:SaveDefault(theme)
		writefile(self.Folder .. '/themes/default.txt', theme)
	end

	function ThemeManager:CreateThemeManager(groupbox)
		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
		groupbox:AddLabel('Main color')	:AddColorPicker('MainColor', { Default = self.Library.MainColor });
		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
		groupbox:AddLabel('Font color')	:AddColorPicker('FontColor', { Default = self.Library.FontColor });

		local ThemesArray = {}
		for Name, Theme in next, self.BuiltInThemes do
			table.insert(ThemesArray, Name)
		end

		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)

		groupbox:AddDivider()
		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })

		groupbox:AddButton('Set as default', function()
			self:SaveDefault(Options.ThemeManager_ThemeList.Value)
			self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_ThemeList.Value))
		end)

		Options.ThemeManager_ThemeList:OnChanged(function()
			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
		end)

		groupbox:AddDivider()
		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })
		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
		groupbox:AddDivider()
		
		groupbox:AddButton('Save theme', function() 
			self:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)

			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end):AddButton('Load theme', function() 
			self:ApplyTheme(Options.ThemeManager_CustomThemeList.Value) 
		end)

		groupbox:AddButton('Refresh list', function()
			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
			Options.ThemeManager_CustomThemeList:SetValue(nil)
		end)

		groupbox:AddButton('Set as default', function()
			if Options.ThemeManager_CustomThemeList.Value ~= nil and Options.ThemeManager_CustomThemeList.Value ~= '' then
				self:SaveDefault(Options.ThemeManager_CustomThemeList.Value)
				self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_CustomThemeList.Value))
			end
		end)

		ThemeManager:LoadDefault()

		local function UpdateTheme()
			self:ThemeUpdate()
		end

		Options.BackgroundColor:OnChanged(UpdateTheme)
		Options.MainColor:OnChanged(UpdateTheme)
		Options.AccentColor:OnChanged(UpdateTheme)
		Options.OutlineColor:OnChanged(UpdateTheme)
		Options.FontColor:OnChanged(UpdateTheme)
	end

	function ThemeManager:GetCustomTheme(file)
		local path = self.Folder .. '/themes/' .. file
		if not isfile(path) then
			return nil
		end

		local data = readfile(path)
		local success, decoded = pcall(httpService.JSONDecode, httpService, data)
		
		if not success then
			return nil
		end

		return decoded
	end

	function ThemeManager:SaveCustomTheme(file)
		if file:gsub(' ', '') == '' then
			return self.Library:Notify('Invalid file name for theme (empty)', 3)
		end

		local theme = {}
		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

		for _, field in next, fields do
			theme[field] = Options[field].Value:ToHex()
		end

		writefile(self.Folder .. '/themes/' .. file .. '.json', httpService:JSONEncode(theme))
	end

	function ThemeManager:ReloadCustomThemes()
		local list = listfiles(self.Folder .. '/themes')

		local out = {}
		for i = 1, #list do
			local file = list[i]
			if file:sub(-5) == '.json' then
				-- i hate this but it has to be done ...

				local pos = file:find('.json', 1, true)
				local char = file:sub(pos, pos)

				while char ~= '/' and char ~= '\\' and char ~= '' do
					pos = pos - 1
					char = file:sub(pos, pos)
				end

				if char == '/' or char == '\\' then
					table.insert(out, file:sub(pos + 1))
				end
			end
		end

		return out
	end

	function ThemeManager:SetLibrary(lib)
		self.Library = lib
	end

	function ThemeManager:BuildFolderTree()
		local paths = {}

		-- build the entire tree if a path is like some-hub/phantom-forces
		-- makefolder builds the entire tree on Synapse X but not other exploits

		local parts = self.Folder:split('/')
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
		end

		table.insert(paths, self.Folder .. '/themes')
		table.insert(paths, self.Folder .. '/settings')

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

	function ThemeManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function ThemeManager:CreateGroupBox(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		return tab:AddLeftGroupbox('Themes')
	end

	function ThemeManager:ApplyToTab(tab)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		local groupbox = self:CreateGroupBox(tab)
		self:CreateThemeManager(groupbox)
	end

	function ThemeManager:ApplyToGroupbox(groupbox)
		assert(self.Library, 'Must set ThemeManager.Library first!')
		self:CreateThemeManager(groupbox)
	end

	ThemeManager:BuildFolderTree()
end

local framework, scrollHandler, network
local counter = 0

while true do
    for _, obj in next, getgc(true) do
        if type(obj) == 'table' then 
            if rawget(obj, 'GameUI') then
                framework = obj;
            elseif type(rawget(obj, 'Server')) == 'table' then
                network = obj;     
            end
        end

        if network and framework then break end
    end

    for _, module in next, getloadedmodules() do
        if module.Name == 'ScrollHandler' then
            scrollHandler = module;
            break;
        end
    end 

    if (type(framework) == 'table' and typeof(scrollHandler) == 'Instance' and type(network) == 'table') then
        break
    end

    counter = counter + 1
    if counter > 6 then
        fail(string.format('Failed to load game dependencies. Details: %s, %s, %s', type(framework), typeof(scrollHandler), type(network)))
    end
    wait(1)
end

local runService = game:GetService('RunService')
local userInputService = game:GetService('UserInputService')

local random = Random.new()

local task = task or getrenv().task;
local fastWait, fastSpawn = task.wait, task.spawn;

-- firesignal implementation
-- hitchance rolling
local fireSignal, rollChance do
    -- updated for script-ware or whatever
    -- attempted to update for krnl

    function fireSignal(target, signal, ...)
        -- getconnections with InputBegan / InputEnded does not work without setting Synapse to the game's context level
        set_identity(2)
        local didFire = false
        for _, signal in next, getconnections(signal) do
            if type(signal.Function) == 'function' and islclosure(signal.Function) then
                local scr = rawget(getfenv(signal.Function), 'script')
                if scr == target then
                    didFire = true
                    pcall(signal.Function, ...)
                end
            end
        end
        -- if not didFire then fail"couldnt fire input signal" end
        set_identity(7)
    end

    -- uses a weighted random system
    -- its a bit scuffed rn but it works good enough

    function rollChance()
        -- if (//library.flags.autoPlayerMode == 'Manual') then
        if Options.AutoplayerMode.Value == 'Manual' then
            if (Options.SickBind:GetState()) then return 'Sick' end
            if (Options.GoodBind:GetState()) then return 'Good' end
            if (Options.OkayBind:GetState()) then return 'Ok' end
            if (Options.BadBind:GetState()) then return 'Bad' end

            return 'Bad' -- incase if it cant find one
        end

        local chances = {
            { 'Sick', Options.SickChance.Value },
            { 'Good', Options.GoodChance.Value },
            { 'Ok', Options.OkChance.Value },
            { 'Bad', Options.BadChance.Value },
            { 'Miss' , Options.MissChance.Value },
        }

        table.sort(chances, function(a, b)
            return a[2] > b[2]
        end)

        local sum = 0;
        for i = 1, #chances do
            sum += chances[i][2]
        end

        if sum == 0 then
            return chances[random:NextInteger(1, #chances)][1]
        end

        local initialWeight = random:NextInteger(0, sum)
        local weight = 0;

        for i = 1, #chances do
            weight = weight + chances[i][2]

            if weight > initialWeight then
                return chances[i][1]
            end
        end

        return 'Sick'
    end
end

-- autoplayer
local chanceValues do
    chanceValues = { 
        Sick = 96,
        Good = 92,
        Ok = 87,
        Bad = 75,
    }

    local keyCodeMap = {}
    for _, enum in next, Enum.KeyCode:GetEnumItems() do
        keyCodeMap[enum.Value] = enum
    end

    if shared._unload then
        pcall(shared._unload)
    end

    function shared._unload()
        if shared._id then
            pcall(runService.UnbindFromRenderStep, runService, shared._id)
        end

        UI:Unload()

        for i = 1, #shared.threads do
            coroutine.close(shared.threads[i])
        end

        for i = 1, #shared.callbacks do
            task.spawn(shared.callbacks[i])
        end
    end

    shared.threads = {}
    shared.callbacks = {}

    shared._id = httpService:GenerateGUID(false)

    local function pressKey(keyCode, state)
        if Options.PressMode.Value == 'virtual input' then
            virtualInputManager:SendKeyEvent(state, keyCode, false, nil)
        else
            fireSignal(scrollHandler, userInputService[state and 'InputBegan' or 'InputEnded'], { KeyCode = keyCode, UserInputType = Enum.UserInputType.Keyboard }, false)
        end
    end

    local rng = Random.new()
    runService:BindToRenderStep(shared._id, 1, function()
        --if (not library.flags.autoPlayer) then return end
        
        if (not Toggles.Autoplayer) or (not Toggles.Autoplayer.Value) then 
            return 
        end

        local currentlyPlaying = framework.SongPlayer.CurrentlyPlaying

        if typeof(currentlyPlaying) ~= 'Instance' or not currentlyPlaying:IsA('Sound') then 
            return 
        end

        local arrows = framework.UI:GetNotes()
        local count = framework.SongPlayer:GetKeyCount()
        local mode = count .. 'Key'

        local arrowData = framework.ArrowData[mode].Arrows
        for i, arrow in next, arrows do
            -- todo: switch to this (https://i.imgur.com/pEVe6Tx.png)
            local ignoredNoteTypes = { Death = true, Mechanic = true, Poison = true }

            if type(arrow.NoteDataConfigs) == 'table' then 
                if ignoredNoteTypes[arrow.NoteDataConfigs.Type] then 
                    continue
                end
            end

            if (arrow.Side == framework.UI.CurrentSide) and (not arrow.Marked) and currentlyPlaying.TimePosition > 0 then
                local position = (arrow.Data.Position % count) .. '' 

                local hitboxOffset = 0 
                do
                    local settings = framework.Settings;
                    local offset = type(settings) == 'table' and settings.HitboxOffset;
                    local value = type(offset) == 'table' and offset.Value;

                    if type(value) == 'number' then
                        hitboxOffset = value;
                    end

                    hitboxOffset = hitboxOffset / 1000
                end

                local songTime = framework.SongPlayer.CurrentTime
                local playbackSpeed = 1
                do
                    local configs = framework.SongPlayer.CurrentSongConfigs
                    if type(configs) == 'table' and type(rawget(configs, "PlaybackSpeed")) == "number" then
                        playbackSpeed = configs.PlaybackSpeed
                    end

                    songTime = songTime / playbackSpeed
                end

                local noteTime = math.clamp((1 - math.abs(arrow.Data.Time - (songTime + hitboxOffset))) * 100, 0, 100)

                local result = rollChance()
                arrow._hitChance = arrow._hitChance or result;

                local hitChance = (Options.AutoplayerMode.Value == 'Manual' and result or arrow._hitChance)
                if hitChance ~= "Miss" and noteTime >= chanceValues[arrow._hitChance] then
                    fastSpawn(function()
                        arrow.Marked = true;
                        local keyCode = keyCodeMap[arrowData[position].Keybinds.Keyboard[1]]

                        pressKey(keyCode, true)

                        local arrowLength = arrow.Data.Length or 0
                        local isHeld = arrowLength > 0
                                
                        if isHeld then arrowLength = arrowLength / playbackSpeed end

                        local delayMode = Options.DelayMode.Value

                        local minDelay = isHeld and Options.HeldDelayMin or Options.NoteDelayMin;
                        local maxDelay = isHeld and Options.HeldDelayMax or Options.NoteDelayMax;
                        local noteDelay = isHeld and Options.HeldDelay or Options.ReleaseDelay

                        local delay = delayMode == 'Random' and rng:NextNumber(minDelay.Value, maxDelay.Value) or noteDelay.Value
                        task.wait(arrowLength + (delay / 1000))

                        pressKey(keyCode, false)
                        arrow.Marked = nil;
                    end)
                end
            end
        end
    end)
end

local ActivateUnlockables do
    -- Note: I know you can do this with UserId but it only works if you run it before opening the notes menu
    -- My script should work no matter the order of which you run things :)

    local loadStyle = nil
    local function loadStyleProxy(...)
        -- This forces the styles to reload every time
            
        local upvalues = getupvalues(loadStyle)
        for i, upvalue in next, upvalues do
            if type(upvalue) == 'table' and rawget(upvalue, 'Style') then
                rawset(upvalue, 'Style', nil);
                setupvalue(loadStyle, i, upvalue)
            end
        end

        return loadStyle(...)
    end

    local function applyLoadStyleProxy(...)
        local gc = getgc()
        for i = 1, #gc do
            local obj = gc[i]
            if type(obj) == 'function' then
                -- goodbye nups numeric loop because script-ware is weird
                local upvalues = getupvalues(obj)
                for i, upv in next, upvalues do
                    if type(upv) == 'function' and getinfo(upv).name == 'LoadStyle' then
                        -- ugly but it works, we don't know every name for is_synapse_function and similar
                        local function isGameFunction(fn)
                            return getinfo(fn).source:match('%.ArrowSelector%.Customize$')
                        end

                        if isGameFunction(obj) and isGameFunction(upv) then
                            -- avoid non-game functions :)
                            loadStyle = loadStyle or upv
                            setupvalue(obj, i, loadStyleProxy)

                            table.insert(shared.callbacks, function()
                                assert(pcall(setupvalue, obj, i, loadStyle))
                            end)
                        end
                    end
                end
            end
        end
    end

    local success, error = pcall(applyLoadStyleProxy)
    if not success then
        return fail(string.format('Failed to hook LoadStyle function. Error(%q)\nExecutor(%q)\n', error, executor))
    end

    function ActivateUnlockables()
        local idx = table.find(framework.SongsWhitelist, client.UserId)
        if idx then return end

        UI:Notify('Developer arrows have been unlocked!', 3)
        table.insert(framework.SongsWhitelist, client.UserId)
    end
end

-- UpdateScore hook
do
    while type(roundManager) ~= 'table' do
        task.wait()
        roundManager = network.Server.RoundManager
    end

    local oldUpdateScore = roundManager.UpdateScore;
    function roundManager.UpdateScore(...)
        local args = { ... }
        local score = args[2]

        if type(score) == 'number' and Options.ScoreModifier then
        --    table.foreach(args, warn)
            if Options.ScoreModifier.Value == 'No decrease on miss' then
                args[2] = 0
            elseif Options.ScoreModifier.Value == 'Increase score on miss' then
                args[2] = math.abs(score)
            end
        end

        return oldUpdateScore(unpack(args))
    end

    table.insert(shared.callbacks, function()
        roundManager.UpdateScore = oldUpdateScore
    end)
end

-- Auto ring collector
do
    local thread = task.spawn(function()
        local map = workspace:waitForChild('Map', 5)
        local buildings = map and map:waitForChild('FunctionalBuildings', 5)
        local spawners = buildings and buildings:waitForChild('RingSpawners', 5)

        if spawners == nil then return end
        if type(firetouchinterest) ~= 'function' then return end 

        while true do
            task.wait()
            if Toggles.AutoClaimRings and Toggles.AutoClaimRings.Value then
                local character = client.Character
                local rootPart = character and character:findFirstChild('HumanoidRootPart')

                if rootPart == nil then continue end

                for i, spawner in next, spawners:GetChildren() do
                    for _, ring in next, spawner:GetChildren() do
                        if ring.Name ~= 'GoldenRing' then continue end

                        local ring = ring:findFirstChild('ring')
                        if not (ring and ring:IsA('BasePart')) then continue end
                        if ring.Transparency == 1 then continue end

                        firetouchinterest(ring, rootPart, 0)
                        firetouchinterest(ring, rootPart, 1)
                    end
                end
            end
        end
    end)
    table.insert(shared.callbacks, function()
        pcall(task.cancel, thread)
    end)
end

local SaveManager = {} do
    SaveManager.Ignore = {}
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object) 
                return { type = 'Toggle', idx = idx, value = object.Value } 
            end,
            Load = function(idx, data)
                if Toggles[idx] then 
                    Toggles[idx]:SetValue(data.value)
                end
            end,
        },
        Slider = {
            Save = function(idx, object)
                return { type = 'Slider', idx = idx, value = tostring(object.Value) }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValue(data.value)
                end
            end,
        },
        Dropdown = {
            Save = function(idx, object)
                return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValue(data.value)
                end
            end,
        },
        ColorPicker = {
            Save = function(idx, object)
                return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex() }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValueRGB(Color3.fromHex(data.value))
                end
            end,
        },
        KeyPicker = {
            Save = function(idx, object)
                return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
            end,
            Load = function(idx, data)
                if Options[idx] then 
                    Options[idx]:SetValue({ data.key, data.mode })
                end
            end,
        }
    }

    function SaveManager:Save(name)
        local fullPath = 'funky_friday_autoplayer/configs/' .. name .. '.json'

        local data = {
            version = 2,
            objects = {}
        }

        for idx, toggle in next, Toggles do
            if self.Ignore[idx] then continue end
            table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
        end

        for idx, option in next, Options do
            if not self.Parser[option.Type] then continue end
            if self.Ignore[idx] then continue end

            table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
        end 

        local success, encoded = pcall(httpService.JSONEncode, httpService, data)
        if not success then
            return false, 'failed to encode data'
        end

        writefile(fullPath, encoded)
        return true
    end

    function SaveManager:Load(name)
        local file = 'funky_friday_autoplayer/configs/' .. name .. '.json'
        if not isfile(file) then return false, 'invalid file' end

        local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
        if not success then return false, 'decode error' end
        if decoded.version ~= 2 then return false, 'invalid version' end

        for _, option in next, decoded.objects do
            if self.Parser[option.type] then
                self.Parser[option.type].Load(option.idx, option)
            end
        end

        return true
    end

    function SaveManager.Refresh()
        local list = listfiles('funky_friday_autoplayer/configs')

        local out = {}
        for i = 1, #list do
            local file = list[i]
            if file:sub(-5) == '.json' then
                -- i hate this but it has to be done ...

                local pos = file:find('.json', 1, true)
                local start = pos

                local char = file:sub(pos, pos)
                while char ~= '/' and char ~= '\\' and char ~= '' do
                    pos = pos - 1
                    char = file:sub(pos, pos)
                end

                if char == '/' or char == '\\' then
                    table.insert(out, file:sub(pos + 1, start - 1))
                end
            end
        end
        
        Options.ConfigList.Values = out;
        Options.ConfigList:SetValues()
        Options.ConfigList:Display()

        return out
    end

    function SaveManager:Delete(name)
        local file = 'funky_friday_autoplayer/configs/' .. name .. '.json'
        if not isfile(file) then return false, string.format('Config %q does not exist', name) end

        local succ, err = pcall(delfile, file)
        if not succ then
            return false, string.format('error occured during file deletion: %s', err)
        end

        return true
    end

    function SaveManager:SetIgnoreIndexes(list)
        for i = 1, #list do 
            table.insert(self.Ignore, list[i])
        end
    end

    function SaveManager.Check()
        local list = listfiles('funky_friday_autoplayer/configs')

        for _, file in next, list do
            if isfolder(file) then continue end

            local data = readfile(file)
            local success, decoded = pcall(httpService.JSONDecode, httpService, data)

            if success and type(decoded) == 'table' and decoded.version ~= 2 then
                pcall(delfile, file)
            end
        end
    end
end

local Window = UI:CreateWindow({
    Title = string.format('funky friday autoplayer - version %s | updated: %s', metadata.version, metadata.updated),
    AutoShow = true,
    
    Center = true,
    Size = UDim2.fromOffset(550, 627),
})

local Tabs = {}
local Groups = {}

Tabs.Main = Window:AddTab('Main')
Tabs.Miscellaneous = Window:AddTab('Miscellaneous')

Groups.Autoplayer = Tabs.Main:AddLeftGroupbox('Autoplayer')
    Groups.Autoplayer:AddToggle('Autoplayer', { Text = 'Autoplayer' }):AddKeyPicker('AutoplayerBind', { Default = 'End', NoUI = true, SyncToggleState = true })
    Groups.Autoplayer:AddDropdown('PressMode', {
        Text = 'Input mode', 
        Compact = true, 
        Default = 'firesignal', 
        Values = { 'firesignal', 'virtual input' }, 
        Tooltip = 'Input method used to press arrows.\n* firesignal: calls input functions directly.\n* virtual input: emulates key presses. use if "firesignal" does not work. (USE ON WAVE)', 
    })

Groups.HitChances = Tabs.Main:AddLeftGroupbox('Hit chances')
    Groups.HitChances:AddDropdown('AutoplayerMode', { 
        Text = 'Autoplayer mode', 
        Compact = true, 
        Default = 1, 
        Values = { 'Automatic', 'Manual' },
        Tooltip = 'Mode to use for deciding when to hit notes.\n* Automatic: hits notes based on chance sliders\n* Manual: hits notes based on held keybinds',
    })

    Groups.HitChances:AddSlider('SickChance',   { Text = 'Sick chance', Min = 0, Max = 100, Default = 95, Suffix = '%', Rounding = 0, Compact = true })
    Groups.HitChances:AddSlider('GoodChance',   { Text = 'Good chance', Min = 0, Max = 100, Default = 5, Suffix = '%', Rounding = 0, Compact = true })
    Groups.HitChances:AddSlider('OkChance',     { Text = 'Ok chance',   Min = 0, Max = 100, Default = 0, Suffix = '%', Rounding = 0, Compact = true })
    Groups.HitChances:AddSlider('BadChance',    { Text = 'Bad chance',  Min = 0, Max = 100, Default = 0, Suffix = '%', Rounding = 0, Compact = true })
    Groups.HitChances:AddSlider('MissChance',   { Text = 'Miss chance', Min = 0, Max = 100, Default = 0, Suffix = '%', Rounding = 0, Compact = true })

Groups.HitTiming = Tabs.Main:AddLeftGroupbox('Hit timing')
    Groups.HitTiming:AddDropdown('DelayMode', { 
        Text = 'Delay mode', 
        Default = 2, 
        Values = { 'Manual', 'Random' },
        Tooltip = 'Adjustable timing for when to release notes.\n* Manual releases the note after a fixed amount of time.\n* Random releases the note after a random amount of time.', 
    })

    Groups.HitTiming:AddLabel('Manual delay')
    Groups.HitTiming:AddSlider('ReleaseDelay',   { Text = 'Note delay', Min = 0, Max = 500, Default = 20, Rounding = 0, Compact = true, Suffix = 'ms' })
    Groups.HitTiming:AddSlider('HeldDelay',      { Text = 'Held note delay', Min = -20, Max = 100, Default = 0, Rounding = 0, Compact = true, Suffix = 'ms' })
        
    Groups.HitTiming:AddLabel('Random delay')
    Groups.HitTiming:AddSlider('NoteDelayMin',   { Text = 'Min note delay', Min = 0, Max = 100, Default = 40,    Rounding = 0, Compact = true, Suffix = 'ms' })
    Groups.HitTiming:AddSlider('NoteDelayMax',   { Text = 'Max note delay', Min = 0, Max = 500, Default = 60,   Rounding = 0, Compact = true, Suffix = 'ms' })
    
    Groups.HitTiming:AddSlider('HeldDelayMin',   { Text = 'Min held note delay', Min = 0, Max = 100, Default = 20,   Rounding = 0, Compact = true, Suffix = 'ms' })
    Groups.HitTiming:AddSlider('HeldDelayMax',   { Text = 'Max held note delay', Min = 0, Max = 500, Default = 65,  Rounding = 0, Compact = true, Suffix = 'ms' })

Groups.Misc = Tabs.Main:AddRightGroupbox('Misc')
    Groups.Misc:AddButton('Unlock developer notes', ActivateUnlockables)
    Groups.Misc:AddToggle('AutoClaimRings', { Text = 'Auto claim rings' })

Groups.Keybinds = Tabs.Main:AddRightGroupbox('Keybinds')
    Groups.Keybinds:AddLabel('Sick'):AddKeyPicker('SickBind', { Default = 'One', NoUI = true })
    Groups.Keybinds:AddLabel('Good'):AddKeyPicker('GoodBind', { Default = 'Two', NoUI = true })
    Groups.Keybinds:AddLabel('Ok'):AddKeyPicker('OkayBind', { Default = 'Three', NoUI = true })
    Groups.Keybinds:AddLabel('Bad'):AddKeyPicker('BadBind', { Default = 'Four', NoUI = true })

Groups.Configs = Tabs.Miscellaneous:AddRightGroupbox('Configs')
Groups.Credits = Tabs.Miscellaneous:AddRightGroupbox('Credits')
    local function addRichText(label)
        label.TextLabel.RichText = true
    end

    addRichText(Groups.Credits:AddLabel('<font color="#3da5ff">wally</font> - script'))
    addRichText(Groups.Credits:AddLabel('<font color="#ff00ff">Bart3kk</font> - mobile port'))
    addRichText(Groups.Credits:AddLabel('<font color="#de6cff">Sezei</font> - contributor'))
    Groups.Credits:AddLabel('Inori - ui library')
    Groups.Credits:AddLabel('Jan - old ui library')
    Groups.Credits:AddButton('copy link to official repo', function()
        if pcall(setclipboard, "https://github.com/Bart3kk/funky-friday/autoplay") then
            UI:Notify("Copied Bart3kk's GitHub link to clipboard!", 5)
        end
    end)


Groups.Misc = Tabs.Miscellaneous:AddRightGroupbox('Miscellaneous')
    Groups.Misc:AddLabel(metadata.message or 'no message found!', true)

    Groups.Misc:AddDivider()
    Groups.Misc:AddButton('Unload script', function() pcall(shared._unload) end)
    Groups.Misc:AddButton('Copy discord', function()
        if pcall(setclipboard, "https://wally.cool/discord") then
            UI:Notify('Successfully copied discord link to your clipboard!', 5)
        end
    end)

    Groups.Misc:AddLabel('Menu toggle'):AddKeyPicker('MenuToggle', { Default = 'Delete', NoUI = true })

    UI.ToggleKeybind = Options.MenuToggle

if type(readfile) == 'function' and type(writefile) == 'function' and type(makefolder) == 'function' and type(isfolder) == 'function' then
    makefolder('funky_friday_autoplayer')
    makefolder('funky_friday_autoplayer\\configs')

    Groups.Configs:AddDropdown('ConfigList', { Text = 'Config list', Values = {}, AllowNull = true })
    Groups.Configs:AddInput('ConfigName',    { Text = 'Config name' })

    Groups.Configs:AddDivider()

    Groups.Configs:AddButton('Save config', function()
        local name = Options.ConfigName.Value;
        if name:gsub(' ', '') == '' then
            return UI:Notify('Invalid config name.', 3)
        end

        local success, err = SaveManager:Save(name)
        if not success then
            return UI:Notify(tostring(err), 5)
        end

        UI:Notify(string.format('Saved config %q', name), 5)
        task.defer(SaveManager.Refresh)
    end)

    Groups.Configs:AddButton('Load', function()
        local name = Options.ConfigList.Value
        local success, err = SaveManager:Load(name)
        if not success then
            return UI:Notify(tostring(err), 5)
        end

        UI:Notify(string.format('Loaded config %q', name), 5)
    end):AddButton('Delete', function()
        local name = Options.ConfigList.Value
        if name:gsub(' ', '') == '' then
            return UI:Notify('Invalid config name.', 3)
        end

        local success, err = SaveManager:Delete(name)
        if not success then
            return UI:Notify(tostring(err), 5)
        end

        UI:Notify(string.format('Deleted config %q', name), 5)

        task.spawn(Options.ConfigList.SetValue, Options.ConfigList, nil)
        task.defer(SaveManager.Refresh)
    end)

    Groups.Configs:AddButton('Refresh list', SaveManager.Refresh)

    task.defer(SaveManager.Refresh)
    task.defer(SaveManager.Check)
else
    Groups.Configs:AddLabel('Your exploit is missing file functions so you are unable to use configs.', true)
    --UI:Notify('Failed to create configs tab due to your exploit missing certain file functions.', 2)
end

-- Themes
do
    local BuiltInThemes = {
		['Default'] 		= { 1, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"0055ff","BackgroundColor":"141414","OutlineColor":"323232"}') },
		['BBot'] 			= { 2, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}') },
		['Fatality']		= { 3, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}') },
		['Jester'] 			= { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Mint'] 			= { 5, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
		['Tokyo Night'] 	= { 6, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}') },
		['Ubuntu'] 			= { 7, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}') },
		['Quartz'] 			= { 8, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}') },
	}

	local latestThemeIndex = 0
	for i, theme in next, BuiltInThemes do
		if theme[1] > latestThemeIndex then
			latestThemeIndex = theme[1]
		end
	end

	latestThemeIndex = latestThemeIndex + 1

	ThemeManager:ApplyToGroupbox(Tabs.Miscellaneous:AddLeftGroupbox('Themes'))

	SaveManager:SetIgnoreIndexes({ 
		"BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", -- themes
		"ThemeManager_ThemeList", 'ThemeManager_CustomThemeList', 'ThemeManager_CustomThemeName', -- themes
	})
end

UI:Notify(string.format('Loaded script in %.4f second(s)!', tick() - start), 3) end --idfk why its needed but it is i guess
