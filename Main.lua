local userid = game:GetService('Players').LocalPlayer.UserId


local ip1 = 'https://thriller'; local ip2 = 'legit.000webhostapp.com/check.php?key=' ..getgenv.key..'&user='..userid 
local RealLink = ip1..ip2;

getgenv().Key = game:HttpGet(RealLink) 
if game:HttpGet(RealLink) == " " then
wait(.5)

---- then ur script goes here lol




local http_request = http_request;
if syn then
	http_request = syn.request
elseif SENTINEL_V2 then
	function http_request(tb)
		return {
			StatusCode = 200;
			Body = request(tb.Url, tb.Method, (tb.Body or ''))
		}
	end
end

if (not http_request) then
	return game:GetService('Players').LocalPlayer:Kick('Unable to find proper request function')
end

-- // define hash function

local hash; do
    local MOD = 2^32
    local MODM = MOD-1
    local bxor = bit32.bxor;
    local band = bit32.band;
    local bnot = bit32.bnot;
    local rshift1 = bit32.rshift;
    local rshift = bit32.rshift;
    local lshift = bit32.lshift;
    local rrotate = bit32.rrotate;

    local str_gsub = string.gsub;
    local str_fmt = string.format;
    local str_byte = string.byte;
    local str_char = string.char;
    local str_rep = string.rep;

    local k = {
	    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
	    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
	    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
	    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
	    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
	    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
	    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
	    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
	    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    }
    local function str2hexa(s)
        return (str_gsub(s, ".", function(c) return str_fmt("%02x", str_byte(c)) end))
    end
    local function num2s(l, n)
        local s = ""
        for i = 1, n do
            local rem = l % 256
            s = str_char(rem) .. s
            l = (l - rem) / 256
        end
        return s
    end
    local function s232num(s, i)
        local n = 0
        for i = i, i + 3 do n = n*256 + str_byte(s, i) end
        return n
        end
        local function preproc(msg, len)
        local extra = 64 - ((len + 9) % 64)
        len = num2s(8 * len, 8)
        msg = msg .. "\128" .. str_rep("\0", extra) .. len
        assert(#msg % 64 == 0)
        return msg
    end
    local function initH256(H)
        H[1] = 0x6a09e667
        H[2] = 0xbb67ae85
        H[3] = 0x3c6ef372
        H[4] = 0xa54ff53a
        H[5] = 0x510e527f
        H[6] = 0x9b05688c
        H[7] = 0x1f83d9ab
        H[8] = 0x5be0cd19
        return H
    end
    local function digestblock(msg, i, H)
        local w = {}
        for j = 1, 16 do w[j] = s232num(msg, i + (j - 1)*4) end
        for j = 17, 64 do
            local v = w[j - 15]
            local s0 = bxor(rrotate(v, 7), rrotate(v, 18), rshift(v, 3))
            v = w[j - 2]
            w[j] = w[j - 16] + s0 + w[j - 7] + bxor(rrotate(v, 17), rrotate(v, 19), rshift(v, 10))
        end
        local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
        for i = 1, 64 do
            local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
            local maj = bxor(band(a, b), band(a, c), band(b, c))
            local t2 = s0 + maj
            local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
            local ch = bxor(band(e, f), band(bnot(e), g))
            local t1 = h + s1 + ch + k[i] + w[i]
            h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
        end
        H[1] = band(H[1] + a)
        H[2] = band(H[2] + b)
        H[3] = band(H[3] + c)
        H[4] = band(H[4] + d)
        H[5] = band(H[5] + e)
        H[6] = band(H[6] + f)
        H[7] = band(H[7] + g)
        H[8] = band(H[8] + h)
    end
    function hash(msg, t) 
        msg = preproc(msg, #msg)
        local H = initH256({})
        for i = 1, #msg, 64 do digestblock(msg, i, H) end
        return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) .. num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
    end
end

local key = 'key_synapse'
local data = http_request({
	Url = ('https://thrillerlegit.000webhostapp.com/server.php?key=' .. key);
	Method = 'GET';
})

if data.StatusCode == 200 then
	-- // if the request did not error...
	local response = data.Body;
	if response == hash(key) then
	    
	    ---player is hwid whitelisted so the script goes here
		
    getgenv().OldAimPart = "UpperTorso"
    getgenv().AimPart = "UpperTorso"
    getgenv().AimlockKey = "q"
    getgenv().AimRadius = 8 
    getgenv().ThirdPerson = true
    getgenv().FirstPerson = true
    getgenv().TeamCheck = false 
    getgenv().PredictMovement = true 
    getgenv().PredictionVelocity = 7.22
    getgenv().CheckIfJumped = true
    getgenv().Smoothness = true
    getgenv().SmoothnessAmount = 0.0195

    local Players, Uis, RService, SGui =
        game:GetService "Players",
        game:GetService "UserInputService",
        game:GetService "RunService",
        game:GetService "StarterGui"
    local Client, Mouse, Camera, CF, RNew, Vec3, Vec2 =
        Players.LocalPlayer,
        Players.LocalPlayer:GetMouse(),
        workspace.CurrentCamera,
        CFrame.new,
        Ray.new,
        Vector3.new,
        Vector2.new
    local Aimlock, MousePressed, CanNotify = true, false, false
    local AimlockTarget
    local OldPre

    getgenv().WorldToViewportPoint = function(P)
        return Camera:WorldToViewportPoint(P)
    end

    getgenv().WorldToScreenPoint = function(P)
        return Camera.WorldToScreenPoint(Camera, P)
    end

    getgenv().GetObscuringObjects = function(T)
        if T and T:FindFirstChild(getgenv().AimPart) and Client and Client.Character:FindFirstChild("Head") then
            local RayPos = workspace:FindPartOnRay(RNew(T[getgenv().AimPart].Position, Client.Character.Head.Position))
            if RayPos then
                return RayPos:IsDescendantOf(T)
            end
        end
    end

    getgenv().GetNearestTarget = function()
        
        local players = {}
        local PLAYER_HOLD = {}
        local DISTANCES = {}
        for i, v in pairs(Players:GetPlayers()) do
            if v ~= Client then
                table.insert(players, v)
            end
        end
        for i, v in pairs(players) do
            if v.Character ~= nil then
                local AIM = v.Character:FindFirstChild("Head")
                if getgenv().TeamCheck == true and v.Team ~= Client.Team then
                    local DISTANCE =
                        (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                    local RAY =
                        Ray.new(
                        game.Workspace.CurrentCamera.CFrame.p,
                        (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE
                    )
                    local HIT, POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                    local DIFF = math.floor((POS - AIM.Position).magnitude)
                    PLAYER_HOLD[v.Name .. i] = {}
                    PLAYER_HOLD[v.Name .. i].dist = DISTANCE
                    PLAYER_HOLD[v.Name .. i].plr = v
                    PLAYER_HOLD[v.Name .. i].diff = DIFF
                    table.insert(DISTANCES, DIFF)
                elseif getgenv().TeamCheck == false and v.Team == Client.Team then
                    local DISTANCE =
                        (v.Character:FindFirstChild("Head").Position - game.Workspace.CurrentCamera.CFrame.p).magnitude
                    local RAY =
                        Ray.new(
                        game.Workspace.CurrentCamera.CFrame.p,
                        (Mouse.Hit.p - game.Workspace.CurrentCamera.CFrame.p).unit * DISTANCE
                    )
                    local HIT, POS = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                    local DIFF = math.floor((POS - AIM.Position).magnitude)
                    PLAYER_HOLD[v.Name .. i] = {}
                    PLAYER_HOLD[v.Name .. i].dist = DISTANCE
                    PLAYER_HOLD[v.Name .. i].plr = v
                    PLAYER_HOLD[v.Name .. i].diff = DIFF
                    table.insert(DISTANCES, DIFF)
                end
            end
        end

        if unpack(DISTANCES) == nil then
            return nil
        end

        local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
        if L_DISTANCE > getgenv().AimRadius then
            return nil
        end

        for i, v in pairs(PLAYER_HOLD) do
            if v.diff == L_DISTANCE then
                return v.plr
            end
        end
        return nil
    end

    Mouse.KeyDown:Connect(
        function(a)
            if not (Uis:GetFocusedTextBox()) then
                if a == AimlockKey and AimlockTarget == nil then
                    pcall(
                        function()
                            if MousePressed ~= true then
                                MousePressed = true
                            end
                            local Target
                            Target = GetNearestTarget()
                            if Target ~= nil then
                                AimlockTarget = Target
                            end
                        end
                    )
                elseif a == AimlockKey and AimlockTarget ~= nil then
                    if AimlockTarget ~= nil then
                        AimlockTarget = nil
                    end
                    if MousePressed ~= false then
                        MousePressed = false
                    end
                end
            end
        end
    )

    RService.RenderStepped:Connect(
        function()
            if getgenv().ThirdPerson == true and getgenv().FirstPerson == true then
                if
                    (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 or
                        (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1
                 then
                    CanNotify = true
                else
                    CanNotify = false
                end
            elseif getgenv().ThirdPerson == true and getgenv().FirstPerson == false then
                if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude > 1 then
                    CanNotify = true
                else
                    CanNotify = false
                end
            elseif getgenv().ThirdPerson == false and getgenv().FirstPerson == true then
                if (Camera.Focus.p - Camera.CoordinateFrame.p).Magnitude <= 1 then
                    CanNotify = true
                else
                    CanNotify = false
                end
            end
            if Aimlock == true and MousePressed == true then
                if
                    AimlockTarget and AimlockTarget.Character and
                        AimlockTarget.Character:FindFirstChild(getgenv().AimPart)
                 then
                    if getgenv().FirstPerson == true then
                        if CanNotify == true then
                            if getgenv().PredictMovement == true then
                                if getgenv().Smoothness == true then
                                    
                                    local Main =
                                        CF(
                                        Camera.CFrame.p,
                                        AimlockTarget.Character[getgenv().AimPart].Position +
                                            AimlockTarget.Character[getgenv().AimPart].Velocity / PredictionVelocity
                                    )

                                    Camera.CFrame =
                                        Camera.CFrame:Lerp(
                                        Main,
                                        getgenv().SmoothnessAmount,
                                        Enum.EasingStyle.Elastic,
                                        Enum.EasingDirection.InOut
                                    )
                                else
                                    Camera.CFrame =
                                        CF(
                                        Camera.CFrame.p,
                                        AimlockTarget.Character[getgenv().AimPart].Position +
                                            AimlockTarget.Character[getgenv().AimPart].Velocity / PredictionVelocity
                                    )
                                end
                            elseif getgenv().PredictMovement == false then
                                if getgenv().Smoothness == true then
                                    
                                    local Main =
                                        CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                                    Camera.CFrame =
                                        Camera.CFrame:Lerp(
                                        Main,
                                        getgenv().SmoothnessAmount,
                                        Enum.EasingStyle.Elastic,
                                        Enum.EasingDirection.InOut
                                    )
                                else
                                    Camera.CFrame =
                                        CF(Camera.CFrame.p, AimlockTarget.Character[getgenv().AimPart].Position)
                                end
                            end
                        end
                    end
                end
            end
            if CheckIfJumped == true then
                if AimlockTarget.Character.HuDDDDDDDDDDWmanoid.FloorMaterial == Enum.Material.Air then
                    getgenv().AimPart = "UpperTorso"
                else
                    getgenv().AimPart = getgenv().OldAimPart
                end
            end
        end
    )

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local Player = game:GetService("Players").LocalPlayer
    local Mouse = Player:GetMouse()
    local SpeedGlitch = false

    Mouse.KeyDown:Connect(
        function(Key)
            if Key == "x" then
                SpeedGlitch = not SpeedGlitch
                if SpeedGlitch == true then
                    repeat
                        game:GetService("RunService").Heartbeat:wait()
                        keypress(0x49)
                        game:GetService("RunService").Heartbeat:wait()
                        keypress(0x4F)
                        game:GetService("RunService").Heartbeat:wait()
                        keyrelease(0x49)
                        game:GetService("RunService").Heartbeat:wait()
                        keyrelease(0x4F)
                        game:GetService("RunService").Heartbeat:wait()
                    until SpeedGlitch == false
                end
            end
        end
    )

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local UserInputService = game:GetService("UserInputService")

    local Off = Instance.new("Sound", game.Workspace)
    Off.SoundId = "rbxassetid://10363531115"
    local On = Instance.new("Sound", game.Workspace)
    On.SoundId = "rbxassetid://10363531700"

    local twelve = Instance.new("Sound", game.Workspace)
    twelve.SoundId = "rbxassetid://10848719687"
    local five = Instance.new("Sound", game.Workspace)
    five.SoundId = "rbxassetid://10848719301"

    local resolvedsound = Instance.new("Sound", game.Workspace)
    resolvedsound.SoundId = "rbxassetid://10849020909"

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
    loadstring(game:HttpGet("https://pastebin.com/raw/6gmj2pTS"))()
    DaHoodSettings.Prediction = 0.1437
    Aiming.TargetPart = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "RightFoot", "LeftFoot"}
    Aiming.FOV = 12.4
    Aiming.FOVSides = 25
    Aiming.HitChance = 114
    Aiming.ShowFOV = false

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local togglekey = "t"
    local mouseyea = game.Players.LocalPlayer:GetMouse()
    mouseyea.KeyDown:Connect(
        function(onandoff)
            if onandoff == togglekey then
                if DaHoodSettings.SilentAim == true then
                    DaHoodSettings.SilentAim = false
                    Off:Play()
                else
                    DaHoodSettings.SilentAim = true
                    On:Play()
                end
            end
        end
    )

    ---------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local switchbro = "z"
    local mouseyea = game.Players.LocalPlayer:GetMouse()
    mouseyea.KeyDown:Connect(
        function(togglebro)
            if togglebro == switchbro then
                if Aiming.FOV == 12.4 then
                    Aiming.FOV = 5.3
                    five:Play()
                else
                    Aiming.FOV = 12.4
                    twelve:Play()
                end
            end
        end
    )

    ---------------------------------------------------------------------------------------------------------------------------------------------

    local Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    --
    getgenv().Yes = nil
    while getgenv().Yes == true do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
            (CFrame.new(Position) + Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))) *
            CFrame.Angles(
                math.rad(math.random(-180, 180)),
                math.rad(math.random(-180, 180)),
                math.rad(math.random(-180, 180))
            )
    end

    
    ---------------------------------------------------------------------------------------------------------------------------------------------

    local resolve = "m"

    local mouseyea = game.Players.LocalPlayer:GetMouse()
    mouseyea.KeyDown:Connect(
        function(resolveitnow)
            if resolveitnow == resolve then

                resolvedsound:Play()
                local RunService = game:GetService("RunService")

                RunService.Heartbeat:Connect(
                    function()
                        pcall(
                            function()
                                for i, v in pairs(game.Players:GetChildren()) do
                                    if v.Name ~= game.Players.LocalPlayer.Name then
                                        local hrp = v.Character.HumanoidRootPart
                                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                                        hrp.AssemblyLinearVelocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                                    end
                                end
                            end
                        )
                    end
                )
            end
        end
    )
end

end

----script ends here

else
game:Shutdown()
messagebox("Invalid Key","whitelist issue",0)
end 
