local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "YC Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "StarConfig",
})

local highlightsAdded = {}

local function toggleRedHighlights()
    local players = game:GetService("Players"):GetPlayers()
    
    for _, player in ipairs(players) do
        local character = player.Character
        if character then
            if highlightsAdded[player] then
                local highlight = character:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
                highlightsAdded[player] = false
            else
                local highlight = Instance.new("Highlight")
                highlight.Name = "Highlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.Parent = character
                highlightsAdded[player] = true
            end
        end
    end
end

local Visual = Window:MakeTab({
    Name = "Player/PVP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
})

local EspSection = Visual:AddSection({
    Name = "Esp",
})

EspSection:AddToggle({
    Name = "Esp Player",
    Default = false,
    Callback = function(Value)
        toggleRedHighlights()
        print("Esp Player toggled:", Value)
    end,
})

EspSection:AddButton({
    Name = "Esp All",
    Callback = function()
        applyHighlights()
        print("Applied highlights to all objects.")
    end,
})

local PvpSection = Visual:AddSection({
    Name = "PVP",
})

local function moveToNearestPlayer()
    local players = game:GetService("Players")
    local localPlayer = players.LocalPlayer
    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end

     if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = nearestPlayer.Character.HumanoidRootPart.CFrame
    end
end


PvpSection:AddButton({
    Name = "Teleport to Nearest Player",
    Callback = function()
        moveToNearestPlayer()
        print("Teleported to nearest player.")
    end,
})

local Farm = Window:MakeTab({
    Name = "Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
})


local function activateTool()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    local backpack = player.Backpack
    
    if character and backpack then
        -- Verifica se o jogador possui alguma ferramenta no inventário
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- Mova a ferramenta do inventário para o personagem
                tool.Parent = character
                -- Ative a ferramenta continuamente
                while tool.Parent == character do
                    wait(0.1)
                    tool:Activate()
                end
            end
        end
    end
end


Farm:AddButton({
    Name = "Auto-Click",
    Callback = function()
        activateTool()
        print("Activated auto-click tool.")
    end,
})

