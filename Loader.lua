if not isfolder("absolutev4") then
    makefolder("absolutev4")
end

if not isfolder("absolutev4/Loader") then
    makefolder("absolutev4/Loader")
end

-- // Main Vars
getgenv().ScriptVersion = "v4.0";
getgenv().ScriptState = "Free";

-- // Loader
local SourceLink = "Link"; local LibraryLink = "Link"; local SoundLink = "https://github.com/kyoukidevs/absolute-v4-assets/raw/refs/heads/main/1217.mp3"; local VideoLink = "https://github.com/kyoukidevs/absolute-v4-assets/raw/refs/heads/main/1217.mp4"

if not isfile("absolutev4/Loader/Video.mp4") then
    writefile("absolutev4/Loader/Video.mp4", game:HttpGet(VideoLink))
end

if not isfile("absolutev4/Loader/Sound.mp3") then
    writefile("absolutev4/Loader/Sound.mp3")
end

local SoundId = getcustomasset("absolutev4/Loader/Sound.mp3"); local VideoId = getcustomasset("absolutev4/Loader/Video.mp4")

local Sound = Instance.new("Sound", cloneref(game:GetService("Workspace"))
Sound.SoundId = SoundId
Sound.Volume = 5

local VideoContainer = Instance.new("ScreenGui", cloneref(gethui())
VideoContainer.IgnoreGuiInset = true

local Video = Instance.new("VideoFrame", VideoContainer)
Video.BackgroundTransparency = 1
Video.Video = VideoId
Video.AnchorPoint = Vector2.new(0.5,0.5)


Video:Play()
Sound:Play()

Sound.Played:Connect(function()
    Video:Destroy()
    Sound:Destroy()
    loadstring(game:HttpGet(SourceLink))()
end)
