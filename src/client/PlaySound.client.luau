local ReplicatedStorage = game:GetService("ReplicatedStorage")
ReplicatedStorage.Event.PlaySound.OnClientEvent:Connect(function()
	local newSound: Sound = workspace.meow:Clone()
	newSound.Parent = workspace

	newSound:Play()

	task.wait(newSound.TimeLength)
	newSound:Destroy()
end)
