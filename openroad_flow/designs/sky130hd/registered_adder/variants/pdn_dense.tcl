# PDN=dense: straps 2x wider and 2x closer than the platform grid
# (platform: 1.6 um wide every ~27 um on met4 and met5). Lower IR drop, but the
# straps take more of the met4/met5 routing tracks.
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
# met1 rails along every standard-cell row (VDD/VSS alternate)
add_pdn_stripe -grid {grid} -layer {met1} -width {0.48} -pitch {5.44} -offset {0} -followpins
add_pdn_stripe -grid {grid} -layer {met4} -width {3.200} -pitch {13.570} -offset {6.785}
add_pdn_stripe -grid {grid} -layer {met5} -width {3.200} -pitch {13.600} -offset {6.800}
add_pdn_connect -grid {grid} -layers {met1 met4}
add_pdn_connect -grid {grid} -layers {met4 met5}
