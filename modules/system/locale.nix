{ lib, ... }:

{
  time.timeZone = lib.mkDefault "Europe/Copenhagen";

  i18n = {
    defaultLocale = "en_DK.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
    };
  };

  console = {
    keyMap = "dk";
  };
}

