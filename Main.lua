if game.PlaceId == 2788229376 then
    -----------------------------------da-hood----------------------------------------------------

    repeat
        wait()
    until game:IsLoaded()

    getgenv().OldAimPart = "UpperTorso"
    local AimPart = getgenv().Settings.SoftAim.Part
    local AimlockKey = getgenv().Settings.SoftAim.Key
    local AimRadius = getgenv().Settings.SoftAim.Radius 
    getgenv().ThirdPerson = true
    getgenv().FirstPerson = true
    getgenv().TeamCheck = false 
    getgenv().PredictMovement = true 
    local PredictionVelocity = 7.22 getgenv().Settings.SoftAim.Prediction
    local CheckIfJumped = getgenv().Settings.SoftAim.Airshots
    local Smoothness = getgenv().Settings.SoftAim.Smoothing.Enabled
    local SmoothnessAmount = getgenv().Settings.SoftAim.Smoothing.Amount

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
if getgenv().Aiming then return getgenv().Aiming end

-- // Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

-- // Vars
local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- // Optimisation Vars (ugly)
local Drawingnew = Drawing.new
local Color3fromRGB = Color3.fromRGB
local Vector2new = Vector2.new
local GetGuiInset = GuiService.GetGuiInset
local Randomnew = Random.new
local mathfloor = math.floor
local CharacterAdded = LocalPlayer.CharacterAdded
local CharacterAddedWait = CharacterAdded.Wait
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local RaycastParamsnew = RaycastParams.new
local EnumRaycastFilterTypeBlacklist = Enum.RaycastFilterType.Blacklist
local Raycast = Workspace.Raycast
local GetPlayers = Players.GetPlayers
local Instancenew = Instance.new
local IsDescendantOf = Instancenew("Part").IsDescendantOf
local FindFirstChildWhichIsA = Instancenew("Part").FindFirstChildWhichIsA
local FindFirstChild = Instancenew("Part").FindFirstChild
local tableremove = table.remove
local tableinsert = table.insert

-- // Silent Aim Vars
getgenv().Aiming = {
    Enabled = true,

    ShowFOV = false,
    FOV = 15.5,
    FOVSides = 25,
    FOVColour = Color3fromRGB(255, 255, 255),

    VisibleCheck = true,
    
    HitChance = 100,

    Selected = nil,
    SelectedPart = nil,

    TargetPart = {"Head", "HumanoidRootPart"},

    Ignored = {
        Teams = {
            {
                Team = LocalPlayer.Team,
                TeamColor = LocalPlayer.TeamColor,
            },
        },
        Players = {
            LocalPlayer,
            91318356
        }
    }
}
local Aiming = getgenv().Aiming

-- // Create circle
local circle = Drawingnew("Circle")
circle.Transparency = 0.4
circle.Thickness = 0.8
circle.Color = Aiming.FOVColour
circle.Filled = false
Aiming.FOVCircle = circle

-- // Update
function Aiming.UpdateFOV()
    -- // Make sure the circle exists
    if not (circle) then
        return
    end

    -- // Set Circle Properties
    circle.Visible = Aiming.ShowFOV
    circle.Radius = (Aiming.FOV * 3)
    circle.Position = Vector2new(Mouse.X, Mouse.Y + GetGuiInset(GuiService).Y)
    circle.NumSides = Aiming.FOVSides
    circle.Color = Aiming.FOVColour

    -- // Return circle
    return circle
end

-- // Custom Functions
local CalcChance = function(percentage)
    -- // Floor the percentage
    percentage = mathfloor(percentage)

    -- // Get the chance
    local chance = mathfloor(Randomnew().NextNumber(Randomnew(), 0, 1) * 100) / 100

    -- // Return
    return chance <= percentage / 100
end

