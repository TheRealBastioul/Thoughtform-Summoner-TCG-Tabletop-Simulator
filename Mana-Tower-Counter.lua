
-- Configuration
local objectGUID = "4341d1"  -- Replace with the GUID of your object
local targetZoneGUIDs = {"71b052", "e74dcc", "738978", "58eadf", "05ce7b", "77a3e0", "b63706", "c33457", "6ec46b", "b1cfff", "8b5ef3", "f52c6a", "40f1b9", "2056f8", "7449b0", "00c6b3", "9d9d07", "f514d1", "283226", "efddd3", "a43814", "70a97a", "6fbfa8", "11a90e", "eee1e8", "07cf6b", "f74a0c", "1ea539", "510106", "8ea6ad", "315d49", "64cb57", "419030"}  -- Replace with your array of target zone GUIDs

-- Initialize the counter index
local currentIndex = 1

function moveObjectToIndex(objectGUID, targetZoneIndex)
    print("is it working")
    local object = getObjectFromGUID(objectGUID)
    if object then
        local targetZoneGUID = targetZoneGUIDs[targetZoneIndex]
        if targetZoneGUID then
            local targetZone = getObjectFromGUID(targetZoneGUID)
            if targetZone then
                local targetPosition = targetZone.getPosition()
                object.setPosition({
                    targetPosition.x,
                    targetPosition.y,  -- Adjust the height if needed
                    targetPosition.z
                })
            else
            end
        else
        end
    else
    end
end
-- Function for handling plus button click
function updateCounterDisplay(self)
    -- Update your counter display logic here
    -- Example: Display the counter in the console
    print("Current MANA POOL: " .. currentIndex)

    -- Update the label on the object
    self.editButton({
        index = 2,  -- Assuming it's the third button (indexing starts from 1)
        label = "MANA POOL: " .. currentIndex,
    })
end
-- Function for handling plus button click
function onPlusButtonClick(_, _, _)
    currentIndex = (currentIndex % #targetZoneGUIDs) + 1
    moveObjectToIndex(objectGUID, currentIndex)
    updateCounterDisplay(self)
end
-- Function for handling minus button click
function onMinusButtonClick(_, _, _)
    currentIndex = ((currentIndex - 2 + #targetZoneGUIDs) % #targetZoneGUIDs) + 1
    moveObjectToIndex(objectGUID, currentIndex)
    updateCounterDisplay(self)
end

-- Create buttons on the object this script is embedded in
function createObjectButtons(self)
    if self then
        self.createButton({
            click_function = "onPlusButtonClick",
            function_owner = self,
            label = "+",
            position = {1, 0.1, 0},
            rotation = {0, 0, 0},
            width = 888,
            height = 333,
            font_size = 333,
            color = {87/255, 201/255, 144/255},
        })

        self.createButton({
            click_function = "onMinusButtonClick",
            function_owner = self,
            label = "-",
            position = {-1, 0.1, 0},
            rotation = {0, 0, 0},
            width = 888,
            height = 333,
            font_size = 333,
            color = {163/255, 204/255, 209/255},
        })
         self.createButton({
            click_function = "dummyFunction",
            function_owner = self,
            label = "MANA POOL: " .. currentIndex,
            position = {0, 0.1, 1},
            rotation = {0, 0, 0},
            width = 1,
            height = 1,
            font_size = 300,
            color = {0.33, 0.33, 0.33, 1},  -- Transparent color
            font_color = {1, 1, 1}
        })
    else
    end
end

-- Call the function to create the buttons
createObjectButtons(self)
