```
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
```
