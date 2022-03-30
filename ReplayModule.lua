local ts = game:GetService("TweenService")
local run = game:GetService("RunService")

local recorder = {}
recorder.__index = recorder

function recorder.new(fps, vpf, recordTime)
	local self = {}
	
	self.parts = {}
	self.services = {}
	self.integers = {}
	
	self.ViewportFrame = vpf
	self.renderLoop = nil
	self.frameRate = fps
	
	self.integers.startTime = 0 
	self.integers.endTime = 0
	self.integers.recordTime = recordTime -- in ms ples	
	
	return setmetatable(self, recorder)
end

function recorder:record()
	self.integers.startTime = tick()
	
	self.renderLoop = run.Heartbeat:Connect(function(delta)		
		local time = tick()
		
		local folder = workspace:GetDescendants() 		
		
		for index, child in pairs(folder) do 
			if (child:IsA("BasePart")) or (child:IsA("Camera")) then 
				if (child.Name == "Terrain") then 
					continue
				end
				
				if (self.parts[child] == nil) then 
					local clone = child:Clone()

					self.parts[child] = {clone}
					
					self.parts[child]["cframes"] = {}
					self.parts[child]["part"] = clone 
					self.parts[child]["timeStamp"] = time 
				else 
					if (time - self.parts[child]["timeStamp"] > self.integers.recordTime) then 
						self.parts[child] = nil 
					end
				end
				
				self.parts[child]["cframes"][time] = child.CFrame
				
				if (child:IsA("Camera")) then 
					self.ViewportFrame.CurrentCamera = self.parts[child]["model"] 
				end
			end 
		end
	end)
end

function recorder:stopRecording()
	self.renderLoop:Disconnect()
	self.renderLoop = nil
	self.integers.endTime = tick()
	
	if (self.integers.endTime - self.integers.startTime > self.integers.recordTime) then 	
		self.integers.endTime = self.integers.recordTime
	end
end

function recorder:rewind()
	-- yea, rewind time
	local cache = {}
	
	while self.integers.startTime < self.integers.endTime do
		self.integers.startTime += run.Heartbeat:Wait()

		coroutine.wrap(function()
			for child, data in pairs(self.parts) do
				
				
				local cframes = data["cframes"]
				local clone = data["part"]
				local newCF = clone.CFrame
				
				if not (clone:IsA("Camera")) then
					if not (self.ViewportFrame:FindFirstChild(clone)) then 
						clone.Parent = self.ViewportFrame
					end
				else
					self.ViewportFrame.CurrentCamera = clone
				end
				
				for t, cf in pairs(cframes) do
					cache[clone] = cache[clone] or {}
					
					if self.integers.startTime >= t and not cache[clone][cf] then
						cache[clone][cf] = true
						newCF = cf
						
						break
					end
				end
				
				local newTrack = ts:Create(clone, TweenInfo.new(1/self.frameRate), {CFrame = newCF})
                                newTrack:Play()
			end
		end)()
	end
end

function recorder:clearTape()
	for i,v in pairs(self.ViewportFrame:GetDescendants()) do 
		v:Destroy()
	end
	
	self.parts = {}
	self.integers = {}

	self.ViewportFrame = nil
	self.renderLoop = nil
	self.frameRate = 0

	self.integers.startTime = 0 
	self.integers.endTime = 0
	self.integers.recordTime = 0
end



return recorder
