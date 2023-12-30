-- Define the scaling factor
local scalingFactor = 3.33
-- Store original scale values for cards
local originalScales = {}

-- Define your specific tag
local specificTag = "Thoughtform"

-- Table to track objects with created buttons
local objectsWithButtons = {}

-- Function to check if a specific tag exists in the component tags
function hasTag(componentTags, targetTag)
    for _, tag in pairs(componentTags) do
        if tag == targetTag then
            return true
        end
    end
    return false
end

-- Function to update counter display
function onUpdateCounterDisplay(obj)
    local currentHP = obj.getVar("currentHP")
    if currentHP ~= nil then
        local buttonIndex = 2
        local button = obj.getButtons()[buttonIndex]

        if button then
            button.label = "HP: " .. currentHP
            obj.editButton({
                index = buttonIndex,
                label = button.label,
            })
        else
        end
    else
    end
end

-- Function to create buttons on object
function onCreateObjectButtons(obj)
    if obj and not objectsWithButtons[obj] then
        obj.createButton({
            click_function = "onPlusButtonClick",
            identifier = _G,
            label = "+",
            position = {0.8, 0.1, 1.8},
            rotation = {0, 0, 0},
            width = 188,
            height = 188,
            font_size = 100,
            color = {0, 0.8, 0},
        })

        obj.createButton({
            click_function = "onMinusButtonClick",
            identifier = _G,
            label = "-",
            position = {-0.8, 0.1, 1.8},
            rotation = {0, 0, 0},
            width = 188,
            height = 188,
            font_size = 100,
            color = {0.8, 0, 0},
        })

        obj.createButton({
            click_function = "onUpdateCounterDisplay",
            identifier = _G,
            label = "HP: " .. obj.getVar("currentHP"),
            position = {0, 0.1, 1.8},
            rotation = {0, 0, 0},
            width = 1,
            height = 1,
            font_size = 188,
            color = {0.33, 0.33, 0.33, 1},
        })

        obj.createButton({
            click_function = "onChangeStall",
            identifier = _G,
            label = "S T A L L",
            label_position = {2, 0.0, 0},
            position = {-1, 1, -1.5},
            rotation = {0, 0, 0},
            width = 188,
            height = 133,
            font_size = 33,
            color = {252/255, 215/255, 3/255, 1},
        })
        obj.createButton({
            click_function = "onEquip",
            identifier = _G,
            label = "N O  E Q U I P",
            label_position = {2, 0.0, 0},
            position = {0.5, 1, -1.5},
            rotation = {0, 0, 0},
            width = 555,
            height = 133,
            font_size = 33,
            font_color = {1, 1, 1},
            color = {0.2, 0.2, 0.2, 1},
        })

        if obj.getVar("equipIndex") == nil then
            obj.setVar("equipIndex", 1)
        end
        if obj.getVar("stall") == nil then
            obj.setVar("stall", false)
        end

        -- Mark the object as having buttons created
        objectsWithButtons[obj] = true
    end
end
-- Function called when object enters a zone
function onObjectEnterZone(zone, obj)
    local componentTags = obj.getTags()
    -- Check if the entered object is a deck or a card
    if (obj.tag == "Deck" or obj.tag == "Card" or obj.tag == "Token") and hasTag(zone.getTags(), "Table") then
        -- Store the original scale
        originalScales[obj] = obj.getScale()

        -- Scale the object
        local scale = {x = scalingFactor, y = 1, z = scalingFactor}
        obj.setScale(scale)
    end

    -- Check if the entered object has the specific tag for creating buttons
    if hasTag(componentTags, specificTag) then
        if obj.getVar("currentHP") == nil then
            obj.setVar("currentHP", 0)
        end
        onCreateObjectButtons(obj)
    end

    -- Ensure the object has the "player_color" variable set
    local player_color = obj.getVar("player_color")

    if player_color then
        -- Check if the entered zone is one of the target zones
        if isTargetZone(zone) then
            if string.lower(player_color) == "red" then
                zone.setRotation({0, 180, 0})
             
            elseif string.lower(player_color) == "blue" then
                zone.setRotation({0, 0, 0})
             
            end
        end
    end
end

-- Click functions
function onPlusButtonClick(obj)
    local currentHP = obj.getVar("currentHP") or 0
    obj.setVar("currentHP", currentHP + 1)
    onUpdateCounterDisplay(obj)
end

function onMinusButtonClick(obj)
    local currentHP = obj.getVar("currentHP") or 0
    obj.setVar("currentHP", currentHP - 1)
    onUpdateCounterDisplay(obj)
end
function onEquip(obj)
    local equipColor = {
        {49/255, 144/255, 76/255},
        {92/255, 49/255, 144/255},
        {202/255, 130/255, 27/255},
        {0.2, 0.2, 0.2, 1}
    }
    local equipIndex = obj.getVar("equipIndex") or 1
    print(equipIndex)
    if equipIndex < 4 then
        print(equipColor[equipIndex])
        obj.editButton({
            label = "E Q U I P P E D",
            index = 4,
            color = equipColor[equipIndex]
        })
        equipIndex = equipIndex + 1
    elseif equipIndex == 4 then
        equipIndex = 1
        obj.editButton({
            index = 4,
            label = "N O  E Q U I P",
            color = equipColor[4]
        })
    end
    obj.setVar("equipIndex", equipIndex)
end

        
function onChangeStall(obj)
    local stall = obj.getVar("stall") or false

    if stall then
        obj.editButton({
            index = 3,
            label = "S T A L L",
            color = {252/255, 215/255, 3/255},
        })
        obj.setVar("stall", false)
    else
        obj.editButton({
            index = 3,
            label = "R E A D Y",
            color = {90/255, 252/255, 3/255},
        })
        obj.setVar("stall", true)
    end
