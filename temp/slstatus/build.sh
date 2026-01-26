#!/bin/sh

set -xeu

sudo make clean install

pkill slstatus
slstatus &
