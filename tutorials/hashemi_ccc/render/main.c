/* The renderer.
 *
 * There is no geometry in this file.  Every vertex it draws comes out of `scene_eval` — the C
 * function printed by RequestProject/CccScene.lean from a list of definitions of the
 * specification, each composed with its frame in the compiler's own graph.  This file only:
 *
 *   - reads the machine's dimensions from hashemi_machine_<a>.json (the ONLY source of numbers),
 *     and, for the handful of quantities the JSON does not carry, calls the specification's own
 *     printed constant (hk_zBoltHashemi, hk_megaGeom) rather than computing anything;
 *   - advances the pose with hk_megaStep, driven through hk_headToDriveAz / hk_headToDriveEl and
 *     the proved hk_follower;
 *   - puts the sun where hk_sceneSunAt (the spec's sunAt) says it is;
 *   - reads the ray draws from rays.csv, the same file the NumPy check reads, so C and NumPy draw
 *     the same rays;
 *   - binds each scene input BY NAME out of that pool, calls scene_eval, and draws the doubles
 *     by the kind and colour the manifest gives.
 *
 * Build:
 *   make                 the raylib window
 *   make check           headless (-DNO_RAYLIB): one SVG frame per scene, then the C/NumPy check
 *
 * Flags: --scene <name>   hashemi | beam | optic
 *        --machine <path> the machine JSON
 *        --pose az t slack
 *        --clock <lat> <doy> <hour>
 *        --replay day.csv (from dump_day.py)
 *        --svg out.svg    (headless only)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define hk_real double
#define HK_LIT(x) ((double)(x))
#include "../hashemi_ccc.h"
#include "scene_sun.h"
#include "scene_registry.h"

#ifndef NO_RAYLIB
#include <raylib.h>
#endif

#define MAXIN 128
#define MAXVERT 4096
#define MAXRAY 256
#define DEG (M_PI / 180.0)

/* ------------------------------------------------------------------ the machine JSON */

static char JBUF[1 << 20];

static int json_load(const char *path) {
  FILE *f = fopen(path, "rb");
  if (!f) return 0;
  size_t n = fread(JBUF, 1, sizeof JBUF - 1, f);
  JBUF[n] = 0;
  fclose(f);
  return 1;
}

/* the value of "key": <number>, wherever it stands.  The machine JSON is flat enough that a key
 * appears once with the meaning we want (kernel/mount/machine repeat a few, and they agree). */
static int json_num(const char *key, double *out) {
  char pat[64];
  snprintf(pat, sizeof pat, "\"%s\"", key);
  const char *p = strstr(JBUF, pat);
  if (!p) return 0;
  p = strchr(p, ':');
  if (!p) return 0;
  char *end;
  double v = strtod(p + 1, &end);
  if (end == p + 1) return 0;
  *out = v;
  return 1;
}

/* ------------------------------------------------------------------ the input pool, by name */

typedef struct { char name[40]; double v; } Slot;
static Slot POOL[MAXIN];
static int NPOOL;

static void put(const char *n, double v) {
  for (int i = 0; i < NPOOL; i++)
    if (!strcmp(POOL[i].name, n)) { POOL[i].v = v; return; }
  if (NPOOL >= MAXIN) return;
  snprintf(POOL[NPOOL].name, sizeof POOL[0].name, "%s", n);
  POOL[NPOOL].v = v;
  NPOOL++;
}

static double get(const char *n) {
  for (int i = 0; i < NPOOL; i++)
    if (!strcmp(POOL[i].name, n)) return POOL[i].v;
  return 0.0;
}

/* the drawing's own choices: which end of the bar a post stands at, and where its foot is.
 * `sg = ±1` is the specification's own parameter of `postTop`; `endIn = 0` is the case
 * `postTop_on_rail` proves (the post over the wheel). */
static void pool_conventions(void) {
  put("sgL", 1.0);
  put("sgR", -1.0);
  put("endIn", 0.0);
}

