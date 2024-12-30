--!strict

-- Packages
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local jecs = require(ReplicatedStorage.Shared.Packages.jecs)

-- functions
local function DistanceBetweenVec3(v1: Vector3, v2: Vector3): number
	return (v1 - v2).Magnitude
end

local function GetRandomWaypoint(): Vector3
	local Waypoints: { Part } = workspace.Waypoints:GetChildren() :: { Part }

	local waypoint: Part = Waypoints[math.random(#Waypoints)]

	return waypoint.Position
end

-- World
local Module = {}

local Cat = jecs.World.new()

-- Components
local TargetPosition = Cat:component()
local PlayerFollowing = Cat:component()
local Model = Cat:component()
local Params = Cat:component()

-- Systems
function Module.Move()
	for entity, targetPosition: Vector3, model: Model, playerFollowing: Player, overlapParams: OverlapParams in
		Cat:query(TargetPosition, Model, PlayerFollowing, Params)
	do
		local parts = workspace:GetPartBoundsInRadius(model.PrimaryPart.Position, 10, overlapParams)

		local distance: number = DistanceBetweenVec3(targetPosition, model.PrimaryPart.Position)

		if distance <= 5 and not playerFollowing then
			Cat:set(entity, TargetPosition, GetRandomWaypoint())
		end

		if distance >= 15 and playerFollowing then
			Cat:set(entity, PlayerFollowing, nil)
		end

		if playerFollowing then
			if playerFollowing.Character then
				Cat:set(entity, TargetPosition, playerFollowing.Character.PrimaryPart.Position)
			else
				Cat:set(entity, TargetPosition, GetRandomWaypoint())
				Cat:set(entity, PlayerFollowing, nil)
			end
		end

		if not playerFollowing then
			for _, part in parts do
				local player = Players:GetPlayerFromCharacter(part.Parent)

				if player then
					Cat:set(entity, PlayerFollowing, player)
					Cat:set(entity, TargetPosition, player.Character.PrimaryPart.Position)
					break
				end
			end
		end

		ReplicatedStorage.Event.UpdateCat:FireAllClients(model, targetPosition)
	end
end

-- Initalize
function Module.SpawnNewCat(model: Model, waypointPos: Vector3)
	local catModel: Model = model:Clone()

	catModel.Parent = workspace
	catModel:MoveTo(waypointPos)

	local overlapParams = OverlapParams.new()
	overlapParams.FilterDescendantsInstances = { catModel } :: { Instance }
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude

	task.spawn(function()
		while true do
			task.wait(math.random(1, 10))
			ReplicatedStorage.Event.PlaySound:FireAllClients()
		end
	end)

	local entity = Cat:entity()
	Cat:set(entity, TargetPosition, GetRandomWaypoint())
	Cat:set(entity, Model, catModel)
	Cat:set(entity, Params, overlapParams)
	Cat:set(entity, PlayerFollowing, nil)
end

return Module
