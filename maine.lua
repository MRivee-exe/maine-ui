local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Nébula-X",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "univer sciript",
    introtext = "univerce", 
    IntroIcon = "rbxassetid://12967596415", 
    SaveConfig = true,
})

local characterTab = Window:MakeTab({
    Name = "Character",
    Icon = "rbxassetid://11422138807",
    PremiumOnly = false
})

local aimebotTab = Window:MakeTab({
    Name = "aime bot | esp",
    Icon = "rbxassetid://11422138807",
    PremiumOnly = false
})

local setingTab = Window:MakeTab({
    Name = "Seting",
    Icon = "rbxassetid://11422138807",
    PremiumOnly = false
})

local btoolsTab = Window:MakeTab({
    Name = "BTools",
    Icon = "rbxassetid://11422138807",
    PremiumOnly = false
})
-- Variables pour le vol
FLYING = false
QEfly = true
iyflyspeed = 1
Players = game.Players
IYMouse = Players.LocalPlayer:GetMouse()
local shiftRunning = false
local runSpeed = 50 
local slidercolor =Color3.fromRGB(143, 174, 199)
local esptextcolor =Color3.fromRGB(0, 255, 0)
-- Fonction pour obtenir la partie racine du personnage
function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart")
end

-- Fonction de vol
function sFLY()
    repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character)
    local T = getRoot(Players.LocalPlayer.Character)
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.cframe = T.CFrame
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9)

        task.spawn(function()
            repeat wait()
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                else
                    SPEED = 0
                end
                BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                BG.cframe = workspace.CurrentCamera.CoordinateFrame
            until not FLYING
            BG:Destroy()
            BV:Destroy()
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end

    IYMouse.KeyDown:Connect(function(KEY)
        if KEY:lower() == 'w' then CONTROL.F = iyflyspeed end
        if KEY:lower() == 's' then CONTROL.B = -iyflyspeed end
        if KEY:lower() == 'a' then CONTROL.L = -iyflyspeed end
        if KEY:lower() == 'd' then CONTROL.R = iyflyspeed end
        if QEfly and KEY:lower() == 'e' then CONTROL.Q = iyflyspeed * 2 end
        if QEfly and KEY:lower() == 'q' then CONTROL.E = -iyflyspeed * 2 end
    end)

    IYMouse.KeyUp:Connect(function(KEY)
        if KEY:lower() == 'w' then CONTROL.F = 0 end
        if KEY:lower() == 's' then CONTROL.B = 0 end
        if KEY:lower() == 'a' then CONTROL.L = 0 end
        if KEY:lower() == 'd' then CONTROL.R = 0 end
        if KEY:lower() == 'e' then CONTROL.Q = 0 end
        if KEY:lower() == 'q' then CONTROL.E = 0 end
    end)

    FLY()
end

function NOFLY()
    FLYING = false
end

-- Variable pour suivre l'état du toggle
local flyActive = false

local HighlightColor1 = Color3.fromRGB(0, 255, 0)
local HighlightColor2 = Color3.fromRGB(255, 255, 255)
-- Variables pour l'ESP
local highlightActive = false

local function applyHighlight()
    local localPlayer = Players.LocalPlayer
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            if not player.Character:FindFirstChildOfClass("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.Adornee = player.Character
                highlight.FillColor = HighlightColor1
                highlight.OutlineColor = HighlightColor2
            end
            if not player.Character:FindFirstChild("NameTag") then
                local billboardGui = Instance.new("BillboardGui")
                billboardGui.Name = "NameTag"
                billboardGui.Parent = player.Character
                billboardGui.Size = UDim2.new(4, 0, 1, 0)
                billboardGui.StudsOffset = Vector3.new(0, 2, 0)
                billboardGui.AlwaysOnTop = true

                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = billboardGui
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = esptextcolor
                textLabel.TextStrokeTransparency = 0
                textLabel.TextSize = 14

                -- Affichage des points de vie
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    textLabel.Text = player.Name .. " | Vie: " .. math.floor(humanoid.Health)
                end
            end
        end
    end
end

local function updateHealth()
    local localPlayer = Players.LocalPlayer
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local billboardGui = player.Character:FindFirstChild("NameTag")
            if billboardGui then
                local textLabel = billboardGui:FindFirstChildOfClass("TextLabel")
                if textLabel then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        textLabel.Text = player.Name .. " | Vie: " .. math.floor(humanoid.Health)
                    end
                end
            end
        end
    end
end

local function removeHighlight()
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            for _, child in ipairs(player.Character:GetChildren()) do
                if child:IsA("Highlight") or child.Name == "NameTag" then
                    child:Destroy()
                end
            end
        end
    end
end

local Noclip = nil
local Clip = nil

function noclip()
    Clip = false
    local function Nocl()
        if Clip == false and game.Players.LocalPlayer.Character ~= nil then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA('BasePart') and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
        wait(0.21) -- basic optimization
    end
    Noclip = game:GetService('RunService').Stepped:Connect(Nocl)
end

function clip()
    if Noclip then Noclip:Disconnect() end
    Clip = true
end

-- Boucle pour mettre à jour l'effet de Highlight et les distances toutes les 0.1 secondes
game:GetService("RunService").RenderStepped:Connect(function()
    if highlightActive then
        applyHighlight()
        updateDistances()
    end
end)

local aimActive = false
local mouse = game.Players.LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local aiming = false
local teamCheckActive = false

-- Checks if the player is visible
local function isPlayerVisible(player)
    if not player or not player.Character then return false end

    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local head = player.Character:FindFirstChild("Head")
    if not head or not localCharacter or not localCharacter:FindFirstChild("Head") then return false end

    -- Raycast to check visibility
    local origin = localCharacter.Head.Position
    local direction = (head.Position - origin).unit * (head.Position - origin).magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {localPlayer.Character}  -- Ignore local player's own character
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    return raycastResult and raycastResult.Instance:IsDescendantOf(player.Character)
end

local function getClosestVisiblePlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local localCharacter = localPlayer.Character or localPlayer.CharacterAdded:Wait()

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head and isPlayerVisible(player) then
                local distance = (localCharacter.Head.Position - head.Position).magnitude
                if distance < shortestDistance then
                    -- Add team check: ignore teammates
                    if not teamCheckActive or player.Team ~= localPlayer.Team then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function aimAtPlayer(player)
    if player and player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            local targetPosition = head.Position
            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, targetPosition)
        end
    end
end

local function createMoveTool()
    local MoveTool = Instance.new("Tool")
    MoveTool.Name = "MoveTool"
    MoveTool.RequiresHandle = false
    MoveTool.Parent = game.Players.LocalPlayer.Backpack

    local selectionBox
    local moveHandles
    local selectedPart
    local previousDistance

    local function onMoveHandlesDown(normal)
        if selectedPart then
            selectedPart.Anchored = true
            previousDistance = 0
        end
    end

    local function onMoveHandlesDrag(normal, distance)
        if selectedPart then
            local delta = distance - previousDistance
            local translation = CFrame.new(Vector3.FromNormalId(normal) * delta)
            selectedPart.CFrame = selectedPart.CFrame * translation
            previousDistance = distance
        end
    end

    local function onButton1Down(mouse)
        selectionBox.Adornee = nil
        moveHandles.Adornee = nil
        if mouse.Target then
            selectedPart = mouse.Target
            selectionBox.Adornee = mouse.Target
            moveHandles.Adornee = mouse.Target
        end
    end

    local function onEquipped(mouse)
        mouse.Icon = "rbxasset://textures/DragCursor.png"
        mouse.Button1Down:Connect(function() onButton1Down(mouse) end)

        selectionBox = Instance.new("SelectionBox")
        selectionBox.Color = BrickColor.new("Really blue")
        selectionBox.Adornee = nil
        selectionBox.Parent = game.Players.LocalPlayer.PlayerGui

        moveHandles = Instance.new("Handles")
        moveHandles.Style = Enum.HandlesStyle.Movement
        moveHandles.Color = BrickColor.new("Really red")
        moveHandles.Adornee = nil
        moveHandles.MouseDrag:Connect(onMoveHandlesDrag)
        moveHandles.MouseButton1Down:Connect(onMoveHandlesDown)
        moveHandles.Parent = game.Players.LocalPlayer.PlayerGui
    end

    local function onUnequipped()
        selectionBox:Destroy()
        moveHandles:Destroy()
    end

    MoveTool.Equipped:Connect(onEquipped)
    MoveTool.Unequipped:Connect(onUnequipped)
end

-- Fonction pour créer l'outil de rotation
local function createRotateTool()
    local RotateTool = Instance.new("Tool")
    RotateTool.Name = "RotateTool"
    RotateTool.RequiresHandle = false
    RotateTool.Parent = game.Players.LocalPlayer.Backpack

    local selectionBox
    local arcHandles
    local selectedPart
    local previousCFrame

    local function onArcHandlesDown()
        if selectedPart then
            selectedPart.Anchored = true
            previousCFrame = selectedPart.CFrame
        end
    end

    local function onArcHandlesDrag(axis, relativeAngle)
        if selectedPart then
            local axisAngle = Vector3.FromAxis(axis) * relativeAngle
            selectedPart.CFrame = previousCFrame * CFrame.Angles(axisAngle.x, axisAngle.y, axisAngle.z)
        end
    end

    local function onButton1Down(mouse)
        selectionBox.Adornee = nil
        arcHandles.Adornee = nil
        if mouse.Target then
            selectedPart = mouse.Target
            selectionBox.Adornee = mouse.Target
            arcHandles.Adornee = mouse.Target
        end
    end

    local function onEquipped(mouse)
        mouse.Icon = "rbxasset://textures/DragCursor.png"
        mouse.Button1Down:Connect(function() onButton1Down(mouse) end)

        selectionBox = Instance.new("SelectionBox")
        selectionBox.Color = BrickColor.new("Really blue")
        selectionBox.Adornee = nil
        selectionBox.Parent = game.Players.LocalPlayer.PlayerGui

        arcHandles = Instance.new("ArcHandles")
        arcHandles.Color = BrickColor.new("New Yeller")
        arcHandles.Adornee = nil
        arcHandles.Axes = Axes.new(Enum.Axis.X, Enum.Axis.Y, Enum.Axis.Z)
        arcHandles.MouseDrag:Connect(onArcHandlesDrag)
        arcHandles.MouseButton1Down:Connect(onArcHandlesDown)
        arcHandles.Parent = game.Players.LocalPlayer.PlayerGui
    end

    local function onUnequipped()
        selectionBox:Destroy()
        arcHandles:Destroy()
    end

    RotateTool.Equipped:Connect(onEquipped)
    RotateTool.Unequipped:Connect(onUnequipped)
end

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local canJump = false

-- Toggle l'infinite jump entre activé et désactivé à chaque exécution du script
_G.infinjump = not _G.infinjump

if _G.infinJumpStarted == nil then
    -- Assure que ceci ne s'exécute qu'une seule fois pour économiser des ressources
    _G.infinJumpStarted = true
    
    -- L'infinite jump
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

    -- Écoute les événements de saut
    userInputService.JumpRequest:Connect(function()
        if _G.infinjump then
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)

    -- Écoute les touches
    local mouse = player:GetMouse()
    mouse.KeyDown:Connect(function(k)
        if _G.infinjump then
            if k:byte() == 32 then -- Si la touche est espace (ASCII 32)
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    wait()
                    humanoid:ChangeState(Enum.HumanoidStateType.Seated)
                end
            end
        end
    end)
end

-- Fonction pour activer l'Infinite Jump
local function enableInfinityJump()
    _G.infinjump = true
end

-- Fonction pour désactiver l'Infinite Jump
local function disableInfinityJump()
    _G.infinjump = false
end

-- Fonction pour activer la course lorsque Shift est pressé
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Si Shift est pressé et ShiftToRun est activé
    if input.KeyCode == Enum.KeyCode.LeftShift and shiftRunning then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = runSpeed
    end
end)