/* every dimension the JSON carries, under the name the scene's inputs use */
static void pool_machine(void) {
  static const char *KEYS[] = {
    "R", "f", "a", "w", "rc", "k", "ze", "ym", "hp", "chord", "apexH", "sideGap", "upright",
    "holeDown", "postH", "rodLen", "rDrum", "W", "rcm", "Tmax", "rho", "Fdrive", "L10",
    "sag", "side", "hanger", "rimHole", "aBase", "cross", "barW", "rDrive", NULL };
  for (int i = 0; KEYS[i]; i++) {
    double v;
    if (json_num(KEYS[i], &v)) put(KEYS[i], v);
  }
  /* `k` is the figure's conic constant: the sphere the spec traces is k = 0 unless told */
  double dummy;
  if (!json_num("k", &dummy)) put("k", 0.0);
}

/* what the JSON does not carry comes from the specification's own printed constants — never from
 * arithmetic here.  `zBar` is `megaGeom`'s column 13 (the rail's height), `zBolt` the bolt line's
 * own constant. */
static void pool_spec(double az, double t) {
  double g[60];
  hk_megaGeom(az, t, 0, 0, 0, 0, 0, 0, 0, get("rDrum"), get("W"), get("rcm"), get("Tmax"),
              get("rho"), get("Fdrive"), get("L10"), get("rodLen"), g);
  put("zBar", g[13]);
  put("zBolt", hk_zBoltHashemi());
  if (get("ym") == 0) put("ym", hk_ymHashemi());
  if (get("hp") == 0) put("hp", hk_hpHashemi());
  if (get("ze") == 0) put("ze", hk_zeHashemi());
  /* the nut setting `swingFocus` takes: the rim nuts at the focal length (`swingFocus_circle`) */
  put("dnut", get("f"));
  /* the pivot of `swingFocus`, the bolt line itself */
  put("P_1", 0.0);
  put("P_2", 0.0);
  /* the secondary, as `hashemi_tandoor_env.py` sets it (beam_L, beam_dm, beam_rm, beam_rt,
   * beam_slot) — the beam scene's own parameters */
  put("L", 1.25); put("dm", 0.06); put("rm", 0.06); put("rt", 0.55); put("slotW", 0.06);
  put("beta", 0.0);
  put("onPanel", 1.0);
  put("hsun", 0.00465);
}

/* ------------------------------------------------------------------ the rays */

static char RAYNAME[32][40];
static int NRAYCOL;
static double RAYS[MAXRAY][32];
static int NRAYS;

static int rays_load(const char *path) {
  FILE *f = fopen(path, "r");
  if (!f) return 0;
  char line[2048];
  if (!fgets(line, sizeof line, f)) { fclose(f); return 0; }
  NRAYCOL = 0;
  for (char *tok = strtok(line, ",\n\r"); tok && NRAYCOL < 32; tok = strtok(NULL, ",\n\r"))
    snprintf(RAYNAME[NRAYCOL++], 40, "%s", tok);
  NRAYS = 0;
  while (NRAYS < MAXRAY && fgets(line, sizeof line, f)) {
    int c = 0;
    for (char *tok = strtok(line, ",\n\r"); tok && c < NRAYCOL; tok = strtok(NULL, ",\n\r"))
      RAYS[NRAYS][c++] = atof(tok);
    if (c) NRAYS++;
  }
  fclose(f);
  return NRAYS;
}

static void pool_ray(int j) {
  if (!NRAYS) return;
  for (int c = 0; c < NRAYCOL; c++) put(RAYNAME[c], RAYS[j % NRAYS][c]);
}

/* ------------------------------------------------------------------ the pose */

typedef struct { double az, t, slack; int hAz, hEl; } Pose;

#define MEGASTEP(P, WM, WD, DT, EL, AZ, OUT) \
  hk_megaStep((P)->az, (P)->t, (P)->slack, (WM), (WD), (DT), (EL), (AZ), 0, get("rDrum"), \
              get("W"), get("rcm"), get("Tmax"), get("rho"), get("Fdrive"), get("L10"), \
              get("rodLen"), (OUT))

static void pose_step(Pose *p, double dt, double elSun, double azSun) {
  double s[17];
  /* the lever arm at this swing is megaStep's own column 8; read it, then command on it */
  MEGASTEP(p, 0, 0, 0, elSun, azSun, s);
  double arm = s[8];
  /* the heads, through the specification's own maps */
  double R = hk_rollerRadius(get("chord"), get("apexH"), get("aBase"), get("cross"), get("barW"),
                             get("rDrive"));
  double wm = hk_headToDriveAz((double)p->hAz, get("rDrive"), R);
  double wd = hk_headToDriveEl((double)p->hEl, arm, get("rDrum"));
  MEGASTEP(p, wm, wd, dt, elSun, azSun, s);
  p->az = s[0];
  p->t = s[1];
  p->slack = s[2];
}

