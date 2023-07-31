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
