$fn = 64;

// ============================================================================
// dimensions
// ============================================================================

shelf_depth = 18;
shelf_width = 191.4;
shelf_margin = 5;
box_height = 25;


outer_height = 190; // altura
outer_width = shelf_width + (shelf_margin*2); // largura
outer_depth = 20; // espessura


pin_diameter = outer_depth / 2;
pin_height = 5;
pin_gap = 0.5;

// =========================================================================
// Pins
// =========================================================================

module round_pin() {
    diameter = pin_diameter;
    difference() {
        translate([diameter/2,0,0]) rotate([0,90,90]) cylinder(d = diameter, h = diameter);
        
        translate([0,0,-diameter/2]) cube([diameter, diameter, diameter/2]);
    }
}


module round_pin_hole() {
    pd = pin_diameter + pin_gap;    
    difference() {
        translate([pd/2,0,0]) rotate([0,90,90]) cylinder(d=pd, h=pd);
        translate([0,0,-(pd/2)]) cube([pd, pd, pd/2]);
    }    
}


// =========================================================================
// Test plates
// =========================================================================

module test_plate() {

    plate_width = 60;
    plate_depth = 20;

    difference() {
        union(){
            translate([0,0,0]) cube([plate_width, plate_depth, 10], false);
            translate([10, plate_depth/2, 10]) round_pin();
            translate([10+pin_diameter+20, plate_depth/2, 10]) round_pin();
        }

        translate([10, plate_depth/2, 0]) round_pin_hole();
        translate([10+pin_diameter+20, plate_depth/2, 0]) round_pin_hole();
    }
}


module test_shelf_hole() {
    height = shelf_depth+(shelf_margin*2);
    dx = shelf_depth + pin_gap;
    dy = shelf_width + (pin_gap*2);
    difference() {
    translate([0,0,0]) cube([height, outer_width, outer_depth]);
    // board hole
    translate([shelf_margin, shelf_margin,0]) cube([dx, dy, outer_depth]);
    }
}

// =========================================================================
// Body
// =========================================================================

module body() {
   bg_width = outer_width * 0.6;
   // shelf board hole size
   dx = shelf_depth + pin_gap;
   dy = shelf_width + (pin_gap*2);  

   // pins
   pin_z = (outer_depth /2) - (pin_diameter/2);
   pin_y_distance = outer_depth * 1.5; 
   pin_y =outer_depth/2; 
   union() { 
        difference() {
            // main body
            translate([0,0,0]) cube([outer_height, outer_width, outer_depth]);
            // board hole
            translate([shelf_margin, shelf_margin,0]) cube([dx, dy, outer_depth]);
           
            // center hole 
            third_height = outer_height /3;
            fifth_width = outer_width /5;
            translate([third_height, fifth_width,0]) cube([third_height, fifth_width*3, outer_depth]);
            
            // bottom hole
            fifth_height = outer_height/5;
            fourth_width = outer_width /4;
            translate([fifth_height*4, fourth_width,0]) cube([third_height, fourth_width*2, outer_depth]);
            
            // pin holes - height,0 corner
            ph_x = outer_height+pin_gap;
            translate([ph_x, pin_y, pin_z]) rotate([0,-90,0]) round_pin_hole();          
            translate([ph_x, pin_y_distance, pin_z]) rotate([0,-90,0]) round_pin_hole();
            
            // pin holes - height,width corner            
            translate([ph_x, outer_width-pin_y-pin_diameter, pin_z]) rotate([0,-90,0]) round_pin_hole();
            translate([ph_x, outer_width-pin_y-pin_y_distance, pin_z]) rotate([0,-90,0]) round_pin_hole();
            
            
        }
        // top pins - 0,0 corner
        translate([0, pin_y, pin_z]) rotate([0,-90,0]) round_pin();
        translate([0, pin_y_distance, pin_z]) rotate([0,-90,0]) round_pin();
        
        // top pins - 0, outer_width corner
        translate([0, outer_width-pin_y-pin_diameter, pin_z]) rotate([0,-90,0]) round_pin();
        translate([0, outer_width-pin_y-pin_y_distance, pin_z]) rotate([0,-90,0]) round_pin();
    }
}

module pinout() {
    union() {
        body();
        translate([0, outer_depth, 20]) rotate([0,0,90]) round_pin();    
    }
}

//test_shelf_hole();
body();