/* ------------------------------------------------------------------ the scene */

static const hk_scene_t *scene_by_name(const char *n) {
  for (int i = 0; i < HK_N_SCENES; i++)
    if (!strcmp(HK_SCENES[i].name, n)) return &HK_SCENES[i];
  return NULL;
}

static void scene_fill(const hk_scene_t *s, double *in) {
  for (int i = 0; i < s->n_in; i++) in[i] = get(s->input[i]);
}

/* ------------------------------------------------------------------ colours */

typedef struct { unsigned char r, g, b; } Hue;
static const Hue HUES[] = {
  {200, 200, 200}, {230, 180, 60}, {120, 200, 240}, {240, 120, 120},
  {160, 240, 160}, {220, 140, 240}, {250, 250, 120}, {250, 180, 40}};
#define NHUE ((int)(sizeof HUES / sizeof HUES[0]))
static Hue hue(int c) { return HUES[((c % NHUE) + NHUE) % NHUE]; }
/* a ray's fate is its colour: 0 off the panel, 1 past the receiver, 2 in it (traceRayKErr) */
static Hue fatehue(double f) {
  int i = (int)(f + 0.5);
  if (i <= 0) return (Hue){110, 110, 110};
  if (i == 1) return (Hue){240, 120, 120};
  return (Hue){120, 240, 160};
}

/* ------------------------------------------------------------------ SVG (headless) */

static FILE *SVG;
static double SVGS = 70.0, SVGX = 560, SVGY = 620;
#define PX(X, Y, Z) (SVGX + SVGS * (0.866 * (X) - 0.866 * (Y)))
#define PY(X, Y, Z) (SVGY - SVGS * ((Z) - 0.5 * (X) - 0.5 * (Y)))

static void svg_line(const double *a, const double *b, Hue h, double wdt) {
  fprintf(SVG, "<line x1='%.2f' y1='%.2f' x2='%.2f' y2='%.2f' stroke='rgb(%d,%d,%d)' "
               "stroke-width='%.2f'/>\n",
          PX(a[0], a[1], a[2]), PY(a[0], a[1], a[2]), PX(b[0], b[1], b[2]), PY(b[0], b[1], b[2]),
          h.r, h.g, h.b, wdt);
}
static void svg_dot(const double *a, Hue h, double r) {
  fprintf(SVG, "<circle cx='%.2f' cy='%.2f' r='%.2f' fill='rgb(%d,%d,%d)'/>\n",
          PX(a[0], a[1], a[2]), PY(a[0], a[1], a[2]), r, h.r, h.g, h.b);
}

static void svg_entries(const hk_scene_t *s, const double *v) {
  for (int e = 0; e < s->n_entry; e++) {
    const double *p = v + s->off[e];
    Hue h = hue(s->colour[e]);
    switch (s->kind[e]) {
      case 0: svg_dot(p, h, 4); break;                      /* point   */
      case 1: svg_line(p, p + 3, h, 2.2); break;            /* segment */
      case 2: {                                             /* ray     */
        Hue f = fatehue(p[9]);
        svg_line(p, p + 3, f, 1.1);
        svg_line(p + 3, p + 6, f, 1.1);
        svg_dot(p + 6, f, 2);
        break;
      }
      case 3:                                               /* axes    */
        svg_line(p, p + 3, (Hue){240, 90, 90}, 1.6);
        svg_line(p, p + 6, (Hue){90, 240, 90}, 1.6);
        svg_line(p, p + 9, (Hue){90, 90, 240}, 1.6);
        break;
      default: break;                                       /* scalar: the legend */
    }
  }
}

