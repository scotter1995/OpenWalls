local toolbar = plugin:CreateToolbar("TestAxe")
local tbbutton = toolbar:CreateButton("test","","")
local status = false
local screengui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local selectingMesh = false
local applyingMesh = false
screengui.Name = "TestGui"
--don't want to show gui at the start, wait for tbbutton
screengui.Enabled = false
dictGUI = {}

local function onOff()
	status = not status
	tbbutton:SetActive(status)
    if status then
        -- if tbbutton on show gui
		screengui.Enabled = true
	else 
		screengui.Enabled = false
	end
end

tbbutton.Click:connect(onOff)

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
--TODO perhaps make this into a single function
function selectMeshClicked()
	local smbutton = screengui:FindFirstChild("SelectMesh", false)
	local ambutton = screengui:FindFirstChild("ApplyMesh", false)
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
--color should be Color3, and textureid should be a string of textureid
--local changeImg(color, textureid){
--  temp = screengui.FindFirstChild('ImgName')
--	if(textureid!=nil) then
--		temp.BackgroundColor3 = Color3.fromRGB(255,255,255)
--		temp.Image = textureid
--  else
--		temp.Image = ""
--      temp.BackgroundColor3 = color
--	end
--}

--local changeImgName(color, textureid)
-- temp = screengui.FindFirstChild('ImgName')
-- if(textureid!=nil) then
-- 		temp.Text = textureid
-- else
--		temp.Text = color
-- end


--SuperFunc
--if selectMesh then call select a face a

