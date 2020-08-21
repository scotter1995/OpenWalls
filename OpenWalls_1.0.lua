local loaded = false
local on = false
local mouse; 
local deactivatingEvent = Instance.new("BindableEvent") --this is the event fired 
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local mouseCnList = {}-- the list of mouse movments
local selectingMesh = false
local applyingMesh = false
local mesh = nil

local screengui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screengui.Name = "TestGui"
screengui.Enabled = false


local toolbar = plugin:CreateToolbar("OpenWalls 1.0")
local toolbarbutton = toolbar:CreateButton("", "Start OpenWalls", "rbxassetid://5136300053") --the icon.png")


toolbarbutton.Click:connect(function()
	if on then
		deactivatingEvent:Fire()--if the plugin is on, make a new instance of binable events
		Off()
	elseif loaded then
		On()
	end
end)


--setup stuff, pretty much done





function connectFunc(button, func)
	button.MouseButton1Click:Connect(func)
end


local function createGUI(options, buttonFunc)
	--label or button
    --for a normal size one, such as title
    local size1 = UDim2.new(0,351,0,30)
    --for a half size one, such as TexturePrt
    local size2 = UDim2.new(0,175,0,30)
    --increase the position of next label/down by 31 pixel
    local posInc = UDim2.new(0, 0, 0, 31)
	local pos = UDim2.new(0,1,0,1)
	local bfindex = 1
    for index, option in pairs(options) do
		if ( index >= 2 and index <= 3 )
        then
			fillGUI("TextButton", size2, pos, option)
			pos = pos + posInc
			connectFunc(screengui:FindFirstChild(option, false), buttonFunc[bfindex])
			bfindex = bfindex + 1
        elseif ( index == 4 )
		then 
            fillGUI( "ImageLabel", UDim2.new(0,175,0,61), UDim2.new(0,177,0,32), option )
        else
            fillGUI("TextLabel", size1, pos, option)
            pos = pos + posInc
		end
    end
end

function fillGUI(guitype, size, pos, text) 
	local temp = Instance.new( guitype, screengui)
	temp.Name = text
    temp.Position = pos
	temp.Size = size
	if(guitype == "TextLabel" or guitype == "TextButton") then
		temp.Text = text
	end
	if(guitype == "TextButton") then
		temp.AutoButtonColor = true
	end
    temp.BackgroundTransparency = 0.3
	temp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end

function selectMeshClicked()
	local smbutton = screengui:FindFirstChild("SelectMesh", false)
	local ambutton = screengui:FindFirstChild("ApplyMesh", false)
--	if(applyingMesh) then
--		selectingMesh = true
--	end
	
	if(selectingMesh) then
		smbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	else
		smbutton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		applyingMesh = false
		ambutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
	selectingMesh = not selectingMesh
end

function applyMeshClicked()
	local smbutton = screengui:FindFirstChild("SelectMesh", false)
	local ambutton = screengui:FindFirstChild("ApplyMesh", false)
	if(applyingMesh) then
		ambutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	else
		ambutton.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
		selectingMesh = false
		smbutton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
	applyingMesh = not applyingMesh
end

createGUI( {'OpenWalls', 'SelectMesh', 'ApplyMesh', 'TextureImg', 'ImgName'}
		  ,{selectMeshClicked, applyMeshClicked})

local mTargetFilter = Instance.new('Model')
mTargetFilter.Name = '$TargetFilter'
mTargetFilter.Archivable = false

local mState = 'FaceA' -- | 'FaceB'

-- We need to think through how mFace A is gonna work
local mFaceA = nil --The functionality of getting the dimensions is problably from mFaceA related functions I think
local mFaceADrawn = nil--so we need to replace that functionality with the selection of a brick thats stretched to the 
local mFaceB = nil--dimensions of mFaceB

--we need to basically change the functionality of MFaceA to a single mesh you define with a get target on mouse click and getTarget
--then you cycle through to a new mFaceB and it lays that mesh according to the functinoality in MFaceB