-- // Customisable Checking Functions: Is a part visible
function Aiming.IsPartVisible(Part, PartDescendant)
    -- // Vars
    local Character = LocalPlayer.Character or CharacterAddedWait(CharacterAdded)
    local Origin = CurrentCamera.CFrame.Position
    local _, OnScreen = WorldToViewportPoint(CurrentCamera, Part.Position)

    -- //
    if (OnScreen) then
        -- // Vars
        local raycastParams = RaycastParamsnew()
        raycastParams.FilterType = EnumRaycastFilterTypeBlacklist
        raycastParams.FilterDescendantsInstances = {Character, CurrentCamera}

        -- // Cast ray
        local Result = Raycast(Workspace, Origin, Part.Position - Origin, raycastParams)

        -- // Make sure we get a result
        if (Result) then
            -- // Vars
            local PartHit = Result.Instance
            local Visible = (not PartHit or IsDescendantOf(PartHit, PartDescendant))

            -- // Return
            return Visible
        end
    end

    -- // Return
    return false
end

-- // Ignore player
function Aiming.IgnorePlayer(Player)
    -- // Vars
    local Ignored = Aiming.Ignored
    local IgnoredPlayers = Ignored.Players

    -- // Find player in table
    for _, IgnoredPlayer in ipairs(IgnoredPlayers) do
        -- // Make sure player matches
        if (IgnoredPlayer == Player) then
            return false
        end
    end

    -- // Blacklist player
    tableinsert(IgnoredPlayers, Player)
    return true
end

-- // Unignore Player
function Aiming.UnIgnorePlayer(Player)
    -- // Vars
    local Ignored = Aiming.Ignored
    local IgnoredPlayers = Ignored.Players

    -- // Find player in table
    for i, IgnoredPlayer in ipairs(IgnoredPlayers) do
        -- // Make sure player matches
        if (IgnoredPlayer == Player) then
            -- // Remove from ignored
            tableremove(IgnoredPlayers, i)
            return true
        end
    end

    -- //
    return false
end

-- // Ignore team
function Aiming.IgnoreTeam(Team, TeamColor)
    -- // Vars
    local Ignored = Aiming.Ignored
    local IgnoredTeams = Ignored.Teams

    -- // Find team in table
    for _, IgnoredTeam in ipairs(IgnoredTeams) do
        -- // Make sure team matches
        if (IgnoredTeam.Team == Team and IgnoredTeam.TeamColor == TeamColor) then
            return false
        end
    end

    -- // Ignore team
    tableinsert(IgnoredTeams, {Team, TeamColor})
    return true
end

-- // Unignore team
function Aiming.UnIgnoreTeam(Team, TeamColor)
    -- // Vars
    local Ignored = Aiming.Ignored
    local IgnoredTeams = Ignored.Teams

    -- // Find team in table
    for i, IgnoredTeam in ipairs(IgnoredTeams) do
        -- // Make sure team matches
        if (IgnoredTeam.Team == Team and IgnoredTeam.TeamColor == TeamColor) then
            -- // Remove
            tableremove(IgnoredTeams, i)
            return true
        end
    end

    -- // Return
    return false
end

-- //  Toggle team check
function Aiming.TeamCheck(Toggle)
    if (Toggle) then
        return Aiming.IgnoreTeam(LocalPlayer.Team, LocalPlayer.TeamColor)
    end

    return Aiming.UnIgnoreTeam(LocalPlayer.Team, LocalPlayer.TeamColor)
end

-- // Check teams
function Aiming.IsIgnoredTeam(Player)
    -- // Vars
    local Ignored = Aiming.Ignored
    local IgnoredTeams = Ignored.Teams

    -- // Check if team is ignored
    for _, IgnoredTeam in ipairs(IgnoredTeams) do
        -- // Make sure team matches
        if (Player.Team == IgnoredTeam.Team and Player.TeamColor == IgnoredTeam.TeamColor) then
            return true
        end
    end

    -- // Return
    return false
end

