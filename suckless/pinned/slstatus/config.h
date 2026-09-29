/* slstatus - suckless status monitor */
#ifndef CONFIG_H
#define CONFIG_H

/* Interval in milliseconds between updates */
const unsigned int interval = 1000;

/* Maximum length of the status text */
#define MAXLEN 2048

/* Define your hardware interfaces here */
#define WIFI_INTERFACE "wlp0s20f3"
#define BATTERY_NAME   "BAT0"
#define AUDIO_MIXER    "default" // Uses default ALSA mixer (usually Master)

static const char unknown_str[] = "n/a";

static const struct arg args[] = {
    /* function      format              argument */

    { datetime,     " %s ",             "%a %b %d  %H:%M" },

    { wifi_essid,   " | wifi: %s",      WIFI_INTERFACE },
    { wifi_perc,    " (%s%%)",          WIFI_INTERFACE },

    { vol_perc,     " | vol: %s%%",     AUDIO_MIXER },

    { battery_perc, " | bat: %s%%",     BATTERY_NAME },
};

#endif /* CONFIG_H */