static void svg_legend(const hk_scene_t *s, const double *v, const Pose *p, double elSun,
                       double azSun) {
  int y = 24;
  fprintf(SVG, "<text x='14' y='%d' fill='#ddd' font-family='monospace' font-size='13'>"
               "scene %s &#183; az %.2f&#176; el %.2f&#176; slack %.3f</text>\n",
          y, s->name, p->az / DEG, (M_PI / 2 - p->t) / DEG, p->slack);
  y += 18;
  fprintf(SVG, "<text x='14' y='%d' fill='#ddd' font-family='monospace' font-size='13'>"
               "sun el %.2f&#176; az %.2f&#176;</text>\n", y, elSun / DEG, azSun / DEG);
  for (int e = 0; e < s->n_entry; e++) {
    if (s->kind[e] != 4) continue;
    y += 16;
    fprintf(SVG, "<text x='14' y='%d' fill='#bbb' font-family='monospace' font-size='12'>"
                 "%s = %.5f</text>\n", y, s->label[e], v[s->off[e]]);
  }
}

/* ------------------------------------------------------------------ replay */

typedef struct { double hour, az, t, slack, lat, doy; } Frame;
static Frame REPLAY[4096];
static int NREPLAY;

static int replay_load(const char *path) {
  FILE *f = fopen(path, "r");
  if (!f) return 0;
  char line[512];
  if (!fgets(line, sizeof line, f)) { fclose(f); return 0; }   /* header */
  NREPLAY = 0;
  while (NREPLAY < 4096 && fgets(line, sizeof line, f)) {
    Frame *r = &REPLAY[NREPLAY];
    if (sscanf(line, "%lf,%lf,%lf,%lf,%lf,%lf", &r->hour, &r->az, &r->t, &r->slack, &r->lat,
               &r->doy) == 6)
      NREPLAY++;
  }
  fclose(f);
  return NREPLAY;
}

/* ------------------------------------------------------------------ main */

