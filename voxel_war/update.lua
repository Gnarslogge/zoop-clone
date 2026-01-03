function love.update(dt)

    --update mouse gui coords
    mouse.gui_x = love.mouse.getX()
    mouse.gui_y = love.mouse.getY()

    --test for gui mode
    if mouse.gui_y < 64 then
        mouse.on_gui = true
    else
        mouse.on_gui = false
    end

    --update gui buttons' hover status
    if mouse.on_gui then

        for i=1, #guiBuildingButton do

            if mouse.gui_x > guiBuildingButton[i].x
            and mouse.gui_x < guiBuildingButton[i].x + 64
            and mouse.gui_y >= guiBuildingButton[i].y
            and mouse.gui_y < guiBuildingButton[i].y + 64 then

                guiBuildingButton[i].hover = true
                guiBuildingButton[i].angle = guiBuildingButton[i].angle + 1

            else
                guiBuildingButton[i].hover = false
                guiBuildingButton[i].angle = 0
            end
        end
    else

        for i=1, #guiBuildingButton do
            guiBuildingButton[i].hover = false
            guiBuildingButton[i].angle = 0
        end
    end

    --decrement guiBuildingButton cooldown
    if guiBuildingButton.cooldown > 0 then

        guiBuildingButton.cooldown = guiBuildingButton.cooldown - 1
    end

    --increment money timer
    for i=1, #building do
        if building[i].type == "drill" then

            building[i].money_timer = building[i].money_timer + 1

            if building[i].money_timer == 60 then

                building[i].money_timer = 0

                money = money + 10
            end
        end
    end

    --toggle grid
    if love.keyboard.isDown('g') then
        draw_grid = not draw_grid
    end


    --move camera with arrow keys
    if love.keyboard.isDown('up') then
        view_y = view_y - 8
        if view_y < (480/2) then view_y = (480/2) end
    end
    if love.keyboard.isDown('down') then
        view_y = view_y + 8
        if view_y > (960 - (480/2)) then view_y = (960-(480/2)) end
    end
    if love.keyboard.isDown('left') then
        view_x = view_x - 8
        if view_x < (640/2) then view_x = (640/2) end
    end
    if love.keyboard.isDown('right') then
        view_x = view_x + 8
        if view_x > (1280 - (640/2)) then view_x = (1280 - (640/2)) end
    end

    cam:setPosition(view_x, view_y)

    --update mouse coords
    mouse.x = love.mouse.getX() + view_x - (640/2)
    mouse.y = love.mouse.getY() + view_y - (view_w/2)

    --move camera if mouse is on edges
    if mouse.x - view_x > (640/2 - 64) then 
        view_x = view_x + 8 
        if view_x > (1280 - (640/2)) then view_x = (1280 - (640/2)) end
    end
    if view_x - mouse.x > (640/2 - 64) then 
        view_x = view_x - 8 
        if view_x < (640/2 + 32) then view_x = (640/2 + 32) end
    end
    if mouse.y - view_y > (480/2 - 128) then
        view_y = view_y + 8
        if view_y > (960 - (480/2)) then view_y = (960 - (480/2)) end
    end
    if view_y - mouse.y > (480/2 - 64) 
    and not mouse.on_gui then
        view_y = view_y - 8
        if view_y < (480/2 + 32) then view_y = (480/2 + 32) end
    end

    cam:setPosition(view_x, view_y)

    --update mouse coords
    mouse.x = love.mouse.getX() + view_x - (640/2)
    mouse.y = love.mouse.getY() + view_y - (view_w/2 - 48)

    --determine mouse grid coords
    mouse.grid_x = math.floor(mouse.x/32) + 1
    mouse.grid_y = math.floor(mouse.y/32) + 1
    if mouse.grid_x < 2 then mouse.grid_x = 2 end
    if mouse.grid_y < 2 then mouse.grid_y = 2 end

    --update mouse to_place coords
    mouse.to_place.grid_x = mouse.grid_x
    mouse.to_place.grid_y = mouse.grid_y
    mouse.to_place.x = (mouse.grid_x+1) * 32
    mouse.to_place.y = (mouse.grid_y+1) * 32

    --test for gui mode
    if mouse.y - view_y < -240 then
        mouse.on_gui = true
    else
        mouse.on_gui = false
    end

    --MOUSE PRESSED DOWN
    if love.mouse.isDown(1) then

        --put into hold mode
        if mouse.held == false then
            mouse.held = true
            mouse.og_x = mouse.x
            mouse.og_y = mouse.y
        
        --initiate drag mode if cursor moves while held
        elseif mouse.drag == false 
        and mouse.mode == "interact" then

            if mouse.og_x ~= mouse.x
            or mouse.og_y ~= mouse.y then

                mouse.drag = true
            end
        end

    --MOUSE RELEASED
    elseif mouse.held then

        --drag mode
        if mouse.drag then

            --local variables to easily swap og / current mouse coords in calculations
            local _mx = mouse.x
            local _mox = mouse.og_x
            local _my = mouse.y
            local _moy = mouse.og_y

            --swap if needed
            if mouse.x < mouse.og_x then
                _mox = mouse.x
                _mx = mouse.og_x
            end
            if mouse.y < mouse.og_y then
                _moy = mouse.y
                _my = mouse.og_y
            end

            --attempt to select multiple units
            selected_units = {}

            for i=1, #unit do
                if unit[i].x >= _mox
                and unit[i].x <= _mx
                and unit[i].y >= _moy
                and unit[i].y <= _my then
                    unit[i].selected = true
                    table.insert(selected_units, unit[i])
                else
                    unit[i].selected = false
                end
            end
        
        --non-drag mode
        else

            if not mouse.on_gui then

                if mouse.mode == "interact" then

                    --attempt to select building
                    for i=1, #building do
                        if mouse.x > ((building[i].x-32) + (16*(building[i].w % 2))) - building[i].w*16
                        and mouse.x < ((building[i].x-32) + (16*(building[i].w % 2))) + building[i].w*16
                        and mouse.y > ((building[i].y-32) + (16*(building[i].h % 2))) - building[i].h*16
                        and mouse.y < ((building[i].y-32) + (16*(building[i].h % 2))) + building[i].h*16 then

                            buildingSelected = building[i]
                            selected_units = {}
                            break
                        end
                    end

                    --attempt to select single unit
                    local _selected_single_unit = false

                    for i=1, #unit do
                        if mouse.x > unit[i].x-16
                        and mouse.x < unit[i].x+16
                        and mouse.y > unit[i].y-16
                        and mouse.y < unit[i].y+16 then
                            
                            selected_units = {unit[i]}
                            unit[i].selected = true
                            _selected_single_unit = true

                            --deselect any building selected
                            buildingSelected = nil
                            break
                        end
                    end

                    --attempt to move selected units
                    if not _selected_single_unit then
                        for i, _unit in ipairs(selected_units) do

                            local target_x = mouse.grid_x - 1
                            local target_y = mouse.grid_y - 1

                            if target_x <= 0 then target_x = 1 end
                            if target_y <= 0 then target_y = 1 end

                            if i == 2 then 
                                target_x = target_x + 1
                            end
                            if i == 3 then 
                                target_x = target_x - 1
                            end
                            if i == 4 then
                                target_x = target_x + 1
                                target_y = target_y + 1
                            end

                            _unit.path = finder:getPath(_unit.grid_x, _unit.grid_y, target_x, target_y)
                            _unit.currentStep = 1

                        end
                    end

                --attempt to place building
                elseif mouse.mode == "place" then

                    if mouse.valid_placement then

                        local _building = table.shallowClone(mouse.to_place)
                        _building.ghost = false

                        table.insert(building, _building)

                        --update grid map
                        for i=1, _building.w do
                            for ii=1, _building.h do
                                grid_map[_building.grid_y-2+ii][_building.grid_x-2+i] = 1
                            end
                        end

                        --set cooldown
                        if _building.type == "drill" then

                            guiBuildingButton.cooldown_max = 600
                            guiBuildingButton.cooldown = 600
                        end

                        money = money - buildingCost[_building.type]

                        mouse.mode = "interact"
                    end
                end
            
            --MOUSE ON GUI
            else

                for i=1, #guiBuildingButton do

                    local _type = guiBuildingButton[i].type

                    if guiBuildingButton[i].hover == true 
                    and guiBuildingButton.cooldown == 0 
                    and money >= buildingCost[_type] then

                        if mouse.mode == "place" then
                            if mouse.to_place.type == _type then
                                mouse.mode = "interact"
                                break
                            end
                        end
 
                        mouse.mode = "place"

                        mouse.to_place = {
                            type = _type,
                            ghost = true,
                            w = buildingDimensions[_type].w,
                            h = buildingDimensions[_type].h,
                            x = (mouse.grid_x-1) * 32,
                            y = (mouse.grid_y-1) * 32,
                            grid_x = mouse.grid_x - 1,
                            grid_y = mouse.grid_y - 1,
                            spr = buildingSprite[_type],
                            money_timer = 0,
                            selected = false
                        }
                        
                        --shitty bandaid fix for a bug
                        if mouse.to_place.grid_y < 2 then mouse.to_place.grid_y = 2 end

                        break
                    end
                end
            end
        end
        mouse.held = false
        mouse.drag = false
    end

    --set mouse to_place building
    if love.keyboard.isDown('1') 
    and guiBuildingButton.cooldown == 0 
    and money >= buildingCost['drill'] then
        if not key_pressed['1'] then

            if mouse.mode ~= "place" then
                mouse.mode = "place"
                mouse.to_place = {
                    type = 'drill',
                    ghost = true,
                    w = 2,
                    h = 2,
                    x = (mouse.grid_x-1) * 32,
                    y = (mouse.grid_y-1) * 32,
                    grid_x = mouse.grid_x - 1,
                    grid_y = mouse.grid_y - 1,
                    spr = spr.drill,
                    money_timer = 0
                }
                --shitty bandaid fix for a bug
                if mouse.to_place.grid_y < 2 then mouse.to_place.grid_y = 2 end

            elseif mouse.to_place.type == "drill" then

                mouse.mode = "interact"
            end
            key_pressed['1'] = true
        end
    end


    if not love.keyboard.isDown('1') then
        key_pressed['1'] = false
    end


    --move units along their respective paths
    for i=1, #unit do

        if unit[i].path then

            local _node_list = {}

            --populate table with nodes
            for node, count in unit[i].path:nodes() do

                _node_list[count] = {
                    x = node:getX(),
                    y = node:getY()
                }
            end


            --identify target node
            local _current_node = _node_list[unit[i].currentStep]

            if _current_node then

                --set tile we're moving away from to be free
                grid_map[unit[i].grid_y][unit[i].grid_x] = 0

                local hori_dir = nil
                local vert_dir = nil

                --determine movement direction
                if _current_node.x*32 + 16 > unit[i].x then
                    unit[i].x = unit[i].x + unit[i].speed
                    hori_dir = "right"
                elseif _current_node.x*32 + 16 < unit[i].x then
                    unit[i].x = unit[i].x - unit[i].speed
                    hori_dir = "left"
                end
                if _current_node.y*32 + 16 > unit[i].y then
                    unit[i].y = unit[i].y + unit[i].speed
                    vert_dir = "down"
                elseif _current_node.y*32 + 16 < unit[i].y then
                    unit[i].y = unit[i].y - unit[i].speed
                    vert_dir = "up"
                end

                --adjust angle
                if vert_dir == "up" then

                    unit[i].goal_angle = 0
                    if hori_dir == "left" then unit[i].goal_angle = 315 end
                    if hori_dir == "right" then unit[i].goal_angle = 45 end

                elseif vert_dir == "down" then

                    unit[i].goal_angle = 180
                    if hori_dir == "left" then unit[i].goal_angle = 225 end
                    if hori_dir == "right" then unit[i].goal_angle = 135 end
                else

                    if hori_dir == "left" then unit[i].goal_angle = 270 end
                    if hori_dir == "right" then unit[i].goal_angle = 90 end
                end

                --calculate which direction is the shortest path
                local _diff = (unit[i].goal_angle - unit[i].angle + 360) % 360
                if _diff > 0
                and _diff <= 180 then
                    unit[i].angle = unit[i].angle + 5
                elseif _diff > 180 then
                    unit[i].angle = unit[i].angle - 5
                end

                --increment step
                if _current_node.x*32 + 16 == unit[i].x
                and _current_node.y*32 + 16 == unit[i].y then

                    unit[i].currentStep = unit[i].currentStep + 1
                    unit[i].grid_x = (unit[i].x-16) / 32
                    unit[i].grid_y = (unit[i].y-16) / 32
                end

            --if at the end of the path
            else
                grid_map[unit[i].grid_y][unit[i].grid_x] = 1
            end
        end
    end

    --determine if mouse.to_place placement is valid
    if mouse.mode == "place" then

        mouse.valid_placement = true

        for i=1, mouse.to_place.w do

            for ii=1, mouse.to_place.h do

                if grid_map[mouse.to_place.grid_y-2+ii][mouse.to_place.grid_x-2+i] ~= 0 then
                    mouse.valid_placement = false
                end
            end

        end
    end

    if love.keyboard.isDown('a') then
        cam:setScale(2)
    end

    --toggle debug display
    if love.keyboard.isDown('`') then
        if not key_pressed['`'] then
            debug_display = not debug_display
            key_pressed['`'] = true
        end
    else
        key_pressed['`'] = false
    end
end