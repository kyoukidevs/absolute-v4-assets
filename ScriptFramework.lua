-- // My Rewrited Framework
--[[ // Update Logs:
Added Drawings Module
Fixed Signals
]]

local framework = {
    Instances = {},
    Services = setmetatable({}, {
        __index = function(self, service)
            local string = service:gsub("_%1", string.upper):gsub("_", ""):gsub("^%1", string.upper)
            local instance = game:GetService(string)
            rawset(self, service, instance)
            return instance
        end
    }),
    Connections = {},
    Drawings = {},
    Modules = {}
}

framework.unload = function()
    for _, module in next, framework.Modules do
        if module.unload then
            module.unload()
        end
    end
end

local modules = framework.Modules

do
    local Instances = {}
    local Signals = {}
    local Drawings = {}

    do
        Instances.new = function(Class, Props)
            local inst = Instance.new(Class)

            for Index, Value in next, Props do
                inst[Index] = Value
            end
            table.insert(framework.Instances, inst)
            return inst
        end

        Instances.unload = function()
            for _, Value in pairs(framework.Instances) do
                Value:Destroy()
            end
        end

        modules.Instances = Instances
    end

    do
        Signals.connection = function(Signal, Callback)
            local connection = Signal:Connect(Callback)
            table.insert(framework.Connections, connection)
            return connection 
        end

        Signals.lerp = function(a, b, t)
            return a + (b - a) * t 
        end

        Signals.unload = function()
            for _, Value in pairs(framework.Connections) do
                Value:Disconnect()
            end
        end

        modules.Signals = Signals 
    end

    do
        Drawings.new = function(Name, Props) -- // Works Shitty Rn Will Fix After I Buy New Executor
            local Drawing = Drawing.new(Name)
            for Index, Prop in next, Props do
                Drawing[Index] = Value
            end
            table.insert(framework.Drawings, Drawing)
            return Drawing
        end

        Drawings.unload = function()
            for Index, Drawing in pairs(framework.Drawings) do
                Drawing:Destroy()
            end
        end

        modules.Drawings = Drawings
    end
end

return framework
