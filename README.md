# ReplayModule
A simple replay module that allows to record and broadcast a moment from a gameplay into a VPF.

## API
```lua
Recorder.new(FrameRate: int, ViewportFrame, MaxRecordingTimeInMS: int)
```
```lua
Tape:start()
```
```lua
Tape:stopRecording()
```
```lua
Tape:rewind()
```
```lua
Tape:clearTape()
```

## Example Code
```lua
-- In a local script

local tape = recorder.new(30, vpf, 3000) -- records at 30fps during 3 seconds

start.MouseButton1Click:Connect(function()
	tape:record()
end) 

stop.MouseButton1Click:Connect(function()
	if (tape) then 
		tape:stopRecording()
	else 
		warn("Please record something before")
	end
end) 

rewind.MouseButton1Click:Connect(function()
	if (tape) then 
		tape:rewind()
	else 
		warn("Please record something before")
	end
end)

clear.MouseButton1Click:Connect(function()
	if (tape) then 
		tape:clearTape()
	else 
		warn("Please record something before")
	end
end)

```
## Purposes ?
Replay module can be used in games like FPS, Sport or any that contents special events. 

## Known issues
  - Jittering can happen when broadcasting 

## Futur updates
I'll implement TShirt and Lightning support as soon as possible!
