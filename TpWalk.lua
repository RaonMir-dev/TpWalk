--TpWalk!

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local tpwalking1 = false
local tpwalking2 = false
local tpwalkSpeed1 = 0.3
local tpwalkSpeed2 = 5
local savedSpeed1 = "0.3"
local savedSpeed2 = "5"

-- Функция для проверки и восстановления GUI
local function ensureGUI()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return nil end
    
    local existingGui = playerGui:FindFirstChild("TpWalkUI")
    if existingGui and existingGui.Parent == playerGui then
        return existingGui
    end
    return nil
end

local function createUI()
    local playerGui = player:WaitForChild("PlayerGui")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TpWalkUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999999 -- Максимальный приоритет отображения
    ScreenGui.Parent = playerGui

    -- Защита от удаления
    ScreenGui.AncestryChanged:Connect(function(_, parent)
        if not parent then
            task.wait(0.1)
            ScreenGui.Parent = playerGui
        end
    end)

    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Size = UDim2.new(0, 240, 0, 140)
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.ClipsDescendants = true
    Frame.Active = true
    Frame.Draggable = true

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 16)

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -40, 0, 25)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "TpWalk"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 3
    Title.Parent = Frame

    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "MinBtn"
    MinBtn.Size = UDim2.new(0, 30, 0, 25)
    MinBtn.Position = UDim2.new(1, -35, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 22
    MinBtn.ZIndex = 4
    MinBtn.AutoButtonColor = false
    MinBtn.Parent = Frame

    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -25)
    Content.Position = UDim2.new(0, 0, 0, 25)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ZIndex = 1
    Content.Parent = Frame

    -- Первая кнопка
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleButton"
    ToggleBtn.Size = UDim2.new(0.42, 0, 0, 35)
    ToggleBtn.Position = UDim2.new(0.04, 0, 0, 5)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "Activate 1"
    ToggleBtn.Font = Enum.Font.GothamSemibold
    ToggleBtn.TextSize = 14
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Parent = Content

    local btnCorner = Instance.new("UICorner", ToggleBtn)
    btnCorner.CornerRadius = UDim.new(0, 10)

    -- Вторая кнопка
    local ToggleBtn2 = Instance.new("TextButton")
    ToggleBtn2.Name = "ToggleButton2"
    ToggleBtn2.Size = UDim2.new(0.42, 0, 0, 35)
    ToggleBtn2.Position = UDim2.new(0.54, 0, 0, 5)
    ToggleBtn2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ToggleBtn2.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn2.Text = "Activate 2"
    ToggleBtn2.Font = Enum.Font.GothamSemibold
    ToggleBtn2.TextSize = 14
    ToggleBtn2.AutoButtonColor = false
    ToggleBtn2.Parent = Content

    local btnCorner2 = Instance.new("UICorner", ToggleBtn2)
    btnCorner2.CornerRadius = UDim.new(0, 10)

    -- Первое поле скорости
    local SpeedBox = Instance.new("TextBox")
    SpeedBox.Name = "SpeedBox"
    SpeedBox.Size = UDim2.new(0.42, 0, 0, 35)
    SpeedBox.Position = UDim2.new(0.04, 0, 0, 45)
    SpeedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBox.Font = Enum.Font.Gotham
    SpeedBox.TextSize = 16
    SpeedBox.PlaceholderText = "Speed 1"
    SpeedBox.ClearTextOnFocus = false
    SpeedBox.Text = savedSpeed1
    SpeedBox.Parent = Content

    local speedCorner = Instance.new("UICorner", SpeedBox)
    speedCorner.CornerRadius = UDim.new(0, 10)

    -- Второе поле скорости
    local SpeedBox2 = Instance.new("TextBox")
    SpeedBox2.Name = "SpeedBox2"
    SpeedBox2.Size = UDim2.new(0.42, 0, 0, 35)
    SpeedBox2.Position = UDim2.new(0.54, 0, 0, 45)
    SpeedBox2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SpeedBox2.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedBox2.Font = Enum.Font.Gotham
    SpeedBox2.TextSize = 16
    SpeedBox2.PlaceholderText = "Speed 2"
    SpeedBox2.ClearTextOnFocus = false
    SpeedBox2.Text = savedSpeed2
    SpeedBox2.Parent = Content

    local speedCorner2 = Instance.new("UICorner", SpeedBox2)
    speedCorner2.CornerRadius = UDim.new(0, 10)

    local MinOverlay = Instance.new("TextButton")
    MinOverlay.Name = "MinOverlay"
    MinOverlay.Size = UDim2.new(1, 0, 1, 0)
    MinOverlay.Position = UDim2.new(0, 0, 0, 0)
    MinOverlay.BackgroundTransparency = 1
    MinOverlay.AutoButtonColor = false
    MinOverlay.Text = ""
    MinOverlay.Visible = false
    MinOverlay.ZIndex = 2
    MinOverlay.Parent = Frame

    MinOverlay.Active = true
    MinOverlay.Draggable = true

    return ScreenGui, Frame, Title, MinBtn, Content, ToggleBtn, SpeedBox, ToggleBtn2, SpeedBox2, MinOverlay
end

-- Создаем GUI
local ScreenGui, Frame, Title, MinBtn, Content, ToggleBtn, SpeedBox, ToggleBtn2, SpeedBox2, MinOverlay = createUI()

