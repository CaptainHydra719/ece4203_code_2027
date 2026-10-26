# Floorplanning variants (registered_adder, sky130hd)

The 64-bit `registered_adder` on sky130hd has three floorplanning switches:
floorplan size, power grid, and pin locations. Set any of them on the `make`
command line, and each combination runs in its own directory, so you can
compare runs side by side.

```bash
cd openroad_flow
make FP=small                     # a) floorplan size / shape
make PDN=sparse                   # b) power grid
make PINS=dataflow                # c) pin locations
make FP=wide PINS=auto            # any combination

make PINS=dataflow gui_final      # open that run in the GUI (same switches)
make PINS=dataflow floorplan_images   # fp_floorplan.png + fp_place.png
make PINS=dataflow clean_all

make variants                     # one run per choice below, images, then metrics
make metrics                      # metrics/metrics.md: one row per variant
```

With every switch at `base` (the default) you get the original flow, in
`results/sky130hd/registered_adder/base/`. Other choices go to a directory named
after the non-base switches, such as `.../fp-small/`, `.../pdn-sparse_pins-auto/`.

| Switch | Choices | Where it's defined |
|---|---|---|
| `FP` | `base` 200×200 µm · `small` 150×150 · `large` 300×300 · `wide` 340×120 (3:1) · `util` (sized from `CORE_UTILIZATION = 35`) | `designs/sky130hd/registered_adder/config.mk` |
| `PDN` | `base` (platform grid) · `dense` · `sparse` · `ring` | `.../registered_adder/variants/pdn_*.tcl` |
| `PINS` | `base` (Lab 1 `io_constraints.tcl`) · `auto` · `random` · `dataflow` · `oneside` | `.../registered_adder/variants/pins_*.tcl` |

## The choices

**a) Floorplan size (`FP`).** The adder synthesizes to about 9,000 µm² of cells.
Timing repair then grows it to about 15,000 µm², because the 2.0 ns clock is far
too fast for a 64-bit ripple carry. The 196 I/O pins need about 270 µm of perimeter.

- `small`: a tight die, 77% final utilization.
- `large`: mostly empty, 20% utilization.
- `wide`: the same core area as base, but 3:1.
- `util`: lets ORFS size a square core from the synthesized area.

The core sits 5 µm inside the die, or 10 µm with `PDN=ring`.

**b) Power grid (`PDN`).** The sky130hd platform grid has:
- met1 rails along every row, which are the cells' own VDD/VSS
- met4 and met5 straps, 1.6 µm wide, every ~27 µm

The variants change it:
- `dense`: straps twice as wide and twice as close together.
- `sparse`: straps 3× farther apart.
- `ring`: adds a VDD/VSS core ring on met4/met5. The straps end on the ring, so they're fed from both ends.

**c) Pins (`PINS`).**
- `base`: the Lab 1 constraints. a on the left, b on the bottom, sum on the right, cout on top.
- `auto`: no constraints. The pin placer puts each pin next to the cells it drives, after a first global placement.
- `dataflow`: follows the bit-sliced datapath. a[i] and b[i] are interleaved on the left, sum[i] is on the right in the same order.
- `oneside`: every data pin is on the bottom edge.
- `random`: a fixed random order, a quarter of the pins on each edge.

The pin files use whole-edge regions (`left:*`), so they work with any `FP`.
`base` uses absolute µm and assumes edges of at least 120 µm, which all the `FP`
choices have.

## Results

From `make variants` on the `v2027.1.0` image. Each run changes one switch from base.

| Variant | Die (µm²) | Utilization | Routed wirelength (µm) | Worst IR drop (mV) | Worst setup slack (ns) | Power (mW) |
|---|---|---|---|---|---|---|
| base | 40,000 | 44% | 36,150 | 0.84 | −1.59 | 11.9 |
| FP=small | 22,500 | 77% | 32,720 | 0.80 | −1.64 | 11.4 |
| FP=large | 90,000 | 20% | 42,280 | 0.77 | −1.58 | 12.2 |
| FP=wide | 40,800 | 44% | 45,850 | 0.75 | −1.73 | 12.4 |
| FP=util | 28,520 | 62% | 33,900 | 0.74 | −1.69 | 11.6 |
| PDN=dense | 40,000 | 44% | 38,620 | **0.39** | −1.71 | 11.8 |
| PDN=sparse | 40,000 | 44% | 35,070 | **7.59** | −1.61 | 11.8 |
| PDN=ring | 40,000 | 49% (180 µm core) | 36,060 | 0.71 | −1.56 | 11.7 |
| PINS=auto | 40,000 | 42% | **25,900** | 0.76 | −1.51 | 11.1 |
| PINS=dataflow | 40,000 | 44% | 30,960 | 1.27 | −1.65 | 11.9 |
| PINS=oneside | 40,000 | 42% | 37,620 | 0.80 | −1.62 | 11.4 |
| PINS=random | 40,000 | 43% | **40,710** | 1.02 | −1.63 | 11.8 |

What the numbers show:

- **Size and shape:**
  - A smaller die shortens wires (−9% for `small`). A larger one lengthens them (+17% for `large`).
  - Aspect ratio matters more than area: `wide` has the same area as base but 27% more wire.
  - Every run fails the 2.0 ns clock by about 1.6 ns. That is set by the carry chain, not the floorplan.
- **Power grid:**
  - IR drop scales with strap pitch: `sparse` is 9× worse than base, and `dense` is half of base.
  - The cost of `dense` is routing: wirelength goes up 7%, because the straps take met4/met5 tracks.
  - This design is small enough that even 7.6 mV is only 0.4% of 1.8 V.
- **Pins:**
  - Pins placed for the logic (`auto`) cut wirelength by 28%.
  - Pins that scatter each bit (`random`) add 13%.
  - `dataflow` is in between: the bit slices line up, but the pins are bunched together rather than spread along the edge.

## Images for each run

In `reports/sky130hd/registered_adder/<variant>/`:

| File | Shows |
|---|---|
| `fp_floorplan.png` | Die, core, power grid and tap cells. Good for comparing `PDN` and `FP`. No I/O pins yet: ORFS places them after a first global placement |
| `fp_place.png` | Placed cells and I/O pins, no power grid. Good for comparing `PINS` |
| `final_all.webp.png`, `final_routing.webp.png`, `final_congestion.webp.png`, `final_ir_drop.webp.png` | The finished layout, routing congestion and the IR-drop map, saved by ORFS at the end of every run |

`fp_*.png` come from `make floorplan_images` (`scripts/save_floorplan_images.tcl`),
which `make variants` runs after each flow.