-- Lorsque Shift est relâché, on rétablit la vitesse de marche par défaut
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16  -- Vitesse de marche par défaut
    end
end)


-- Ajout des boutons pour créer les outils dans le tab BTools
local btools1 = btoolsTab:AddButton({
    Name = "Give Move Tool",
    Callback = function()
        createMoveTool()
    end    
})

local btools2 = btoolsTab:AddButton({
    Name = "Give Rotate Tool",
    Callback = function()
        createRotateTool()
    end    
})


-- Toggle pour l'ESP et le vol

local FLYToggle = characterTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(Value)
        -- Met à jour la variable `flyActive` en fonction de l'état du toggle
        flyActive = Value
        if Value then
            sFLY()  -- Activer le vol si le toggle est activé
        else
            NOFLY()  -- Désactiver le vol si le toggle est désactivé
        end
    end    
})
-- Keybind pour activer/désactiver le vol avec la touche
local FLYKeybind = characterTab:AddBind({
    Name = "Fly Keybind",
    Default = Enum.KeyCode.E,
    Hold = false,
    Callback = function()
        -- Vérifie si le toggle est activé
        if flyActive then
            if not FLYING then
                sFLY()  -- Si le vol n'est pas activé, on l'active
            else
                NOFLY()  -- Si le vol est déjà activé, on le désactive
            end
        else
            print("Le keybind de vol est désactivé, toggle non activé")  -- Le keybind ne fait rien si le toggle est désactivé
        end
    end    
})


