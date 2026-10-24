// ==========================================
// PARAMETRIC 3D-PRINTABLE TINY HOUSE PROJECT
// Units: Millimeters (mm)
// ==========================================

// --- Parameters ---
house_width  = 100; // X axis
house_length = 150; // Y axis
wall_height  = 70;  // Z axis wall height
wall_thickness = 4; // Optimized for 0.4mm nozzle (multiple perimeters)
roof_pitch_height = 40; // Height of the gable roof peak

// Door & Window toggles/dimensions
has_door = true;
door_width = 30;
door_height = 50;

has_window = true;
window_width = 25;
window_height = 25;

// --- Module: Main Shell ---
module house_shell() {
    difference() {
        // Outer Hull (Walls + Roof)
        union() {
            // Main rectangular body
            cube([house_width, house_length, wall_height]);
            
            // Gable Roof
            translate([0, 0, wall_height])
            polyhedron(
                points = [
                    [0, 0, 0],                                    // 0: Front-Left base
                    [house_width, 0, 0],                          // 1: Front-Right base
                    [house_width, house_length, 0],               // 2: Back-Right base
                    [0, house_length, 0],                         // 3: Back-Left base
                    [0, 0, roof_pitch_height],                    // 4: Front ridge-left peak
                    [house_width, 0, roof_pitch_height],          // 5: Front ridge-right peak
                    [house_width, house_length, roof_pitch_height], // 6: Back ridge-right peak
                    [0, house_length, roof_pitch_height]          // 7: Back ridge-left peak
                ],
                faces = [
                    [0, 1, 5, 4], // Front gable
                    [1, 2, 6, 5], // Right roof slope
                    [2, 3, 7, 6], // Back gable
                    [3, 0, 4, 7], // Left roof slope
                    [4, 5, 6, 7], // Ridge peak
                    [3, 2, 1, 0]  // Base (floor underside)
                ]
            );
        }
        
        // Inner Cavity (Hollowing out the house)
        translate([wall_thickness, wall_thickness, -1])
        union() {
            // Hollow body
            cube([
                house_width - (wall_thickness * 2), 
                house_length - (wall_thickness * 2), 
                wall_height + 1
            ]);
            
            // Hollow roof cavity (matching pitch slope)
            translate([0, 0, wall_height])
            hull() {
                translate([wall_thickness, wall_thickness, 0])
                cube([house_width - (wall_thickness * 2), house_length - (wall_thickness * 2), 0.1]);
                
                translate([house_width/2, wall_thickness, roof_pitch_height - wall_thickness])
                cube([0.1, house_length - (wall_thickness * 2), 0.1]);
            }
        }
        
        // --- Openings: Door ---
        if (has_door) {
            translate([(house_width / 2) - (door_width / 2), -1, 0])
            cube([door_width, wall_thickness + 2, door_height]);
        }
        
        // --- Openings: Windows (Side Walls) ---
        if (has_window) {
            // Left Window
            translate([-1, (house_length / 2) - (window_width / 2), wall_height / 2])
            cube([wall_thickness + 2, window_width, window_height]);
            
            // Right Window
            translate([house_width - wall_thickness - 1, (house_length / 2) - (window_width / 2), wall_height / 2])
            cube([wall_thickness + 2, window_width, window_height]);
        }
    }
}

// --- Module: Interlocking Base Flange (for multi-part printing) ---
module base_alignment_pins() {
    // Adds small alignment ridges on the bottom floor edge for modular building plates
    // (Optional use if splitting model into halves)
    interim = 2;
}

// --- Render Final Object ---
// Rotate or split here if printing in halves (e.g., slicing down the Y-axis)
house_shell();
