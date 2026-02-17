 /* interval in milliseconds */
const unsigned int interval = 1000; 

static const char unknown_str[] = "n/a";

#define MAXLEN 2048
 static const struct arg args[] = {
    /* function         format                          argument */

    /* --- Left Bar: System Performance --- */
    { cpu_perc,         "CPU %s%% ",                    NULL },
    { ram_perc,         "| RAM %s%% ",                  NULL },
    { disk_perc,        "| SSD %s%% ",                  "/"  },
    { uptime,           "| UP %s ",                     NULL },

    /* --- The Split: Everything after this goes to the second bar --- */
    { run_command,      "; ",                           "echo" },

    /* --- Right Bar: Environment & Power --- */
    { run_command,      "VOL %s ",                      "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2*100 \"%\"}'" },
    
    /* Battery: Grouped state and percentage together */
    { battery_state,    "| %s ",                        "macsmc-battery" },
    { battery_perc,     "%s%% ",                        "macsmc-battery" },
    
    /* Time: Using %s to accept the format string from the argument column */
    { datetime,         "| %s",                         "%a %b %d  %H:%M" },
};
