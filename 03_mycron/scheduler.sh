#!/bin/bash

# 1. change dir to /etc/systemd/system
# 2. make a link to scheduler.service
# 3. change ExecStart in the scheduler.service
#     to the full path of scheduler.sh
# 4. sudo chmod +x scheduler.sh
# 5. sudo systemctl start scheduler
# 6. sudo systemctl enable scheduler
# ???
# 7. profit!
# 8. sudo systemctl stop scheduler


cfg_path="/etc/mycron.cfg"
# cfg_path="/home/mi/work/au_unix/09_classwork/mycron.cfg"

default_config=$(printf "%s\n%s"\
  '1   # периодичность выполнения (в минутах)' \
  'echo "test" | wall  # команда для выполнения')

while true; do
  [[ -e "$cfg_path" ]] || {
    echo "$default_config" > "$cfg_path";
  }

  pause=$(awk -e '{print $1;exit}' "$cfg_path")
  (( pause > 0 )) || { sleep 10; continue; }

  cmd=$(tail +2 "$cfg_path")
  bash -c "$cmd" &

  sleep "${pause}s"
done
