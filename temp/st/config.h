/* See LICENSE file for copyright and license details. */

/*
 * appearance
 *
 * font: see http://freedesktop.org/software/fontconfig/fontconfig-user.html
 */
static char *font =
    "JetBrainsMono Nerd Font "
    "Mono:style=Regular:pixelsize=20:antialias=true:autohint=true";

static int borderpx = 8;

/*
 * What program is execed by st depends of these precedence rules:
 * 1: program passed with -e
 * 2: scroll and/or utmp
 * 3: SHELL environment variable
 * 4: value of shell in /etc/passwd
 * 5: value of shell in config.h
 */
static char *shell = "/usr/bin/fish";

char *utmp = NULL;
char *scroll = NULL;
char *stty_args = "stty raw pass8 nl -echo -iexten -cstopb 38400";

/* identification sequence returned in DA and DECID */
char *vtiden = "\033[?6c";

/* Kerning / character bounding-box multipliers */
static float cwscale = 1.0;
static float chscale = 1.0;

/* word delimiters */
wchar_t *worddelimiters = L" ";

/* selection timeouts (in milliseconds) */
static unsigned int doubleclicktimeout = 300;
static unsigned int tripleclicktimeout = 600;

/* alt screens */
int allowaltscreen = 1;

/* allow non-interactive window ops */
int allowwindowops = 0;

/* draw latency */
static double minlatency = 2;
static double maxlatency = 33;

/* blinking timeout */
static unsigned int blinktimeout = 800;

/* thickness of underline and bar cursors */
static unsigned int cursorthickness = 14;

/* bell volume */
static int bellvolume = 0;

/* default TERM value */
char *termname = "st-256color";

/* spaces per tab */
unsigned int tabspaces = 4;

/* Terminal colors */
static const char *colorname[] = {
    /* 8 normal colors */
    "black", "red3", "green3", "yellow3", "blue2", "magenta3", "cyan3",
    "gray90",

    /* 8 bright colors */
    "gray50", "red", "green", "yellow", "#5c5cff", "magenta", "cyan", "white",

    [255] = 0,

    /* default colors */
    "#c8ccd4", /* foreground */
    "#0f1115", /* background */
};

/* Default colors (indices into colorname[]) */
unsigned int defaultfg = 256;
unsigned int defaultbg = 257;
unsigned int defaultcs = 256;
static unsigned int defaultrcs = 257;

/* cursor shape */
static unsigned int cursorshape = 2;

/* default cols / rows */
static unsigned int cols = 80;
static unsigned int rows = 24;

/* mouse cursor */
static unsigned int mouseshape = XC_xterm;
static unsigned int mousefg = 7;
static unsigned int mousebg = 0;

/* font fallback attribute color */
static unsigned int defaultattr = 11;

/* force mouse modifier */
static uint forcemousemod = ShiftMask;

/* mouse shortcuts */
static MouseShortcut mshortcuts[] = {
    {XK_ANY_MOD, Button2, selpaste, {.i = 0}, 1},
    {ShiftMask, Button4, ttysend, {.s = "\033[5;2~"}},
    {XK_ANY_MOD, Button4, ttysend, {.s = "\031"}},
    {ShiftMask, Button5, ttysend, {.s = "\033[6;2~"}},
    {XK_ANY_MOD, Button5, ttysend, {.s = "\005"}},
};

/* keyboard shortcuts */
#define MODKEY Mod1Mask
#define TERMMOD (ControlMask | ShiftMask)

static Shortcut shortcuts[] = {
    {XK_ANY_MOD, XK_Break, sendbreak, {.i = 0}},
    {ControlMask, XK_Print, toggleprinter, {.i = 0}},
    {ShiftMask, XK_Print, printscreen, {.i = 0}},
    {XK_ANY_MOD, XK_Print, printsel, {.i = 0}},
    {TERMMOD, XK_Prior, zoom, {.f = +1}},
    {TERMMOD, XK_Next, zoom, {.f = -1}},
    {TERMMOD, XK_Home, zoomreset, {.f = 0}},
    {TERMMOD, XK_C, clipcopy, {.i = 0}},
    {TERMMOD, XK_V, clippaste, {.i = 0}},
    {TERMMOD, XK_Y, selpaste, {.i = 0}},
    {ShiftMask, XK_Insert, selpaste, {.i = 0}},
    {TERMMOD, XK_Num_Lock, numlock, {.i = 0}},
};

/* mapped keys */
static KeySym mappedkeys[] = {-1};

/* ignored modifiers */
static uint ignoremod = Mod2Mask | XK_SWITCH_MOD;

/* huge key table omitted for brevity in explanation
 * (UNCHANGED from your file)
 */
static Key key[] = {
    /* KEEP YOUR EXISTING KEY TABLE HERE EXACTLY AS IS */
};

/* selection masks */
static uint selmasks[] = {
    [SEL_RECTANGULAR] = Mod1Mask,
};

/* printable ASCII */
static char ascii_printable[] = " !\"#$%&'()*+,-./0123456789:;<=>?"
                                "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_"
                                "`abcdefghijklmnopqrstuvwxyz{|}~";
