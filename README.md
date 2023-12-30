# Tabletop Simulator Lua Script

## Introduction

This Lua script enhances Tabletop Simulator's functionality for objects tagged with "Thoughtform." It introduces features such as automatic scaling, health point management, stall and equip controls, zone-based rotations, and duplicate placement. Visit [dimensionbeyond.space](https://dimensionbeyond.space) for more insights.

## Features

### Scaling Objects
Objects tagged "Thoughtform" automatically scale up for improved visibility on the table.

### Health Points Counter
Buttons on "Thoughtform" objects enable easy adjustment and display of health points.

### Stall and Equip Buttons
Toggle between "Ready" and "Stall" states, manage equipment, and cycle through different equipment states with dedicated buttons.

### Zone Rotation
Objects align their rotation based on player colors when entering specific zones.

### Duplicate Placement
Pick up objects with specific component tags face up, and the script creates duplicates arranged in a grid around the original object's position. Dropping the object destroys the duplicates.

## Usage

### Scaling
Place objects with the "Thoughtform" tag on the table for automatic scaling.

### Health Points
Click the plus and minus buttons to adjust health points. The "HP" button displays current health points.

### Stall and Equip
Use the "S T A L L" button to toggle between "Ready" and "Stall" states. The "N O E Q U I P" button manages equipment, cycling through different states.

### Zone Rotation
Objects rotate based on their player color when entering specific zones.

### Duplicate Placement
Pick up objects face up with specific component tags to create duplicates around the original position. Dropping the object destroys the duplicates.

## Functions

### Health Points Functions
- `onPlusButtonClick(obj)`: Increase health points.
- `onMinusButtonClick(obj)`: Decrease health points.
- `onUpdateCounterDisplay(obj)`: Update health points display.

### Stall and Equip Functions
- `onChangeStall(obj)`: Toggle between "Ready" and "Stall" states.
- `onEquip(obj)`: Cycle through different equipment states.

### Duplicate Placement Functions
- `onObjectPickUp(player_color, picked_up_object)`: Initialize the script when an object is picked up.
- `onObjectDrop(player_color, dropped_object)`: Destroy duplicates when the object is dropped.
- `onCollisionEnter(info)`: Destroy duplicates when colliding with a deck.

### Helper Functions
- `isTargetZone(zone)`: Check if a zone is a target zone for rotation.
- `rotateVector(vector, rotation)`: Rotate a vector based on a given rotation.
- `createDuplicate(originalObject, x, y, z, scaleFactor)`: Create a duplicate of an object at a specified position.
- `destroyDuplicates()`: Destroy all duplicates.

### Other Functions
- `onObjectEnterZone(zone, obj)`: Perform actions when an object enters a zone.
- `onObjectLeaveZone(zone, obj)`: Perform actions when an object leaves a zone.
- `onUpdate()`: Update duplicate positions.

## Configuration

The script includes configurable parameters like scaling factors, button positions, and zone rotations.

## License

This script is provided under an open-source license. Feel free to modify and distribute it according to the terms of the license.

## Feedback and Contributions

Your feedback and contributions are welcomed! If you encounter issues or have suggestions for improvements, please open an issue or submit a pull request on the [GitHub repository](https://github.com/TheRealBastioul/Thoughtform-Summoner-TCG-Tabletop-Simulator/).

Enjoy using this Tabletop Simulator Lua script!
