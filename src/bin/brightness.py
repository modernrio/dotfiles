#!/usr/bin/python3
"""
brightness.py
----------------
A python script which displays the screen brightness for use with i3blocks.
This version was written for the ThinkPad T470 and changes may be needed for
other systems.
----------------
Dependencies:
    - brightnessctl
"""
import os

def main():
    """ Entry point """
    # Get brightness info from brightnessctl
    info = os.popen("brightnessctl -m").read().strip("\n")

    # Split up information seperated by commas
    info = info.split(",")

    # Print full_text for i3blocks
    print(info[3])

    # Print short_text for i3blocks (none)
    print("")

    # Print color for i3blocks
    print("#FFFFFF")

if __name__ == "__main__":
    main()
