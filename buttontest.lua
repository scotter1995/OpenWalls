local toolbar = plugin:CreateToolbar("Test")
local tbbutton = toolbar:CreateButton("test","","")
local status = false
local screengui = Instance.new("ScreenGui", game:GetService("CoreGui"))
screengui.Name = "TestGui"
--don't want to show gui at the start, wait for tbbutton
screengui.Enabled = false

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



local function createGUI(options)
	--label or button
	local guitype = ""
    --for a normal size one, such as title
    local size1 = UDim2.new(0,351,0,30)
    --for a half size one, such as TexturePrt
    local size2 = UDim2.new(0,175,0,30)
    --increase the position of next label/down by 31 pixel
    local posInc = UDim2.new(0, 0, 0, 31)
    local pos = UDim2.new(0,1,0,1)
    for index, option in pairs(options) do
		if ( index == 2 or ( index >= 7 and index <= 9 ) ) then
			guitype = "TextButton"
		else
			guitype = "TextLabel" 
		end
		if ( index >= 2 and index <= 4 )
        then
            fillGUI(guitype, size2, pos, option)
            pos = pos + posInc
        elseif ( index == 5 )
        then 
            fillGUI( guitype, UDim2.new(0,175,0,92), UDim2.new(0,177,0,32), option )
        else
            fillGUI(guitype, size1, pos, option)
            pos = pos + posInc
        end
    end
end

function fillGUI(guitype, size, pos, text) 
    local temp = Instance.new( guitype, screengui)
    temp.Position = pos
    temp.Size = size
    temp.Text = text
    temp.BackgroundTransparency = 0.3
    temp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end

createGUI({'OpenWalls', 'TexturePrt', 'SelectImg', '\"ImgName\"', '\"TextureImg\"', 'PrtTypeAttach', 'Auto', 'Brick', 'Wedge', 'TODO'})