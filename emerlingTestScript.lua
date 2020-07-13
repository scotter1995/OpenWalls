print("hhhhhhhhhhhhhhhh")
local part2 = game.Workspace.MeshToMove2
local wall2 = game.Workspace.Wall2


--wall2 = CFrame.Angles(math.rad(180),math.rad(180),math.rad(90))

--print(wall2.Position)
--print(wall2.CFrame.LookVector)


for i = 0, 1, .01 do
	wait()
		--part2.CFrame = part2.CFrame:Lerp((wall2.CFrame),i)
		--part2.CFrame = part2.CFrame:Lerp((CFrame:GetComponents(wall2))* (math.rad(180),math.rad(180),math.rad(90)),i)
		--part2.CFrame = CFrame.new(newc.CFrame.Position, newc.CFrame.LookVector)
		--part2.CFrame = CFrame.new(wall2.Position, math.rad(180),math.rad(180),math.rad(90)))		
		--part2.CFrame = CFrame.new(newc.CFrame.Position)
		part2.CFrame = CFrame.new(wall2.CFrame:GetComponents())
end