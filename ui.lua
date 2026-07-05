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

local function setDefaultPosition(element, parent, nextY)
    element.Position = UDim2.new(0, 10, 0, nextY)
    return nextY + element.Size.Y.Offset + 10
end

function UI.createWindow(title)
    local screenGui = newInstance("ScreenGui", {
        Name = "SimpleUILibrary",
        ResetOnSpawn = false,
    })

    local frame = newInstance("Frame", {
        Name = "Window",
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, -150, 0.5, -100),
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
        nextY = 40,
    }
end

function UI.addButton(window, text, callback)
    local button = newInstance("TextButton", {
        Name = text or "Button",
        Size = UDim2.new(0, 120, 0, 35),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        Text = text or "Button",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        Parent = window.Frame,
    })

    window.nextY = setDefaultPosition(button, window.Frame, window.nextY)

    button.MouseButton1Click:Connect(function()
        if typeof(callback) == "function" then
            callback()
        end
    end)

    table.insert(window.Buttons, button)
    return button
end

function UI.addLabel(window, text)
    local label = newInstance("TextLabel", {
        Name = text or "Label",
        Size = UDim2.new(0, 200, 0, 25),
        BackgroundTransparency = 1,
        Text = text or "Label",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.Frame,
    })

    window.nextY = setDefaultPosition(label, window.Frame, window.nextY)

    table.insert(window.Labels, label)
    return label
end

function UI.addTextBox(window, placeholder, callback)
    local textBox = newInstance("TextBox", {
        Name = "TextBox",
        Size = UDim2.new(0, 200, 0, 30),
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

    window.nextY = setDefaultPosition(textBox, window.Frame, window.nextY)

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

function UI.addSection(window, title)
    local sectionFrame = newInstance("Frame", {
        Name = title or "Section",
        Size = UDim2.new(1, -20, 0, 180),
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
        Labels = {},
        nextY = 10,
    }

    function section:addButton(text, callback)
        return UI.addButton(self, text, callback)
    end

    function section:addLabel(text)
        return UI.addLabel(self, text)
    end

    table.insert(window.Sections, section)
    return section
end

function UI.show(window, parent)
    window.ScreenGui.Parent = parent or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

function UI.hide(window)
    window.ScreenGui.Parent = nil
end

return UI