local function FixTargetFilter()
	if not mTargetFilter.Parent then
		if mFaceADrawn then
			for _, o in pairs(mFaceADrawn) do
				o:Destroy()
			end
		end
		mTargetFilter = Instance.new('Model')
		mTargetFilter.Name = '$TargetFilter'
		mTargetFilter.Archivable = false
		if on then
			mTargetFilter.Parent = workspace
			mouse.TargetFilter = mTargetFilter
		end
	end
end

local function getNormal(face)
	return face.Object.CFrame:vectorToWorldSpace(Vector3.FromNormalId(face.Normal))
end

local function getDimension(face)
	local dir = Vector3.FromNormalId(face.Normal)
	return Vector3.new(math.abs(dir.X), math.abs(dir.Y), math.abs(dir.Z))
end



-- Run when the popup is activated.
function On()--so while its activated
	screengui.Enabled = true
	plugin:Activate(true)--its active
	toolbarbutton:SetActive(true)
	on = true
	mouse = plugin:GetMouse(true)
	table.insert(mouseCnList, mouse.Button1Down:connect(function()
		MeshSelectApply()--now constantly search for parts being selected
	end))--if at any point the mose clicks
	table.insert(mouseCnList, mouse.Button1Up:connect(function()
		MouseUp()-- we insert the  event
	end))
	table.insert(mouseCnList, mouse.Move:connect(function()
		MouseMove()
	end))
	table.insert(mouseCnList, mouse.Idle:connect(function()
		MouseIdle()
	end))
	table.insert(mouseCnList, mouse.KeyDown:connect(function()
		KeyDown()
	end))
	--
	Selected() 
end

-- Run when the popup is deactivated.
function Off()
	screengui.Enabled = false
	toolbarbutton:SetActive(false)
	on = false
	for i, cn in pairs(mouseCnList) do
		cn:disconnect()
		mouseCnList[i] = nil
	end
	--
	Deselected()
end

function SetWaypoint()
	local ch = mTargetFilter:GetChildren()
	for _, c in pairs(ch) do
		c.Parent = nil
	end
	game:GetService('ChangeHistoryService'):SetWaypoint('Resize')
	for _, c in pairs(ch) do
		c.Parent = mTargetFilter
	end
end

local function close(a, b)
	return math.abs(a - b) < 0.001
end
function GetTarget()
	local ignore = {mTargetFilter}
	local rayparams = RaycastParams.new()
	if mState == 'FaceB' then
		table.insert(ignore, mFaceA.Object)
	end
	rayparams.FilterDescendantsInstances = ignore
	rayparams.FilterType = Enum.RaycastFilterType.Blacklist
	local rayresult = workspace:Raycast(mouse.UnitRay.Origin, mouse.UnitRay.Direction*999, rayparams)
	local hit, pos
	if rayresult then
		hit = rayresult.Instance
		pos = rayresult.Position
	end
	--[[local ray = Ray.new(mouse.UnitRay.Origin, mouse.UnitRay.Direction*999)
	local ignore = {mTargetFilter}

	local hit, at = workspace:FindPartOnRayWithIgnoreList(ray, ignore)]]
	local targetSurface;
	if hit then
		if hit:IsA("MeshPart") or hit:IsA("FileMesh") then
--			print(hit.TextureID)
		end
		local localDisp = hit.CFrame:vectorToObjectSpace(pos - hit.Position)
		local halfSize = hit.Size / 2
		local smallest = math.huge --we actually need to steal this idea, or use/make a new method for
		if math.abs(localDisp.x - halfSize.x) < smallest then--constructing an absurdly small value in 
			targetSurface = Enum.NormalId.Right				--roblox
			smallest = math.abs(localDisp.x - halfSize.x)
		end
		if math.abs(localDisp.x + halfSize.x) < smallest then
			targetSurface = Enum.NormalId.Left
			smallest = math.abs(localDisp.x + halfSize.x)
		end
		if math.abs(localDisp.y - halfSize.y) < smallest then
			targetSurface = Enum.NormalId.Top
			smallest = math.abs(localDisp.y - halfSize.y)
		end
		if math.abs(localDisp.y + halfSize.y) < smallest then
			targetSurface = Enum.NormalId.Bottom
			smallest = math.abs(localDisp.y + halfSize.y)
		end
		if math.abs(localDisp.z - halfSize.z) < smallest then
			targetSurface = Enum.NormalId.Back
			smallest = math.abs(localDisp.z - halfSize.z)
		end
		if math.abs(localDisp.z + halfSize.z) < smallest then
			targetSurface = Enum.NormalId.Front
			smallest = math.abs(localDisp.z + halfSize.z)
		end
	end
