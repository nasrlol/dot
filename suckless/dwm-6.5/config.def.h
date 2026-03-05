 /* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 5;
static const unsigned int gappx = 5;
static const unsigned int snap = 1;
static const int showbar = 1;
static const int topbar = 0;

static const char statussep = ';'; /* separator between status bars */

/* no bar padding */
static const int vertpad = 10;
static const int sidepad = 10;

/* fonts */
static const char *fonts[] = {"Liberation Mono:size=14"};
static const char dmenufont[] = "Liberation Mono:size=14";

/* --- Handmade Hero Palette --- */
static const char hh_back[]         = "#161616"; /* defcolor_back */
static const char hh_text[]         = "#a08563"; /* defcolor_text_default (tan) */
static const char hh_comment[]      = "#7d7d7d"; /* defcolor_comment (gray) */
static const char hh_keyword[]      = "#cd950c"; /* defcolor_keyword (gold) */
static const char hh_cursor[]       = "#40ff40"; /* defcolor_cursor green */
static const char hh_border[]       = "#262626"; /* defcolor_margin */
static const char hh_highlight[]    = "#703419"; /* defcolor_highlight (dark orange/brown) */

/* --- The Scheme Array --- */
static const char *colors[][3] = {
	/* fg           bg           border   */
	/* Normal: Tan text on dark charcoal bar */
	[SchemeNorm] = { hh_text,     hh_back,     hh_border },

	/* Selected: Green text on Highlight background */
	[SchemeSel]  = { hh_cursor,   hh_highlight, hh_keyword },
};

/* tags */
static const char *tags[] = {"1", "2", "3", "4", "5"};

/* rules */
static const Rule rules[] = {
	/* class       instance  title  tags mask  isfloating  monitor */
	{"neovide", NULL, NULL, 1 << 0, 0, -1},
	{"Neovide", NULL, NULL, 1 << 0, 0, -1},
	{"Firefox", NULL, NULL, 1 << 1, 0, -1},
	{"Navigator", NULL, NULL, 1 << 1, 0, -1},
	{"CLion", NULL, NULL, 1 << 3, 0, -1},
	{"GoLand", NULL, NULL, 1 << 3, 0, -1},
};

/* layout */
static const float mfact = 0.55;
static const int nmaster = 1;
static const int lockfullscreen = 1;
static const int resizehints = 0;
static const int refreshrate = 120;

static const Layout layouts[] = {
	{"[]=", tile},
	{"><>", NULL},
	{"[M]", monocle},
};

/* key definitions */
#define MODKEY Mod4Mask

#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                       \
  }

/* commands */
static char dmenumon[2] = "0";

static const char *dmenucmd[] = {
	"dmenu_run", "-vi",      "-m",  dmenumon,
	"-fn",       dmenufont,  "-nb", hh_back,  /* normal background */
	"-nf",       hh_text,                     /* normal foreground */
	"-sb",       hh_highlight,                /* selected background */
	"-sf",       hh_cursor,                   /* selected foreground */
	NULL};

static const char *termcmd[] = {"st", NULL};
static const char *ghostty[] = {"ghostty", NULL};
static const char *neovide[] = {"neovide", NULL};
static const char *emacs[]   = {"emacs-gtk+x11", NULL};
static const char *browser[] = {"firefox", NULL};
static const char *discord[] = {"discord", NULL};
static const char *lock[]    = { "slock", NULL };

/* Screenshots */
static const char *scrot_full[]      = { "scrot", "%Y-%m-%d-%H%M%S.png", "-e", "mv $f ~/Pictures/Screenshots/", NULL };
static const char *scrot_select[]    = { "scrot", "-s", "%Y-%m-%d-%H%M%S.png", "-e", "mv $f ~/Pictures/Screenshots/", NULL };
static const char *scrot_window[]    = { "scrot", "-u", "%Y-%m-%d-%H%M%S.png", "-e", "mv $f ~/Pictures/Screenshots/", NULL };

/* keys */
static const Key keys[] = {
	/* launch */
	{MODKEY,            XK_Return, spawn, {.v = termcmd}},
	{MODKEY,            XK_n,      spawn, {.v = neovide}},
	{MODKEY,            XK_b,      spawn, {.v = browser}},
	{MODKEY,            XK_p,      spawn, {.v = dmenucmd}},
	{MODKEY,            XK_g,      spawn, {.v = ghostty}},
	{MODKEY,            XK_d,      spawn, {.v = discord}},
	{MODKEY,            XK_e,      spawn, {.v = emacs}},
	{MODKEY|ShiftMask,  XK_l,      spawn, {.v = lock}},

	/* lock screen */
	{MODKEY|ShiftMask, XK_l, spawn, {.v = lock }},

	/* screenshot bindings */
	{ MODKEY,         XK_s,      spawn, {.v = scrot_select } }, /* Mod + s        = Select Area */
	{ MODKEY|ShiftMask, XK_s,    spawn, {.v = scrot_full   } }, /* Mod + Shift + s = Entire Screen */
	{ MODKEY|ControlMask, XK_s,  spawn, {.v = scrot_window } }, /* Mod + Ctrl + s  = Active Window */

	/* focus */
	{MODKEY, XK_j, focusstack, {.i = +1}},
	{MODKEY, XK_k, focusstack, {.i = -1}},

	/* master */
	{MODKEY, XK_i, incnmaster, {.i = +1}},
	{MODKEY, XK_o, incnmaster, {.i = -1}},

	/* resize */
	{MODKEY, XK_h, setmfact, {.f = -0.05}},
	{MODKEY, XK_l, setmfact, {.f = +0.05}},

	/* layout */
	{MODKEY, XK_t, setlayout, {.v = &layouts[0]}},
	{MODKEY, XK_f, setlayout, {.v = &layouts[1]}},
	{MODKEY, XK_m, setlayout, {.v = &layouts[2]}},
	{MODKEY, XK_space, setlayout, {0}},
	{MODKEY | ShiftMask, XK_space, togglefloating, {0}},

	/* gaps */
	{MODKEY, XK_minus, setgaps, {.i = -5}},
	{MODKEY, XK_equal, setgaps, {.i = +5}},
	{MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0}},

	/* misc */
	{MODKEY, XK_Tab, view, {0}},
	{MODKEY, XK_q, killclient, {0}},
	{MODKEY | ShiftMask, XK_Return, zoom, {0}},

	/* tags */

	TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
		TAGKEYS(XK_5, 4)

	/* quit */
	{MODKEY | ShiftMask, XK_q, quit, {0}},
};

/* mouse buttons */
static const Button buttons[] = {
	{ClkLtSymbol, 0, Button1, setlayout, {0}},
	{ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},

	{ClkWinTitle, 0, Button2, zoom, {0}},

	{ClkClientWin, MODKEY, Button1, movemouse, {0}},
	{ClkClientWin, MODKEY, Button2, togglefloating, {0}},
	{ClkClientWin, MODKEY, Button3, resizemouse, {0}},

	{ClkTagBar, 0, Button1, view, {0}},
	{ClkTagBar, 0, Button3, toggleview, {0}},
	{ClkTagBar, MODKEY, Button1, tag, {0}},
	{ClkTagBar, MODKEY, Button3, toggletag, {0}},
};
