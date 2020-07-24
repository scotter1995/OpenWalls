--This script outlines the tasks we expect OpenWalls to, but in a vastly simplified environment
--with just rectangular walls and known resizing width and height values

local part1 = game.Workspace.Part1
local part2 = game.Workspace.Part2
local a = 0

local function onPartTouched(otherPart)
	if otherPart.Name == part2.Name then
		a = 1
	end
end


local part2Ray = Ray.new(part2.Position, (part1.Position - Vector3.new(part2.Position.X,part2.Position.Y,part2.Position.Z)).Unit * 50)
local hit, position = game.Workspace:FindPartOnRayWithIgnoreList(part2Ray, {part2})
if hit == part1 then
	for i = 0,2,1 do
		wait()
		part1.Size = part1.Size + Vector3.new(1,0,0)
	end
	for i = 0,6,1 do
		wait()
		part1.Size = part1.Size + Vector3.new(0,1,0)
	end
	for i = 0,1,.01 do
		wait()
		part1.CFrame = part1.CFrame:Lerp(part2.CFrame, i)
		part1.Touched:Connect(onPartTouched)
		print(a)
		if a == 1 then
			part1.Anchored = true
			part1.CFrame = CFrame.new(part1.Position) * CFrame.Angles(0,0,0)
			break
		end
	end
end