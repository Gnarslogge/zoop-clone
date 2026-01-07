function spiralSearch(targetX, targetY)

	local extraBreak = false
	local tempX = targetX
	local tempY = targetY
	local dirX = 1
	local dirY = 0
	local segmentLength = 1
	local totalSegments = 12
	local segmentStep = 0
	local segmentsCompleted = 0

	--first determine if the very center is NOT free
	if grid_map[targetY][targetX] ~= 0 then
		

		--swing on the spiral until a free tile is located
		for i=1, totalSegments do
			for i=1, segmentLength do
			
				--update x/y grid cords
				tempX = tempX + dirX
				tempY = tempY + dirY
				segmentStep = segmentStep + 1

				--if the tile isn't free
				if grid_map[tempY][tempX] ~= 0 then

					--check if segment is complete
					if segmentStep == segmentLength then
						segmentStep = 0
						segmentsCompleted = segmentsCompleted + 1

						--change direction
						if dirX == 1 and dirY == 0 then
							dirX, dirY = 0, 1
						elseif dirX == 0 and dirY == 1 then
							dirX, dirY = -1, 0
						elseif dirX == -1 and dirY == 0 then
							dirX, dirY = 0, -1
						elseif dirX == 0 and dirY == -1 then
							dirX, dirY = 1, 0
						end

						--increase segment length
						if segmentsCompleted == 2 then
							segmentsCompleted = 0
							segmentLength = segmentLength + 1
						end
					end

				else
					return tempX, tempY
				end

			end
		end
	else 
		return targetX, targetY
	end
end