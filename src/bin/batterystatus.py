#!/usr/bin/python3
"""
batterystatus.py
----------------
A python script written for displaying the battery percentage for both batteries
on the ThinkPad T470 (external and internal).
This script is intented to be used as a command for i3blocks, but feel free to
change the code to meet your needs.
----------------
Dependencies:
    - acpi
"""
import argparse
import os
import sys

class Battery:
    """
    Save state of a battery to display it pretty
    """
    def __init__(self, batnum):
        self.batnum = batnum
        self.present = False
        self.state = ""
        self.percentage = ""
        self.timeleft = ""

        self.update()

    def update(self):
        """ Get battery info from acpi """
        # Execute 'acpi -b' to get all connected batteries
        acpi_output = os.popen("acpi -b").read().split("\n")

        # Each line represents one battery
        for line in acpi_output:
            # Search for battery number
            if line.startswith("Battery " + str(self.batnum)):
                # Battery is present, if found
                self.present = True

                # Cut battery number and get state, percentage
                line = line.split(" ")[2:]
                self.state = line[0].strip(",")
                self.percentage = int(line[1].strip(",%"))

                # Get time left if available
                try:
                    self.timeleft = line[2]
                except IndexError:
                    pass

                # Stop if we found the information we needed
                return

        # If we get here, the battery wan't found
        self.present = False

    @staticmethod
    def percentage_color(percentage):
        """ Consider text color based on percentage """
        if percentage < 20:
            return "#FF0000"
        elif percentage < 40:
            return "#FFAE00"
        elif percentage < 60:
            return "#FFF600"
        elif percentage < 85:
            return "#A8FF00"

        return "#FFFFFF"

def main():
    """ Entry point """
    # Parse arguments from command line
    parser = argparse.ArgumentParser(
        description="A python script for displaying the battery percentage for \
                     dual battery systems (internal and external battery).")

    parser.add_argument("-i", "--internal", type=int, metavar="N", default=0,
                        help="Battery number for internal battery")
    parser.add_argument("-e", "--external", type=int, metavar="N", default=1,
                        help="Battery number for external battery")

    args = parser.parse_args()

    # Battery number 0 is internal, Battery number 1 is external (T470 specific)
    internal = Battery(args.internal)
    external = Battery(args.external)

    # Tell if external battery is connected
    if external.present:
        current = external
    else:
        current = internal

    # Print full_text for i3blocks
    if current == external:
        print(str(external.percentage) + "%", end=" (")
        print(str(internal.percentage) + "%", end=")")
    else:
        print(str(internal.percentage) + "%", end="")

    if current.state == "Charging":
        print(" ", end=" ")
        print(current.timeleft, end="")

    print("")

    # Print short_text for i3blocks (none for now)
    print("")

    # Print color for i3blocks (based on percentage)
    print(Battery.percentage_color(current.percentage))

    # Set urgency (exit code 33) if internal battery is less than 10%
    # and external battery is also missing
    if internal.percentage < 10 and not external.present:
        sys.exit(33)
    else:
        return

if __name__ == "__main__":
    main()
