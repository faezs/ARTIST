/* The C twin's harness — and nothing else.
 *
 * The window used to be here, built on a raylib that is not installed on this machine, and the
 * rays used to come from a CSV.  Both are gone: the viewer is `view.py` on pyray, and the rays
 * are the megakernel's own table, dispatched through `scene_kernel.py`.  What is left of this
 * file is the third printer's harness — `scene_<name>.h` is C printed from the same hash-consed
 * graph as the Metal kernel and the NumPy twin, and `--eval` is how `scene_kernel.py` asks it
 * for its answer so the three can be compared.  There is no geometry here; there never was.
 *
 *   ./hashemi_frame --scene hashemi --eval     one line per frame: "x0,..,xn;dr0,..,drN"
 *                                              out: the static vertices, then P x n_ray
 *   ./hashemi_frame --sun                      one line per instant: "lat,doy,hour" -> "el,az"
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "scene_registry.h"
#include "scene_sun.h"

#define MAXV 65536
#define MAXLINE (1 << 20)

static const hk_scene_t *find_scene(const char *name) {
  for (int i = 0; i < HK_N_SCENES; ++i)
    if (strcmp(HK_SCENES[i].name, name) == 0) return &HK_SCENES[i];
  return NULL;
}

static int parse_reals(char *s, hk_real *out, int max) {
  int n = 0;
  char *tok = strtok(s, ",");
  while (tok && n < max) {
    out[n++] = (hk_real)atof(tok);
    tok = strtok(NULL, ",");
  }
  return n;
}

static int cmd_eval(const hk_scene_t *sc) {
  static char line[MAXLINE];
  static hk_real in[512], dr[MAXV], vs[MAXV], vr[MAXV];
  while (fgets(line, sizeof line, stdin)) {
    char *semi = strchr(line, ';');
    if (!semi) continue;
    *semi = '\0';
    int ni = parse_reals(line, in, 512);
    int nd = parse_reals(semi + 1, dr, MAXV);
    if (ni != sc->n_in) {
      fprintf(stderr, "scene %s wants %d inputs, got %d\n", sc->name, sc->n_in, ni);
      return 1;
    }
    /* the tables, concatenated in the kernel's own buffer order (scene_<name>.json "arrays") */
    const hk_real *tab[8];
    int off = 0;
    for (int k = 0; k < sc->n_tab && k < 8; ++k) { tab[k] = dr + off; off += sc->tab[k]; }
    if (nd != off) {
      fprintf(stderr, "scene %s wants %d table entries, got %d\n", sc->name, off, nd);
      return 1;
    }
    sc->eval(in, tab, vs, vr);
    for (int k = 0; k < sc->n_static; ++k) printf(k ? ",%.17g" : "%.17g", (double)vs[k]);
    for (int i = 0; i < sc->n_rays; ++i)
      for (int k = 0; k < sc->n_ray; ++k)
        printf((sc->n_static || i || k) ? ",%.17g" : "%.17g", (double)vr[i * sc->n_ray + k]);
    printf("\n");
  }
  return 0;
}

static int cmd_sun(void) {
  static char line[4096];
  while (fgets(line, sizeof line, stdin)) {
    hk_real v[8];
    int n = parse_reals(line, v, 8);
    if (n < 3) continue;
    hk_real out[2];
    hk_sceneSunAt(v[0], v[1], v[2], out);
    printf("%.17g,%.17g\n", (double)out[0], (double)out[1]);
  }
  return 0;
}

int main(int argc, char **argv) {
  const char *scene = "hashemi";
  int eval = 0, sun = 0;
  for (int i = 1; i < argc; ++i) {
    if (!strcmp(argv[i], "--scene") && i + 1 < argc) scene = argv[++i];
    else if (!strcmp(argv[i], "--eval")) eval = 1;
    else if (!strcmp(argv[i], "--sun")) sun = 1;
    else if (!strcmp(argv[i], "--list")) {
      for (int k = 0; k < HK_N_SCENES; ++k)
        printf("%s %d %d %d %d %d\n", HK_SCENES[k].name, HK_SCENES[k].n_in, HK_SCENES[k].n_static,
               HK_SCENES[k].n_rays, HK_SCENES[k].n_ray, HK_SCENES[k].n_tab);
      return 0;
    } else {
      fprintf(stderr, "usage: %s [--scene NAME] [--eval|--sun|--list]\n", argv[0]);
      return 2;
    }
  }
  if (sun) return cmd_sun();
  const hk_scene_t *sc = find_scene(scene);
  if (!sc) { fprintf(stderr, "no scene %s\n", scene); return 2; }
  if (eval) return cmd_eval(sc);
  fprintf(stderr, "nothing to do: pass --eval or --sun (the window is view.py)\n");
  return 2;
}