end
-- Function called when object leaves a zone
function onObjectLeaveZone(zone, obj)
    local componentTags = obj.getTags()

    -- Check if the left object is a deck or a card
    if (obj.tag == "Deck" or obj.tag == "Card" or obj.tag == "Token") and hasTag(zone.getTags(), "Table") then
        -- Check if the object was scaled before
        if originalScales[obj] then
            -- Restore the original scale
            obj.setScale(originalScales[obj])
            -- Remove the entry from the originalScales table
            originalScales[obj] = nil
        end
    end

    -- Check if the left object has the specific tag for creating buttons
    if hasTag(componentTags, specificTag) then
        -- Implement any additional logic for when an object with the specific tag leaves the zone
        -- For example, you might want to remove buttons or perform other actions.
    end
end

-- Replace 'your_object_guid_here' with the actual GUID of your object
-- Specify the GUIDs of the zones where the script should take effect
local targetZoneGUIDs = {"4a7bd4", "9c76a9", "46328c", "54c6cf", "d219c0", "b67d21", "493653", "447114", "13e7b3", "3a4fc9", "fd5558"}

function isTargetZone(zone)
    -- Check if the given zone is in the target zones array
    for _, targetGUID in pairs(targetZoneGUIDs) do
        if zone.guid == targetGUID then
            return true
        end
    end
    return false
end


local numRows = 3
local numCols = 5
local spacing = 3.33 -- Adjust the spacing between duplicates
local yOffset = 0

local componentTags = {
    "r5", "r4", "r3", "r2", "r1",
    "r10", "r9", "r8", "r7", "r6",
    "r15", "r14", "r13", "r12", "r11"
}

local duplicatesTable = {}
function onObjectPickUp(player_color, picked_up_object)
    picked_up_object.setVar("player_color", player_color)

    -- Check if the object is face up
    local rotation = picked_up_object.getRotation()
    local threshold = 5  -- Adjust the threshold as needed
    
    local isFaceUp = math.abs(rotation.z) < threshold
    


    if not isFaceUp then
        return
    end

    local objectTags = picked_up_object.getTags()

    -- Define a 2D boolean matrix to represent cell selection
    local cellSelection = {}

    for i = 1, numRows do
        cellSelection[i] = {}
        for j = 1, numCols do
            local tag = componentTags[(i - 1) * numCols + j]
            cellSelection[i][j] = hasTag(objectTags, tag)
        end
    end

    -- Check if the object has any of the tags in componentTags
    local initializeScript = false
    for i = 1, numRows do
        for j = 1, numCols do
            if cellSelection[i][j] then
                initializeScript = true
                break
            end
        end
        if initializeScript then
            break
        end
    end

    if initializeScript then
        local pos = picked_up_object.getPosition()

        duplicatesTable = {}

        for i = 1, numRows do
            for j = 1, numCols do
                if cellSelection[i][j] then
                    local offsetX = (j - math.ceil(numCols / 2)) * spacing * 0.78
                    local offsetZ = (i - math.ceil(numRows / 2)) * spacing * 1.15

                    local duplicate, offset = createDuplicate(picked_up_object, pos.x + offsetX, pos.y + yOffset, pos.z + offsetZ, spacing)
                    table.insert(duplicatesTable, { duplicate = duplicate, offset = offset, originalObject = picked_up_object })
                end
            end
        end
    end
end


function onObjectDrop(player_color, dropped_object)
    dropped_object.setVar("player_color", player_color)
    
    local isDuplicate = dropped_object.getVar("isDuplicate")
    if not isDuplicate then
        destroyDuplicates()
    end
end

function onCollisionEnter(info)
    if info.collision_object.tag == "Deck" then
        destroyDuplicates()
    end
end


function onUpdate()
    if duplicatesTable and #duplicatesTable > 0 then
        updateDuplicatesPosition()
    end
end

function updateDuplicatesPosition()
    local originalObject = duplicatesTable[1].originalObject
    local pos = originalObject.getPosition()
    local rotation = originalObject.getRotation()

    for _, entry in ipairs(duplicatesTable) do
        local duplicate = entry.duplicate
        local offset = entry.offset

        -- Rotate the offset vector based on the original object's rotation
        local rotatedOffset = rotateVector(offset, rotation)

        local newPos = Vector(pos.x + rotatedOffset.x, pos.y + rotatedOffset.y, pos.z + rotatedOffset.z)
        duplicate.setPositionSmooth(newPos, false, true)

        -- Set the rotation of the duplicate to match the original object
        duplicate.setRotation(rotation)
    end
end

function rotateVector(vector, rotation)
    local angle = -math.rad(rotation.y) -- Use the negative of the rotation angle
    local x = vector.x * math.cos(angle) - vector.z * math.sin(angle)
    local z = vector.x * math.sin(angle) + vector.z * math.cos(angle)

    return { x = x, y = vector.y, z = z }
end

function createDuplicate(originalObject, x, y, z, scaleFactor)
    local rangeind = getObjectFromGUID("193593")
    local duplicate = rangeind.clone({ position = { x, y, z} })
    duplicate.setName(rangeind.getName() .. "_duplicate")
    duplicate.setLock(true)
    duplicate.setVar("isDuplicate", true)

    local originalPos = originalObject.getPosition()

    local offset = {
        x = (x - originalPos.x) * scaleFactor,
        y = (y - originalPos.y) * scaleFactor,
        z = (z - originalPos.z) * scaleFactor
    }

    return duplicate, offset
end

function destroyDuplicates()
    if duplicatesTable then
        for _, entry in ipairs(duplicatesTable) do
            entry.duplicate.destroy()
        end

        duplicatesTable = {}
    end
end
