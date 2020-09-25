# Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain
# simulation tool for power systems.
import os
import sys
import re
from optparse import OptionParser
from xml.dom import minidom


dicOppositeEvents = {
    "PMIN : activation" : ["PMIN : deactivation"],
    "PMIN : deactivation" : ["PMIN : activation"],
    "PV Generator : max reactive power limit reached" : ["PV Generator : back to voltage regulation"],
    "PV Generator : min reactive power limit reached" : ["PV Generator : back to voltage regulation"],
    "PV Generator : back to voltage regulation" : ["PV Generator : min reactive power limit reached", "PV Generator : max reactive power limit reached"],
    "Phase-shifter : above maximum allowed value" : ["Phase-shifter : below maximum allowed value"],
    "Phase-shifter : below maximum allowed value" : ["Phase-shifter : above maximum allowed value"],
    "Under-voltage automaton for generator arming" : ["Under-voltage automaton for generator disarming"],
    "Under-voltage automaton for generator disarming" : ["Under-voltage automaton for generator arming"],
    "BUS : switch on" : ["BUS : switch off"],
    "BUS : switch off" : ["BUS : switch on"],
    "LINE : closing on side 1" : ["LINE : opening on side 1"],
    "LINE : opening on side 1" : [" LINE : closing on side 1"],
    "LINE : closing on side 2" : ["LINE : opening on side 2"],
    "LINE : opening on side 2" : [" LINE : closing on side 2"],
    "LINE : opening both sides" : ["LINE : closing both sides"],
    "LINE : closing both sides" : ["LINE : opening both sides"],
    "LOAD : connecting" : ["LOAD : disconnecting"],
    "LOAD : disconnecting" : ["LOAD : connecting"],
    "LINE : connecting" : ["LINE : disconnecting"],
    "LINE : disconnecting" : ["LINE : connecting"],
    "GENERATOR : connecting" : ["GENERATOR : disconnecting"],
    "GENERATOR : disconnecting" : ["GENERATOR : connecting"],
    "SHUNT : connecting" : ["SHUNT : disconnecting"],
    "SHUNT : disconnecting" : ["SHUNT : connecting"],
    "SVarC : connecting" : ["SVarC : disconnecting"],
    "SVarC : disconnecting" : ["SVarC : connecting"],
    "SWITCH : closing" : ["SWITCH : opening"],
    "SWITCH : opening" : ["SWITCH : closing"],
    "CONVERTER1 : disconnecting" : ["CONVERTER1 : connecting"],
    "CONVERTER1 : connecting" : ["CONVERTER1 : disconnecting"],
    "CONVERTER2 : disconnecting" : ["CONVERTER2 : connecting"],
    "CONVERTER2 : connecting" : ["CONVERTER2 : disconnecting"],
    "TRANSFORMER : closing on side 1" : ["TRANSFORMER : opening on side 1"],
    "TRANSFORMER : opening on side 1" : [" TRANSFORMER : closing on side 1"],
    "TRANSFORMER : closing on side 2" : ["TRANSFORMER : opening on side 2"],
    "TRANSFORMER : opening on side 2" : [" TRANSFORMER : closing on side 2"],
    "TRANSFORMER : opening both sides" : ["TRANSFORMER : closing both sides"],
    "TRANSFORMER : closing both sides" : ["TRANSFORMER : opening both sides"],
    }

class Event :
    def __init__(self):
        self.time = 0
        self.model = ""
        self.event = ""

    def __eq__(self, obj):
        return self.time == obj.time and self.model == obj.model and self.event == obj.event

