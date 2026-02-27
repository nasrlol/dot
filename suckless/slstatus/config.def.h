 /* slstatus - suckless status monitor */
#ifndef CONFIG_H
#define CONFIG_H

/* Update interval in milliseconds */
#define interval 1000

/* Maximum buffer length for status string */
#define MAXLEN 2048

/* String to display for unknown/unavailable values */
static const char unknown_str[] = "n/a";

/* Wireless interface name */
#define WIFI_INTERFACE "wlp1s0f0"

/* Battery command */
#define BATTERY_CMD "macsmc-battery"

/* Volume command */
#define VOLUME_CMD \
	"wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf \"%d%%\", $2*100}'"

/* Status bar components configuration */
static const struct arg args[] = {
	/* Date and time */
	{
		datetime,
		"%s ",
		"%a %b %d  %H:%M"
	},
	/* CPU usage */
	{
		cpu_perc,
		" cpu %s%% ",
		NULL
	},
	/* Separator */
	{
		run_command,
		"; ",
		"echo"
	},
	/* RAM usage */
	{
		ram_perc,
		" ram %s%% ",
		NULL
	},
	/* Volume level */
	{
		run_command,
		" vol %s ",
		VOLUME_CMD
	},
	/* Battery percentage */
	{
		battery_perc,
		" batt: %s%%  ",
		BATTERY_CMD
	},
	/* WiFi ESSID */
	{
		wifi_essid,
		" %s ",
		WIFI_INTERFACE
	},
	/* WiFi signal strength */
	{
		wifi_perc,
		" (%s%%) ",
		WIFI_INTERFACE
	},
};

#endif /* CONFIG_H */
