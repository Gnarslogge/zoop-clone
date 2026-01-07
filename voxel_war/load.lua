function love.load()

    debug_display = false

    --set default font
    font = love.graphics.newFont("BoldPixels.ttf", 24)
    love.graphics.setFont(font)

    --set button font
    button_font = love.graphics.newFont('BoldPixels.ttf', 14)

    -- Code here runs once when the game starts

    function math.sign(x)
        return x > 0 and 1 or (x < 0 and -1 or 0)
    end

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
    local grid_lib = require ('pathfinder.grid')
    pathfinder = require('pathfinder.pathfinder')
    local gamera = require('gamera')
    require ('spiral_search')
    require ('camera_movement')

    --cursor
    cursor = {
        default = love.mouse.newCursor('spr/cursor/cursor_default.png', 16, 16),
        up = love.mouse.newCursor('spr/cursor/cursor_up.png', 16, 16),
        down = love.mouse.newCursor('spr/cursor/cursor_down.png', 16, 16),
        left = love.mouse.newCursor('spr/cursor/cursor_left.png', 16, 16),
        right = love.mouse.newCursor('spr/cursor/cursor_right.png', 16, 16),
        upleft = love.mouse.newCursor('spr/cursor/cursor_upleft.png', 32, 32),
        upright = love.mouse.newCursor('spr/cursor/cursor_upright.png', 32, 32),
        downleft = love.mouse.newCursor('spr/cursor/cursor_downleft.png', 32, 32),
        downright = love.mouse.newCursor('spr/cursor/cursor_downright.png', 32, 32)
    }
    love.mouse.setCursor(cursor.default)
    temp_cursor = cursor.default

    --setup camera
    cam = gamera.new(0, 0, 1920, 1920)
    cam:setWindow(0, 0, 640, 360)
    view_x = 320
    view_y = 240
    view_w = 640
    view_h = 360
    view_margin = 48
    view_scale = 1

    gui = {
        x = 0,
        y = 360
    }
    --setup pathfinding
    grid_map = {
        {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,1,1,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    }
    grid = grid_lib(grid_map)
    draw_grid = false

    local function isWalkable(value)
        return value == 0 or value == 0.5
    end
    
    finder = pathfinder(grid, 'DIJKSTRA', isWalkable)

    --load in images
    spr = {
        bg = love.graphics.newImage('spr/bg.png'),
        metal_icon = love.graphics.newImage('spr/metal_icon.png'),
        unit_icon = love.graphics.newImage('spr/unit_limit.png'),
        guiBuildingButton = {
            dull = love.graphics.newImage('spr/guibuildingbutton/guibuildingbutton_dulled.png'),
            normal = love.graphics.newImage('spr/guibuildingbutton/guibuildingbutton_normal.png'),
            selected = love.graphics.newImage('spr/guibuildingbutton/guibuildingbutton_selected.png'),
            outline = love.graphics.newImage('spr/guibuildingbutton/guibuildingbutton_outline_highlight.png')
        },
        guiFactoryPopup = {
            bg = love.graphics.newImage('spr/guiFactoryPopup/guiFactoryPopup_bg.png'),
            dull = love.graphics.newImage('spr/guiFactoryPopup/guiFactoryPopupbutton_dull.png'),
            normal = love.graphics.newImage('spr/guiFactoryPopup/guiFactoryPopupbutton_normal.png'),
            selected = love.graphics.newImage('spr/guiFactoryPopup/guiFactoryPopupbutton_selected.png'),
            outline = love.graphics.newImage('spr/guiFactoryPopup/guiFactoryPopupbutton_outline.png')
        },
        soldier = {
            love.graphics.newImage('spr/soldier/soldier1.png'),
            love.graphics.newImage('spr/soldier/soldier2.png'),
            love.graphics.newImage('spr/soldier/soldier3.png'),
            love.graphics.newImage('spr/soldier/soldier4.png'),
            love.graphics.newImage('spr/soldier/soldier5.png'),
            love.graphics.newImage('spr/soldier/soldier6.png'),
            love.graphics.newImage('spr/soldier/soldier7.png'),
            love.graphics.newImage('spr/soldier/soldier8.png'),
            love.graphics.newImage('spr/soldier/soldier9.png'),
            love.graphics.newImage('spr/soldier/soldier10.png'),
            love.graphics.newImage('spr/soldier/soldier11.png'),
            love.graphics.newImage('spr/soldier/soldier12.png'),
            love.graphics.newImage('spr/soldier/soldier13.png')
        },
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
        tent = {
            love.graphics.newImage('spr/tent/tent1.png'),
            love.graphics.newImage('spr/tent/tent2.png'),
            love.graphics.newImage('spr/tent/tent3.png'),
            love.graphics.newImage('spr/tent/tent4.png'),
            love.graphics.newImage('spr/tent/tent5.png'),
            love.graphics.newImage('spr/tent/tent6.png'),
            love.graphics.newImage('spr/tent/tent7.png'),
            love.graphics.newImage('spr/tent/tent8.png'),
            love.graphics.newImage('spr/tent/tent9.png'),
            love.graphics.newImage('spr/tent/tent10.png'),
            love.graphics.newImage('spr/tent/tent11.png'),
            love.graphics.newImage('spr/tent/tent12.png'),
            love.graphics.newImage('spr/tent/tent13.png'),
            love.graphics.newImage('spr/tent/tent14.png'),
            love.graphics.newImage('spr/tent/tent15.png'),
            love.graphics.newImage('spr/tent/tent16.png'),
            love.graphics.newImage('spr/tent/tent17.png')
        },
        bootcamp = { 
            love.graphics.newImage('spr/bootcamp/bootcamp1.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp2.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp3.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp4.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp5.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp6.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp7.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp8.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp9.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp10.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp11.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp12.png'),
            love.graphics.newImage('spr/bootcamp/bootcamp13.png')
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
            love.graphics.newImage('spr/tank/tank6.png'),
            love.graphics.newImage('spr/tank/tank7.png'),
            love.graphics.newImage('spr/tank/tank8.png'),
            love.graphics.newImage('spr/tank/tank9.png'),
            love.graphics.newImage('spr/tank/tank10.png'),
            love.graphics.newImage('spr/tank/tank11.png'),
            love.graphics.newImage('spr/tank/tank12.png'),
            love.graphics.newImage('spr/tank/tank13.png'),
            love.graphics.newImage('spr/tank/tank14.png'),
            love.graphics.newImage('spr/tank/tank15.png'),
            love.graphics.newImage('spr/tank/tank16.png'),
            love.graphics.newImage('spr/tank/tank17.png'),
            love.graphics.newImage('spr/tank/tank18.png')
        },
        buggy = {
            love.graphics.newImage('spr/buggy/buggy1.png'),
            love.graphics.newImage('spr/buggy/buggy2.png'),
            love.graphics.newImage('spr/buggy/buggy3.png'),
            love.graphics.newImage('spr/buggy/buggy4.png'),
            love.graphics.newImage('spr/buggy/buggy5.png'),
            love.graphics.newImage('spr/buggy/buggy6.png'),
            love.graphics.newImage('spr/buggy/buggy7.png'),
            love.graphics.newImage('spr/buggy/buggy8.png'),
            love.graphics.newImage('spr/buggy/buggy9.png'),
            love.graphics.newImage('spr/buggy/buggy10.png'),
            love.graphics.newImage('spr/buggy/buggy11.png')
        },
        enemy_tank = {
            base = {
                love.graphics.newImage('spr/tank2/tank_base1.png'),
                love.graphics.newImage('spr/tank2/tank_base2.png'),
                love.graphics.newImage('spr/tank2/tank_base3.png'),
                love.graphics.newImage('spr/tank2/tank_base4.png'),
                love.graphics.newImage('spr/tank2/tank_base5.png'),
                love.graphics.newImage('spr/tank2/tank_base6.png'),
                love.graphics.newImage('spr/tank2/tank_base7.png'),
                love.graphics.newImage('spr/tank2/tank_base8.png'),
                love.graphics.newImage('spr/tank2/tank_base9.png'),
                love.graphics.newImage('spr/tank2/tank_base10.png'),
                love.graphics.newImage('spr/tank2/tank_base11.png'),
                love.graphics.newImage('spr/tank2/tank_base12.png'),
                love.graphics.newImage('spr/tank2/tank_base13.png'),
                love.graphics.newImage('spr/tank2/tank_base14.png'),
                love.graphics.newImage('spr/tank2/tank_base15.png'),
                love.graphics.newImage('spr/tank2/tank_base16.png'),
                love.graphics.newImage('spr/tank2/tank_base17.png'),
                love.graphics.newImage('spr/tank2/tank_base18.png')
            }
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
        on_gui = false,
        on_popup_gui = false
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
            gun_angle = 0,
            gun_goal_angle = 0,
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
            gun_angle = 0,
            gun_goal_angle = 0,
            selected = false,
            currentStep = 0,
            speed = 2,
            path = nil
        },
        {
            type = 'soldier',
            x = 300,
            y = 176,
            grid_x = 6,
            grid_y = 6,
            angle = 0,
            goal_angle = 0,
            selected = false,
            currentStep = 0,
            speed = 1,
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

    metal = 100
    unit_count = 5
    unit_limit = 8

    draw_order = {}

    key_pressed = {

        ['1'] = false,
        ['`'] = false
    }

    guiUnitButton = {
        cooldown = 0,
        cooldown_max = 0,

    }

    guiBuildingButton = {
        cooldown = 0,
        cooldown_max = 0,
        w = 48,
        h = 48,
        selected = nil,
        {
            x = 160,
            y = 360,
            type = "drill",
            angle = 0,
            hover = false
        },
        {
            x = 160 + 64,
            y = 360,
            type = "tent",
            angle = 0,
            hover = false
        },
        {
            x = 160 + 128,
            y = 360,
            type = "bootcamp",
            angle = 0,
            hover = false
        },
        {
            x = 160 + 192,
            y = 360,
            type = "vehicle_maker",
            angle = 0,
            hover = false
        }
    }

    guiBootcampPopup = {
        active = false
    }

    guiFactoryPopup = {
        active = false,
        x = view_w/2 - 116,
        y = view_h/2 - 48,
        w = 232,
        h = 96,
        linkedBuilding = nil,
        button = {
            w = 48,
            h = 80,
            {
                x = 8,
                y = 24,
                type = "buggy",
                angle = 0,
                hover = false
            },
            {
                x = 72,
                y = 24,
                type = "tank",
                angle = 0,
                hover = false
            }
        }
    }

    buildingSelected = nil
    buildingCost = {
        ['drill'] = 20,
        ['tent'] = 20,
        ['bootcamp'] = 50,
        ['vehicle_maker'] = 80
    }
    buildingSprite = {
        ['drill'] = spr.drill,
        ['tent'] = spr.tent,
        ['bootcamp'] = spr.bootcamp,
        ['vehicle_maker'] = spr.vehicle_maker
    }
    buildingDimensions = {
        ['drill'] = {w = 2, h = 2},
        ['tent'] = {w = 2, h = 2},
        ['bootcamp'] = {w = 2, h = 2},
        ['vehicle_maker'] = {w = 3, h = 3}
    }
    buildingCooldown = {
        ['drill'] = 600,
        ['tent'] = 600,
        ['bootcamp'] = 1200,
        ['vehicle_maker'] = 1200
    }

    unitCost = {
        ['soldier'] = {metal = 10, count = 1},
        ['buggy'] = {metal = 50, count = 1},
        ['tank'] = {metal = 80, count = 2}
    }
    unitButtonScale = {
        ['buggy'] = 1,
        ['tank'] = 1,
        ['soldier'] = 1.5
    }
    unitSpriteOrigin = {
        ['tank'] = {x = 8, y = 16},
        ['buggy'] = {x=16, y = 16},
        ['soldier'] = {x = 16, y = 16}
    }

    minimapCanvas = love.graphics.newCanvas(120, 120)
    minimapUpdateTimer = 0






    --[[ENEMY STUFF]]
    enemy_unit = {
        {
            type = 'tank2',
            x = 688,
            y = 688,
            grid_x = 20,
            grid_y = 20,
            angle = 0,
            goal_angle = 0,
            gun_angle = 0,
            gun_goal_angle = 0,
            selected = false,
            currentStep = 0,
            speed = 2,
            path = nil
        }
    }
    enemy_building = 0
end