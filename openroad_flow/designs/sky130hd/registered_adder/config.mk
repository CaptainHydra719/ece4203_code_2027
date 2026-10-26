export DESIGN_NAME = registered_adder
export PLATFORM    = sky130hd

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/registered_adder.v
export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Adders degrade GCD
export ADDER_MAP_FILE :=

export TNS_END_PERCENT = 100
export EQUIVALENCE_CHECK   ?=   0
export REMOVE_CELLS_FOR_EQY = sky130_fd_sc_hd__tapvpwrvgnd*

# ---------------------------------------------------------------------------
# Floorplanning variants. Pick one of each on the make command line:
#
#   make FP=small                    floorplan size / shape
#   make PDN=sparse                  power grid
#   make PINS=dataflow               pin locations
#   make FP=wide PINS=auto           any combination
#
# Each combination runs in its own directory, results/sky130hd/registered_adder/
# <variant>/ (likewise logs/, reports/), so runs don't overwrite each other.
# With everything at "base" the variant is "base", the original flow. Pass the
# same options to gui_final, clean_all etc.:  make PDN=sparse gui_final
# The variant files are in ./variants/; `make variants` runs one of each.
# ---------------------------------------------------------------------------
FP   ?= base
PDN  ?= base
PINS ?= base

FP_CHOICES   := base small large wide util
PDN_CHOICES  := base dense sparse ring
PINS_CHOICES := base auto random dataflow oneside
$(if $(filter $(FP),$(FP_CHOICES)),,$(error FP=$(FP): choose one of $(FP_CHOICES)))
$(if $(filter $(PDN),$(PDN_CHOICES)),,$(error PDN=$(PDN): choose one of $(PDN_CHOICES)))
$(if $(filter $(PINS),$(PINS_CHOICES)),,$(error PINS=$(PINS): choose one of $(PINS_CHOICES)))

# Variant name: the non-base choices, e.g. fp-small_pins-auto
_empty :=
_space := $(_empty) $(_empty)
_variant := $(strip $(if $(filter-out base,$(FP)),fp-$(FP)) \
                    $(if $(filter-out base,$(PDN)),pdn-$(PDN)) \
                    $(if $(filter-out base,$(PINS)),pins-$(PINS)))
export FLOW_VARIANT ?= $(if $(_variant),$(subst $(_space),_,$(_variant)),base)

_variants = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/variants

# --- a) Floorplan size ------------------------------------------------------
# The adder starts at ~9,000 um^2 of cells after synthesis and grows to ~15,000
# um^2 once timing repair adds buffers and upsizes the carry chain. The 196 I/O
# pins need a ~270 um perimeter. Sizes are in um. The core sits _margin um
# inside the die on every side: 5 um, or 10 um with PDN=ring to make room for
# the ring.
_margin := $(if $(filter ring,$(PDN)),10,5)
ifeq ($(FP),base)
  # 190 x 190 um core: ~25% utilization after synthesis, ~45% at the end
  _die := 200 200
else ifeq ($(FP),small)
  # 140 x 140 um core: ~45% after synthesis, ~75% at the end. Tight
  _die := 150 150
else ifeq ($(FP),large)
  # 290 x 290 um core: ~20% at the end. Wasted area, longer wires
  _die := 300 300
else ifeq ($(FP),wide)
  # Same core area as base (~36,000 um^2), aspect ratio 3:1
  _die := 340 120
endif
ifeq ($(FP),util)
  # Let the tool size the die: core area = synthesized cell area / 0.35,
  # square (~160 x 160 um here), with the margin to the die
  export CORE_UTILIZATION  = 35
  export CORE_ASPECT_RATIO = 1
  export CORE_MARGIN       = $(_margin)
else
  export DIE_AREA  = 0 0 $(_die)
  export CORE_AREA = $(_margin) $(_margin) \
                     $(shell expr $(word 1,$(_die)) - $(_margin)) $(shell expr $(word 2,$(_die)) - $(_margin))
endif

# --- b) Power grid ----------------------------------------------------------
# base: the platform's grid ($(PLATFORM_DIR)/pdn.tcl): met1 rails along every
#       row, met4 and met5 straps every ~27 um
ifneq ($(PDN),base)
  export PDN_TCL = $(_variants)/pdn_$(PDN).tcl
endif

# --- c) Pin locations -------------------------------------------------------
# base: io_constraints.tcl, a on the left, b on the bottom, sum on the right,
#       cout on top. Its regions are in um, up to 120 um along each edge
ifeq ($(PINS),base)
  export IO_CONSTRAINTS = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/io_constraints.tcl
else ifneq ($(PINS),auto)
  # auto: no constraints; the pin placer puts each pin next to the cells it
  # connects to (after a first global placement)
  export IO_CONSTRAINTS = $(_variants)/pins_$(PINS).tcl
endif
