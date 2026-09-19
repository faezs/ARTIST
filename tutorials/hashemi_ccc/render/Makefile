# The renderer of his fixed-focus concentrator.
#
# No geometry lives in this directory's C.  scene_*.h/.py/.json and scene_registry.h are printed
# by `lake build RequestProject.SceneCcc` from RequestProject/HashemiSceneInst.lean's three lists
# of DATA, through RequestProject/CccScene.lean; ../hashemi_ccc.h by
# `lake build RequestProject.HashemiCcc` from Hashemi.lean.  Rebuild those if the spec moved.
#
#   make            the raylib window (needs `brew install raylib`)
#   make check      headless: the three scenes against their NumPy twins, the sun against the
#                   trainer, and one committed SVG frame per scene
#   make clean

RAYLIB_PREFIX ?= $(shell brew --prefix raylib 2>/dev/null)
RAYLIB  ?= $(shell test -f "$(RAYLIB_PREFIX)/include/raylib.h" && echo "$(RAYLIB_PREFIX)")
CC      ?= cc
CFLAGS  ?= -O2 -std=c99 -Wall -Wno-unused-function -Wno-unused-variable
PYTHON  ?= /Users/faezs/ARTIST/tutorials/puffer_tandoor/.venv/bin/python
HDRS     = scene_registry.h scene_hashemi.h scene_beam.h scene_optic.h scene_sun.h ../hashemi_ccc.h

ifeq ($(strip $(RAYLIB)),)
all:
	@echo "raylib is not installed ($(RAYLIB_PREFIX)/include/raylib.h is missing)."
	@echo "The window needs it:      brew install raylib && make"
	@echo "The headless build does not, and is the acceptance:"
	@echo "                          make check"
	@exit 1
else
all: hashemi_render

hashemi_render: main.c $(HDRS)
	$(CC) $(CFLAGS) -I$(RAYLIB)/include main.c -o $@ -L$(RAYLIB)/lib -lraylib -lm \
	  -framework Cocoa -framework IOKit -framework CoreVideo -framework OpenGL
endif

# the same source with the window compiled out: --eval, --sun and one SVG frame
hashemi_frame: main.c $(HDRS)
	$(CC) $(CFLAGS) -DNO_RAYLIB main.c -o $@ -lm

check: hashemi_frame
	$(PYTHON) check.py
	./hashemi_frame --scene hashemi --pose 1.976 0.2617 0.0 --clock 30.2 172 11.0
	./hashemi_frame --scene beam    --pose 1.976 0.2617 0.0 --clock 30.2 172 11.0
	./hashemi_frame --scene optic   --pose 1.976 0.2617 0.0 --clock 30.2 172 11.0

clean:
	rm -f hashemi_render hashemi_frame

.PHONY: all check clean