--	print(targetSurface)
	return hit, pos, targetSurface
end


function UpdateHover()
	FixTargetFilter()
	local hit, at, targetSurface= GetTarget()
	if hit and not hit.Locked then
		ShowHoverFace(hit, targetSurface)
	else
		HideHoverFace()
	end
end


local function otherNormals(dir)
	if math.abs(dir.X) > 0 then
		return Vector3.new(0, 1, 0), Vector3.new(0, 0, 1)
	elseif math.abs(dir.Y) > 0 then
		return Vector3.new(1, 0, 0), Vector3.new(0, 0, 1)
	else
		return Vector3.new(1, 0, 0), Vector3.new(0, 1, 0)
	end
end


local function extend(v, amount)-- this function drives the resize by returning a vector equal to the 
	return v.unit * (v.magnitude + amount) --distance between two points
end

local function drawFace(parent, part, normalId, color, trans)
	local tb = {}
	--
	local hsize = part.Size / 2
	local faceDir = Vector3.FromNormalId(normalId)
	local faceA, faceB = otherNormals(faceDir)
	faceDir, faceA, faceB = faceDir*hsize, faceA*hsize, faceB*hsize
	--
	local function seg(size, cf)--reassign the new colors and such to what its supposed to be
		local segment = Instance.new('Part', parent)
		segment.BrickColor = color
		segment.Anchored = true
		segment.Locked = true
		segment.Archivable = false
		segment.Transparency = trans
		segment.TopSurface = 'Smooth'
		segment.BottomSurface = 'Smooth'
		segment.FormFactor = 'Custom'
		segment.Size = size
		segment.CFrame = part.CFrame * cf
		table.insert(tb, segment)
	end
	--
	seg(extend(faceA, 0.1)*2, CFrame.new(faceDir + faceB))
	seg(extend(faceA, 0.1)*2, CFrame.new(faceDir - faceB))
	seg(extend(faceB, 0.1)*2, CFrame.new(faceDir + faceA))
	seg(extend(faceB, 0.1)*2, CFrame.new(faceDir - faceA))
	--
	return tb
end

local mState = 'FaceA' -- | 'FaceB'
local mFaceA = nil
local mFaceADrawn = nil
local mFaceB = nil
local mStateSelect = false



local function changeDisplayImg(objHit) --Need to test this
	local img = screengui:FindFirstChild('TextureImg')
	local text = screengui:FindFirstChild('ImgName')
	local textureid = objHit.TextureID
	if(textureid == "") then
		img.Image = ""
		img.BackgroundColor3 = objHit.Color
		local temp = BrickColor.new(objHit.Color)
		text.Text = temp.Name
--		temp.Text = color  holy fuck no we'd have to litterally take this list https://developer.roblox.com/en-us/articles/BrickColor-Codes and 
 	else--translate it to fucking color codes
		img.BackgroundColor3 = Color3.fromRGB(255,255,255)
		img.Image = textureid
		text.Text = textureid
	end
end


