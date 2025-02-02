local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {
    Tabs = {},
    CurrentTab = nil,
    Flags = {},
    ToggleKey = Enum.KeyCode.RightShift
}

-- Theme configuration for a modern design
local Theme = {
    Colors = {
        DarkBg    = Color3.fromRGB(20, 20, 25),
        LightBg   = Color3.fromRGB(28, 28, 30),
        TitleBar  = Color3.fromRGB(25, 25, 30),
        Accent    = Color3.fromRGB(65, 140, 240),
        TabBg     = Color3.fromRGB(30, 30, 35),
        TabActive = Color3.fromRGB(50, 50, 50),
        SliderBg  = Color3.fromRGB(40, 40, 45),
        ToggleBg  = Color3.fromRGB(30, 30, 35),
        SwitchOff = Color3.fromRGB(30, 30, 30),
        SwitchOn  = Color3.fromRGB(60, 60, 60)
    },
    CornerRadius = 10,
    TweenTime = 0.3
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function Tween(object, tweenInfo, properties)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Helper to check if an instance is a UI element we want to tween
local function isUIElement(obj)
    return obj:IsA("Frame") 
        or obj:IsA("TextLabel") 
        or obj:IsA("TextButton") 
        or obj:IsA("ImageLabel") 
        or obj:IsA("ImageButton")
        or obj:IsA("ScrollingFrame")
        or obj:IsA("UIStroke")
end

-- Forward declarations for UI elements used in toggleUI
local ScreenGui, MainFrame

-- Simple toggle function
local function toggleUI()
    ScreenGui.Enabled = not ScreenGui.Enabled
end

-- Create Base GUI with a modern design
ScreenGui = Create("ScreenGui", {
    Name = "SerenityHub",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Enabled = true -- Start visible
})

MainFrame = Create("Frame", {
    Name = "MainFrame", 
    Parent = ScreenGui,
    BackgroundColor3 = Theme.Colors.DarkBg,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -325, 0.5, -200),
    Size = UDim2.new(0, 650, 0, 400),
    ClipsDescendants = true
})

-- Add modern rounded corners and an optional accent outline
local Corner = Create("UICorner", {
    Parent = MainFrame,
    CornerRadius = UDim.new(0, Theme.CornerRadius)
})
local Stroke = Create("UIStroke", {
    Parent = MainFrame,
    Color = Theme.Colors.Accent,
    Transparency = 0.85,
    Thickness = 2
})

-- Add a sleek shadow effect
local Shadow = Create("ImageLabel", {
    Parent = MainFrame,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, -15, 0, -15),
    Size = UDim2.new(1, 30, 1, 30),
    Image = "rbxassetid://5554236805",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(23, 23, 277, 277),
    SliceScale = 1
})

-- Modern title bar with accent color and refined design
local TitleBar = Create("Frame", {
    Name = "TitleBar",
    Parent = MainFrame,
    BackgroundColor3 = Theme.Colors.TitleBar,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 40)
})
local TitleBarCorner = Create("UICorner", {
    Parent = TitleBar,
    CornerRadius = UDim.new(0, Theme.CornerRadius)
})
local AccentLine = Create("Frame", {
    Parent = TitleBar,
    BackgroundColor3 = Theme.Colors.Accent,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
    Transparency = 0.7
})
local Title = Create("TextLabel", {
    Parent = TitleBar,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -30, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "Serenity Hub",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})
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

-- Connect close button
CloseButton.MouseButton1Click:Connect(toggleUI)

-- Connect toggle key (Right Shift)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Library.ToggleKey then
        toggleUI()
    end
end)

-- Modern tab container
local TabContainer = Create("ScrollingFrame", {
    Name = "TabContainer",
    Parent = MainFrame,
    BackgroundColor3 = Theme.Colors.TitleBar,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 40),
    Size = UDim2.new(0, 160, 1, -40),
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = Theme.Colors.Accent,
    CanvasSize = UDim2.new(0, 0, 0, 0)
})
local TabGradient = Create("UIGradient", {
    Parent = TabContainer,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Colors.TabBg),
        ColorSequenceKeypoint.new(1, Theme.Colors.DarkBg)
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
local ContentContainer = Create("ScrollingFrame", {
    Name = "ContentContainer",
    Parent = MainFrame,
    BackgroundColor3 = Theme.Colors.DarkBg,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 160, 0, 40),
    Size = UDim2.new(1, -160, 1, -40),
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Theme.Colors.Accent,
    Visible = false,
    CanvasSize = UDim2.new(0, 0, 0, 0)
})
local ContentGradient = Create("UIGradient", {
    Parent = ContentContainer,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    }),
    Rotation = 90
})

-- Make GUI Draggable with smooth movement
local dragging, dragInput, dragStart, startPos
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

function Library:CreateWindow(info)
    Title.Text = info.Name or "Serenity Hub"
    return self
end

