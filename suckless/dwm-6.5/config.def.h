 /* See LICENSE file for copyright and license details. */
 #include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx = 0;
static const unsigned int gappx = 10;
static const unsigned int snap = 0;
static const int showbar = 1;
static const int topbar = 1;

static const char statussep = ';'; /* separator between status bars */

/* no bar padding */
static const int vertpad = 0;
static const int sidepad = 0;

/* fonts */
static const char *fonts[] = {"Comic Mono:style=Regular:size=12"};
static const char dmenufont[] = "Comic Mono:size=12";

static const char hh_back[]         = "#0a0a0a";
static const char hh_text[]         = "#a0b8a0";
static const char hh_comment[]      = "#506050";
static const char hh_keyword[]      = "#7ad97a";
static const char hh_cursor[]       = "#00ff00";
static const char hh_border[]       = "#0a1a0a";
static const char hh_highlight[]    = "#1a3a1a";

/* --- The Scheme Array --- */
static const char *colors[][3] = {
	/* fg           bg           border   */
	/* Normal: Tan text on dark charcoal bar */
	[SchemeNorm] = { hh_text,     hh_back,     hh_border },

	/* Selected: Green text on Highlight background */
	[SchemeSel]  = { hh_cursor,   hh_highlight, hh_keyword },
};

/* tags */
static const char *tags[] = {" code", "terminal", "browser", "IDE", "+ "};

/* rules */
static const Rule rules[] = {
	/* class                instance  title  tags   mask  isfloating  monitor */
	// {"neovide",             NULL,   NULL,   1 << 0, 0, -1},
	{"org.mozzila.firefox", NULL,   NULL,   1 << 2, 0, -1},
    {"Mozilla Firefox",     NULL,   NULL,   1 << 2, 0, -1},
	{"Navigator",           NULL,   NULL,   1 << 2, 0, -1},
	{"jetbrains-clion",     NULL,   NULL,   1 << 3, 0, -1},
	{"jetbrains-goland",    NULL,   NULL,   1 << 3, 0, -1},
};

/* layout */
static const float mfact = 0.55;
static const int nmaster = 1;
static const int lockfullscreen = 1;
static const int resizehints = 0;
static const int refreshrate = 60;

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
static const char *emacs[]   = {"emacs", NULL};
static const char *browser[] = {"firefox", NULL};
static const char *discord[] = {"discord", NULL};
static const char *lock[]    = {"slock", NULL };
static const char *mail[]    = {"thunderbird", NULL };


/* Volumes */
static const char *vol_up[]   = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };
static const char *vol_down[] = { "pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };
static const char *vol_mute[] = { "pactl", "set-sink-mute",   "@DEFAULT_SINK@", "toggle", NULL };

/* Screenshots */
// - removed, looking for a single binary screenshot tool. scrot is shit
static const char *scrot_full[]   = { "scrot", "%Y-%m-%d-%H%M%S.png", "-e",
    "mv $f ~/Pictures/Screenshots/ && xclip -selection clipboard -t image/png -i ~/Pictures/Screenshots/$f", NULL };

static const char *scrot_select[] = { "scrot", "-s", "%Y-%m-%d-%H%M%S.png", "-e",
    "mv $f ~/Pictures/Screenshots/ && xclip -selection clipboard -t image/png -i ~/Pictures/Screenshots/$f", NULL };

static const char *scrot_window[] = { "scrot", "-u", "%Y-%m-%d-%H%M%S.png", "-e",
    "mv $f ~/Pictures/Screenshots/ && xclip -selection clipboard -t image/png -i ~/Pictures/Screenshots/$f", NULL };


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
	{MODKEY|ShiftMask,  XK_m,      spawn, {.v = mail}},

	/* lock screen */
	{MODKEY|ShiftMask, XK_l, spawn, {.v = lock }},

	/* screenshot bindings */
	{ MODKEY|ShiftMask, XK_s,    spawn, {.v = scrot_full   } }, /* Mod + Shift + s = Entire Screen */
	{ MODKEY,         XK_s,      spawn, {.v = scrot_select } }, /* Mod + s        = Select Area */
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

  { MODKEY, XK_F12, spawn, {.v = vol_up   } },
  { MODKEY, XK_F11, spawn, {.v = vol_down } },
  { MODKEY, XK_F10, spawn, {.v = vol_mute } },

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
