--This is a compilation of functions extracted from Resize Align that may prove helpful
--inspiration for OpenWalls's code. This is not supposed to run as its own script -
--it's intended as a reference

function GetGeometry(part, hit)
	local cf = part.CFrame
	local pos = cf.p
	--
	local sx = part.Size.x/2
	local sy = part.Size.y/2
	local sz = part.Size.z/2
	--
	local xvec = rightVector(cf)
	local yvec = topVector(cf)
	local zvec = backVector(cf)
	--
	local verts, edges, faces;--set up local variables to be used as containers for the parts
	--data
	local vertexMargin;
	--
	if part:IsA('Part') then--if we've selected a valid part
		if part.Shape == Enum.PartType.Block or part.Shape == Enum.PartType.Cylinder then
			--8 vertices
			verts = {
				pos +xvec*sx  +yvec*sy  +zvec*sz, --top 4
				pos +xvec*sx  +yvec*sy  -zvec*sz,
				pos -xvec*sx  +yvec*sy  +zvec*sz,
				pos -xvec*sx  +yvec*sy  -zvec*sz,
				--
				pos +xvec*sx  -yvec*sy  +zvec*sz, --bottom 4
				pos +xvec*sx  -yvec*sy  -zvec*sz,
				pos -xvec*sx  -yvec*sy  +zvec*sz,
				pos -xvec*sx  -yvec*sy  -zvec*sz,
			}
			--12 edges
			edges = {
				{verts[1], verts[2], math.min(2*sx, 2*sy)}, --top 4
				{verts[3], verts[4], math.min(2*sx, 2*sy)},
				{verts[1], verts[3], math.min(2*sy, 2*sz)},
				{verts[2], verts[4], math.min(2*sy, 2*sz)},
				--
				{verts[5], verts[6], math.min(2*sx, 2*sy)}, --bottom 4
				{verts[7], verts[8], math.min(2*sx, 2*sy)},
				{verts[5], verts[7], math.min(2*sy, 2*sz)},
				{verts[6], verts[8], math.min(2*sy, 2*sz)},
				--
				{verts[1], verts[5], math.min(2*sx, 2*sz)}, --verticals
				{verts[2], verts[6], math.min(2*sx, 2*sz)},
				{verts[3], verts[7], math.min(2*sx, 2*sz)},
				{verts[4], verts[8], math.min(2*sx, 2*sz)},
			}
			--6 faces
			faces = {
				{verts[1],  xvec, zvec, {verts[1], verts[2], verts[6], verts[5]}}, --right
				{verts[3], -xvec, zvec, {verts[3], verts[4], verts[8], verts[7]}}, --left
				{verts[1],  yvec, xvec, {verts[1], verts[2], verts[4], verts[3]}}, --top
				{verts[5], -yvec, xvec, {verts[5], verts[6], verts[8], verts[7]}}, --bottom
				{verts[1],  zvec, xvec, {verts[1], verts[3], verts[7], verts[5]}}, --back
				{verts[2], -zvec, xvec, {verts[2], verts[4], verts[8], verts[6]}}, --front
			}
		elseif part.Shape == Enum.PartType.Ball then
			-- just have one face and vertex, at the hit pos
			verts = { hit }
			edges = {} --edge can be selected as the normal of the face if the user needs it
			local norm = (hit-pos).unit
			local norm2 = norm:Cross(Vector3.new(0,1,0)).unit
			faces = {
				{hit, norm, norm2, {}}
			}
 
		else
			assert(false, "Bad Part Shape: `"..tostring(part.Shape).."`")
		end
	elseif part:IsA('CornerWedgePart') then
		local slantVec1 = ( zvec*sy + yvec*sz).unit
		local slantVec2 = (-xvec*sy + yvec*sx).unit
		-- 5 verts
		verts = {
			pos +xvec*sx  +yvec*sy  -zvec*sz, --top 1
			--
			pos +xvec*sx  -yvec*sy  +zvec*sz, --bottom 4
			pos +xvec*sx  -yvec*sy  -zvec*sz,
			pos -xvec*sx  -yvec*sy  +zvec*sz,
			pos -xvec*sx  -yvec*sy  -zvec*sz,
		}
		-- 8 edges
		edges = {
			{verts[2], verts[3], 0}, -- bottom 4
			{verts[3], verts[5], 0},
			{verts[5], verts[4], 0},
			{verts[4], verts[1], 0},
			--
			{verts[1], verts[3], 0}, -- vertical
			--
			{verts[1], verts[2], 0}, -- side diagonals
			{verts[1], verts[5], 0},
			--
			{verts[1], verts[4], 0}, -- middle diagonal
		}
		-- 5 faces
		faces = {
			{verts[2], -yvec, xvec, {verts[2], verts[3], verts[5], verts[4]}}, -- bottom
			--
			{verts[1],  xvec, -yvec, {verts[1], verts[3], verts[2]}}, -- sides
			{verts[1], -zvec, -yvec, {verts[1], verts[3], verts[5]}},
			--
			{verts[1],  slantVec1, xvec, {verts[1], verts[2], verts[4]}}, -- tops
			{verts[1],  slantVec2, zvec, {verts[1], verts[5], verts[4]}},
		}
 
	elseif part:IsA('WedgePart') then
		local slantVec = (-zvec*sy + yvec*sz).unit
		--6 vertices
		verts = {
			pos +xvec*sx  +yvec*sy  +zvec*sz, --top 2
			pos -xvec*sx  +yvec*sy  +zvec*sz,
			--
			pos +xvec*sx  -yvec*sy  +zvec*sz, --bottom 4
			pos +xvec*sx  -yvec*sy  -zvec*sz,
			pos -xvec*sx  -yvec*sy  +zvec*sz,
			pos -xvec*sx  -yvec*sy  -zvec*sz,
		}
		--9 edges
		edges = {
			{verts[1], verts[2], math.min(2*sy, 2*sz)}, --top 1
			--
			{verts[1], verts[4], math.min(2*sy, 2*sz)}, --slanted 2
			{verts[2], verts[6], math.min(2*sy, 2*sz)},
			--
			{verts[3], verts[4], math.min(2*sx, 2*sy)}, --bottom 4
			{verts[5], verts[6], math.min(2*sx, 2*sy)},
			{verts[3], verts[5], math.min(2*sy, 2*sz)},
			{verts[4], verts[6], math.min(2*sy, 2*sz)},
			--
			{verts[1], verts[3], math.min(2*sx, 2*sz)}, --vertical 2
			{verts[2], verts[5], math.min(2*sx, 2*sz)},
		}
		--5 faces
		faces = {
			{verts[1],  xvec, zvec, {verts[1], verts[4], verts[3]}}, --right
			{verts[2], -xvec, zvec, {verts[2], verts[6], verts[5]}}, --left
			{verts[3], -yvec, xvec, {verts[3], verts[4], verts[6], verts[5]}}, --bottom
			{verts[1],  zvec, xvec, {verts[1], verts[2], verts[5], verts[3]}}, --back
			{verts[2], slantVec, slantVec:Cross(xvec), {verts[2], verts[1], verts[4], verts[6]}}, --slanted
		}
	elseif part:IsA('Terrain') then
		local cellPos = game.Workspace.Terrain:WorldToCellPreferSolid(hit)
		local mat, block, orient = game.Workspace.Terrain:GetCell(cellPos.x, cellPos.y, cellPos.z)
		local pos = game.Workspace.Terrain:CellCenterToWorld(cellPos.x, cellPos.y, cellPos.z)
		--
		vertexMargin = 4
		--
		local orientToNumberMap = {
			[Enum.CellOrientation.NegZ] = 0;
			[Enum.CellOrientation.X]    = 1;
			[Enum.CellOrientation.Z]    = 2;
			[Enum.CellOrientation.NegX] = 3;
		}
		--
		local xvec = CFrame.Angles(0, math.pi/2*(orientToNumberMap[orient]-1), 0).lookVector
		local yvec = Vector3.new(0, 1, 0)
		local zvec = xvec:Cross(yvec)
		--
		if block == Enum.CellBlock.Solid then
			--8 vertices
			verts = {
				pos +xvec*2  +yvec*2  +zvec*2, --top 4
				pos +xvec*2  +yvec*2  -zvec*2,
				pos -xvec*2  +yvec*2  +zvec*2,
				pos -xvec*2  +yvec*2  -zvec*2,
				--
				pos +xvec*2  -yvec*2  +zvec*2, --bottom 4
				pos +xvec*2  -yvec*2  -zvec*2,
				pos -xvec*2  -yvec*2  +zvec*2,
				pos -xvec*2  -yvec*2  -zvec*2,
			}
			--12 edges
			edges = {
				{verts[1], verts[2], 4}, --top 4
				{verts[3], verts[4], 4},
				{verts[1], verts[3], 4},
				{verts[2], verts[4], 4},
				--
				{verts[5], verts[6], 4}, --bottom 4
				{verts[7], verts[8], 4},
				{verts[5], verts[7], 4},
				{verts[6], verts[8], 4},
				--
				{verts[1], verts[5], 4}, --verticals
				{verts[2], verts[6], 4},
				{verts[3], verts[7], 4},
				{verts[4], verts[8], 4},
			}
			--6 faces
			faces = {
				{pos+xvec*2,  xvec, zvec, {verts[1], verts[2], verts[6], verts[5]}}, --right
				{pos-xvec*2, -xvec, zvec, {verts[3], verts[4], verts[8], verts[7]}}, --left
				{pos+yvec*2,  yvec, xvec, {verts[1], verts[2], verts[4], verts[3]}}, --top
				{pos-yvec*2, -yvec, xvec, {verts[5], verts[6], verts[8], verts[7]}}, --bottom
				{pos+zvec*2,  zvec, xvec, {verts[1], verts[3], verts[7], verts[5]}}, --back
				{pos-zvec*2, -zvec, xvec, {verts[2], verts[4], verts[8], verts[6]}}, --front
			}
 
		elseif block == Enum.CellBlock.VerticalWedge then
			--top wedge. Similar to wedgepart, but we need to flip the Z axis
			zvec = -zvec
			xvec = -xvec
			--
			local slantVec = (-zvec*2 + yvec*2).unit
			--6 vertices
			verts = {
				pos +xvec*2  +yvec*2  +zvec*2, --top 2
				pos -xvec*2  +yvec*2  +zvec*2,
				--
				pos +xvec*2  -yvec*2  +zvec*2, --bottom 4
				pos +xvec*2  -yvec*2  -zvec*2,
				pos -xvec*2  -yvec*2  +zvec*2,
				pos -xvec*2  -yvec*2  -zvec*2,
			}
			--9 edges
			edges = {
				{verts[1], verts[2], 4}, --top 1
				--
				{verts[1], verts[4], 4}, --slanted 2
				{verts[2], verts[6], 4},
				--
				{verts[3], verts[4], 4}, --bottom 4
				{verts[5], verts[6], 4},
				{verts[3], verts[5], 4},
				{verts[4], verts[6], 4},
				--
				{verts[1], verts[3], 4}, --vertical 2
				{verts[2], verts[5], 4},
			}
			--5 faces
			faces = {
				{pos+xvec*2,  xvec, zvec, {verts[1], verts[4], verts[3]}}, --right
				{pos-xvec*2, -xvec, zvec, {verts[2], verts[6], verts[5]}}, --left
				{pos-yvec*2, -yvec, xvec, {verts[3], verts[4], verts[6], verts[5]}}, --bottom
				{pos+zvec*2,  zvec, xvec, {verts[1], verts[2], verts[5], verts[3]}}, --back
				{pos, slantVec, slantVec:Cross(xvec), {verts[2], verts[1], verts[4], verts[6]}}, --slanted
			}
 
		elseif block == Enum.CellBlock.CornerWedge then
			--top corner wedge
			--4 verts
			verts = {
				pos +xvec*2  +yvec*2  -zvec*2, --top 1
				--
				pos +xvec*2  -yvec*2  -zvec*2, --bottom 3
				pos +xvec*2  -yvec*2  +zvec*2,
				pos -xvec*2  -yvec*2  -zvec*2,
			}
			--6 edges
			edges = {
				{verts[1], verts[2], 3},
				{verts[1], verts[3], 3},
				{verts[1], verts[4], 3},
				{verts[2], verts[3], 3},
				{verts[2], verts[4], 3},
				{verts[3], verts[4], 3},
			}
			local centerXZ = ((verts[3]+verts[4])/2 + verts[2])/2
			local slantCenter = Vector3.new(centerXZ.x, pos.y, centerXZ.z)
			local slantFaceDir = ((zvec-xvec).unit*2 + Vector3.new(0, math.sqrt(2), 0)).unit
			--4 faces
			faces = {
				{centerXZ, -yvec, xvec, {verts[2], verts[3], verts[4]}},
				{pos + xvec*2,  xvec, yvec, {verts[1], verts[2], verts[3]}},
				{pos - zvec*2, -zvec, yvec, {verts[1], verts[2], verts[4]}},
				{slantCenter, slantFaceDir, (xvec+zvec).unit, {verts[1], verts[3], verts[4]}},
			}
 
		elseif block == Enum.CellBlock.InverseCornerWedge then
			--block corner cut
			--7 vertices
			verts = {
				pos +xvec*2  +yvec*2  +zvec*2, --top 3
				pos +xvec*2  +yvec*2  -zvec*2,
				pos -xvec*2  +yvec*2  -zvec*2,
				--
				pos +xvec*2  -yvec*2  +zvec*2, --bottom 4
				pos +xvec*2  -yvec*2  -zvec*2,
				pos -xvec*2  -yvec*2  +zvec*2,
				pos -xvec*2  -yvec*2  -zvec*2,
			}
			--12 edges
			edges = {
				{verts[1], verts[2], 4}, --top 4
				{verts[2], verts[3], 4},
				--
				{verts[4], verts[5], 4}, --bottom 4
				{verts[6], verts[7], 4},
				{verts[4], verts[6], 4},
				{verts[5], verts[7], 4},
				--
				{verts[1], verts[4], 4}, --verticals
				{verts[2], verts[5], 4},
				{verts[3], verts[7], 4},
				--
				{verts[1], verts[3], 2.5}, --slants
				{verts[1], verts[6], 2.5},
				{verts[3], verts[6], 2.5},
			}
			--7 faces
			local centerXZ = ((verts[4]+verts[7])/2 + verts[6])/2
			local slantCenter = Vector3.new(centerXZ.x, pos.y, centerXZ.z)
			local slantFaceDir = ((zvec-xvec).unit*2 + Vector3.new(0, math.sqrt(2), 0)).unit
			faces = {
				{pos+xvec*2,  xvec, zvec, {verts[1], verts[2], verts[5], verts[4]} }, --right
				{pos-xvec*2, -xvec, zvec, {verts[3], verts[7], verts[6]}           }, --left
				{pos+yvec*2,  yvec, xvec, {verts[1], verts[2], verts[3]}           }, --top
				{pos-yvec*2, -yvec, xvec, {verts[4], verts[5], verts[7], verts[6]} }, --bottom
				{pos+zvec*2,  zvec, xvec, {verts[1], verts[6], verts[4]}           }, --back
				{pos-zvec*2, -zvec, xvec, {verts[2], verts[3], verts[7], verts[5]} }, --front
				{slantCenter, slantFaceDir, (xvec+zvec).unit, {verts[1], verts[3], verts[6]}}, --slant
			}
 
		elseif block == Enum.CellBlock.HorizontalWedge then
			--block side wedge
			--6 vertices
			verts = {
				pos +xvec*2  +yvec*2  +zvec*2, --top 4
				pos +xvec*2  +yvec*2  -zvec*2,
				pos -xvec*2  +yvec*2  -zvec*2,
				--
				pos +xvec*2  -yvec*2  +zvec*2, --bottom 4
				pos +xvec*2  -yvec*2  -zvec*2,
				pos -xvec*2  -yvec*2  -zvec*2,
			}
			--9 edges
			edges = {
				{verts[1], verts[2], 4}, --top 4
				{verts[2], verts[3], 4},
				--
				{verts[4], verts[5], 4}, --bottom 4
				{verts[5], verts[6], 4},
				--
				{verts[1], verts[4], 4}, --verticals
				{verts[2], verts[5], 4},
				{verts[3], verts[6], 4},
				--
				{verts[1], verts[3], 2.5}, --slants
				{verts[4], verts[6], 2.5},
			}
			--5 faces
			faces = {
				{pos+xvec*2,  xvec, zvec, {verts[1], verts[2], verts[5], verts[4]} }, --right
				{pos+yvec*2,  yvec, xvec, {verts[1], verts[2], verts[3]}           }, --top
				{pos-yvec*2, -yvec, xvec, {verts[4], verts[5], verts[6]}           }, --bottom
				{pos-zvec*2, -zvec, xvec, {verts[2], verts[3], verts[6], verts[5]} }, --front
				{pos, (zvec-xvec).unit, yvec, {verts[1], verts[3], verts[4], verts[6]}}, --slant
			}
 
		else
			assert(false, "unreachable")
		end
	end
	--
	local geometry = {
		part = part;
		vertices = verts;
		edges = edges;
		faces = faces;
		vertexMargin = vertexMargin or math.min(sx, sy, sz)*2;
	}
	--
	local geomId = 0
	--
	for i, dat in pairs(faces) do--so adjust the faces of each pair of cords 
		geomId = geomId + 1
		dat.id = geomId
		dat.point = dat[1]
		dat.normal = dat[2]
		dat.direction = dat[3]
		dat.vertices = dat[4]
		dat.type = 'Face'
		--avoid Event bug (if both keys + indicies are present keys are discarded when passing tables)
		dat[1], dat[2], dat[3], dat[4] = nil, nil, nil, nil
	end
	for i, dat in pairs(edges) do
		geomId = geomId + 1
		dat.id = geomId
		dat.a, dat.b = dat[1], dat[2]
		dat.direction = (dat.b-dat.a).unit
		dat.length = (dat.b-dat.a).magnitude
		dat.edgeMargin = dat[3]
		dat.type = 'Edge'
		--avoid Event bug (if both keys + indicies are present keys are discarded when passing tables)
		dat[1], dat[2], dat[3] = nil, nil, nil
	end
	for i, dat in pairs(verts) do
		geomId = geomId + 1
		verts[i] = {
			position = dat;
			id = geomId;
			ignoreUnlessNeeded = IsSmoothPart(part);
			type = 'Vertex';
		}
	end
	--
	return geometry