-------------TESTCODE----------------------------------
function createMesh(SurfaceToApply, mesh)
	local copy
	if mesh then
		copy = mesh:Clone()
		copy.Parent = mesh.Parent
	else 
		copy = Instance.new("MeshPart", workspace)
	end
	local size, orien, rotation
	if SurfaceToApply.Normal== Enum.NormalId.Top then
		size = Vector3.new(SurfaceToApply.length,math.min,SurfaceToApply.width)
		orien = CFrame.new(0,SurfaceToApply.height/2,0)
		--rotation = Vector3.new(0,0,0)
		rotation = CFrame.Angles(0,0,0)
	end
	if SurfaceToApply.Normal== Enum.NormalId.Bottom then
		size = Vector3.new(SurfaceToApply.length,math.min,SurfaceToApply.width)
		orien = CFrame.new(0,-(SurfaceToApply.height/2),0)
		--rotation = Vector3.new(180,0,0)
		rotation = CFrame.Angles(math.rad(180),0,0)
	end
	if SurfaceToApply.Normal== Enum.NormalId.Front then
		size = Vector3.new(SurfaceToApply.length,math.min,SurfaceToApply.height)
		orien = CFrame.new(0,0,-(SurfaceToApply.width/2))
		--rotation = Vector3.new(90,0,0)
		rotation = CFrame.Angles(math.rad(-90),0,0)
	end
	if SurfaceToApply.Normal== Enum.NormalId.Back then
		size = Vector3.new(SurfaceToApply.length, math.min, SurfaceToApply.height)
		orien = CFrame.new(0,0,SurfaceToApply.width/2)
		--rotation = Vector3.new(-90,0,0)
		rotation = CFrame.Angles(math.rad(90),0,0)
	end
	if SurfaceToApply.Normal== Enum.NormalId.Left then
		size = Vector3.new(SurfaceToApply.height,math.min, SurfaceToApply.width)
		orien = CFrame.new(-(SurfaceToApply.length/2),0,0)
		--rotation = Vector3.new(0,0,90)
		rotation = CFrame.Angles(0,0,math.rad(90))
	end
	if SurfaceToApply.Normal== Enum.NormalId.Right then
		size = Vector3.new(SurfaceToApply.height,math.min, SurfaceToApply.width)
		orien = CFrame.new(SurfaceToApply.length/2,0,0)
		--rotation = Vector3.new(0,0,-90)
		rotation = CFrame.Angles(0,0,math.rad(-90))
	end
	copy.Size = size
	copy.Position = Vector3.new(0,0,0)
	copy.CFrame = SurfaceToApply.Object.CFrame:ToWorldSpace(orien)
	--copy.Orientation = copy.Orientation + rotation
	copy.CFrame = copy.CFrame * rotation
end

-------------------------------------------------------
function MeshSelectApply()
	if (selectingMesh) then
		local hit, at, targetSurface = GetTarget()
		local MeshSelected = { 
					Object = hit;
					Normal = targetSurface;
		}
		changeDisplayImg(MeshSelected.Object)
		mesh = hit
		--assign the mesh to use
		--update gui
	end
	if (not selectingMesh) and (applyingMesh) then
		local hit, at, targetSurface = GetTarget()
		if hit and not hit.Locked then
			local SurfaceToApply = {
					Object = hit;
					Normal = targetSurface;
					length = hit.size.x;
					height = hit.size.y;
					width = hit.size.z
			}
			createMesh(SurfaceToApply, mesh)
		end
	end
end
	
--	local hit, at, targetSurface = GetTarget()
--	if hit and not hit.Locked then
--
--			for _, o in pairs(mFaceADrawn) do
--				o:Destroy()
--			end
--
--	HideHoverFace()




local mHoverFaceDrawn = {}
function ShowHoverFace(part, normalId, color)
	HideHoverFace()
	mHoverFaceDrawn = drawFace(mTargetFilter, part, normalId, BrickColor.new(21), 0.5)
end
function HideHoverFace()
	for _, ch in pairs(mHoverFaceDrawn) do
		ch:Destroy()
	end
	mHoverFaceDrawn = {}
end


function Selected()
--	mModeScreenGui.Parent = game:GetService('CoreGui')
--	mTargetFilter.Parent = workspace
--	mouse.TargetFilter = mTargetFilter
	mState = 'FaceA'
end
function Deselected()
--	mModeScreenGui.Parent = nil
--	mIgnoreNextTargetFilterDeparent = true
--	mTargetFilter.Parent = nil
	HideHoverFace()
	if mFaceADrawn then
		for _, o in pairs(mFaceADrawn) do
			o:Destroy()
		end
		mFaceADrawn = nil
	end
end

function MouseUp()

end

function MouseMove()
	UpdateHover()
end

function MouseIdle()
	UpdateHover()
end

function KeyDown()

end

loaded = true

--so a lot of thats not mine




