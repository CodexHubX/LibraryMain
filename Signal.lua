local Signal = {}
Signal.__index = Signal
Signal.ClassName = "Signal"

function Signal.new()
    local self = setmetatable({},Signal)
    self.bindableEvent = Instance.new("BindableEvent");
    self.Args = nil;
    self.ArgsCount = nil;

    self.signalCall = self:Connect(function(key)
        if not key then return end;
        self.Key = key;
    end);

    return self;
end;

function Signal.isSignal(object)
    return typeof(object) == 'table' and getmetatable(object) == Signal;
end;

function Signal:Fire(...)
    if not self.bindableEvent then return end;
    self.Args = {...};
    self.ArgsCount = select("#", ...);
    self.bindableEvent:Fire()
    self.Args = nil;
    self.ArgsCount = nil;
end;

function Signal:WaitCalled(key,timeOut)
    --local calling;
    local t = tick();

    -- if self.Key and self.Key == key then 
    --     calling = true;
    --     self.Key = nil;
    -- end;
    repeat task.wait() until self.Key == key or (timeOut and (tick() - t > timeOut)) or not self.bindableEvent;
    self.Key = nil;
end;

function Signal:Connect(object)
    if not self.bindableEvent then return end;
    if type(object) ~= 'function' then return end;

    return self.bindableEvent.Event:Connect(function()
        object(unpack(self.Args, 1, self.ArgsCount))
    end);
end;

function Signal:Destroy(...)
    if not self.bindableEvent then return end;
    self.bindableEvent:Destroy()
    self.bindableEvent = nil;
    self.signalCall:Disconnect()
end;

return Signal;