function Library:CreateTab(name, icon)
    local Tab = Create("TextButton", {
        Name = name,
        Parent = TabContainer,
        BackgroundColor3 = Theme.Colors.TabBg,
        Size = UDim2.new(1, -16, 0, 40),
        Position = UDim2.new(0, 8, 0, 5),
        Font = Enum.Font.GothamBold,
        Text = "  " .. name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })
    local TabCorner = Create("UICorner", {
        Parent = Tab,
        CornerRadius = UDim.new(0, Theme.CornerRadius - 2)
    })
    local Hover = Create("Frame", {
        Parent = Tab,
        BackgroundColor3 = Theme.Colors.LightBg,
        BackgroundTransparency = 0.9,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false
    })
    local HoverCorner = Create("UICorner", {
        Parent = Hover,
        CornerRadius = UDim.new(0, Theme.CornerRadius - 2)
    })
    local Selection = Create("Frame", {
        Parent = Tab,
        BackgroundColor3 = Theme.Colors.Accent,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 3, 1, 0),
        Visible = false
    })
    local SelectionCorner = Create("UICorner", {
        Parent = Selection,
        CornerRadius = UDim.new(0, 2)
    })
    local Container = Create("ScrollingFrame", {
        Name = name .. "Container",
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Colors.Accent,
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
            Tween(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Colors.TabBg})
        end
        Container.Visible = true
        Tween(Tab, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Colors.TabActive})
    end)

    local TabFunctions = {}

    function TabFunctions:CreateSlider(info)
        local Slider = Create("Frame", {
            Name = "Slider",
            Parent = Container,
            BackgroundColor3 = Theme.Colors.SliderBg,
            Size = UDim2.new(1, -20, 0, 65),
            Position = UDim2.new(0, 10, 0, 5)
        })
        local SliderCorner = Create("UICorner", {
            Parent = Slider,
            CornerRadius = UDim.new(0, Theme.CornerRadius - 2)
        })
        local Title = Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 8),
            Size = UDim2.new(1, -24, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = info.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local ValueDisplay = Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -55, 0, 8),
            Size = UDim2.new(0, 45, 0, 20),
            Font = Enum.Font.GothamBold,
            Text = tostring(info.CurrentValue),
            TextColor3 = Theme.Colors.Accent,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Right
        })
        local SliderBar = Create("Frame", {
            Parent = Slider,
            BackgroundColor3 = Theme.Colors.SliderBg,
            Position = UDim2.new(0, 12, 0, 40),
            Size = UDim2.new(1, -24, 0, 6)
        })
        local SliderBarCorner = Create("UICorner", {
            Parent = SliderBar,
            CornerRadius = UDim.new(1, 0)
        })
        local Fill = Create("Frame", {
            Parent = SliderBar,
            BackgroundColor3 = Theme.Colors.Accent,
            Size = UDim2.new(0.5, 0, 1, 0)
        })
        local FillCorner = Create("UICorner", {
            Parent = Fill,
            CornerRadius = UDim.new(1, 0)
        })
        local Hover = Create("Frame", {
            Parent = Slider,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })
        local HoverCorner = Create("UICorner", {
            Parent = Hover,
            CornerRadius = UDim.new(0, Theme.CornerRadius - 2)
        })

        local min = info.Range[1] or 0
        local max = info.Range[2] or 100
        local default = math.clamp(info.CurrentValue or min, min, max)
        
        local function update(input)
            local posX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(posX, 0, 1, 0)
            local value = math.floor(min + ((max - min) * posX))
            ValueDisplay.Text = tostring(value)
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
            BackgroundColor3 = Theme.Colors.ToggleBg,
            Size = UDim2.new(1, -20, 0, 50),
            Position = UDim2.new(0, 10, 0, 5)
        })
        local ToggleCorner = Create("UICorner", {
            Parent = Toggle,
            CornerRadius = UDim.new(0, Theme.CornerRadius - 2)
        })
        local Title = Create("TextLabel", {
            Parent = Toggle,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            Size = UDim2.new(1, -70, 1, 0),
            Font = Enum.Font.GothamBold,
            Text = info.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        local Switch = Create("TextButton", {
            Parent = Toggle,
            BackgroundColor3 = Color3.fromRGB(40, 40, 45),
            Position = UDim2.new(1, -52, 0.5, -10),
            Size = UDim2.new(0, 40, 0, 20),
            Text = "",
            AutoButtonColor = false
        })
        local SwitchCorner = Create("UICorner", {
            Parent = Switch,
            CornerRadius = UDim.new(1, 0)
        })
        local Circle = Create("Frame", {
            Parent = Switch,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(0, 2, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16)
        })
        local CircleCorner = Create("UICorner", {
            Parent = Circle,
            CornerRadius = UDim.new(1, 0)
        })
        local Hover = Create("Frame", {
            Parent = Toggle,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.9,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })
        local HoverCorner = Create("UICorner", {
            Parent = Hover,
            CornerRadius = UDim.new(0, Theme.CornerRadius - 2)
        })

        local toggled = info.Default or false
        local function updateToggle()
            toggled = not toggled
            local targetPos = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Tween(Circle, TweenInfo.new(0.2), {Position = targetPos})
            local targetColor = toggled and Theme.Colors.SwitchOn or Theme.Colors.SwitchOff
            Tween(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
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
        Tab.BackgroundColor3 = Theme.Colors.TabActive
    end

    return TabFunctions
end

return Library
