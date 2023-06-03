Prefab = game.ServerStorage.Prefabs.Javelin
FollowEvent = game.ReplicatedStorage.Events.FollowObject
ThrowEvent = game.ServerStorage.Events.Javelin.JavStart
CameraEvent = game.ReplicatedStorage.Events.Camera
AnimateEvent = game.ReplicatedStorage.Events.Animate
Tool = script.Parent
CurrentBasePower = 300
Player = game.Players:FindFirstChild(Tool.Parent.Name)

if not Player then
	return
end

function CheckIfInArea(partToTrig,CheckPart)
	local region3 = Region3.new(partToTrig.Position - (partToTrig.Size/2), partToTrig.Position +(partToTrig.Size/2))
	local parts = game.Workspace:FindPartsInRegion3WithWhiteList(region3, {CheckPart})

	for _, part in pairs(parts) do
		if part:FindFirstAncestor(script.Parent.Parent.Name) then
			return true
		end
	end
	return false
end

Tool.Activated:Connect(function()
	local HumanoidRootPart = script.Parent.Parent:WaitForChild("HumanoidRootPart")
	
	local rotation = CFrame.Angles( math.rad(0), math.rad(90), math.rad(0))
	local modelCFrame = CFrame.new(Tool.Parent:GetPivot().Position)
	
	Tool.Parent:PivotTo(modelCFrame * rotation)
	
	if(CheckIfInArea(workspace.Javelin.JavelinArea,HumanoidRootPart) == false) then
		print("NotInTheArea")
		AnimateEvent:FireClient(Player,"NONE")
		CameraEvent:FireClient(Player,"RESET")
		return
	end
	--AnimateEvent:FireClient(Player,"http://www.roblox.com/asset/?id=10713966026")
	local Pos1 = HumanoidRootPart.Position
	local Pos2 = HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector  * CurrentBasePower
	local Direction = Pos2-Pos1
	local Duration = math.log(1.001 + Direction.Magnitude * 0.01)
	local Force = Direction / Duration + Vector3.new(0,workspace.Gravity * Duration * 0.5,0)
	local NewClone = Prefab:Clone()
	NewClone.LookAtPos.Value = Pos2
	NewClone.PlayerName.Value = script.Parent.Parent.Name
	NewClone.Position = Pos1
	NewClone.Parent = workspace
	NewClone.Owner.Value = script.Parent.Parent.Name
	NewClone.CFrame = CFrame.lookAt(NewClone.Position, Pos2)
	
	FollowEvent:FireClient(game.Players:FindFirstChild(script.Parent.Parent.Name),NewClone)
	
	NewClone:ApplyImpulse(Force * NewClone.AssemblyMass)
	NewClone:SetNetworkOwner(nil)
	NewClone.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			NewClone:Destroy()
		end
	end)
end)

ThrowEvent.Event:Connect(function(Player,BasePower)
	if(Player.Name ~= script.Parent.Parent.Name) then
		return
	end
	
	CurrentBasePower = BasePower
	print(Player.Name, BasePower)
	
	Tool:Activate()
end)