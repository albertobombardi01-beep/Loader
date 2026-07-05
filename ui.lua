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

function UI.show(window, parent)
    window.ScreenGui.Parent = parent or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

function UI.hide(window)
    window.ScreenGui.Parent = nil
end

return UI
