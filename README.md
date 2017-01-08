**How to start**

1. Download `fr24feed.ini` from source repository and adjust your fr24 sharing key.
2. Start via
```
docker run -d --device=/dev/bus/usb:/dev/bus/usb -v $(pwd)/fr24feed.ini:/etc/fr24feed.ini:ro -p 8754:8754 -p 8080:8080 mwilmes/rpi-fr24feed
```
  
Check port 8080 for dump1090 graphical map.
Check port 8754 for stats.
