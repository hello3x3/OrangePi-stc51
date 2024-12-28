#!/bin/bash

docker run -it --rm --device=/dev/ttyUSB0:/dev/ttyUSB0 -v /root/stc51/:/root/stc51/ stc51