end

local function getFacePoints(face)
	local hsize = face.Object.Size / 2
	local faceDir = Vector3.FromNormalId(face.Normal)
	local faceA, faceB = otherNormals(faceDir)
	faceDir, faceA, faceB = faceDir*hsize, faceA*hsize, faceB*hsize
	--
	local function sp(offset)
		return (face.Object.CFrame * CFrame.new(offset)).p
	end
	--
	return {
		sp(faceDir + faceA + faceB);
		sp(faceDir + faceA - faceB);
		sp(faceDir - faceA - faceB);
		sp(faceDir - faceA + faceB);
	}
end

function resizePart(part, normal, delta)
	local axis = Vector3.FromNormalId(normal)
	local cf = part.CFrame
	local targetSize = part.Size + Vector3.new(math.abs(axis.X), math.abs(axis.Y), math.abs(axis.Z))*delta
	if not part:IsA('FormFactorPart') then
		-- Nothing to do, can't modify formfactor anyways
	elseif part.FormFactor == Enum.FormFactor.Brick then
		if targetSize.X % 1 ~= 0 or targetSize.Y % 1.2 ~= 0 or targetSize.Z % 1 ~= 0 then
			part.FormFactor = 'Custom'
		end
	elseif part.FormFactor == Enum.FormFactor.Symmetric then
		if targetSize.X % 1 ~= 0 or targetSize.Y % 1 ~= 0 or targetSize.Z % 1 ~= 0 then
			part.FormFactor = 'Custom'
		end
	elseif part.FormFactor == Enum.FormFactor.Plate then
		if targetSize.X % 1 ~= 0 or targetSize.Y % 0.4 ~= 0 or targetSize.Z % 1 ~= 0 then
			part.FormFactor = 'Custom'
		end
	else
		-- nothing to do, is custom
	end
	part:BreakJoints()
	part.Size = targetSize
	part:BreakJoints()
	part.CFrame = cf * CFrame.new(axis * (delta/2))
