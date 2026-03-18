/* slstatus - suckless status monitor */
#ifndef CONFIG_H
#define CONFIG_H

const unsigned int interval = 1000;
#define MAXLEN 2048
#define WIFI_INTERFACE "wlp1s0f0"
#define BATTERY_CMD "macsmc-battery"

static const char unknown_str[] = "n/a";

static const struct arg args[] = {
    /* function       format              argument */

    {datetime,     " %s ",           "%a %b %d  %H:%M"},
    {run_command,  "; ",             "echo"},
    {run_command,  " :: ",           "echo"},
    {battery_perc, " battery %s%%",      BATTERY_CMD},
    {run_command,  " :: ",           "echo"},
    {uptime,       " %s",        NULL},
    {run_command,  " :: ",           "echo"},
};

#endif /* CONFIG_H */
