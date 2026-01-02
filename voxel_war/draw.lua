function love.draw()

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
    if mouse.mode == "place" then
        table.insert(draw_order, mouse.to_place)
    end

    table.sort(draw_order, function(a, b)

        return a.y < b.y
    end)

    function cam_draw()

        --draw background
        love.graphics.setColor(1, 1, 1, 0.25)
        love.graphics.rectangle('fill', 0, 0, 1280, 960)
        love.graphics.setColor(1, 1, 1, 1)

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
        if mouse.mode == "interact" then
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
                    love.graphics.draw(spr.tank[ii], draw_order[i].x, draw_order[i].y-((ii*3)-3),
                                       math.rad(draw_order[i].angle), 2, 2, 8, 16)
                    love.graphics.draw(spr.tank[ii], draw_order[i].x, draw_order[i].y-((ii*3)-2),
                                       math.rad(draw_order[i].angle), 2, 2, 8, 16)
                    love.graphics.draw(spr.tank[ii], draw_order[i].x, draw_order[i].y-((ii*3)-1),
                                       math.rad(draw_order[i].angle), 2, 2, 8, 16 )
                end

            --wall
            elseif draw_order[i].type == "wall" then
            
                for ii=1, #spr.wall do
                    love.graphics.draw(spr.wall[ii], draw_order[i].grid_x * 32 + 16, (draw_order[i].grid_y*32+16)-((ii*3)-3), 0, 2, 2, 8, 8)
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
                    love.graphics.draw(spr.drill[ii], draw_order[i].grid_x * 32, (draw_order[i].grid_y*32) - ((ii*3)-3), 0, 2, 2, 16, 16)
                    love.graphics.draw(spr.drill[ii], draw_order[i].grid_x * 32, (draw_order[i].grid_y*32) - ((ii*3)-2), 0, 2, 2, 16, 16)
                    love.graphics.draw(spr.drill[ii], draw_order[i].grid_x * 32, (draw_order[i].grid_y*32) - ((ii*3)-1), 0, 2, 2, 16, 16)
                end

                --reset color
                love.graphics.setColor(1, 1, 1, 1)

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
    love.graphics.print(tostring(money), 544, 16)

    for i=1, #guiBuildingButton do


        love.graphics.setColor(0.5, 0.5, 0, 1)
        love.graphics.rectangle('fill', guiBuildingButton[i].x, guiBuildingButton[i].y, 64, 64)
        love.graphics.setColor(1, 1, 1, 1)


        --draw the building
        if money < buildingCost[guiBuildingButton[i].type] then
            love.graphics.setColor(0.5, 0.5, 0.5, 1)
        end

        if guiBuildingButton[i].type == "drill" then
        
            for ii=1, #spr.drill do
                love.graphics.draw(spr.drill[ii], guiBuildingButton[i].x + 32, guiBuildingButton[i].y + 32 - (ii), 
                                   math.rad(guiBuildingButton[i].angle), 1, 1, 16, 16)
            end
        
        elseif guiBuildingButton[i].type == 'vehicle_maker' then

            for ii=1, #spr.vehicle_maker do
                love.graphics.draw(spr.vehicle_maker[ii], guiBuildingButton[i].x + 32, guiBuildingButton[i].y + 32 - (ii), 
                                   math.rad(guiBuildingButton[i].angle), 1, 1, 24, 24)
            end
        end

        love.graphics.setColor(1, 1, 1, 1)

        if guiBuildingButton[i].hover 
        and guiBuildingButton.cooldown == 0 
        and money >= buildingCost[guiBuildingButton[i].type] then
            love.graphics.rectangle('line', guiBuildingButton[i].x, guiBuildingButton[i].y, 64, 64)
        end

        if money < buildingCost[guiBuildingButton[i].type] then
            --darken the image
            love.graphics.setColor(0, 0, 0, 0.5)
            love.graphics.rectangle("fill", guiBuildingButton[i].x, guiBuildingButton[i].y, 64, 64)
            love.graphics.setColor(1, 1, 1, 1)
        end

        if guiBuildingButton.cooldown > 0 then

            --darken the image
            love.graphics.setColor(0, 0, 0, 0.25)
            love.graphics.rectangle("fill", guiBuildingButton[i].x, guiBuildingButton[i].y, 64, 64)
            love.graphics.setColor(1, 1, 1, 1)

            --draw white loading bar over image
            local _draw_unit = 64 / guiBuildingButton.cooldown_max

            local _draw_height = (guiBuildingButton.cooldown_max - guiBuildingButton.cooldown) * _draw_unit

            love.graphics.setColor(1, 1, 1, 0.25)
            love.graphics.rectangle("fill", guiBuildingButton[i].x, guiBuildingButton[i].y + 64 - _draw_height, 64, _draw_height)
            love.graphics.setColor(1, 1, 1, 1)
        end

    end

    love.graphics.print(tostring(love.timer.getFPS()))

    --minimap
    for _y=1, #grid_map do
        for _x=1, #grid_map[_y] do

            love.graphics.setColor(0, 0, 0, 1)
            if grid_map[_y][_x] == 1 then

                love.graphics.setColor(0, 1, 0, 1)
            end
            love.graphics.rectangle('fill', 32 + _x*2, 320 + _y*2, 2, 2)
        end
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    love.graphics.rectangle('line', 32 + ((view_x-320)/16) + 1, 320 + ((view_y-240)/16) + 1, 40, 26)

    --mouse debug
    if (debug_display) then 
        love.graphics.print("MOUSE X/Y: " .. tostring(mouse.x) .. "/" .. tostring(mouse.y), 32, 400)
        love.graphics.print("MOUSE GUI X/Y: " .. tostring(mouse.gui_x) .. "/" .. tostring(mouse.gui_y), 32, 420)
        love.graphics.print("VIEW X/Y: " .. tostring(view_x) .. "/" .. tostring(view_y), 32, 440)
    end
end