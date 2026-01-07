function love.draw()

    --populate and sort draw order table
    draw_order = {}

    for i=1, #building do
        table.insert(draw_order, building[i])
    end
    for i=1, #unit do
        table.insert(draw_order, unit[i])
    end
    for i=1, #wall do
        table.insert(draw_order, wall[i])
    end
    for i=1, #enemy_unit do
        table.insert(draw_order, enemy_unit[i])
    end
    if mouse.mode == "place" then
        table.insert(draw_order, mouse.to_place)
    end

    table.sort(draw_order, function(a, b)
        return a.y < b.y
    end)

    --draw camera view
    function cam_draw()

        --draw background
        love.graphics.draw(spr.bg, 0, 0, 0, 32, 32)

        --draw grid
        if (draw_grid) then
            love.graphics.setColor(0, 1, 0, 0.5)
            for i=1, 40 do
                love.graphics.line(i*32, 0, i*32, 960)
            end
            for i=1, 30 do
                love.graphics.line(0, i*32, 1280, i*32)
            end
            love.graphics.setColor(1, 1, 1, 1)
        end

        --selected grid square
        if mouse.mode == "interact" 
        and not mouse.on_gui
        and not mouse.on_popup_gui then
            love.graphics.rectangle('fill', ((mouse.grid_x-1)*32), ((mouse.grid_y-1)*32), 32, 32)
        end

        --selected building
        if buildingSelected then 

            love.graphics.setColor(0, 1, 0, 1) --green
            love.graphics.circle('line', buildingSelected.x-32 + (16 * (buildingSelected.w % 2)), 
                                         buildingSelected.y-32 + (16 * (buildingSelected.h % 2)), buildingSelected.w*16 + 16)
            love.graphics.setColor(1, 1, 1, 1)
        end

        --unit selection
        for i=1, #selected_units do 
            love.graphics.setColor(0, 1, 0, 1) --green
            love.graphics.circle('line', selected_units[i].x, selected_units[i].y, 24)
            love.graphics.setColor(1, 1, 1, 1) --white
        end
        
        --draw all entities
        for i=1, #draw_order do

            --tank
            if draw_order[i].type == "tank" then

                for ii=1, #spr.tank do
                    love.graphics.draw(spr.tank[ii], draw_order[i].x, draw_order[i].y-ii-1,
                                       math.rad(draw_order[i].angle), 1, 1, 16, 16)
                end

            elseif draw_order[i].type == 'tank2' then
            
                --draw base of tank
                for ii=1, #spr.enemy_tank.base do

                    love.graphics.draw(spr.enemy_tank.base[ii], draw_order[i].x, draw_order[i].y-ii-1,
                                       math.rad(draw_order[i].angle), 1, 1, 16, 16)
                end

            --buggy
            elseif draw_order[i].type == 'buggy' then

                for ii=1, #spr.buggy do
                    love.graphics.draw(spr.buggy[ii], draw_order[i].x, draw_order[i].y-(ii-1),
                                       math.rad(draw_order[i].angle),
                                       1, 1, 16, 16)
                end

            --soldier
            elseif draw_order[i].type == "soldier" then
                
                for ii=1, #spr.soldier do
                    love.graphics.draw(spr.soldier[ii], draw_order[i].x, draw_order[i].y-(ii),
                                       math.rad(draw_order[i].angle), 1, 1, 16, 16) 
                end

            --wall
            elseif draw_order[i].type == "wall" then

                for ii=1, #spr.wall do
                    love.graphics.draw(spr.wall[ii], draw_order[i].grid_x * 32 + 16,
                                                     (draw_order[i].grid_y*32+16)-((ii*3)-3), 0, 2, 2, 8, 8)
                end
            
            --drill
            elseif draw_order[i].type == "drill" then

                --toggle color based on validity
                if draw_order[i].ghost then 
                    if mouse.valid_placement then
                        love.graphics.setColor(1, 1, 1, 0.25)
                    else
                        love.graphics.setColor(1, 0, 0, 0.25)
                    end
                end

                --draw drill
                for ii=1, #spr.drill do


                    love.graphics.draw(spr.drill[ii], draw_order[i].grid_x * 32, 
                                                      (draw_order[i].grid_y*32) - (ii*2) - 3, 
                                                      0, 2, 2, 16, 16)
                    love.graphics.draw(spr.drill[ii], draw_order[i].grid_x * 32, 
                                                      (draw_order[i].grid_y*32) - (ii*2) - 2, 
                                                      0, 2, 2, 16, 16)
                    love.graphics.draw(spr.drill[ii], draw_order[i].grid_x * 32, 
                                                      (draw_order[i].grid_y*32) - (ii*2) - 1, 
                                                      0, 2, 2, 16, 16)
                end

                --reset color
                love.graphics.setColor(1, 1, 1, 1)

            --tent
            elseif draw_order[i].type == "tent" then

                --toggle color based on validity
                if draw_order[i].ghost then 
                    if mouse.valid_placement then
                        love.graphics.setColor(1, 1, 1, 0.25)
                    else
                        love.graphics.setColor(1, 0, 0, 0.25)
                    end
                end

                --draw vehicle maker
                for ii=1, #spr.tent do
                    love.graphics.draw(spr.tent[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*2)-3), 0, 2, 2, 24, 24)
                    love.graphics.draw(spr.tent[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*2)-2), 0, 2, 2, 24, 24)
                    love.graphics.draw(spr.tent[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*2)-1), 0, 2, 2, 24, 24)
                end

                --reset color
                love.graphics.setColor(1, 1, 1, 1)

            elseif draw_order[i].type == "bootcamp" then

                --toggle color based on validity
                if draw_order[i].ghost then 
                    if mouse.valid_placement then
                        love.graphics.setColor(1, 1, 1, 0.25)
                    else
                        love.graphics.setColor(1, 0, 0, 0.25)
                    end
                end

                --draw vehicle maker
                for ii=1, #spr.bootcamp do
                    love.graphics.draw(spr.bootcamp[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*2)-3), 0, 2, 2, 24, 24)
                    love.graphics.draw(spr.bootcamp[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*2)-2), 0, 2, 2, 24, 24)
                    love.graphics.draw(spr.bootcamp[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*2)-1), 0, 2, 2, 24, 24)
                end

                --reset color
                love.graphics.setColor(1, 1, 1, 1)

            --vehicle maker
            elseif draw_order[i].type == "vehicle_maker" then

                --toggle color based on validity
                if draw_order[i].ghost then 
                    if mouse.valid_placement then
                        love.graphics.setColor(1, 1, 1, 0.25)
                    else
                        love.graphics.setColor(1, 0, 0, 0.25)
                    end
                end

                --draw vehicle maker
                for ii=1, #spr.vehicle_maker do
                    love.graphics.draw(spr.vehicle_maker[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*3)-3), 0, 2, 2, 24, 24)
                    love.graphics.draw(spr.vehicle_maker[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*3)-2), 0, 2, 2, 24, 24)
                    love.graphics.draw(spr.vehicle_maker[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16) - ((ii*3)-1), 0, 2, 2, 24, 24)
                end

                --reset color
                love.graphics.setColor(1, 1, 1, 1)
            end
        end

        --select region
        if mouse.drag then
            love.graphics.rectangle("line", mouse.og_x, mouse.og_y, mouse.x - mouse.og_x, mouse.y - mouse.og_y)
        end
    end

    cam:draw(cam_draw)


    --GUI

    --resource icons
    love.graphics.draw(spr.metal_icon, 8, 8)
    love.graphics.print(tostring(metal), 40, 8)
    love.graphics.draw(spr.unit_icon, 8, 40)
    love.graphics.print(tostring(unit_count) .. "/" .. tostring(unit_limit), 40, 40)

    --buttons
    for i=1, #guiBuildingButton do

        --start with normal sprite
        local _button_sprite = spr.guiBuildingButton.normal
        
        --selected sprite
        if guiBuildingButton.selected == i then
            _button_sprite = spr.guiBuildingButton.selected
        end

        --dull sprite if costs too much
        if metal < buildingCost[guiBuildingButton[i].type] then
            _button_sprite = spr.guiBuildingButton.dull
        end

        --draw button sprite
        love.graphics.draw(_button_sprite, guiBuildingButton[i].x, guiBuildingButton[i].y)

        --draw outline if hover
        if guiBuildingButton[i].hover 
        and guiBuildingButton.cooldown == 0 
        and metal >= buildingCost[guiBuildingButton[i].type] then
            love.graphics.draw(spr.guiBuildingButton.outline, guiBuildingButton[i].x, guiBuildingButton[i].y)
        end

        --draw building cost
        love.graphics.setFont(button_font)
        love.graphics.print(tostring(buildingCost[guiBuildingButton[i].type]), guiBuildingButton[i].x + 24, guiBuildingButton[i].y + 48)
        love.graphics.setFont(font)

        --draw the building
        if metal < buildingCost[guiBuildingButton[i].type] then
            love.graphics.setColor(0.5, 0.5, 0.5, 1)
        end

        if guiBuildingButton[i].type == "drill" then
        
            for ii=1, #spr.drill do
                love.graphics.draw(spr.drill[ii], guiBuildingButton[i].x + 24, guiBuildingButton[i].y + 24 - (ii), 
                                   math.rad(guiBuildingButton[i].angle), 0.75, 0.75, 16, 16)
            end
        
        elseif guiBuildingButton[i].type == "tent" then

            for ii=1, #spr.tent do
                love.graphics.draw(spr.tent[ii], guiBuildingButton[i].x + 24, guiBuildingButton[i].y + 24 - (ii*0.70),
                                   math.rad(guiBuildingButton[i].angle), 0.75, 0.75, 16, 16)

            end

        elseif guiBuildingButton[i].type == "bootcamp" then

            for ii=1, #spr.bootcamp do
                love.graphics.draw(spr.bootcamp[ii], guiBuildingButton[i].x + 24, guiBuildingButton[i].y + 24 - (ii),
                                   math.rad(guiBuildingButton[i].angle), 0.75, 0.75, 16, 16)
            end

        elseif guiBuildingButton[i].type == 'vehicle_maker' then

            for ii=1, #spr.vehicle_maker do
                love.graphics.draw(spr.vehicle_maker[ii], guiBuildingButton[i].x + 24, guiBuildingButton[i].y + 24 - (ii), 
                                   math.rad(guiBuildingButton[i].angle), 0.5, 0.5, 24, 24)
            end
        end

        love.graphics.setColor(1, 1, 1, 1)

        --draw cooldown effect
        if guiBuildingButton.cooldown > 0 then

            --draw white loading bar over image
            local _draw_unit = 64 / guiBuildingButton.cooldown_max

            local _draw_height = (guiBuildingButton.cooldown_max - guiBuildingButton.cooldown) * _draw_unit

            --darken the image
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", guiBuildingButton[i].x, guiBuildingButton[i].y, 48, 64 - _draw_height)
            love.graphics.setColor(1, 1, 1, 1)
        end

    end

    love.graphics.print(tostring(love.timer.getFPS()))


    --minimap
    minimapUpdateTimer = minimapUpdateTimer + 1

    if minimapUpdateTimer == 60 then

        love.graphics.setCanvas(minimapCanvas)

        for _y=1, #grid_map do
            for _x=1, #grid_map[_y] do

                love.graphics.setColor(0, 0, 0.5, 1)
                if grid_map[_y][_x] ~= 0 then

                    love.graphics.setColor(0, 1, 0, 1)
                end
                love.graphics.rectangle('fill', (_x-1)*2, (_y-1)*2, 2, 2)
            end
        end

        love.graphics.setCanvas()

        minimapUpdateTimer = 0
    end
    
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(minimapCanvas, gui.x, gui.y)
    love.graphics.setBlendMode('alpha')

    --draw rectangle viewport
    -- camera info
    local camX, camY = cam:getPosition()
    local zoom = cam:getScale()

    -- visible world size
    local viewWorldW = view_w / zoom
    local viewWorldH = view_h / zoom

    -- minimap scaling
    local scaleX = 120 / 1920
    local scaleY = 120 / 1920

    -- minimap rectangle size
    local rectW = viewWorldW * scaleX
    local rectH = viewWorldH * scaleY

    -- minimap rectangle position
    local viewX = camX - viewWorldW / 2
    local viewY = camY - viewWorldH / 2

    local rectX = gui.x + viewX * scaleX
    local rectY = gui.y + viewY * scaleY

    -- draw
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", rectX, rectY, rectW, rectH)

    --[[
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', gui.x + ((view_x-(view_w/2))/16) + 1, gui.y + ((view_y-(view_h/2))/16) + 1, 38, 21)
    ]]
    --mouse debug
    if (debug_display) then 
        love.graphics.print("MOUSE X/Y: " .. tostring(mouse.x) .. "/" .. tostring(mouse.y), 32, 400)
        love.graphics.print("MOUSE GUI X/Y: " .. tostring(mouse.gui_x) .. "/" .. tostring(mouse.gui_y), 32, 420)
        love.graphics.print("VIEW X/Y: " .. tostring(view_x) .. "/" .. tostring(view_y), 32, 440)
        love.graphics.print("ZOOM: " .. tostring(view_scale), 32, 460)
    end

    --gui factory popup
    if guiFactoryPopup.active then
        
        --draw background
        love.graphics.draw(spr.guiFactoryPopup.bg, guiFactoryPopup.x, guiFactoryPopup.y)

        --draw building name
        love.graphics.print("FACTORY", guiFactoryPopup.x + 8, guiFactoryPopup.y)

        --draw buttons
        local _button = guiFactoryPopup.button

        for i=1, #_button do

            --draw button
            local _spr = spr.guiFactoryPopup.normal

            love.graphics.draw(_spr, guiFactoryPopup.x + _button[i].x, guiFactoryPopup.y + _button[i].y)

            --draw highlighted outline if hovering over
            if _button[i].hover then
                love.graphics.draw(spr.guiFactoryPopup.outline, guiFactoryPopup.x + _button[i].x, guiFactoryPopup.y + _button[i].y)
            end

            --draw costs
            love.graphics.setFont(button_font)
            love.graphics.print(tostring(unitCost[_button[i].type].metal), guiFactoryPopup.x + _button[i].x + 24, guiFactoryPopup.y + _button[i].y + 48)
            love.graphics.print(tostring(unitCost[_button[i].type].count), guiFactoryPopup.x + _button[i].x + 24, guiFactoryPopup.y + _button[i].y + 64)
            love.graphics.setFont(font)

            --draw spritestack
            local _stackheight = 1

            if _button[i].type == 'tank' then
                _stackheight = 1
            end

            for ii=1, #spr[_button[i].type] do
                love.graphics.draw(spr[_button[i].type][ii], 
                                   guiFactoryPopup.x + _button[i].x + 24, guiFactoryPopup.y + _button[i].y - ((ii-1)*_stackheight) + 24, 
                                   math.rad(_button[i].angle), 
                                    unitButtonScale[_button[i].type], unitButtonScale[_button[i].type],
                                    unitSpriteOrigin[_button[i].type].x, unitSpriteOrigin[_button[i].type].y)
            end
        end
    end

    --resource icons

end