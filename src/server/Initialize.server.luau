local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local Baseplate = workspace.Baseplate
local BaseplateSize = Baseplate.Size

local PartCount = 1000
local RowCount = math.ceil(math.sqrt(PartCount))
local ColumnCount = RowCount

local XSpacing = BaseplateSize.X / (ColumnCount + 1)
local ZSpacing = BaseplateSize.Z / (RowCount + 1)

local PartIndex = 0

for row = 1, RowCount do
	for column = 1, ColumnCount do
		PartIndex += 1

		if PartIndex > PartCount then
			break
		end

		local part = Instance.new("Part")
		part.Size = Vector3.new(1, 1, 1)
		part.Anchored = true
		part.Parent = workspace.Waypoints
		part.CanCollide = false
		part.Transparency = 1

		local xPos = -BaseplateSize.X / 2 + (column * XSpacing)
		local zPos = -BaseplateSize.Z / 2 + (row * ZSpacing)

		part.Position = Vector3.new(xPos, Baseplate.Position.Y + BaseplateSize.Y / 2 + part.Size.Y / 2, zPos)
	end
end
local Cat = require(ServerStorage.SharedServer.Cat)

for _, waypoint in workspace.Waypoints:GetChildren() do
	Cat.SpawnNewCat(ServerStorage.Cat, waypoint.Position)
end

RunService.Stepped:Connect(Cat.Move)
