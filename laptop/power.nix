_:

{
  services = {
    auto-cpufreq.enable = false;
    power-profiles-daemon.enable = false;
    tuned.enable = true;
    upower.enable = true;
    system76-scheduler.enable = true;
  };
}
