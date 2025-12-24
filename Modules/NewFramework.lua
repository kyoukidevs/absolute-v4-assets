    --[[
New Framework, Many New Modules & More
]]

local Framework = {
    Instances = {},
    Drawings = {},
    Services = setmetatable({}, {
        __index = function(self, service)
            local string = service:gsub("_", ""):gsub("^%1", string.upper)
            local instance = game:GetService(string)
            rawset(self, service, instance)
            return instance
        end
    }),
    Connections = {},
    Threads = {},
    Modules = {}
}

Framework.unload = function()
    for _, Module in Framework.Modules do
        if Module.unload then
            Module.unload()
        end
    end
end

local Modules = Framework.Modules 

do
    local Instances = {}
    local Drawings = {}
    local Signals = {}
    local Math = {}
    local Misc = {}
    local Threads = {
        Entity = {},
        Client = {},
        Render = {}
    }

    do
        Instances.new = function(Class, Properties)
            local Instance = Instance.new(Class)

            for Prop, Value in next, Properties do
                Instance[Prop] = Value 
            end

            table.insert(Framework.Instances, Instance)

            return Instance 
        end

        Instances.unload = function()
            for _, Instance in next, Framework.Instances do
                Instance:Destroy()
            end
        end

        Framework.Modules.Instances = Instances 
    end

    do
        Drawings.new = function(Class, Properties)
            local Drawing = Drawing.new(Class)

            for Prop, Value in next, Properties do
                Drawing[Prop] = Value 
            end

            table.insert(Framework.Drawings, Drawing)

            return Drawing
        end

        Drawings.unload = function()
            for _, Drawing in next, Framework.Drawings do
                Drawing:Destroy()
            end
        end

        Framework.Modules.Drawings = Drawings 
    end

    do
        Signals.connection = function(Signal, Callback)
            local Connection = Signal:Connect(Callback)

            table.insert(Framework.Connections, Connection)

            return Connection
        end

        Signals.thread = function(Name, Callback, Type)
            local Thread = setmetatable({
                Name = Name,
                Callback = Callback,
                Type = Type
            }, Framework.Threads)

            if not Type then
                Type = "Rendering"
            end

            Thread.Type = Type 

            local Index = #Framework.Threads[Type] + 1
            Framework.Threads[Type][Index] = Thread 
            return Framework.Threads[Type][Index]
        end

        Signals.unload = function()
            for _, Connection in next, Framework.Connections do
                Connection:Disconnect()
            end

            --for _, Thread in next, Framework.Threads do
            --    Thread = nil
        -- end
        end

        Framework.Modules.Signals = Signals
    end

    do
        Math.lerp = function(a,b,t)
            return a + (b - a) * t
        end

        Math.floorvector = function(Vector)
            if typeof(Vector) == "Vector2" then
                return Vector2.new(math.floor(Vector.X), math.floor(Vector.Y))
            else
                return Vector3.new(math.floor(Vector.X), math.floor(Vector.Y), math.floor(Vector.Z)) 
            end
        end

        Framework.Modules.Math = Math 
    end

    do
        Misc.Tween = function(Object, Info, Prop)
            local Tween = game:GetService("TweenService"):Create(Object, Info, Prop)

            Tween:Play()
            return Tween
        end

        Framework.Modules.Misc = Misc
    end

    do
        Threads.__index = Threads 

        Threads.new = function(Name, Callback, Type)
            local Thread = setmetatable({
                Name = Name,
                Callback = Callback,
                Type = Type
            }, Threads)

            if not Type then
                Type = "Render"
            end

            Thread.Type = Type

            local Index = #Threads[Type] + 1
            Threads[Type][Index] = Thread 
            return Threads[Type][Index]
        end

        Threads.run = function(self)
            local Success, Error = pcall(self.Callback)

            if not Success and Error then
                return Error 
            end
        end

        Framework.Modules.Threads = Threads 
    end
end

return Framework
