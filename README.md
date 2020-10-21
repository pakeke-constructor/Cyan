


# Cyan
#### As of 22/09/2020, this library has no known bugs.

Cyan is a lightweight ECS library built for lua, inspired from Concord and other ECS libs.

It is designed to have a very minimalistic and intuitive API whilst having time complexities among the best ECS libaries out there.

I mainly built this for personal use. Check out Concord, Nata, or HOOECS if you want a more feature-complete ECS lib!


# Usage:

```lua

-- importing:
local cyan = require "(path to cyan folder).Cyan"

```

This tutorial assumes you know the basics of ECS.
If you don't, there are plenty of great online resources.

# Entities:

Entities hold data.
They are basically a glorified lua table.

```lua

local ent = cyan.Entity()


ent:add("position", {x = 1,  y = 2})  -- adds position component.
                                      -- same as:   ent.position = {x = 1, y = 2}
                                      -- (note: components do not have to be tables)


ent:remove("position") -- removes component 'position'


-- Marks entity for deletion (will be deleted next frame)
ent:delete()

```
 
 
      
# Systems:
Systems is where logic is held.
It is also where the entities belong.

You do not need to add entities to systems- they will automatically be added
if they have the required set of components.
```lua

--  A system for entities with `image` and `position` components
local DrawSys = cyan.System( "image", "position" )




-- Access system entities using `System.group`.
-- This table is read only!!! Do NOT modify it!
-- Example:
function DrawSys:draw()
    for _, ent in ipairs(self.group) do -- iterates over all entities in `DrawSys`
        draw( ent )
    end
end


```
There are also callbacks for entities being added and removed from systems,
called :added and :removed. The entity is the first argument
```lua
function DrawSys:added( entity )
  ImageBatch:add( entity )
end


function DrawSys:removed( entity )
  ImageBatch:remove( entity )
end

```
 
   
   
##  Calling functions / emitting events:
This feature allows you to call multiple System functions at once, easily. 

The call order depends on when each function was made. (First made, first served)
```lua
--  To call functions in Cyan systems, use
--  " Cyan.call "

function love.update(dt)

    cyan.call("update", dt)
    -- Calls ALL systems with an `update` function, 
    -- passing in `dt` as first argument.
end


function love.draw(dt)

    cyan.call("draw")
    -- Calls ALL systems with a `draw` function, passing in 0 arguments.

end


```

# Other functions:  (OPTIONAL)
Here are some tips that provide extra functionality, but are
entirely optional.
   
 
    
      
```lua

-- Low level entity functions:

local ent = cyan.Entity()


ent:has("pos") -- returns `true` is entity has position component, false otherwise.

-- Adds component `q` without adding to any systems.
ent:rawadd("q", 1)


-- Removes component `q` without removing from any systems.
ent:rawremove("q")


ent:getSystems() -- Gets all the systems of an entity.
    -- WARNING:: This operation is extrememly expensive!!!
    -- Do NOT use it every frame!!!



-- Low level system functions

-- removes `entity` from `Sys`
Sys:remove(entity)

-- adds `entity` to `Sys`
Sys:add(entity)

-- This is done automatically, so it doesn't really need to be done.


```

# *Final notes*  (OPTIONAL)

*Static Systems* are very useful.
These are just Systems that take no entities, but perform important roles. A common way to use them is to pass the entity in as the first argument through `Cyan.call`.

In this example, an event is emitted after an Entity explodes. The sound system can thus react appropriately, even though it does not take entities.
```lua
local SoundSys = Cyan.System()

function SoundSys:explode(ent) -- Called upon   Cyan.call("explode", ent)
    if ent.size > 30 then
        love.audio.play( bigExplosionSound )
    else
        love.audio.play( smallExplosionSound )
    end
end
```

### This library is not meant to be used as a barebones library. 

The user is expected to add the functionality they want through extra functions, and extra helper tables that they see necessary; minimalism comes at a cost!

For example, if you wanted an easy way to add multiple components at once,
you could do:
```lua
local function addAll(entity, comps)
    for key, value in pairs(comps) do
        entity[key] = value
    end
end


addAll(ent,
{
    pos = vec3(0,0,0);
    health = 10;
    max_health = 100;
    image = love.graphics.newImage("monkey.png")
})
```

Just make sure to stick to your conventions, and keep it
as minimalistic and strict as possible to avoid spagetti.
No edge cases!


