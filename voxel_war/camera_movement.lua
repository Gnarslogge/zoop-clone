function clampCamera(_cam, _worldW, _worldH, _viewW, _viewH)
    local _desiredX, _desiredY = _cam:getPosition()
    local _zoom = _cam:getScale()

    local _viewWorldW = _viewW / _zoom
    local _viewWorldH = _viewH / _zoom

    local _camX, _camY = _desiredX, _desiredY

    -- clamp state flags
    local _clampLeft, _clampRight = false, false
    local _clampTop, _clampBottom = false, false

    -- X axis
    if _worldW <= _viewWorldW then
        _camX = _worldW / 2
    else
        local _halfW = _viewWorldW / 2
        if _desiredX < _halfW then
            _camX = _halfW
            _clampLeft = true
        elseif _desiredX > _worldW - _halfW then
            _camX = _worldW - _halfW
            _clampRight = true
        end
    end

    -- Y axis
    if _worldH <= _viewWorldH then
        _camY = _worldH / 2
    else
        local _halfH = _viewWorldH / 2
        if _desiredY < _halfH then
            _camY = _halfH
            _clampTop = true
        elseif _desiredY > _worldH - _halfH then
            _camY = _worldH - _halfH
            _clampBottom = true
        end
    end

    _cam:setPosition(_camX, _camY)

    view_x = _camX
    view_y = _camY

    return {
        left = _clampLeft,
        right = _clampRight,
        top = _clampTop,
        bottom = _clampBottom
    }
end

function zoomToCursor(_cam, _zoomDelta)
    if _zoomDelta == 0 then return end

    zoom_moving = true

    -- world position under cursor BEFORE zoom
    local _wx_before, _wy_before = _cam:toWorld(mouse.gui_x, mouse.gui_y)

    -- apply zoom
    view_scale = _cam:getScale() + _zoomDelta
    view_scale = math.max(0.5, math.min(1.5, view_scale))
    _cam:setScale(view_scale)

    -- world position under cursor AFTER zoom
    local _wx_after, _wy_after = _cam:toWorld(mouse.gui_x, mouse.gui_y)

    -- move camera by the difference
    local _cx, _cy = _cam:getPosition()
    _cam:setPosition(
        _cx + (_wx_before - _wx_after),
        _cy + (_wy_before - _wy_after)
    )

    view_x = _cx
    view_y = _cy
end

function update_camera_movement()
    -- 1️⃣ Get current camera position as source of truth
    local cam_x, cam_y = cam:getPosition()
    local start_x, start_y = cam_x, cam_y

    local scroll_intent_x = 0
    local scroll_intent_y = 0
    local cam_moved_with_mouse = false

    -- 2️⃣ Edge scrolling
    if mouse.gui_x > (view_w - view_margin) then
        cam_x = cam_x + 8
        cam_moved_with_mouse = true
        scroll_intent_x = 1
    elseif mouse.gui_x < view_margin and not mouse.on_gui then
        cam_x = cam_x - 8
        cam_moved_with_mouse = true
        scroll_intent_x = -1
    end

    if mouse.gui_y > (view_h - view_margin) and not mouse.on_gui then
        cam_y = cam_y + 8
        cam_moved_with_mouse = true
        scroll_intent_y = 1
    elseif mouse.gui_y < view_margin then
        cam_y = cam_y - 8
        cam_moved_with_mouse = true
        scroll_intent_y = -1
    end

    -- 3️⃣ Arrow key movement (only if mouse not scrolling)
    if not cam_moved_with_mouse then
        if love.keyboard.isDown("up") then
            cam_y = cam_y - 8
            scroll_intent_y = -1
        end
        if love.keyboard.isDown("down") then
            cam_y = cam_y + 8
            scroll_intent_y = 1
        end
        if love.keyboard.isDown("left") then
            cam_x = cam_x - 8
            scroll_intent_x = -1
        end
        if love.keyboard.isDown("right") then
            cam_x = cam_x + 8
            scroll_intent_x = 1
        end
    end

    -- 4️⃣ Apply movement to camera before clamp
    cam:setPosition(cam_x, cam_y)

    -- 5️⃣ Clamp camera (updates view_x/view_y)
    clampCamera(cam, 1920, 1920, view_w, view_h)

    -- 6️⃣ Determine actual movement (ignoring zoom)
    local new_x, new_y = cam:getPosition()
    local xdiff = new_x - start_x
    local ydiff = new_y - start_y

    -- 7️⃣ Set cursor (diagonal-aware)
    local temp_cursor = cursor.default

    -- Only consider intentional movement
    local move_x = (scroll_intent_x ~= 0 and xdiff ~= 0 and math.sign(xdiff) == scroll_intent_x) and scroll_intent_x or 0
    local move_y = (scroll_intent_y ~= 0 and ydiff ~= 0 and math.sign(ydiff) == scroll_intent_y) and scroll_intent_y or 0

    if move_x ~= 0 and move_y ~= 0 then
        -- diagonal cursors
        if move_x > 0 and move_y < 0 then
            temp_cursor = cursor.upright
        elseif move_x < 0 and move_y < 0 then
            temp_cursor = cursor.upleft
        elseif move_x > 0 and move_y > 0 then
            temp_cursor = cursor.downright
        elseif move_x < 0 and move_y > 0 then
            temp_cursor = cursor.downleft
        end
    elseif move_x ~= 0 then
        -- horizontal only
        temp_cursor = move_x > 0 and cursor.right or cursor.left
    elseif move_y ~= 0 then
        -- vertical only
        temp_cursor = move_y > 0 and cursor.down or cursor.up
    end

    love.mouse.setCursor(temp_cursor)
end