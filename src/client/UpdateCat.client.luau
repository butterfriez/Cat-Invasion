local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage.Event.UpdateCat.OnClientEvent:Connect(function(model: Model, targetPos: Vector3)
	local Humanoid: Humanoid = model.Humanoid
	Humanoid:MoveTo(targetPos)
end)
