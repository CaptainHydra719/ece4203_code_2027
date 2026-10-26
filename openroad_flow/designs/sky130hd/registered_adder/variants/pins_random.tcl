# PINS=random: every data pin in a random order (fixed seed), a quarter of them on
# each edge. Bit i's a, b and sum pins end up far apart, so the placer can't
# line the adder up with its pins and the wires get long. Compare with
# PINS=dataflow. Generated with Python random.Random(4203).shuffle.

set_io_pin_constraint -group -order -region left:* -pin_names {
  sum[19] b[62] b[29] a[0] a[30] sum[39] sum[45] sum[41]
  a[39] a[32] a[14] a[12] sum[42] a[48] sum[54] sum[38]
  sum[10] a[60] sum[56] a[20] b[21] sum[34] sum[59] b[20]
  b[14] sum[40] b[11] sum[9] b[40] b[4] a[9] sum[57]
  b[0] a[21] a[45] a[33] b[25] sum[44] sum[60] b[60]
  b[43] sum[31] b[27] a[42] b[15] a[1] a[57] b[41]
}

set_io_pin_constraint -group -order -region bottom:* -pin_names {
  b[2] b[48] sum[53] b[9] sum[33] sum[23] a[63] sum[14]
  a[6] b[3] a[25] sum[7] a[24] a[34] b[24] a[44]
  sum[47] b[46] b[54] b[45] a[38] a[50] a[53] b[49]
  sum[58] a[19] sum[3] b[51] sum[37] a[31] a[13] b[47]
  b[26] b[17] a[2] sum[27] sum[18] a[18] a[62] sum[22]
  b[57] sum[26] b[28] a[46] a[40] b[44] b[22] sum[49]
}

set_io_pin_constraint -group -order -region right:* -pin_names {
  b[53] b[6] a[27] b[34] sum[48] b[12] sum[25] b[50]
  b[33] sum[12] a[56] a[7] sum[15] a[22] a[11] sum[13]
  a[49] b[39] a[5] b[1] b[19] sum[51] sum[28] sum[1]
  a[3] sum[24] sum[62] sum[4] a[61] a[55] b[42] a[37]
  sum[50] cout sum[17] b[56] b[16] sum[6] sum[61] b[10]
  b[8] a[35] sum[32] b[13] a[10] sum[21] sum[30] sum[46]
}

set_io_pin_constraint -group -order -region top:* -pin_names {
  sum[16] a[43] b[7] a[23] a[28] b[61] b[18] a[8]
  a[17] a[4] a[52] a[15] sum[29] sum[55] sum[20] sum[8]
  sum[52] cin b[32] a[47] a[59] b[58] b[31] a[26]
  b[63] b[23] b[5] b[30] b[38] sum[11] sum[2] b[36]
  a[36] b[37] sum[0] sum[36] a[41] sum[35] b[52] sum[5]
  b[59] a[16] a[29] a[54] sum[43] b[35] a[58] sum[63]
  a[51] b[55]
}
