/* See LICENSE file for copyright and license details. */

static const unsigned int borderpx = 2; /* window border */
static const unsigned int gappx = 20;
static const unsigned int snap = 8; /* snap pixel */
static const int showbar = 1;       /* show bar */
static const int topbar = 0;        /* bar at top */

static const int vertpad = 0; /* vertical padding of bar */
static const int sidepad = 0; /* horizontal padding of bar */

static const char *fonts[] = {"JetBrainsMono Nerd Font:size=18"};
static const char dmenufont[] = "JetBrainsMono Nerd Font:size=16";

static const char col_bg[] = "#000000";
static const char col_bg_alt[] = "#0a0a0a";
static const char col_border[] = "#1a1a1a";
static const char col_fg[] = "#b8b8b8";
static const char col_fg_dim[] = "#6b6b6b";
static const char col_accent[] = "#7fda89";
static const char col_accent_bg[] = "#1a3a1f";
static const char col_occupied[] = "#7fda89";  
static const char *colors[2][3] = {
    [SchemeNorm] = {col_fg_dim, col_bg_alt, col_border},
    [SchemeSel] = {col_fg, col_accent_bg, col_accent},
};

static const char *tags[] = {"1", "2", "3", "4", "5"};

/* class        instance  title  tags mask  isfloating  monitor */
static Rule rules[] = { {"Code", NULL, NULL, 1 << 1, 0, -1}, {"Chromium", NULL, NULL, 1 << 2, 0, -1}, {"Firefox", NULL, NULL, 1 << 2, 0, -1}, };

static const float mfact = 0.55;
static const int nmaster = 1;
static const int resizehints = 0;
static const int lockfullscreen = 1;
static const int refreshrate = 60;

static const Layout layouts[] = {
    {"[]=", tile},
    {"><>", NULL},
    {"[M]", monocle},
};

#define MODKEY Mod4Mask

#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
      {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \
      {MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}},               \
      {MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

#define SHCMD(cmd)                                                             \
  {                                                                            \
    .v = (const char *[]) { "/bin/sh", "-c", cmd, NULL }                      \
  }

static char dmenumon[2] = "0";

static const char *dmenucmd[] = {"dmenu_run", "-vi",      "-m",  dmenumon,
                                 "-fn",       dmenufont,  "-nb", col_bg_alt,
                                 "-nf",       col_fg_dim, "-sb", col_accent_bg,
                                 "-sf",       col_fg,     NULL};

static const char *termcmd[] = {"alacritty", NULL};
static const char *ide[] = {"neovide", NULL};
static const char *browser[] = {"firefox", NULL};
static const char *files[] = {"thunar", NULL};

/* Volume controls (adjust for your system) */
static const char *upvol[] = {"pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL};
static const char *downvol[] = {"pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL};
static const char *mutevol[] = {"pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL};

/* Brightness controls (adjust for your system) */
static const char *brightup[] = {"brightnessctl", "set", "5%+", NULL};
static const char *brightdown[] = {"brightnessctl", "set", "5%-", NULL};

static const Key keys[] = {

    /* launch */
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY, XK_n, spawn, {.v = ide}},
    {MODKEY, XK_b, spawn, {.v = browser}},
    {MODKEY, XK_e, spawn, {.v = files}},
    {MODKEY, XK_p, spawn, {.v = dmenucmd}},
    {MODKEY, XK_d, spawn, {.v = dmenucmd}},

    /* focus */
    {MODKEY, XK_j, focusstack, {.i = +1}},
    {MODKEY, XK_k, focusstack, {.i = -1}},
    {MODKEY, XK_Left, focusstack, {.i = -1}},
    {MODKEY, XK_Right, focusstack, {.i = +1}},

    /* master */
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_o, incnmaster, {.i = -1}},

    /* resize */
    {MODKEY, XK_h, setmfact, {.f = -0.05}},
    {MODKEY, XK_l, setmfact, {.f = +0.05}},
    {MODKEY | ShiftMask, XK_h, setmfact, {.f = -0.01}},
    {MODKEY | ShiftMask, XK_l, setmfact, {.f = +0.01}},

    /* layout */
    {MODKEY, XK_t, setlayout, {.v = &layouts[0]}}, /* tile */
    {MODKEY, XK_f, setlayout, {.v = &layouts[1]}}, /* float */
    {MODKEY, XK_m, setlayout, {.v = &layouts[2]}}, /* monocle */
    {MODKEY, XK_space, setlayout, {0}},            /* toggle last layout */
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY | ShiftMask, XK_f, fullscreen, {0}},

    /* gaps */
    {MODKEY, XK_minus, setgaps, {.i = -5}},
    {MODKEY, XK_equal, setgaps, {.i = +5}},
    {MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0}},
    {MODKEY | ShiftMask, XK_minus, setgaps, {.i = gappx}},

    /* misc */
    {MODKEY, XK_Tab, view, {0}},           /* toggle last tag */
    {MODKEY, XK_q, killclient, {0}},
    {MODKEY | ShiftMask, XK_Return, zoom, {0}}, /* swap with master */
    {MODKEY, XK_0, view, {.ui = ~0}},           /* view all tags */
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}}, /* tag on all tags */

    /* monitor */
    {MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},

    /* tags */
    TAGKEYS(XK_1, 0)
    TAGKEYS(XK_2, 1)
    TAGKEYS(XK_3, 2)
    TAGKEYS(XK_4, 3)
    TAGKEYS(XK_5, 4)
    TAGKEYS(XK_6, 5)
    TAGKEYS(XK_7, 6)
    TAGKEYS(XK_8, 7)
    TAGKEYS(XK_9, 8)

    /* quit */
    {MODKEY | ShiftMask, XK_q, quit, {0}},
    {MODKEY | ControlMask | ShiftMask, XK_q, quit, {1}}, /* restart dwm */
};

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
