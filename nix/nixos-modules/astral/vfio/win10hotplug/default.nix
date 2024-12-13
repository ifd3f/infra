{ writeShellScriptBin, ... }:
writeShellScriptBin "win10hotplug" ''
  WIN10HOTPLUG_XMLDIR=${./.} exec ${./win10hotplug.sh} $@
''