-- // Check if player (and team) is ignored
function Aiming.IsIgnored(Player)
    -- // Vars
    local Ignored = Aiming.Ignored
    local IgnoredPlayers = Ignored.Players

    -- // Loop
    for _, IgnoredPlayer in ipairs(IgnoredPlayers) do
        -- // Check if Player Id
        if (typeof(IgnoredPlayer) == "number" and Player.UserId == IgnoredPlayer) then
            return true
        end

        -- // Normal Player Instance
        if (IgnoredPlayer == Player) then
            return true
        end
    end

    -- // Team check
    return Aiming.IsIgnoredTeam(Player)
end

-- // Get the Direction, Normal and Material
function Aiming.Raycast(Origin, Destination, UnitMultiplier)
    if (typeof(Origin) == "Vector3" and typeof(Destination) == "Vector3") then
        -- // Handling
        if (not UnitMultiplier) then UnitMultiplier = 1 end

        -- // Vars
        local Direction = (Destination - Origin).Unit * UnitMultiplier
        local Result = Raycast(Workspace, Origin, Direction)

        -- // Make sure we have a result
        if (Result) then
            local Normal = Result.Normal
            local Material = Result.Material

            return Direction, Normal, Material
        end
    end

    -- // Return
    return nil
end

-- // Get Character
function Aiming.Character(Player)
    return Player.Character
end

-- // Check Health
function Aiming.CheckHealth(Player)
    -- // Get Humanoid
    local Character = Aiming.Character(Player)
    local Humanoid = FindFirstChildWhichIsA(Character, "Humanoid")

    -- // Get Health
    local Health = (Humanoid and Humanoid.Health or 0)

    -- //
    return Health > 0
end

-- // Check if silent aim can used
function Aiming.Check()
    return (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil)
end
Aiming.checkSilentAim = Aiming.Check

-- // Get Closest Target Part
function Aiming.GetClosestTargetPartToCursor(Character)
    local TargetParts = Aiming.TargetPart

    -- // Vars
    local ClosestPart = nil
    local ClosestPartPosition = nil
    local ClosestPartOnScreen = false
    local ClosestPartMagnitudeFromMouse = nil
    local ShortestDistance = 1/0

    -- //
    local function CheckTargetPart(TargetPart)
        -- // Convert string -> Instance
        if (typeof(TargetPart) == "string") then
            TargetPart = FindFirstChild(Character, TargetPart)
        end

        -- // Make sure we have a target
        if not (TargetPart) then
            return
        end

        -- // Get the length between Mouse and Target Part (on screen)
        local PartPos, onScreen = WorldToViewportPoint(CurrentCamera, TargetPart.Position)
        local GuiInset = GetGuiInset(GuiService)
        local Magnitude = (Vector2new(PartPos.X, PartPos.Y - GuiInset.Y) - Vector2new(Mouse.X, Mouse.Y)).Magnitude

        -- //
        if (Magnitude < ShortestDistance) then
            ClosestPart = TargetPart
            ClosestPartPosition = PartPos
            ClosestPartOnScreen = onScreen
            ClosestPartMagnitudeFromMouse = Magnitude
            ShortestDistance = Magnitude
        end
    end

    -- // String check
    if (typeof(TargetParts) == "string") then
        -- // Check if it all
        if (TargetParts == "All") then
            -- // Loop through character children
            for _, v in ipairs(Character:GetChildren()) do
                -- // See if it a part
                if not (v:IsA("BasePart")) then
                    continue
                end

                -- // Check it
                CheckTargetPart(v)
            end
        else
            -- // Individual
            CheckTargetPart(TargetParts)
        end
    end

    -- //
    if (typeof(TargetParts) == "table") then
        -- // Loop through all target parts and check them
        for _, TargetPartName in ipairs(TargetParts) do
            CheckTargetPart(TargetPartName)
        end
    end

    -- //
    return ClosestPart, ClosestPartPosition, ClosestPartOnScreen, ClosestPartMagnitudeFromMouse
end

