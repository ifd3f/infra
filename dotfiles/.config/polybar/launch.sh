#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

rm -f /tmp/polybar-monitor-text-*

# Launch polybars (see https://github.com/polybar/polybar/issues/763#issuecomment-392960721)
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main --config=$HOME/.config/polybar/config.ini &
    PID=$!
    mkfifo /tmp/polybar-monitor-text-$PID
    ln -sf /tmp/polybar_mqueue.$PID /tmp/polybar-monitor-$m  # Create symlink
done
