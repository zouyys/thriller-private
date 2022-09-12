if game.PlaceId == 2788229376 then
    -----------------------------------da-hood----------------------------------------------------

    repeat
        wait()
    until game:IsLoaded()

    
    
    Local Hitbox = getgenv().AimPart
    Local Smoothing = getgenv().Smoothness
    
    
    
    getgenv().OldAimPart = "UpperTorso"
    --getgenv().AimPart = "UpperTorso"
    getgenv().AimlockKey = "q"
    getgenv().AimRadius = 8 
    getgenv().ThirdPerson = true
    getgenv().FirstPerson = true
    getgenv().TeamCheck = false 
    getgenv().PredictMovement = true 
    getgenv().PredictionVelocity = 7.22
    getgenv().CheckIfJumped = true
    --getgenv().Smoothness = true
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