-- Функция для восстановления GUI при исчезновении
local function monitorGUI()
    task.spawn(function()
        while true do
            task.wait(0.5) -- Проверяем каждые 0.5 секунды
            
            -- Проверяем все элементы GUI
            if not ensureGUI() or not Frame.Parent or not Content.Parent then
                -- GUI исчез, создаем заново
                ScreenGui, Frame, Title, MinBtn, Content, ToggleBtn, SpeedBox, ToggleBtn2, SpeedBox2, MinOverlay = createUI()
                bindEvents()
            else
                -- Проверяем отдельные элементы
                if not ToggleBtn.Parent then
                    ToggleBtn.Parent = Content
                end
                if not ToggleBtn2.Parent then
                    ToggleBtn2.Parent = Content
                end
                if not SpeedBox.Parent then
                    SpeedBox.Parent = Content
                end
                if not SpeedBox2.Parent then
                    SpeedBox2.Parent = Content
                end
                if not MinBtn.Parent then
                    MinBtn.Parent = Frame
                end
                if not Title.Parent then
                    Title.Parent = Frame
                end
            end
        end
    end)
end

-- Функция для запуска TP Walk 1
local function startTPWalk1(speed)
    tpwalking1 = true
    tpwalkSpeed1 = tonumber(speed) or 0.3
    
    task.spawn(function()
        while tpwalking1 do
            local delta = RunService.Heartbeat:Wait()
            
            local char = player.Character
            local hum = char and char:FindFirstChildWhichIsA("Humanoid")
            
            if char and hum and hum.Parent then
                if hum.MoveDirection.Magnitude > 0 then
                    pcall(function()
                        char:TranslateBy(hum.MoveDirection * tpwalkSpeed1 * delta * 10)
                    end)
                end
            end
        end
    end)
end

-- Функция для запуска TP Walk 2
local function startTPWalk2(speed)
    tpwalking2 = true
    tpwalkSpeed2 = tonumber(speed) or 5
    
    task.spawn(function()
        while tpwalking2 do
            local delta = RunService.Heartbeat:Wait()
            
            local char = player.Character
            local hum = char and char:FindFirstChildWhichIsA("Humanoid")
            
            if char and hum and hum.Parent then
                if hum.MoveDirection.Magnitude > 0 then
                    pcall(function()
                        char:TranslateBy(hum.MoveDirection * tpwalkSpeed2 * delta * 10)
                    end)
                end
            end
        end
    end)
end

local function stopTPWalk1()
    tpwalking1 = false
end

local function stopTPWalk2()
    tpwalking2 = false
end

local function updateButton(button, state, text)
    if state then
        button.Text = "Deactivate" .. (text or "")
        button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        button.Text = "Activate" .. (text or "")
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end

-- Функция для привязки событий
local function bindEvents()
    -- Первая кнопка
    ToggleBtn.MouseButton1Click:Connect(function()
        if tpwalking1 then
            stopTPWalk1()
            updateButton(ToggleBtn, false, " 1")
        else
            local speed = tonumber(SpeedBox.Text)
            if speed and speed > 0 then
                startTPWalk1(speed)
                savedSpeed1 = tostring(speed)
                updateButton(ToggleBtn, true, " 1")
            else
                SpeedBox.Text = savedSpeed1
                updateButton(ToggleBtn, false, " 1")
            end
        end
    end)

    -- Вторая кнопка
    ToggleBtn2.MouseButton1Click:Connect(function()
        if tpwalking2 then
            stopTPWalk2()
            updateButton(ToggleBtn2, false, " 2")
        else
            local speed = tonumber(SpeedBox2.Text)
            if speed and speed > 0 then
                startTPWalk2(speed)
                savedSpeed2 = tostring(speed)
                updateButton(ToggleBtn2, true, " 2")
            else
                SpeedBox2.Text = savedSpeed2
                updateButton(ToggleBtn2, false, " 2")
            end
        end
    end)

    -- Обработчики полей скорости
    SpeedBox.FocusLost:Connect(function()
        local speed = tonumber(SpeedBox.Text)
        if speed and speed > 0 then
            tpwalkSpeed1 = speed
            savedSpeed1 = tostring(speed)
        else
            SpeedBox.Text = savedSpeed1
        end
    end)

    SpeedBox2.FocusLost:Connect(function()
        local speed = tonumber(SpeedBox2.Text)
        if speed and speed > 0 then
            tpwalkSpeed2 = speed
            savedSpeed2 = tostring(speed)
        else
            SpeedBox2.Text = savedSpeed2
        end
    end)

    local minimized = false
    local normalSize = Frame.Size
    local miniSize = UDim2.new(0, 160, 0, 40)
    local lastTween = nil

    local function setMinimized(state)
        if state == nil then minimized = not minimized else minimized = state end
        if minimized then
            MinBtn.Text = "+"
            MinOverlay.Visible = true
            local tween = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = miniSize})
            lastTween = tween
            tween:Play()
            tween.Completed:Connect(function()
                if lastTween == tween and minimized then
                    Content.Visible = false
                end
            end)
        else
            MinBtn.Text = "-"
            Content.Visible = true
            MinOverlay.Visible = false
            local tween = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = normalSize})
            lastTween = tween
            tween:Play()
        end
    end

    MinBtn.MouseButton1Click:Connect(function()
        setMinimized()
    end)

    MinOverlay.MouseButton1Click:Connect(function()
        if minimized then
            setMinimized(false)
        end
    end)
end

-- Привязываем события
bindEvents()

-- Запускаем мониторинг GUI
monitorGUI()

-- Восстанавливаем сохраненные значения
SpeedBox.Text = savedSpeed1
SpeedBox2.Text = savedSpeed2
Content.Visible = true
