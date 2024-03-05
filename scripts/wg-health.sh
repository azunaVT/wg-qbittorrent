#!/bin/bash

ip l | grep wg0 > /dev/null || echo $?
