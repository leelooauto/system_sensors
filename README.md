# ~~RPI~~ Linux System Sensors

[![GitHub Release][releases-shield]][releases]
[![License][license-shield]](LICENSE)

![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]

**WARNING !!! This fork has been modified, probably in a very poor way.**

I have:
 - Changed the upgrades pending method
 - Changed some sensor icons and units
 - Add additional disk, memory and network sensors
 - Optimised for Docker
 - Updated this README.md for clearer install guide
---

[Sennevds](https://github.com/Sennevds/system_sensors) created a simple python script that runs every 60 seconds and sends several system data over MQTT. It uses the MQTT Discovery for Home Assistant so you don’t need to configure anything in Home Assistant if you have discovery enabled for MQTT

It currently logs the following data:

- CPU usage
- CPU temperature
- CPU Clock Speed
- Fan Speed
- Disk usage
- Memory usage
- Power status of the RPI
- Last boot
- Last message received timestamp
- Swap usage
- Wifi signal strength
- Wifi connected SSID
- Amount of upgrades pending
- Disk usage of external drives
- Hostname
- Host local IP
- Host OS distro and version
- CPU Load (1min, 5min and 15min)
- Network Download & Upload throughput

**Added Sensors**
- Disk Available & Used
- Disk Available & Used Percentage
- Memory Available & Used
- Memory Available & Used Percentage
- Network Bytes Sent and Received
- Network Packets Sent and Received
- Host Kernel Version
- Host Platform


# Dependencies
- You need to have **Git** to clone System Sensors.
- You need to have at least **python 3.6** and **Pip** installed to use System Sensors.
```
sudo apt install git
sudo apt-get install python3-pip
```

# Installation
1. Clone the following repo
```
git clone https://github.com/leelooauto/system_sensors.git
```

**FOR DOCKER INSTALL SEE DOKCER STEPS BELOW !!!**

2. Install Python3 if not already
```
sudo apt-get install python3-apt
```
3. To install and run system_sensors
```
cd system_sensors
pip3 install -r requirements.txt
```
3a. If 'Externally Managed Environment'
```
pip3 install -r requirements.txt --break-system-packages
```
4. Copy and edit settings.yaml to reflect your system settings
```
cp src/settings_example.yaml src/settings.yaml
sudo nano src/settings.yaml
```

| Value                           | Required | Default | Description                                                                                                                                     |
| ------------------------------- | -------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| mqtt                            | true     | \       | Details of the MQTT broker                                                                                                                      |
| mqtt:hostname                   | true     | \       | Hostname of the MQTT broker                                                                                                                     |
| mqtt:port                       | false    | 1883    | Port of the MQTT broker                                                                                                                         |
| mqtt:user                       | false    | \       | The userlogin( if defined) for the MQTT broker                                                                                                  |
| mqtt:password                   | false    | \       | the password ( if defined) for the MQTT broker                                                                                                  |
| tls                             | false    | \       | Details of TLS settings broker                                                                                                  |
| tls:ca_certs                    | false    | \       | TLS settings ( if defined) for the MQTT broker                                                                                                  |
| tls:certfile                    | false    | \       | TLS settings ( if defined) for the MQTT broker                                                                                                  |
| tls:keyfile                     | false    | \       | TLS settings ( if defined) for the MQTT broker                                                                                                  |
| client_id                       | true     | \       | client id to connect to the MQTT broker                                                                                                         |
| ha_status                       | false    | hass    | Status topic for homeassistant, defaults to _hass_ if not set                                                                                      |
| timezone                        | true     | \       | Your local timezone (you can find the list of timezones here: [time zones](https://gist.github.com/heyalexej/8bf688fd67d7199be4a1682b3eec7568)) |
| power_integer_state(Deprecated) | false    | false   | Deprecated                                                                                                                                      |
| update_interval                 | false    | 60      | The update interval to send new values to the MQTT broker                                                                                       |
| sensors                         | false    | \       | Enable/disable individual sensors (see example settings.yaml for how-to). Default is true for all sensors.                                      |

5. Run to confirm working as expected
```
python3 src/system_sensors.py src/settings.yaml
``` 
6. (optional, but not really) create service to autostart the script at boot
  - Edit the path to your script path and settings.yaml. Also make sure you replace pi in "User=pi" with the account from which this script will be run. This is typically 'pi' on default Pi OS systems.
```
sudo cp system_sensors.service /etc/systemd/system/system_sensors.service
sudo systemctl enable system_sensors.service
sudo systemctl start system_sensors.service
```
   
# Docker Install
## Preparations
1. Before running in a docker add the following to the crontab
```
crontab -e
```
2. Add the following cron job
```
@reboot <git clone location>/src/bin/ip_pipe.sh
```
  - This little script will create a pipe and fetch the Host OS IP address and put it in the pipe.  
  - The container will have the pipe mounted `/tmp/system_sensor_pipe:/app/host/system_sensor_pipe:ro` so it can read the ip.
  - This is required since docker container can't and *shouldn't* access the host OS

3. Add a second cron job for the apt-get update else the pending updates will get stale
```
0 2 * * * sudo apt-get update
```

## Build & Start Container
1. Copy cloned repo to Docker directory
```
sudo cp -r system_sensors docker/systemsensors
cd docker/systemsensors
```
2. Build the container
```
docker compose build --no-cache
```
3. Start the container
```
docker compose up -d
```
4. Then stop the container to configure
```
docker compose up -d
```
5. Edit the config.yaml to reflect your system settings in the newly created /config folder, see table above for config options


[commits-shield]: https://img.shields.io/github/commit-activity/y/leelooauto/system_sensors?style=for-the-badge
[commits]: https://github.com/leelooauto/system_sensors/commits/master
[license-shield]: https://img.shields.io/github/license/leelooauto/system_sensors.svg?style=for-the-badge
[maintenance-shield]: https://img.shields.io/maintenance/yes/2026.svg?style=for-the-badge
[releases-shield]: https://img.shields.io/github/release/leelooauto/system_sensors.svg?style=for-the-badge
[releases]: https://github.com/leelooauto/system_sensors/releases
