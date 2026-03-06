/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nobody";

static const float textsize=64.0;
static const char* textfamily="JetBrainsMono Nerd Font";
static const double textcolorred=255;
static const double textcolorgreen=255;
static const double textcolorblue=255;

static const char *colorname[NUMCOLS] = {
  [INIT] =   "black",     /* after initialization */
  [INPUT] =  "#161616",   /* during input */
  [FAILED] = "#cd950c"   /* wrong password */
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;