-- Ajout d'un bouton Noclip dans le tab "Character"
local NoclipTab = characterTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(Value)
        if Value then
            noclip()
            print("Noclip activé")
        else
            clip()
            print("Noclip désactivé")
        end
    end    
})

local infjToggle = characterTab:AddToggle({
    Name = "Infinity Jump",
    Default = false,
    Callback = function(Value)
        if Value then
            enableInfinityJump()
        else
            disableInfinityJump()
        end
    end    
})

local ShiftToRun = characterTab:AddToggle({
    Name = "ShiftToRun",
    Default = false,
    Callback = function(State)
        shiftRunning = State
    end    
})


-- Ajouter un slider pour la vitesse du joueur
local SpeedSlider = characterTab:AddSlider({
    Name = "Player Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = slidercolor,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value -- Modifie la vitesse du joueur
        end
    end    
})

-- Ajouter un slider pour la vitesse du fly
local FlySpeedSlider = characterTab:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 50,
    Default = 16,
    Color = slidercolor,
    Increment = 1,
    ValueName = "iyflyspeed",
    Callback = function(Value)
        iyflyspeed = Value  -- Modifie la vitesse du vol
    end    
})

local SpeedSlider = characterTab:AddSlider({
    Name = "Running Speed",
    Min = 10,
    Max = 500,
    Color = slidercolor,
    Default = runSpeed,
    Increment = 5,
    Callback = function(Value)
        runSpeed = Value
    end    
})
-- Ajouter un slider pour la puissance de saut du joueur
local JumpPowerSlider = characterTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = slidercolor,
    Increment = 1,
    ValueName = "Jump Power",
    Callback = function(Value)
        local humanoid = Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value -- Modifie la puissance de saut du joueur
        end
    end    
})

