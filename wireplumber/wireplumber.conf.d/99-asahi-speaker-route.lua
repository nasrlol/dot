rule = {
  matches = {
    {
      { "node.name", "equals", "alsa_card._sys_devices_platform_sound_sound_card1" } }
  },
  apply_properties = {
    ["audio.route"] = 0,
  },
}

table.insert(alsa_monitor.rules, rule)
