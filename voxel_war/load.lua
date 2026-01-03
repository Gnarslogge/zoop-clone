function love.load()

    debug_display = false

    --set default font
    font = love.graphics.newFont("BoldPixels.ttf", 24)
    love.graphics.setFont(font)

    -- Code here runs once when the game starts.
    
    function table.shallowClone(og_table)
        local copy_table = {}
        for k, v in pairs(og_table) do
            copy_table[k] = v
        end
        return copy_table
    end

    --turn off blur filter
    love.graphics.setDefaultFilter( 'nearest', 'nearest' )

    --set window size
    love.window.setMode(640, 480)

    --libraries
    grid_lib = require ('pathfinder.grid')
    pathfinder = require('pathfinder.pathfinder')
    gamera = require('gamera')

    --setup camera
    cam = gamera.new(0, 0, 1280, 960)
    cam:setWindow(0, 64, 640, 416)
    view_x = 320
    view_y = 240
    view_w = 640
    view_h = 416

    --setup pathfinding
    grid_map = {
        {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    }
    grid = grid_lib(grid_map)
    draw_grid = false

    local function isWalkable(value)
        return value == 0 or value == 0.5
    end
    
    finder = pathfinder(grid, 'DIJKSTRA', isWalkable)

    --load in images
    spr = {
        vehicle_maker = {
            love.graphics.newImage('spr/vehicle_maker/vehicle_maker1.png'),
            love.graphics.newImage('spr/vehicle_maker/vehicle_maker2.png'),
            love.graphics.newImage('spr/vehicle_maker/vehicle_maker3.png'),
            love.graphics.newImage('spr/vehicle_maker/vehicle_maker4.png'),
            love.graphics.newImage('spr/vehicle_maker/vehicle_maker5.png'),
            love.graphics.newImage('spr/vehicle_maker/vehicle_maker6.png')
        },
        drill = {
            love.graphics.newImage('spr/drill/drill1.png'),
            love.graphics.newImage('spr/drill/drill2.png'),
            love.graphics.newImage('spr/drill/drill3.png'),
            love.graphics.newImage('spr/drill/drill4.png'),
            love.graphics.newImage('spr/drill/drill5.png'),
            love.graphics.newImage('spr/drill/drill6.png'),
            love.graphics.newImage('spr/drill/drill7.png'),
            love.graphics.newImage('spr/drill/drill8.png'),
            love.graphics.newImage('spr/drill/drill9.png'),
        },
        wall = {
            love.graphics.newImage('spr/wall/wall1.png'),
            love.graphics.newImage('spr/wall/wall2.png'),
            love.graphics.newImage('spr/wall/wall3.png'),
            love.graphics.newImage('spr/wall/wall4.png'),
            love.graphics.newImage('spr/wall/wall5.png'),
            love.graphics.newImage('spr/wall/wall6.png')
        },
        tank = {
            love.graphics.newImage('spr/tank/tank1.png'),
            love.graphics.newImage('spr/tank/tank2.png'),
            love.graphics.newImage('spr/tank/tank3.png'),
            love.graphics.newImage('spr/tank/tank4.png'),
            love.graphics.newImage('spr/tank/tank5.png'),
            love.graphics.newImage('spr/tank/tank6.png')
        }
    }

    --mouse object
    mouse = {
        mode = "interact",
        held = false,
        drag = false,
        x = 0,
        y = 0,
        og_x = 0,
        og_y = 0,
        grid_x = 1,
        grid_y = 1,
        gui_x = 1,
        gui_y = 1,
        to_place = {
            grid_x = 0,
            grid_y = 0,
            ghost = false
        },
        valid_placement = true,
        on_gui = false
    }

    building = {}

    unit = {
        {
            type = 'tank',
            x = 336,
            y = 336,
            grid_x = 10,
            grid_y = 10,
            angle = 0,
            goal_angle = 0,
            selected = false,
            currentStep = 0,
            speed = 2,
            path = nil
        },
        {
            type = 'tank',
            x = 176,
            y = 176,
            grid_x = 5,
            grid_y = 5,
            angle = 0,
            goal_angle = 0,
            selected = false,
            currentStep = 0,
            speed = 2,
            path = nil
        }
    }

    wall = {}

    --layout of level
    for i=1, #grid_map do
        for ii=1, #grid_map[i] do
            if grid_map[i][ii] == 1 then
                table.insert(wall, {
                    type = 'wall',
                    x = ii * 32 + 16,
                    y = i * 32 + 16,
                    grid_x = ii, 
                    grid_y = i
                })
            end
        end
    end

    selected_units = {}

    money = 5000

    draw_order = {}

    key_pressed = {

        ['1'] = false,
        ['`'] = false
    }

    guiBuildingButton = {
        cooldown = 0,
        cooldown_max = 0,
        {
            x = 0,
            y = 0,
            type = "drill",
            angle = 0,
            hover = false
        },
        {
            x = 64,
            y = 0,
            type = "vehicle_maker",
            angle = 0,
            hover = false
        }
    }

    buildingSelected = nil
    buildingCost = {
        ['drill'] = 500,
        ['vehicle_maker'] = 2000
    }
    buildingSprite = {
        ['drill'] = spr.drill,
        ['vehicle_maker'] = spr.vehicle_maker
    }
    buildingDimensions = {
        ['drill'] = {w = 2, h = 2},
        ['vehicle_maker'] = {w = 3, h = 3}
    }
end