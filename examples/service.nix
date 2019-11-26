[Unit]
Description=i3lock
Before=sleep.target

[Service]
User={Inserted my User}
Type=forking
Environment=DISPLAY=:0
ExecStart=/usr/bin/i3lock -c 272d2d

[Install]
WantedBy=sleep.target