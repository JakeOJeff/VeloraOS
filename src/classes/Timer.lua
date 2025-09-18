local Timer = {}

function Timer:new()
    return setmetatable({tasks = {}}, {__index = self})
end

function Timer:after(delay, func)
    table.insert(self.tasks, {time = delay, func = func})
end

function Timer:update(dt)
    for i=#self.tasks,1,-1 do
        local t = self.tasks[i]
        t.time = t.time - dt
        if t.time <= 0 then
            t.func()
            table.remove(self.tasks, i)
        end
    end
end

return Timer