# PDN=ring: the platform grid plus a VDD/VSS ring around the core on met4
# (vertical sides) and met5 (horizontal sides). The straps end on the ring, so
# every strap is fed from both ends. The ring sits between core and die, so
# this variant widens that margin from 5 to 10 um (config.mk): 1.0 offset
# + 2.0 VDD + 1.6 spacing + 2.0 VSS = 6.6 um. (In sky130, met5 must be at
# least 1.6 um wide with 1.6 um spacing.)
####################################
# global connections (same as the platform pdn.tcl)
####################################
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDPE$}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDDCE$}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPWR}
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {VPB}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSSE$}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VGND}
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {VNB}
global_connect
set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}

define_pdn_grid -name {grid} -voltage_domains {CORE} -pins {met5}
add_pdn_ring -grid {grid} -layers {met4 met5} -widths {2.0} -spacings {1.6} \
  -core_offsets {1.0}
add_pdn_stripe -grid {grid} -layer {met1} -width {0.48} -pitch {5.44} -offset {0} \
  -followpins -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {met4} -width {1.600} -pitch {27.140} -offset {13.570} \
  -extend_to_core_ring
add_pdn_stripe -grid {grid} -layer {met5} -width {1.600} -pitch {27.200} -offset {13.600} \
  -extend_to_core_ring
add_pdn_connect -grid {grid} -layers {met1 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}
