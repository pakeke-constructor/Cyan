


local PATH = (...):gsub('%.[^%.]+$', '')

local Cyan = {

}




local Entity = require(PATH..".ent")
local System = require(PATH..".system")

local WorldControl = require(PATH..".world")






-- Cyan.Entity(); entity ctor
Cyan.Entity = Entity

--Cyan.System(...); system ctor
Cyan.System = System





--[[
 core cyan management

]]



-- Depth is the call depth of a Cyan.call function.
-- It tracks the `depth` of the call so automatic flushing can be done on every root call.
Cyan.___depth = 0

do
    function Cyan.call(func_name,   a,b,c,d,e,f)
        if Cyan.___depth == 0 then
            Cyan.flush()
        end
        Cyan.___depth = Cyan.___depth + 1
        --[[
            Calls all systems with the given function. Alias: Cyan.emit

            @arg func @(
                The function name to be called
            )

            @arg ... @(
                Any other arguments sent in after will be passed to system.
            )

            @return Cyan @
        ]]
        
        for _, sys in ipairs(System.func_backrefs[func_name]) do
            if sys.active then
                sys[func_name](sys, a,b,c,d,e,f)
            end
        end

        Cyan.___depth = Cyan.___depth - 1 -- Depth will be zero if and ONLY IF this call was a root call. (ie called from love.update or love.draw)

        return Cyan
    end

    Cyan.emit = Cyan.call



    -- Flushes all entities that need to be deleted
    function Cyan.flush()
        --[[
            Removes all entities marked for deletion.

            @return Cyan@
        ]]
        local sys_list = System.systems
        local sys
        for _, ent in ipairs(Entity.___remove_set.objects) do
            for index = 1, sys_list.len do
                sys = sys_list[index]
                sys:remove(ent)
            end
        end
    end
end


--[[
]]





--[[
    World management
    NEEDS TESTING!!!
]]
do
    function Cyan.setWorld(name)
        assert(name, "Cyan.setWorld requires a world name as a string!")
        return WorldControl:setWorld(name, Cyan)
    end

    function Cyan.getWorld()
        return WorldControl:getWorld()
    end

    function Cyan.clearWorld(name)
        assert(name, "Cyan.clearWorld requires a world name as a string!")
        return WorldControl:clearWorld(name, Cyan)
    end

    function Cyan.newWorld(name)
        assert(name, "Cyan.newWorld requires a world name as a string!")
        return WorldControl:newWorld(name, Cyan)
    end
end
--[[
]]


-- Default world is `main`
Cyan.newWorld("main")
Cyan.setWorld("main")








return setmetatable(Cyan, {__metatable = "Defended metatable"})




