/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int instant = 1;  /* -n option; if 1, select single entry automatically */
static int topbar = 1;   /* -b option; if 0, dmenu appears at bottom */

/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {"JetBrainsMono Nerd Font:size=18"};

static const char *prompt = NULL; /* -p option; prompt to the left of input field */

static unsigned int lines = 12; /* NUMBER OF VISIBLE LINES (vertical) */

static const char *colors[SchemeLast][2] = {
    /*               fg         bg       */
    [SchemeNorm]   = {"#8b949e", "#0d1117"},
    [SchemeSel]    = {"#ffffff", "#1f6feb"},
    [SchemeOut]    = {"#0d1117", "#3fb950"},
    [SchemeCursor] = {"#0d1117", "#58a6ff"},
};

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

static const unsigned int border_width = 2;

/*
 * -vi option; if nonzero, vi mode is always enabled and can be
 * accessed with the global_esc keysym + mod mask
 */
static unsigned int vi_mode = 1;
static unsigned int start_mode = 0; /* mode to use when -vi is passed. 0 = insert mode, 1 = normal mode */
static Key global_esc = { XK_n, Mod1Mask }; /* escape key when vi mode is not enabled explicitly */

static Key quit_keys[] = {
	/* keysym	modifier */
	{ XK_q,		0 }
};
