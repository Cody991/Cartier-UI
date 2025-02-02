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
    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -300, 0.5, -175),
    Size = UDim2.new(0, 600, 0, 350),
    ClipsDescendants = true
})

-- Add Shadow and Rounding
local Corner = Create("UICorner", {
    Parent = MainFrame,
    CornerRadius = UDim.new(0, 8)
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

-- Title Bar
local TitleBar = Create("Frame", {
    Name = "TitleBar",
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 30)
})

Create("UICorner", {
    Parent = TitleBar,
    CornerRadius = UDim.new(0, 8)
})

local Title = Create("TextLabel", {
    Parent = TitleBar,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 10, 0, 0),
    Size = UDim2.new(1, -20, 1, 0),
    Font = Enum.Font.GothamBold,
    Text = "Serenity Hub",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Tab Container
local TabContainer = Create("ScrollingFrame", {
    Name = "TabContainer",
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 30),
    Size = UDim2.new(0, 120, 1, -30),
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0)
})

local TabList = Create("UIListLayout", {
    Parent = TabContainer,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 5)
})

-- Content Container
local ContentContainer = Create("Frame", {
    Name = "ContentContainer",
    Parent = MainFrame,
    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 120, 0, 30),
    Size = UDim2.new(1, -120, 1, -30)
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

-- Toggle GUI Visibility
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Library.ToggleKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
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
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = UDim2.new(1, -10, 0, 30),
        Position = UDim2.new(0, 5, 0, 5),
        Font = Enum.Font.Gotham,
        Text = name,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 12,
        AutoButtonColor = false
    })

    Create("UICorner", {
        Parent = Tab,
        CornerRadius = UDim.new(0, 6)
    })

    local Container = Create("ScrollingFrame", {
        Name = name.."Container",
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(70, 70, 70),
        Visible = false,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    local ElementList = Create("UIListLayout", {
        Parent = Container,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })

    local ElementPadding = Create("UIPadding", {
        Parent = Container,
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        PaddingTop = UDim.new(0, 10)
    })

    Tab.MouseButton1Click:Connect(function()
        for _, t in pairs(Library.Tabs) do
            t.Container.Visible = false
            Tween(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        end
        Container.Visible = true
        Tween(Tab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    end)

    local TabFunctions = {}

    function TabFunctions:CreateSlider(info)
        local min = info.Min or 0
        local max = info.Max or 100
        local default = math.clamp(info.Default or min, min, max)
        
        local Slider = Create("Frame", {
            Name = "Slider",
            Parent = Container,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Size = UDim2.new(1, 0, 0, 50)
        })

        Create("UICorner", {Parent = Slider})

        local Title = Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 5),
            Size = UDim2.new(1, -20, 0, 20),
            Font = Enum.Font.Gotham,
            Text = info.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })

        local SliderBar = Create("Frame", {
            Parent = Slider,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Position = UDim2.new(0, 10, 0, 35),
            Size = UDim2.new(1, -20, 0, 5)
        })

        Create("UICorner", {
            Parent = SliderBar,
            CornerRadius = UDim.new(1, 0)
        })

        local Fill = Create("Frame", {
            Parent = SliderBar,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
        })

        Create("UICorner", {
            Parent = Fill,
            CornerRadius = UDim.new(1, 0)
        })

        local Value = Create("TextLabel", {
            Parent = Slider,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -50, 0, 5),
            Size = UDim2.new(0, 40, 0, 20),
            Font = Enum.Font.Gotham,
            Text = tostring(default),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 12
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
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
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
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
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