int main(int argc, char **argv) {
  const char *sceneName = "hashemi";
  const char *machine = "../hashemi_machine_2.0.json";
  const char *raysFile = "rays.csv";
  const char *svgOut = NULL;
  const char *replay = NULL;
  double lat = 30.2, doy = 172, hour = 11.0;
  int evalMode = 0, sunMode = 0;
  Pose pose = {120 * DEG, 15 * DEG, 0.0, 3, 3};
  int havePose = 0;

  for (int i = 1; i < argc; i++) {
    if (!strcmp(argv[i], "--scene") && i + 1 < argc) sceneName = argv[++i];
    else if (!strcmp(argv[i], "--machine") && i + 1 < argc) machine = argv[++i];
    else if (!strcmp(argv[i], "--rays") && i + 1 < argc) raysFile = argv[++i];
    else if (!strcmp(argv[i], "--svg") && i + 1 < argc) svgOut = argv[++i];
    else if (!strcmp(argv[i], "--replay") && i + 1 < argc) replay = argv[++i];
    else if (!strcmp(argv[i], "--eval")) evalMode = 1;
    else if (!strcmp(argv[i], "--sun")) sunMode = 1;
    else if (!strcmp(argv[i], "--pose") && i + 3 < argc) {
      pose.az = atof(argv[i + 1]); pose.t = atof(argv[i + 2]); pose.slack = atof(argv[i + 3]);
      i += 3; havePose = 1;
    } else if (!strcmp(argv[i], "--clock") && i + 3 < argc) {
      lat = atof(argv[i + 1]); doy = atof(argv[i + 2]); hour = atof(argv[i + 3]); i += 3;
    }
  }
  (void)havePose;

  const hk_scene_t *s = scene_by_name(sceneName);
  if (!s) {
    fprintf(stderr, "no such scene: %s.  Have:", sceneName);
    for (int i = 0; i < HK_N_SCENES; i++) fprintf(stderr, " %s", HK_SCENES[i].name);
    fprintf(stderr, "\n");
    return 2;
  }
  if (!json_load(machine)) fprintf(stderr, "warning: no machine JSON at %s\n", machine);
  rays_load(raysFile);
  if (replay) replay_load(replay);

  double in[MAXIN], verts[MAXVERT];
  int nray = NRAYS ? NRAYS : 1;

  double sun[2];
  hk_sceneSunAt(lat, doy, hour, sun);

  /* the acceptance modes: the printed function, called with nothing else in the way */
  if (sunMode) {
    char line[256];
    while (fgets(line, sizeof line, stdin)) {
      double L, D, H, o[2];
      if (sscanf(line, "%lf,%lf,%lf", &L, &D, &H) != 3) continue;
      hk_sceneSunAt(L, D, H, o);
      printf("%.17g,%.17g\n", o[0], o[1]);
    }
    return 0;
  }
  if (evalMode) {
    char line[8192];
    while (fgets(line, sizeof line, stdin)) {
      int c = 0;
      for (char *tok = strtok(line, ",\n\r"); tok && c < s->n_in; tok = strtok(NULL, ",\n\r"))
        in[c++] = atof(tok);
      if (c != s->n_in) continue;
      s->eval(in, verts);
      for (int k = 0; k < s->n_vert; k++) printf("%.17g%s", verts[k], k + 1 < s->n_vert ? "," : "\n");
    }
    return 0;
  }

#ifdef NO_RAYLIB
  /* one frame, to SVG */
  char out[256];
  snprintf(out, sizeof out, "%s", svgOut ? svgOut : "frame.svg");
  if (!svgOut) snprintf(out, sizeof out, "frame_%s.svg", sceneName);
  SVG = fopen(out, "w");
  if (!SVG) { perror(out); return 1; }
  fprintf(SVG, "<svg xmlns='http://www.w3.org/2000/svg' width='1120' height='760' "
               "viewBox='0 0 1120 760'><rect width='1120' height='760' fill='#101418'/>\n");
  pool_conventions();
  pool_machine();
  put("az", pose.az); put("t", pose.t); put("slack", pose.slack);
  put("elSun", sun[0]); put("azSun", sun[1]);
  put("lat", lat); put("doy", doy); put("hour", hour);
  pool_spec(pose.az, pose.t);
  for (int j = 0; j < nray; j++) {
    pool_ray(j);
    scene_fill(s, in);
    s->eval(in, verts);
    svg_entries(s, verts);
  }
  svg_legend(s, verts, &pose, sun[0], sun[1]);
  fprintf(SVG, "</svg>\n");
  fclose(SVG);
  printf("%s: %d entries, %d doubles, %d inputs, %d rays -> %s\n", s->name, s->n_entry,
         s->n_vert, s->n_in, nray, out);
  return 0;
#else
  InitWindow(1280, 860, "the scene, printed from the spec");
  SetTargetFPS(60);
  Camera3D cam = {0};
  cam.position = (Vector3){7.0f, 5.0f, 7.0f};
  cam.target = (Vector3){0.0f, 2.5f, 0.0f};
  cam.up = (Vector3){0.0f, 1.0f, 0.0f};
  cam.fovy = 50.0f;
  cam.projection = CAMERA_PERSPECTIVE;
  int follower = 1, sceneIdx = 0, frame = 0;
  double speed = 60.0;   /* solar seconds per wall second */
  for (int i = 0; i < HK_N_SCENES; i++) if (&HK_SCENES[i] == s) sceneIdx = i;

  while (!WindowShouldClose()) {
    UpdateCamera(&cam, CAMERA_ORBITAL);
    if (IsKeyPressed(KEY_TAB)) { sceneIdx = (sceneIdx + 1) % HK_N_SCENES; s = &HK_SCENES[sceneIdx]; }
    if (IsKeyPressed(KEY_F)) follower = !follower;
    if (IsKeyPressed(KEY_EQUAL)) speed *= 2;
    if (IsKeyPressed(KEY_MINUS)) speed /= 2;
    if (IsKeyDown(KEY_LEFT)) pose.hAz = 0;
    else if (IsKeyDown(KEY_RIGHT)) pose.hAz = 6;
    else pose.hAz = 3;
    if (IsKeyDown(KEY_DOWN)) pose.hEl = 0;
    else if (IsKeyDown(KEY_UP)) pose.hEl = 6;
    else pose.hEl = 3;

    double dt = GetFrameTime() * speed;
    if (NREPLAY) {
      const Frame *r = &REPLAY[(frame / 2) % NREPLAY];
      pose.az = r->az; pose.t = r->t; pose.slack = r->slack;
      hour = r->hour; lat = r->lat; doy = r->doy;
      frame++;
    }
    hk_sceneSunAt(lat, doy, hour, sun);
    if (!NREPLAY) {
#ifdef HK_HAVE_FOLLOWER
      if (follower) {
        /* the proved follower (HashemiPolicy.lean) commands both heads */
        double cmd[2];
        hk_follower(hk_azErr(pose.az, sun[1]), hk_elErr(pose.t, sun[0]), dt, cmd);
        pose.hAz = (int)(3 + 3 * cmd[0]);
        pose.hEl = (int)(3 + 3 * cmd[1]);
      }
#endif
      pose_step(&pose, dt, sun[0], sun[1]);
      hour += dt / 3600.0;
    }

    pool_conventions();
    pool_machine();
    put("az", pose.az); put("t", pose.t); put("slack", pose.slack);
    put("elSun", sun[0]); put("azSun", sun[1]);
    put("lat", lat); put("doy", doy); put("hour", hour);
    pool_spec(pose.az, pose.t);

    double geo[60];
    hk_megaGeom(pose.az, pose.t, pose.slack, 0, 0, 0, sun[0], sun[1], 900.0, get("rDrum"),
                get("W"), get("rcm"), get("Tmax"), get("rho"), get("Fdrive"), get("L10"),
                get("rodLen"), geo);

    BeginDrawing();
    ClearBackground((Color){16, 20, 24, 255});
    BeginMode3D(cam);
    DrawGrid(20, 0.5f);
    for (int j = 0; j < nray; j++) {
      pool_ray(j);
      scene_fill(s, in);
      s->eval(in, verts);
      for (int e = 0; e < s->n_entry; e++) {
        const double *p = verts + s->off[e];
        Hue h = hue(s->colour[e]);
        Color c = (Color){h.r, h.g, h.b, 255};
        /* roof (x north, y east, z up) -> raylib (x, y up, z) */
#define V3(q) ((Vector3){(float)(q)[0], (float)(q)[2], (float)(q)[1]})
        switch (s->kind[e]) {
          case 0: DrawSphere(V3(p), 0.04f, c); break;
          case 1: DrawLine3D(V3(p), V3(p + 3), c); break;
          case 2: {
            Hue f = fatehue(p[9]);
            Color fc = (Color){f.r, f.g, f.b, 255};
            DrawLine3D(V3(p), V3(p + 3), fc);
            DrawLine3D(V3(p + 3), V3(p + 6), fc);
            break;
          }
          case 3:
            DrawLine3D(V3(p), V3(p + 3), RED);
            DrawLine3D(V3(p), V3(p + 6), GREEN);
            DrawLine3D(V3(p), V3(p + 9), BLUE);
            break;
          default: break;
        }
#undef V3
      }
      if (j == 0 && s->kind[0] == 4) break;
    }
    EndMode3D();
    int y = 10;
    DrawText(TextFormat("scene %s  (TAB)", s->name), 10, y, 18, RAYWHITE); y += 22;
    DrawText(TextFormat("az %.2f deg   el %.2f deg   slack %.3f", pose.az / DEG,
                        (M_PI / 2 - pose.t) / DEG, pose.slack), 10, y, 18, RAYWHITE); y += 22;
    DrawText(TextFormat("sun el %.2f deg  az %.2f deg   hour %.2f  doy %.0f", sun[0] / DEG,
                        sun[1] / DEG, hour, doy), 10, y, 18, RAYWHITE); y += 22;
    DrawText(TextFormat("pointing %.3f deg   capture %.3f   power %.0f W",
                        hk_pointingError(pose.az, pose.t, sun[0], sun[1]) / DEG, geo[52], geo[53]),
             10, y, 18, RAYWHITE); y += 22;
#ifndef HK_HAVE_FOLLOWER
    DrawText("follower: hk_follower is not in this hashemi_ccc.h - rebuild RequestProject.HashemiCcc",
             10, y, 14, (Color){200, 150, 90, 255}); y += 18;
#endif
    DrawText(TextFormat("follower %s (F)   speed x%.0f (+/-)", follower ? "on" : "off", speed),
             10, y, 18, GRAY); y += 22;
    for (int e = 0; e < s->n_entry; e++) {
      if (s->kind[e] != 4) continue;
      DrawText(TextFormat("%s = %.5f", s->label[e], verts[s->off[e]]), 10, y, 16, LIGHTGRAY);
      y += 18;
    }
    EndDrawing();
  }
  CloseWindow();
  return 0;
#endif
}