local AutoChest = (function()
    local ativado = true
    local moveIndex = 1

    local positions = {
        Vector3.new(-2612.8740234375, 13.046133041381836, 33.443267822265625),
        Vector3.new(-2672.637451171875, 14.929405212402344, 151.0562744140625),
        Vector3.new(-2444.31591796875, 13.046142578125, -79.5899658203125),
        Vector3.new(-2483.024169921875, 13.046142578125, -81.99137115478516),
        Vector3.new(-2281.61181640625, 12.970499038696289, -147.5656280517578),
        Vector3.new(-2339.12060546875, 13.046138763427734, 211.44479370117188),
        Vector3.new(-2283.42041015625, 13.046142578125, 357.0035400390625),
        Vector3.new(-249.70675659179688, 44.16874694824219, 771.2797241210938),
        Vector3.new(876.0436401367188, 60.75099182128906, 3749.3310546875),
        Vector3.new(689.1666259765625, 11.660248756408691, 3768.564697265625),
        Vector3.new(387.534423828125, 11.660248756408691, 3901.204345703125),
        Vector3.new(287.5807189941406, 32.25508117675781, 3930.505615234375),
        Vector3.new(316.7060852050781, 31.342529296875, 3773.482421875),
        Vector3.new(-1038.0806884765625, 20.053556442260742, -3185.239013671875),
        Vector3.new(131.58872985839844, 17.843080520629883, 691.4762573242188),
        Vector3.new(1785.022216796875, 10.12531566619873, -692.864013671875),
        Vector3.new(2027.1956787109375, 24.18516731262207, -324.4190979003906),
        Vector3.new(-106.19489288330078, 16.534364700317383, 884.2457885742188),
        Vector3.new(-2673.131103515625, 19.052635192871094, 143.97508239746094),
        Vector3.new(-160.77066040039062, 16.534364700317383, 660.4036254882812),
        Vector3.new(1781.2283935546875, 10.22346019744873, -586.26806640625),
        Vector3.new(1901.9974365234375, 48.667720794677734, -651.6541137695312),
        Vector3.new(-1323.192626953125, 38.001258850097656, -2539.19580078125),
        Vector3.new(-1288.9942626953125, 38.00129699707031, -2722.7255859375),
        Vector3.new(3904.384033203125, 9.388663291931152, 4196.681640625),
        Vector3.new(4054.7548828125, 515.5868530273438, 4060.4365234375),
        Vector3.new(3362.99755859375, 862.3154296875, 3525.742431640625),
        Vector3.new(4547.6103515625, 1347.0167236328125, 3534.5966796875),
        Vector3.new(4586.98779296875, 1221.1890869140625, 3366.22705078125),
        Vector3.new(-4011.99072265625, 70.1473388671875, 1619.8953857421875),
        Vector3.new(-2293.9521484375, 109.46821594238281, 3684.23876953125),
        Vector3.new(-2297.862548828125, 109.46841430664062, 3679.509765625),
        Vector3.new(-2357.378662109375, 75.93946075439453, 3724.204345703125),
        Vector3.new(-2491.484619140625, 75.93946075439453, 3548.61376953125),
        Vector3.new(-2644.662109375, 157.69940185546875, 3846.773193359375),
        Vector3.new(-2605.306640625, 157.69940185546875, 3862.870361328125),
        Vector3.new(-2585.43359375, 157.69943237304688, 3908.783935546875),
        Vector3.new(-2552.436767578125, 159.83084106445312, 3949.7861328125),
        Vector3.new(-2451.566162109375, 259.0572509765625, 4091.477294921875),
        Vector3.new(-2459.344970703125, 259.4244079589844, 4091.951416015625),
        Vector3.new(-2457.10205078125, 259.0572204589844, 4077.79150390625),
        Vector3.new(1972.0980224609375, 12.83711051940918, -335.3066101074219),
        Vector3.new(-2638.239501953125, 406.0933837890625, 4052.206787109375),
        Vector3.new(-2695.6513671875, 479.0758361816406, 4086.29833984375),
        Vector3.new(-3160.34423828125, 141.1989288330078, -3008.54296875),
        Vector3.new(-4001.631103515625, 99.11713409423828, 1624.4619140625),
        Vector3.new(-3962.224609375, 55.98686599731445, 1288.5562744140625),
        Vector3.new(-3886.152587890625, 55.00044250488281, 1779.687744140625),
        Vector3.new(1847.1214599609375, 10.576910972595215, -464.21014404296875)
    }

    local function movePlayerToNextPosition()
        if ativado then
            local player = game:GetService("Players").LocalPlayer
            if player.Character then
                local humanoidRootPart = player.Character.HumanoidRootPart
                if humanoidRootPart then
                    humanoidRootPart.CFrame = CFrame.new(positions[moveIndex])
                    moveIndex = moveIndex % #positions + 1
                end
            end
            wait(0.6)
            movePlayerToNextPosition()
        end
    end

    return function()
        ativado = not ativado -- Alterna entre ativado e desativado
        
        if ativado then
            print('Ativado')
            movePlayerToNextPosition()
        else
            print('Desativado')
        end
    end
end)()


Farm:AddToggle({
	Name = "Auto Money",
	Default = false,
	Callback = function(Value)
		print(Value)
        AutoChest()
	end    
})

function FG()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local teleportPosition = Vector3.new(2000.434814453125, 70.27788543701172, -541.860595703125)

    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.Humanoid.Health = 0
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(2.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        
    end
end

function FD()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local teleportPosition = Vector3.new(-2566.877197265625, 13.046140670776367, 249.95558166503906)

    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.Humanoid.Health = 0
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(2.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
     end
end

function OH()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local teleportPosition = Vector3.new(4487.56982421875, 1281.43994140625, 3466.681396484375)

    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.Humanoid.Health = 0
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(2.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
     end
end

function BH()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local teleportPosition = Vector3.new(-1299.226806640625, 38.00129699707031, -2741.140869140625)

    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.Humanoid.Health = 0
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(2.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.3)
        player.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
     end
end

local NpcSection = Farm:AddSection({
    Name = "Npc",
})


Farm:AddDropdown({
	Name = "Npc Teleporter",
	Default = "None",
	Options = {"None", "Fruit Gacha", "Fruit Dealer", "Observation Haki", "Buso Haki"},
	Callback = function(Value)
        if Value == 'Fruit Gacha' then
            FG()
        elseif Value == 'Fruit Dealer' then
            FD()
        elseif Value == 'Observation Haki' then
            OH()
        elseif Value == 'Buso Haki' then
            BH()
        end
		print(Value)
	end    
})

local Credits = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
})


local CreditsSection = Credits:AddSection({
    Name = "Script by @SnowCHC_ofc",
})