class Timeline :
    def __init__(self):
        self.time_to_events = {}

    def add_event(self, event):
        if (event.time not in self.time_to_events):
            self.time_to_events[event.time] = []
        self.time_to_events[event.time].append(event)

    def filter_useless_events(self):
        print "[INFO] Filtering duplicated events"
        for time in self.time_to_events:
            events = self.time_to_events[time]
            idx_to_check = 1
            while idx_to_check <= len(events) - 1:
                curr_event = events[len(events) - idx_to_check]
                id_to_remove = []
                for i in range(len(events) - idx_to_check - 1, -1, -1):
                    if curr_event == events[i]:
                        id_to_remove.append(i)
                for i in id_to_remove:
                    del events[i]
                idx_to_check += 1
            self.time_to_events[time] = events

        print "[INFO] Removing opposed events"
        for time in self.time_to_events:
            events = self.time_to_events[time]
            idx_to_check = 1
            while idx_to_check <= len(events) - 1:
                curr_event = events[len(events) - idx_to_check]
                if curr_event.event not in dicOppositeEvents:
                    idx_to_check += 1
                    continue
                id_to_remove = []
                events_to_delete = dicOppositeEvents[curr_event.event]
                for i in range(len(events) - idx_to_check - 1, -1, -1):
                    if events[i].event in events_to_delete:
                        id_to_remove.append(i)
                for i in id_to_remove:
                    del events[i]
                idx_to_check += 1
            self.time_to_events[time] = events

    def filter_model(self, models_to_keep):
        print "[INFO] Filtering model"
        for time in self.time_to_events:
            events = self.time_to_events[time]
            new_events = []
            for i in range(-1, len(events) -1):
                if events[i].model in models_to_keep:
                    new_events.append(events[i])
            self.time_to_events[time] = new_events


    def dump(self, filepath, type):
        print "[INFO] dumping result into " + filepath
        sorted_keys = self.time_to_events.keys()
        sorted_keys.sort()

        if type == "TXT":
            f = open(filepath, "w")
            for time in sorted_keys:
                events = self.time_to_events[time]
                for event in events:
                    f.write(str(time) + " | " + event.model + " | " + event.event+"\n")
            f.close()
        elif type == "XML":
            f = open(filepath, "w")
            f.write("<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>\n")
            f.write("<timeline xmlns:dyn=\"http://www.rte-france.com/dynawo\">\n")
            for time in sorted_keys:
                events = self.time_to_events[time]
                for event in events:
                    f.write("<event time=\"" + str(event.time) + "\" modelName=\"" + event.model+ "\" message=\"" + event.event + "\"/>\n")
            f.write("</timeline>\n")
            f.close()




def read_txt(filepath):
    timeline = Timeline()
    f=open(filepath, "r")

    for line in f.readlines():
        array = line.split('|')
        if (len(array) != 3):
            continue
        event = Event()
        time = float(array[0].strip())
        event.time = time
        event.model = array[1].strip()
        event.event = array[2].rstrip().lstrip()
        timeline.add_event(event)
    f.close()
    return timeline

def read_xml(filepath):
    timeline = Timeline()
    try:
        doc = minidom.parse(filepath)
        root = doc.documentElement
    except:
        printout("Fail to import XML file " + filepath + os.linesep, BLACK)
        sys.exit(1)

    for event_timeline in root.getElementsByTagNameNS(root.namespaceURI, 'event'):
        event = Event()
        time = float(event_timeline.getAttribute('time'))
        event.time = time
        event.model = event_timeline.getAttribute('modelName').strip()
        event.event = event_timeline.getAttribute('message').rstrip().lstrip()
        timeline.add_event(event)

    return timeline



def main():
    usage=u""" Usage: %prog

    Script to filter a timeline
    """

    options = {}

    options[('-t', '--timelineFile')] = {'dest': 'timeline_file',
                                    'help': 'Timeline file to filter'}

    options[('-m', '--model')] = {'dest': 'models', 'action':'append',
                                    'help': 'models to keep (optional)'}

    parser = OptionParser(usage)
    for param, option in options.items():
        parser.add_option(*param, **option)
    (options, args) = parser.parse_args()

    if (options.timeline_file is None):
        print("[ERROR] parameter '--timelineFile' is missing.")
        sys.exit(1)
    if (not os.path.isfile(options.timeline_file)):
        print("[ERROR] " +options.timeline_file+" not found.")
        sys.exit(1)
    timeline_file = options.timeline_file

    if os.path.basename(timeline_file).endswith(".log") or os.path.basename(timeline_file).endswith(".txt"):
        type = "TXT"
    elif os.path.basename(timeline_file).endswith(".xml"):
        type = "XML"
    else:
        print("[ERROR] unrecognized file extension.")
        sys.exit(1)

    timeline = None
    if type == "TXT":
        timeline = read_txt(timeline_file)
    elif type == "XML":
        timeline = read_xml(timeline_file)

    timeline.filter_useless_events()
    if options.models is not None and len(options.models) > 0:
        timeline.filter_model(options.models)
    if type == "TXT":
        timeline.dump(os.path.join(os.path.dirname(timeline_file), "filtered_timeline.log"), type)
    elif type == "XML":
        timeline.dump(os.path.join(os.path.dirname(timeline_file), "filtered_timeline.xml"), type)


if __name__ == "__main__":
    main()
