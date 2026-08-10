FROM python:3.12-slim

RUN mkdir -p /app/config 
RUN mkdir -p /app/host

ENV YES_YOU_ARE_IN_A_CONTAINER=True

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY src/ /app/
RUN chmod a+x /app/bin/system_sensors.sh

CMD /app/bin/system_sensors.sh
