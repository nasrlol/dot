/* slstatus - suckless status monitor */
#ifndef CONFIG_H
#define CONFIG_H

const unsigned int interval = 1000;
#define MAXLEN 2048
#define WIFI_INTERFACE "wlp1s0f0"
#define BATTERY_CMD "macsmc-battery"
#define VOLUME_CMD  "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"%d%%\", $2*100}'"

static const char unknown_str[] = "n/a";

static const struct arg args[] =
{
	{ datetime      , "%s"            , " %a %b %d  %H:%M " },
	{ run_command   , " volume %s "      , VOLUME_CMD },
	{ run_command   , "; "            , "echo" },
	{ battery_perc  , " battery: %s%%  " , BATTERY_CMD },
};

#endif /* CONFIG_H */