local ESPToggle = aimebotTab:AddToggle({
    Name = "ESP",
    Default = false,
    Callback = function(Value)
        if Value then
            applyHighlight()
            highlightActive = true
            while highlightActive do
                updateHealth() -- Met à jour les points de vie
                wait(1)
            end
        else
            removeHighlight()
            highlightActive = false
        end
    end    
})


-- Ajouter un bouton Aimbot dans le tab "Character"
local AIMBOT = aimebotTab:AddToggle({
    Name = "Aim Bot",
    Default = false,
    Callback = function(Value)
        aimActive = Value
        print(aimActive and "Aim Bot activé" or "Aim Bot désactivé")
    end    
})

local teamCheckToggle = aimebotTab:AddToggle({
    Name = "Team Check",
    Default = false,
    Callback = function(Value)
        teamCheckActive = Value
        if highlightActive then
            removeHighlight()
            applyHighlight()
        end
    end
})

-- Maintenir clic droit pour suivre la cible
mouse.Button2Down:Connect(function()
    if aimActive then
        aiming = true
        while aiming do
            local closestPlayer = getClosestVisiblePlayer()
            if closestPlayer then
                aimAtPlayer(closestPlayer)
            end
            RunService.RenderStepped:Wait() -- Updates every frame
        end
    end
end)

local RJ = characterTab:AddButton({
    Name = "Rejoin",
    Callback = function(Value)
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end    
})

mouse.Button2Up:Connect(function()
    aiming = false
end)

local AIMBOT = aimebotTab:AddButton({
    Name = "print cat",
    Default = false,
    Callback = function(Value)
        print[[
               ╱|、
                          (˚ˎ 。7
                           |、˜〵
                          じしˍ,)ノ

]]
    end    
})

local HIGHLIGHTCOLOR1 = setingTab:AddColorpicker({
	Name = "ESP Color FillColor",
	Default = Color3.fromRGB(0, 255, 0),
	Callback = function(Value)
		HighlightColor1 = Value
	end	  
})
local HIGHLIGHTCOLOR2 = setingTab:AddColorpicker({
	Name = "ESP Color OutlineColor",
	Default = Color3.fromRGB(255, 255, 255),
	Callback = function(Value)
		HighlightColor2 = Value
	end	  
})
local ESPTEXTCOLOR = setingTab:AddColorpicker({
	Name = "ESP Text Color",
	Default = Color3.fromRGB(143, 174, 199),
	Callback = function(Value)
		esptextcolor = Value
	end	  
})

OrionLib:Init()
