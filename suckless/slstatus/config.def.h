const unsigned int interval = 100;

static const char unknown_str[] = "n/a";

#define MAXLEN 2048

static const struct arg args[] = {
    {battery_perc,      "  bat: %s%% ", "macsmc-battery"},
    {ram_perc,          "  ram:  %s%% ", NULL},
    {cpu_perc,          "  cpu:  %s%% ", NULL},
    {datetime,          "  %s ",  "%a %d %b %H:%M"},
};
