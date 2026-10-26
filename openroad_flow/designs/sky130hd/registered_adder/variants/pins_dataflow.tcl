# PINS=dataflow: follow the bit-sliced datapath. Inputs come in on the left,
# interleaved a[0] b[0] a[1] b[1] ... so each bit's two inputs sit side by side;
# outputs leave on the right in the same order, so bit i flows straight across
# the die. cin enters next to bit 0 and cout leaves next to bit 63. clk and
# rst_n are unconstrained. Regions use "*" (the whole edge) so this works for
# any FP size.
# -group keeps the pins next to each other; -order keeps them in the listed
# order along the edge.

set_io_pin_constraint -group -order -region left:* -pin_names {
  cin
  a[0] b[0]  a[1] b[1]  a[2] b[2]  a[3] b[3]
  a[4] b[4]  a[5] b[5]  a[6] b[6]  a[7] b[7]
  a[8] b[8]  a[9] b[9]  a[10] b[10]  a[11] b[11]
  a[12] b[12]  a[13] b[13]  a[14] b[14]  a[15] b[15]
  a[16] b[16]  a[17] b[17]  a[18] b[18]  a[19] b[19]
  a[20] b[20]  a[21] b[21]  a[22] b[22]  a[23] b[23]
  a[24] b[24]  a[25] b[25]  a[26] b[26]  a[27] b[27]
  a[28] b[28]  a[29] b[29]  a[30] b[30]  a[31] b[31]
  a[32] b[32]  a[33] b[33]  a[34] b[34]  a[35] b[35]
  a[36] b[36]  a[37] b[37]  a[38] b[38]  a[39] b[39]
  a[40] b[40]  a[41] b[41]  a[42] b[42]  a[43] b[43]
  a[44] b[44]  a[45] b[45]  a[46] b[46]  a[47] b[47]
  a[48] b[48]  a[49] b[49]  a[50] b[50]  a[51] b[51]
  a[52] b[52]  a[53] b[53]  a[54] b[54]  a[55] b[55]
  a[56] b[56]  a[57] b[57]  a[58] b[58]  a[59] b[59]
  a[60] b[60]  a[61] b[61]  a[62] b[62]  a[63] b[63]
}

set_io_pin_constraint -group -order -region right:* -pin_names {
  sum[0] sum[1] sum[2] sum[3] sum[4] sum[5] sum[6] sum[7]
  sum[8] sum[9] sum[10] sum[11] sum[12] sum[13] sum[14] sum[15]
  sum[16] sum[17] sum[18] sum[19] sum[20] sum[21] sum[22] sum[23]
  sum[24] sum[25] sum[26] sum[27] sum[28] sum[29] sum[30] sum[31]
  sum[32] sum[33] sum[34] sum[35] sum[36] sum[37] sum[38] sum[39]
  sum[40] sum[41] sum[42] sum[43] sum[44] sum[45] sum[46] sum[47]
  sum[48] sum[49] sum[50] sum[51] sum[52] sum[53] sum[54] sum[55]
  sum[56] sum[57] sum[58] sum[59] sum[60] sum[61] sum[62] sum[63]
  cout
}
