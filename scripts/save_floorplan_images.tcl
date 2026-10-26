# Save images of the floorplan and placement stages of an ORFS run, to go with
# the final_*.webp.png images the flow already saves at the end.
#
#   make floorplan_images                  (from openroad_flow/, after a run)
#   make PINS=auto floorplan_images        (same knobs as the run)
#
# Writes to the run's reports directory:
#   fp_floorplan.png   2_floorplan.odb: die, core, power grid, tap cells. No I/O
#                      pins yet: ORFS places them after a first global placement
#   fp_place.png       3_place.odb: placed cells and I/O pins, no power grid
# Each is ~1200 pixels on its longer side.

proc fp_set_view { } {
  gui::clear_highlights -1
  gui::clear_selections
  gui::set_display_controls "*" visible false
  gui::set_display_controls "Layers/*" visible true
  gui::set_display_controls "Nets/*" visible true
  gui::set_display_controls "Instances/*" visible true
  gui::set_display_controls "Shape Types/*" visible true
  gui::set_display_controls "Misc/Instances/*" visible false
  gui::set_display_controls "Misc/Instances/Pins" visible true
  gui::set_display_controls "Misc/Scale bar" visible true
  gui::set_display_controls "Misc/Detailed view" visible true
  gui::fit
}

proc fp_resolution { } {
  set bbox [[ord::get_db_block] getBBox]
  set longer [expr max([$bbox getDX], [$bbox getDY])]
  return [expr [ord::dbu_to_microns $longer] / 1200.0]
}

proc fp_save { name } {
  save_image -resolution [fp_resolution] $::env(REPORTS_DIR)/$name.png
  puts "Saved $::env(REPORTS_DIR)/$name.png"
}

proc fp_floorplan_images { } {
  fp_set_view
  fp_save fp_floorplan
}

proc fp_place_images { } {
  fp_set_view
  gui::set_display_controls "Nets/Power" visible false
  gui::set_display_controls "Nets/Ground" visible false
  gui::set_display_controls "Instances/Physical/*" visible false
  fp_save fp_place
}

# One stage per openroad run: FP_IMAGE_STAGE=floorplan or place
set stage $::env(FP_IMAGE_STAGE)
set odb $::env(RESULTS_DIR)/[dict get {floorplan 2_floorplan.odb place 3_place.odb} $stage]
if { [file exists $odb] } {
  read_db $odb
  gui::show fp_${stage}_images false
} else {
  puts "Skipping $stage images: [file tail $odb] not built yet"
}
