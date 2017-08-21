#!/usr/bin/python3
"""
adjust_brightness.py
----------------
A wrapper around brightnessctl which fixes the rounding errors of brightnessctl
when using delta percentages.
----------------
Dependencies:
    - brightnessctl
"""
import argparse
import math
import os

def main():
    """ Entry point """
    # Parse arguments from command line
    parser = argparse.ArgumentParser( \
            description="A wrapper around brightnessctl which fixes the rounding \
            errors of brightnessctl when using delta percentages.")

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("-i", "--increase", metavar="N", type=int, \
                        help="Increase brightness by N percent.")
    group.add_argument("-d", "--decrease", metavar="N", type=int, \
                        help="Decrease brightness by N percent.")

    args = parser.parse_args()

    # Get brightness info from brightnessctl
    info = os.popen("brightnessctl -m").read().strip("\n")

    # Save relevant information
    info = info.split(",")
    percent = int(info[3].strip("%"))/100
    maxvalue = int(info[4])

    # Calculate new brightness value
    if args.increase:
        percent += args.increase/100
    elif args.decrease:
        percent -= args.decrease/100

    value = math.ceil(percent * maxvalue)

    # Set new brightness value via brightnessctl
    os.popen("brightnessctl s " + str(value))

    return

if __name__ == "__main__":
    main()
