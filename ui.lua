local UI = {}

local function newInstance(className, properties)
    local instance = Instance.new(className)
    if properties then
        for property, value in pairs(properties) do
            instance[property] = value
        end
    end
    return instance
end

local function setSectionPosition(section, element, size, position)
    if position then
        element.Position = position
    else
        local height = (size and size.Y.Offset) or 35
        element.Position = UDim2.new(0, 10, 0, section.nextY)
        section.nextY = section.nextY + height + 10
    end
end

function UI.createWindow(title, size, position)
    local screenGui = newInstance("ScreenGui", {
        Name = "SimpleUILibrary",
        ResetOnSpawn = false,
    })

    local frame = newInstance("Frame", {
        Name = "Window",
        Size = size or UDim2.new(0, 300, 0, 200),
        Position = position or UDim2.new(0.5, -150, 0.5, -100),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = screenGui,
    })

    local titleLabel = newInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Text = title or "Window",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        Parent = frame,
    })

    return {
        ScreenGui = screenGui,
        Frame = frame,
        TitleLabel = titleLabel,
        Buttons = {},
        Labels = {},
        TextBoxes = {},
        Sections = {},
    }
end

function UI.addButton(window, text, size, position, callback)
    local button = newInstance("TextButton", {
        Name = text or "Button",
        Size = size or UDim2.new(0, 120, 0, 35),
        Position = position or UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        Text = text or "Button",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        Parent = window.Frame,
    })

    button.MouseButton1Click:Connect(function()
        if typeof(callback) == "function" then
            callback()
        end
    end)

    table.insert(window.Buttons, button)
    return button
end

function UI.addLabel(window, text, size, position)
    local label = newInstance("TextLabel", {
        Name = text or "Label",
        Size = size or UDim2.new(0, 200, 0, 25),
        Position = position or UDim2.new(0, 0, 0, 80),
        BackgroundTransparency = 1,
        Text = text or "Label",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.Frame,
    })

    table.insert(window.Labels, label)
    return label
end

function UI.addTextBox(window, placeholder, size, position, callback)
    local textBox = newInstance("TextBox", {
        Name = "TextBox",
        Size = size or UDim2.new(0, 200, 0, 30),
        Position = position or UDim2.new(0, 0, 0, 110),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = placeholder or "Enter text...",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        ClearTextOnFocus = false,
        Parent = window.Frame,
    })

    if typeof(callback) == "function" then
        textBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(textBox.Text)
            end
        end)
    end

    table.insert(window.TextBoxes, textBox)
    return textBox
end

function UI.addSection(window, title, size, position)
    local sectionFrame = newInstance("Frame", {
        Name = title or "Section",
        Size = size or UDim2.new(1, -20, 0, 180),
        Position = position or UDim2.new(0, 10, 0, 120 + #window.Sections * 190),
        BackgroundColor3 = Color3.fromRGB(36, 36, 36),
        BorderSizePixel = 0,
        Parent = window.Frame,
    })

    local titleLabel = newInstance("TextLabel", {
        Name = "SectionTitle",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Text = title or "Section",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
        Parent = sectionFrame,
    })

    local contentFrame = newInstance("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = sectionFrame,
    })

    local section = {
        Frame = sectionFrame,
        TitleLabel = titleLabel,
        Content = contentFrame,
        Buttons = {},
        Toggles = {},
        Sliders = {},
        Labels = {},
        nextY = 10,
    }

    function section:addButton(text, size, position, callback)
        return UI.addSectionButton(self, text, size, position, callback)
    end

    function section:addToggle(text, default, callback, size, position)
        return UI.addSectionToggle(self, text, default, callback, size, position)
    end

    function section:addSlider(text, min, max, default, callback, size, position)
        return UI.addSectionSlider(self, text, min, max, default, callback, size, position)
    end

    function section:addLabel(text, size, position)
        return UI.addSectionLabel(self, text, size, position)
    end

    table.insert(window.Sections, section)
    return section
end

function UI.addSectionLabel(section, text, size, position)
    local label = newInstance("TextLabel", {
        Name = text or "Label",
        Size = size or UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Text = text or "Label",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Content,
    })

    setSectionPosition(section, label, label.Size, position)
    table.insert(section.Labels, label)
    return label
end

function UI.addSectionButton(section, text, size, position, callback)
    local button = newInstance("TextButton", {
        Name = text or "Button",
        Size = size or UDim2.new(1, -20, 0, 35),
        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
        BorderSizePixel = 0,
        Text = text or "Button",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        Parent = section.Content,
    })

    setSectionPosition(section, button, button.Size, position)

    button.MouseButton1Click:Connect(function()
        if typeof(callback) == "function" then
            callback()
        end
    end)

    table.insert(section.Buttons, button)
    return button
end

function UI.addSectionToggle(section, text, default, callback, size, position)
    local state = default == true
    local toggleButton = newInstance("TextButton", {
        Name = text or "Toggle",
        Size = size or UDim2.new(1, -20, 0, 35),
        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
        BorderSizePixel = 0,
        Text = (text or "Toggle") .. ": " .. (state and "On" or "Off"),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        Parent = section.Content,
    })

    setSectionPosition(section, toggleButton, toggleButton.Size, position)

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = (text or "Toggle") .. ": " .. (state and "On" or "Off")
        if typeof(callback) == "function" then
            callback(state)
        end
    end)

    table.insert(section.Toggles, toggleButton)
    return toggleButton
end

function UI.addSectionSlider(section, text, min, max, default, callback, size, position)
    min = min or 0
    max = max or 100
    default = default or min
    local sliderHeight = 60
    local sliderFrame = newInstance("Frame", {
        Name = text or "Slider",
        Size = size or UDim2.new(1, -20, 0, sliderHeight),
        BackgroundColor3 = Color3.fromRGB(55, 55, 55),
        BorderSizePixel = 0,
        Parent = section.Content,
    })

    local label = newInstance("TextLabel", {
        Name = "SliderLabel",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text or "Slider",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = sliderFrame,
    })

    local valueLabel = newInstance("TextLabel", {
        Name = "ValueLabel",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = sliderFrame,
    })

    local track = newInstance("Frame", {
        Name = "Track",
        Size = UDim2.new(1, -20, 0, 12),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = sliderFrame,
    })

    local knob = newInstance("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 16, 1, 0),
        Position = UDim2.new((default - min) / math.max(max - min, 1), 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(170, 170, 170),
        BorderSizePixel = 0,
        Parent = track,
    })

    setSectionPosition(section, sliderFrame, sliderFrame.Size, position)

    local UserInputService = game:GetService("UserInputService")
    local dragging = false

    local function updateValue(inputPositionX)
        local relativeX = math.clamp(inputPositionX - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local percent = relativeX / track.AbsoluteSize.X
        local value = math.floor(min + percent * (max - min) + 0.5)
        knob.Position = UDim2.new(percent, 0, 0, 0)
        valueLabel.Text = tostring(value)
        if typeof(callback) == "function" then
            callback(value)
        end
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateValue(input.Position.X)
        end
    end)

    table.insert(section.Sliders, sliderFrame)
    return sliderFrame
end

function UI.show(window, parent)
    window.ScreenGui.Parent = parent or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

function UI.hide(window)
    window.ScreenGui.Parent = nil
end

return UI
