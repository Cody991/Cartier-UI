local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Tabs = {},
    CurrentTab = nil,
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift
}

-- Utility Functions
local function Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Tween(object, info, properties)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

-- Create Base GUI
local ScreenGui = Create("ScreenGui", {
    Name = "SerenityHub",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
})

local MainFrame = Create("Frame", {
    Name = "MainFrame", 
    Parent = ScreenGui,
    BackgroundColor3 = Color3.fromRGB(25, 25, 30),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -300, 0.5, -175),
    Size = UDim2.new(0, 600, 0, 350),
    ClipsDescendants = true
})

local Corner = Create("UICorner", {
    Parent = MainFrame,
    CornerRadius = UDim.new(0, 10)
})

local Blur = Create("BlurEffect", {
    Parent = MainFrame,
    Size = 10
})

local Shadow = Create("ImageLabel", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, -15, 0, -15),
    Size = UDim2.new(1, 30, 1, 30),
    Image = "rbxassetid://5554236805",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.6,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(23, 23, 277, 277),
    SliceScale = 1
})

-- Title Bar with gradient
local TitleBar = Create("Frame", {
    Name = "TitleBar",
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 35)
})

local TitleGradient = Create("UIGradient", {
    Parent = TitleBar,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }),
    Rotation = 90
})

Create("UICorner", {
    Parent = TitleBar,
    CornerRadius = UDim.new(0, 10)
})

local Title = Create("TextLabel", {
    Parent = TitleBar,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -30, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "Serenity Hub",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Add a close button
local CloseButton = Create("TextButton", {
    Parent = TitleBar,
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -30, 0, 0),
    Size = UDim2.new(0, 30, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 20
})

-- Tab Container with gradient
local TabContainer = Create("ScrollingFrame", {
    Name = "TabContainer",
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 35),
    Size = UDim2.new(0, 150, 1, -35),
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
    CanvasSize = UDim2.new(0, 0, 0, 0)
})

local TabGradient = Create("UIGradient", {
    Parent = TabContainer,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }),
    Rotation = 90
})

local TabList = Create("UIListLayout", {
    Parent = TabContainer,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8)
})

local TabPadding = Create("UIPadding", {
    Parent = TabContainer,
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8)
})

-- Content Container
local ContentContainer = Create("Frame", {
    Name = "ContentContainer",
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 150, 0, 35),
    Size = UDim2.new(1, -150, 1, -35)
})

local ContentGradient = Create("UIGradient", {
    Parent = ContentContainer,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    }),
    Rotation = 90
})

-- Make GUI Draggable
local dragging
local dragInput
local dragStart
local startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

TitleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle GUI Visibility with smooth fade
local function toggleUI()
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if ScreenGui.Enabled then
        -- Fade out
        local fadeTween = Tween(MainFrame, tweenInfo, {BackgroundTransparency = 1})
        for _, obj in pairs(MainFrame:GetDescendants()) do
            if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
                Tween(obj, tweenInfo, {
                    BackgroundTransparency = 1,
                    TextTransparency = 1,
                    ImageTransparency = 1
                })
            end
        end
        fadeTween.Completed:Wait()
        ScreenGui.Enabled = false
    else
        -- Fade in
        ScreenGui.Enabled = true
        MainFrame.BackgroundTransparency = 1
        for _, obj in pairs(MainFrame:GetDescendants()) do
            if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
                obj.BackgroundTransparency = 1
                obj.TextTransparency = 1
                obj.ImageTransparency = 1
            end
        end
        
        Tween(MainFrame, tweenInfo, {BackgroundTransparency = 0})
        for _, obj in pairs(MainFrame:GetDescendants()) do
            if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("ImageLabel") then
                Tween(obj, tweenInfo, {
                    BackgroundTransparency = 0,
                    TextTransparency = 0,
                    ImageTransparency = obj:GetAttribute("DefaultTransparency") or 0
                })
            end
        end
    end
end

-- Update toggle key connection
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Library.ToggleKey then
        toggleUI()
    end
end)

-- Add close button functionality
CloseButton.MouseButton1Click:Connect(function()
    toggleUI()
end)

function Library:CreateWindow(info)
    Title.Text = info.Name or "Serenity Hub"
    return self
end

