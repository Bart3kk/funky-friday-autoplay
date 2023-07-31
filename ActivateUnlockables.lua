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