-- // Silent Aim Function
function Aiming.GetClosestPlayerToCursor()
    -- // Vars
    local TargetPart = nil
    local ClosestPlayer = nil
    local Chance = CalcChance(Aiming.HitChance)
    local ShortestDistance = 1/0

    -- // Chance
    if (not Chance) then
        Aiming.Selected = LocalPlayer
        Aiming.SelectedPart = nil

        return LocalPlayer
    end

    -- // Loop through all players
    for _, Player in ipairs(GetPlayers(Players)) do
        -- // Get Character
        local Character = Aiming.Character(Player)

        -- // Make sure isn't ignored and Character exists
        if (Aiming.IsIgnored(Player) == false and Character) then
            -- // Vars
            local TargetPartTemp, _, _, Magnitude = Aiming.GetClosestTargetPartToCursor(Character)

            -- // Check if part exists and health
            if (TargetPartTemp and Aiming.CheckHealth(Player)) then
                -- // Check if is in FOV
                if (circle.Radius > Magnitude and Magnitude < ShortestDistance) then
                    -- // Check if Visible
                    if (Aiming.VisibleCheck and not Aiming.IsPartVisible(TargetPartTemp, Character)) then continue end

                    -- // Set vars
                    ClosestPlayer = Player
                    ShortestDistance = Magnitude
                    TargetPart = TargetPartTemp
                end
            end
        end
    end

    -- // End
    Aiming.Selected = ClosestPlayer
    Aiming.SelectedPart = TargetPart
end

-- // Heartbeat Function
Heartbeat:Connect(function()
    Aiming.UpdateFOV()
    Aiming.GetClosestPlayerToCursor()
end)

-- //
return Aiming

-- // If you want the examples, look at the docs.
                            Aiming.TeamCheck(false)
                             
                            
                            local Workspace = game:GetService("Workspace")
                            local Players = game:GetService("Players")
                            local RunService = game:GetService("RunService")
                            local UserInputService = game:GetService("UserInputService")
                            
                            
                            local LocalPlayer = Players.LocalPlayer
                            local Mouse = LocalPlayer:GetMouse()
                            local CurrentCamera = Workspace.CurrentCamera
                            
                            local DaHoodSettings = {
                                SilentAim = true,
                                AimLock = false,
                                Prediction = 0.131,
                                AimLockKeybind = Enum.KeyCode.E
                            }
                            getgenv().DaHoodSettings = DaHoodSettings
                            
                            
                            function Aiming.Check()
                            -------------
                                if not (Aiming.Enabled == true and Aiming.Selected ~= LocalPlayer and Aiming.SelectedPart ~= nil) then
                                    return false
                                end
                            
                                -- // Check if downed
                                local Character = Aiming.Character(Aiming.Selected)
                                local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
                                local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil
                            
                                -- // Check B
                                if (KOd or Grabbed) then
                                    return false
                                end
                            
                                -- //
                                return true
                            end
                            
                            -- // Hook
                            local __index
                            __index = hookmetamethod(game, "__index", function(t, k)
                                -- // Check if it trying to get our mouse's hit or target and see if we can use it
                                if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and Aiming.Check()) then
                                    local SelectedPart = Aiming.SelectedPart
                            
                                    -- // Hit/Target
                                    if (DaHoodSettings.SilentAim and (k == "Hit" or k == "Target")) then
                                        -- // Hit to account prediction
                                        local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)
                            
                                        -- // Return modded val
                                        return (k == "Hit" and Hit or SelectedPart)
                                    end
                                end
                            
                                -- // Return
                                return __index(t, k)
                            end)
                            
                            -- // Aimlock
                            RunService:BindToRenderStep("AimLock", 0, function()
                                if (DaHoodSettings.AimLock and Aiming.Check() and UserInputService:IsKeyDown(DaHoodSettings.AimLockKeybind)) then
                                    -- // Vars
                                    local SelectedPart = Aiming.SelectedPart
                            
                                    -- // Hit to account prediction
                                    local Hit = SelectedPart.CFrame + (SelectedPart.Velocity * DaHoodSettings.Prediction)
                            
                                    CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Hit.Position)
                                end
                                end)
  
  ----------------------------------------------------------------------------------------------------------------------------------------------------------
  
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