end

-- Calculate the result
function DoExtend(faceA, faceB)
	--
	local pointsA = getFacePoints(faceA)
	local pointsB = getFacePoints(faceB)
	--
	local extendPointA, extendPointB;
	if mModeOption.Mode == 'ExtendInto' or mModeOption.Mode == 'OuterTouch' or mModeOption.Mode == 'ButtJoint' then
		extendPointA = getPositivePointToFace(faceB, pointsA)
		extendPointB = getPositivePointToFace(faceA, pointsB)
	elseif mModeOption.Mode == 'ExtendUpto' or mModeOption.Mode == 'InnerTouch' then
		extendPointA = getNegativePointToFace(faceB, pointsA)
		extendPointB = getNegativePointToFace(faceA, pointsB)
	else
		assert(false, "unreachable")		
	end
	local startSep = extendPointB - extendPointA
	--
	local localDimensionA = getDimension(faceA)
	local localDimensionB = getDimension(faceB)
	local dirA = getNormal(faceA)
	local dirB = getNormal(faceB)
	--
	-- Find the closest distance between the rays (extendPointA, dirA) and (extendPointB, dirB):
	-- See: http://geomalgorithms.com/a07-_distance.html#dist3D_Segment_to_Segment
	local a, b, c, d, e = dirA:Dot(dirA), dirA:Dot(dirB), dirB:Dot(dirB), dirA:Dot(startSep), dirB:Dot(startSep)
	local denom = a*c - b*b

	-- Is this a degenerate case?
	if math.abs(denom) < 0.001 then
		-- Parts are parallel, extend faceA to faceB
		local lenA = (extendPointA - extendPointB):Dot(getNormal(faceB))
		local extendableA = (localDimensionA * faceA.Object.Size).magnitude
		if getNormal(faceA):Dot(getNormal(faceB)) > 0 then
			lenA = -lenA
		end
		if lenA < -extendableA then
			return
		end
		resizePart(faceA.Object, faceA.Normal, lenA)
		SetWaypoint()
		return
	end

	-- Get the distances to extend by
	local lenA = -(b*e - c*d) / denom
	local lenB = -(a*e - b*d) / denom

	if mModeOption.Mode == 'ExtendInto' or mModeOption.Mode == 'ExtendUpto' then
		-- We need to find a different lenA, which is the intersection of
		-- extendPointA to the plane faceB:
		-- dist to plane (point, normal) = - (ray_dir . normal) / ((ray_origin - point) . normal)
		local denom2 = dirA:Dot(dirB)
		if math.abs(denom2) > 0.0001 then
			lenA = - (extendPointA - extendPointB):Dot(dirB) / denom2
			lenB = 0
		else
			-- Perpendicular
			-- Project all points of faceB onto faceA and extend by that much
			local points = getPoints(faceB.Object)
			if mModeOption == 'ExtendUpto' then
				local smallestLen = math.huge
				for _, v in pairs(points) do
					local dist = (v - extendPointA):Dot(getNormal(faceA))
					if dist < smallestLen then
						smallestLen = dist
					end
				end
				lenA = smallestLen
			elseif mModeOption == 'ExtendInto' then
				local largestLen = -math.huge
				for _, v in pairs(points) do
					local dist = (v - extendPointA):Dot(getNormal(faceA))
					if dist > largestLen then
						largestLen = dist
					end
				end
				lenA = largestLen
			end
			lenB = 0
		end
	end

	-- Are both extents doable?
	-- Note: Negative amounts to extend by *are* allowed, but only
	-- up to the size of the part on the dimension being extended on.
	local extendableA = (localDimensionA * faceA.Object.Size).magnitude
	local extendableB = (localDimensionB * faceB.Object.Size).magnitude
	if lenA < -extendableA then
		return
	end
	if lenB < -extendableB then
		return
	end

	-- Both are doable, execute:
	resizePart(faceA.Object, faceA.Normal, lenA)
	resizePart(faceB.Object, faceB.Normal, lenB)

	-- For a butt joint, we want to resize back one of the parts by the thickness 
	-- of the other part on that axis. Renize the first part (A), such that it
	-- "butts up against" the second part (B).
	if mModeOption.Mode == 'ButtJoint' then
		-- Find the width of B on the axis A, which is the amount to resize by
		local points = getPoints(faceB.Object)
		local minV =  math.huge
		local maxV = -math.huge
		for _, v in pairs(points) do
			local proj = (v - extendPointA):Dot(dirA)
			if proj < minV then minV = proj end
			if proj > maxV then maxV = proj end
		end
		resizePart(faceA.Object, faceA.Normal, -(maxV - minV))
	end

	SetWaypoint()
end