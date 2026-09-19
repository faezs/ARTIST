# The renderer of his fixed-focus concentrator.
#
# No geometry lives in this directory.  scene_*.h/.metal/.py/.json and scene_registry.h are
# printed by `lake build RequestProject.SceneCcc` from RequestProject/HashemiSceneInst.lean's
# lists of DATA, through RequestProject/CccScene.lean; ../hashemi_ccc.h by
# `lake build RequestProject.HashemiCcc` from Hashemi.lean.  Rebuild those if the spec moved.
#
# The rays come from the megakernel through the FFI; the viewer is pyray.
#
#   make            the window (view.py on pyray)
#   make check      headless: C == NumPy == Metal for the three scenes, the sun against the
#                   trainer, and one committed frame from view.py
#   make clean

CC      ?= cc
CFLAGS  ?= -O2 -std=c99 -Wall -Wno-unused-function -Wno-unused-variable
PYTHON  ?= /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python
HDRS     = scene_registry.h scene_hashemi.h scene_beam.h scene_optic.h scene_sun.h

all:
	$(PYTHON) view.py --scene hashemi

# the C twin's harness: --eval (what check.py compares) and --sun.  No window, no raylib.
hashemi_frame: main.c $(HDRS)
	$(CC) $(CFLAGS) main.c -o $@ -lm

check: hashemi_frame
	$(PYTHON) check.py
	$(PYTHON) view.py --scene hashemi --frames 1 --out .
	@test -s frame_hashemi_000.png && echo "frame_hashemi_000.png written"

clean:
	rm -f hashemi_frame

.PHONY: all check clean
