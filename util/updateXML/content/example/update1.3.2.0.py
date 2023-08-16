import os
import sys

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)

from Ticket import ticket

@ticket(930)
def update(jobs):
    omegarefs = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "DYNModelOmegaRef")
    for omegaref in omegarefs:
        omegaref.set_lib_name("DYNModelOmegaRef_NAME_CHANGED")