function Library:CreateTab(name, icon)
    local Tab = Create("TextButton", {
        Name = name,
        Parent = TabContainer,
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        Size = UDim2.new(1, 0, 0, 35),
        Font = Enum.Font.GothamSemibold,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        AutoButtonColor = false
    })

    Create("UICorner", {
        Parent = Tab,
        CornerRadius = UDim.new(0, 8)
    })

    if icon then
        local Icon = Create("ImageLabel", {
            Parent = Tab,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = "rbxassetid://" .. icon,
            ImageColor3 = Color3.fromRGB(255, 255, 255)
        })
        Tab.TextXAlignment = Enum.TextXAlignment.Right
        Tab.Text = "  " .. name
    end

    local Container = Create("ScrollingFrame", {
        Name = name.."Container",
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(75, 75, 75),
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    local ElementList = Create("UIListLayout", {
        Parent = Container,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8)
    })

    local ElementPadding = Create("UIPadding", {
        Parent = Container,
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        PaddingTop = UDim.new(0, 15)
    })

    Tab.MouseButton1Click:Connect(function()
        for _, t in pairs(Library.Tabs) do
            t.Container.Visible = false
            Tween(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
        end
        Container.Visible = true
        Tween(Tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
    end)

    local TabFunctions = {}

    function TabFunctions:CreateSlider(info)
        local min = info.Range[1] or 0
        local max = info.Range[2] or 100
        local default = math.clamp(info.CurrentValue or min, min, max)
        
        local Slider = Create("Frame", {
            Name = "Slider",
            Parent = Container,
            BackgroundColor3 = Color3.fromRGB(35, 35, 40),
            Size = UDim2.new(1, 0, 0, 55)
        })

        Create("UICorner", {
            Parent = Slider,
            CornerRadius = UDim.new(0, 8)
        })

        local Title = Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 8),
            Size = UDim2.new(1, -24, 0, 20),
            Font = Enum.Font.GothamSemibold,
            Text = info.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local SliderBar = Create("Frame", {
            Parent = Slider,
            BackgroundColor3 = Color3.fromRGB(45, 45, 50),
            Position = UDim2.new(0, 12, 0, 38),
            Size = UDim2.new(1, -24, 0, 6)
        })

        Create("UICorner", {
            Parent = SliderBar,
            CornerRadius = UDim.new(1, 0)
        })

        local Fill = Create("Frame", {
            Parent = SliderBar,
            BackgroundColor3 = Color3.fromRGB(65, 140, 240), -- Modern blue color
            Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        })

        Create("UICorner", {
            Parent = Fill,
            CornerRadius = UDim.new(1, 0)
        })

        local Value = Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -62, 0, 8),
            Size = UDim2.new(0, 50, 0, 20),
            Font = Enum.Font.GothamSemibold,
            Text = tostring(default),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14
        })

        local function update(input)
            local pos = UDim2.new(math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
            Fill.Size = pos
            local value = math.floor(min + ((max - min) * pos.X.Scale))
            Value.Text = tostring(value)
            info.Callback(value)
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                update(input)
                local connection
                connection = UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end

    function TabFunctions:CreateToggle(info)
        local Toggle = Create("Frame", {
            Name = "Toggle",
            Parent = Container,
            BackgroundColor3 = Color3.fromRGB(35, 35, 40),
            Size = UDim2.new(1, 0, 0, 35)
        })

        Create("UICorner", {Parent = Toggle})

        local Title = Create("TextLabel", {
            Parent = Toggle,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -50, 1, 0),
            Font = Enum.Font.Gotham,
            Text = info.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local Switch = Create("TextButton", {
            Parent = Toggle,
            BackgroundColor3 = Color3.fromRGB(45, 45, 50),
            Position = UDim2.new(1, -40, 0.5, -10),
            Size = UDim2.new(0, 30, 0, 20),
            Text = "",
            AutoButtonColor = false
        })

        Create("UICorner", {
            Parent = Switch,
            CornerRadius = UDim.new(1, 0)
        })

        local Circle = Create("Frame", {
            Parent = Switch,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(0, 2, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16)
        })

        Create("UICorner", {
            Parent = Circle,
            CornerRadius = UDim.new(1, 0)
        })

        local toggled = info.Default or false
        local function updateToggle()
            toggled = not toggled
            Tween(Circle, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
            Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)})
            info.Callback(toggled)
        end

        Switch.MouseButton1Click:Connect(updateToggle)
        if toggled then
            updateToggle()
        end
    end

    Library.Tabs[name] = {
        Button = Tab,
        Container = Container
    }

    if not Library.CurrentTab then
        Library.CurrentTab = name
        Container.Visible = true
        Tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end

    return TabFunctions
end

return Library
