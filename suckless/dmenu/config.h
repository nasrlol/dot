/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int instant = 1; /* -n option; if 1, select single entry automatically */
static int topbar = 1;  /* -b option; if 0, dmenu appears at bottom */

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = { "LiterationMono Nerd Font Mono:size=20"};

static const char *prompt = "looking "; /* -p option; prompt to the left of input field */

static unsigned int lines = 18; /* NUMBER OF VISIBLE LINES (vertical) */

/* Padding and spacing for visual polish */
static int horizpadbar = 2;                 /* horizontal padding */
static int vertpadbar = 2;                  /* vertical padding */

/* Color scheme — nasr theme: warm amber/rust/sepia on dark */
static const char *colors[SchemeLast][2] = {
    /*               fg         bg       */
    [SchemeNorm]    = {"#C4A882", "#0D1117"},  /* warm tan on dark back */
    [SchemeSel]     = {"#0D1117", "#D48B30"},  /* dark on keyword amber */
    [SchemeOut]     = {"#0D1117", "#D4A030"},  /* dark on pop1 gold */
    [SchemeCursor]  = {"#0D1117", "#F0A030"},  /* dark on cursor gold */
};

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

static unsigned int border_width = 0;  /* no border */

/*
 * -vi option; if nonzero, vi mode is always enabled and can be
 * accessed with the global_esc keysym + mod mask
 */
static unsigned int vi_mode = 1;
static unsigned int start_mode = 0; /* mode to use when -vi is passed. 0 = insert mode, 1 = normal mode */

static Key global_esc = {
    XK_n, Mod1Mask
}; /* escape key when vi mode is not enabled explicitly */

static Key quit_keys[] = {
    /* keysym    modifier */
    {XK_q, 0},
    {XK_Escape, 0},
};
