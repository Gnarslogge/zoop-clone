function love.update(dt)

    --update mouse gui coords
    mouse.gui_x = love.mouse.getX()
    mouse.gui_y = love.mouse.getY()

    --test for gui mode
    if mouse.gui_y > 360 then
        mouse.on_gui = true
    else
        mouse.on_gui = false
    end

    --test for gui popup mode
    if guiFactoryPopup.active
    and mouse.gui_x >= view_w/2 - guiFactoryPopup.w/2 
    and mouse.gui_x < view_w/2 + guiFactoryPopup.w/2 
    and mouse.gui_y >= view_h/2 - guiFactoryPopup.h/2
    and mouse.gui_y < view_h/2 + guiFactoryPopup.h/2 then

        mouse.on_popup_gui = true
    
    else

        mouse.on_popup_gui = false

        --attempt to close popup gui if any clicks occur outside of window
        if love.mouse.isDown('1') then
            guiFactoryPopup.active = false
        end
    end

    --update gui buttons' hover status
    if mouse.on_gui then

        for i=1, #guiBuildingButton do

            if mouse.gui_x > guiBuildingButton[i].x
            and mouse.gui_x < guiBuildingButton[i].x + 48
            and mouse.gui_y >= guiBuildingButton[i].y
            and mouse.gui_y < guiBuildingButton[i].y + 48 then

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

    if guiFactoryPopup.active then
        for i=1, #guiFactoryPopup.button do

            if mouse.gui_x >= guiFactoryPopup.x + guiFactoryPopup.button[i].x
            and mouse.gui_x < guiFactoryPopup.x + guiFactoryPopup.button[i].x + guiFactoryPopup.button.w
            and mouse.gui_y >= guiFactoryPopup.y + guiFactoryPopup.button[i].y
            and mouse.gui_y < guiFactoryPopup.y + guiFactoryPopup.button[i].y + guiFactoryPopup.button.h then
                
                guiFactoryPopup.button[i].hover = true
                guiFactoryPopup.button[i].angle = guiFactoryPopup.button[i].angle + 1
            else
                guiFactoryPopup.button[i].hover = false
                guiFactoryPopup.button[i].angle = 90
            end
        end
    end

    --decrement guiBuildingButton cooldown
    if guiBuildingButton.cooldown > 0 then

        guiBuildingButton.cooldown = guiBuildingButton.cooldown - 1
    end

    --increment metal timer
    for i=1, #building do
        if building[i].type == "drill" then

            building[i].metal_timer = building[i].metal_timer + 1

            if building[i].metal_timer == 60 then

                building[i].metal_timer = 0

                metal = metal + 1
            end
        end
    end

    --toggle grid
    if love.keyboard.isDown('g') then
        draw_grid = not draw_grid
    end

    --[[CAMERA MOVEMENT]]
    function love.wheelmoved(_, y)
        if y == 0 then return end
        zoomToCursor(cam, y * 0.1)
    end

    update_camera_movement()

    --update mouse coords
    mouse.x, mouse.y = cam:toWorld(mouse.gui_x, mouse.gui_y)

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
    if mouse.gui_y > 360 then
        mouse.on_gui = true
    else
        mouse.on_gui = false
    end

    enemy_unit[1].angle = enemy_unit[1].angle + 1

    --MOUSE PRESSED DOWN
    if love.mouse.isDown(1) then

        --attempt to deselect any selected buildings
        if buildingSelected 
        and not mouse.held 
        and not mouse.on_popup_gui then
            buildingSelected = nil
        end

        --put into hold mode
        if mouse.held == false then
            mouse.held = true
            mouse.og_x = mouse.x
            mouse.og_y = mouse.y
        
        --initiate drag mode if cursor moves while held
        elseif mouse.drag == false 
        and mouse.mode == "interact" then

            if math.abs(mouse.og_x - mouse.x) >= 2
            and math.abs(mouse.og_y - mouse.y) >= 2 then

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

                if not mouse.on_popup_gui then
                
                    if mouse.mode == "interact" then

                        --attempt to select building
                        for i=1, #building do
                            if mouse.x > ((building[i].x-32) + (16*(building[i].w % 2))) - building[i].w*16
                            and mouse.x < ((building[i].x-32) + (16*(building[i].w % 2))) + building[i].w*16
                            and mouse.y > ((building[i].y-32) + (16*(building[i].h % 2))) - building[i].h*16
                            and mouse.y < ((building[i].y-32) + (16*(building[i].h % 2))) + building[i].h*16 then

                                buildingSelected = building[i]
                                selected_units = {}

                                --setup popup
                                if building[i].type == "vehicle_maker" then 
                                    guiFactoryPopup.active = true
                                    guiFactoryPopup.linkedBuilding = building[i]
                                end
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

                            --first free up tiles each unit is standing on, to prevent them from blocking eachother's pathfinding
                            for i=1, #selected_units do
                                grid_map[selected_units[i].grid_y][selected_units[i].grid_x] = 0
                            end


                            local target_x = mouse.grid_x - 1
                            local target_y = mouse.grid_y - 1

                            local temp_blocks = {}

                            if target_x <= 0 then target_x = 1 end
                            if target_y <= 0 then target_y = 1 end

                            for i, _unit in ipairs(selected_units) do

                                temp_target_x, temp_target_y = spiralSearch(target_x, target_y)

                                print(temp_target_x .. "/" .. temp_target_y)

                                --temporarily block this tile to prevent it from being used again
                                grid_map[temp_target_y][temp_target_x] = 0.5

                                table.insert(temp_blocks, {
                                    x = temp_target_x,
                                    y = temp_target_y
                                })

                                _unit.path = finder:getPath(_unit.grid_x, _unit.grid_y, temp_target_x, temp_target_y)
                                _unit.currentStep = 1

                            end

                            --unblock temporary blocks on tiles
                            for i=1, #temp_blocks do

                                grid_map[temp_blocks[i].y][temp_blocks[i].x] = 0
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
                            guiBuildingButton.cooldown_max = buildingCooldown[_building.type]
                            guiBuildingButton.cooldown = buildingCooldown[_building.type]

                            --subtract metal
                            metal = metal - buildingCost[_building.type]

                            --increase unit limit if tent
                            if _building.type == 'tent' then
                                unit_limit = unit_limit + 6
                            end

                            --reset gui buttons
                            guiBuildingButton.selected = nil

                            mouse.mode = "interact"
                        end
                    end
            
                --MOUSE ON FACTORY POPUP GUI
                else

                    for i=1, #guiFactoryPopup.button do

                        if guiFactoryPopup.button[i].hover then

                            local _unit_cost_count = unitCost[guiFactoryPopup.button[i].type].count

                            if unit_count + _unit_cost_count <= unit_limit then

                                local _grid_x, _grid_y = spiralSearch(guiFactoryPopup.linkedBuilding.grid_x,
                                                                      guiFactoryPopup.linkedBuilding.grid_y + 2)

                                local _x = _grid_x * 32 + 16
                                local _y = _grid_y * 32 + 16

                                table.insert(unit, {
                                    type = guiFactoryPopup.button[i].type,
                                    x = _x,
                                    y = _y,
                                    grid_x = _grid_x,
                                    grid_y = _grid_y,
                                    angle = 180,
                                    goal_angle = 0,
                                    gun_angle = 0,
                                    gun_goal_angle = 0,
                                    selected = false,
                                    currentStep = 0,
                                    speed = 2,
                                    path = nil
                                })

                                grid_map[_grid_y][_grid_x] = 1

                                unit_count = unit_count + unitCost[guiFactoryPopup.button[i].type].count
                            end
                            break
                        end
                    end
                end

            --MOUSE ON GUI
            else

                --check for click on minimap
                if mouse.gui_x >= gui.x
                and mouse.gui_x < gui.x + 120
                and mouse.gui_y >= gui.y
                and mouse.gui_y < gui.y + 120 then
                    
                    view_x = mouse.gui_x * 16
                    view_y = (mouse.gui_y - gui.y) * 16

                    cam:setPosition(view_x, view_y)
                end

                for i=1, #guiBuildingButton do

                    local _type = guiBuildingButton[i].type

                    if guiBuildingButton[i].hover == true 
                    and guiBuildingButton.cooldown == 0 
                    and metal >= buildingCost[_type] then

                        --deselect button and return mouse to interact mode OR select different button
                        if mouse.mode == "place" then
                            if mouse.to_place.type == _type then
                                guiBuildingButton.selected = nil
                                mouse.mode = "interact"
                                break
                            else
                                guiBuildingButton.selected = i
                            end

                        --select button and go into place mode
                        elseif mouse.mode == "interact" then
                            guiBuildingButton.selected = i
                            mouse.mode = "place"
                        end

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
                            metal_timer = 0,
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
    and metal >= buildingCost['drill'] then
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
                    metal_timer = 0
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

                --set tile we're moving to to be 0.5 (for the minimap)
                grid_map[_current_node.y][_current_node.x] = 0.5

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

                --calculate which angle direction is the shortest path
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