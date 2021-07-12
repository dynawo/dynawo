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
import glob

class Event :
    def __init__(self):
        self.time = 0
        self.model = ""
        self.event = ""
        self.priority = None

    def __eq__(self, obj):
        return self.time == obj.time and self.model == obj.model and self.event == obj.event

    def to_string(self):
        return str(self.time) + "|" + self.model + "|" + self.event

class Timeline :
    def __init__(self):
        self.time_to_events = {}

    def add_event(self, event):
        if (event.time not in self.time_to_events):
            self.time_to_events[event.time] = []
        self.time_to_events[event.time].append(event)

    def filter_useless_events(self, dicOppositeEvents):
        print "[INFO] Filtering duplicated events"
        for time in self.time_to_events:
            event_found = set()
            events = self.time_to_events[time]
            new_events = []
            for event in reversed(events):
                if event.to_string() not in event_found:
                    new_events.insert(0, event)
                    event_found.add(event.to_string())
            self.time_to_events[time] = new_events

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
                    if event.priority == None:
                        f.write(str(time) + " | " + event.model + " | " + event.event+"\n")
                    else:
                        f.write(str(time) + " | " + event.model + " | " + event.event+ " | " + event.priority+"\n")
            f.close()
        elif type == "XML":
            f = open(filepath, "w")
            f.write("<?xml version=\"1.0\" encoding=\"ISO-8859-1\" standalone=\"no\"?>\n")
            f.write("<timeline xmlns:dyn=\"http://www.rte-france.com/dynawo\">\n")
            for time in sorted_keys:
                events = self.time_to_events[time]
                for event in events:
                    try:
                        if event.priority == None:
                            f.write("<event time=\"" + str(event.time) + "\" modelName=\"" + event.model+ "\" message=\"" + event.event + "\"/>\n")
                        else:
                            f.write("<event time=\"" + str(event.time) + "\" modelName=\"" + event.model+ "\" message=\"" + event.event+ "\" priority=\"" + event.priority + "\"/>\n")
                    except UnicodeEncodeError:
                        if event.priority == None:
                            f.write("<event time=\"" + str(event.time).encode('iso8859-1') + "\" modelName=\"" + event.mode.encode('iso8859-1')+ "\" message=\"" + event.event.encode('iso8859-1') + "\"/>\n")
                        else:
                            f.write("<event time=\"" + str(event.time).encode('iso8859-1') + "\" modelName=\"" + event.model.encode('iso8859-1')+ "\" message=\"" + event.event.encode('iso8859-1')+ "\" priority=\"" + event.priority.encode('iso8859-1') + "\"/>\n")
            f.write("</timeline>\n")
            f.close()

def read_txt(filepath):
    timeline = Timeline()
    f=open(filepath, "r")

    for line in f.readlines():
        array = line.split('|')
        if (len(array) < 3):
            continue
        event = Event()
        time = float(array[0].strip())
        event.time = time
        event.model = array[1].strip()
        event.event = array[2].rstrip().lstrip()
        if (len(array) >= 4):
            event.priority = array[3].rstrip().lstrip()
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
        if event_timeline.hasAttribute('priority'):
            event.priority = event_timeline.getAttribute('priority').rstrip().lstrip()
        timeline.add_event(event)

    return timeline



def main(args):
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
    (options, args) = parser.parse_args(args)

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

    #Read opposite events tables
    if os.getenv("DYNAWO_RESOURCES_DIR") is None:
        print("environment variable DYNAWO_RESOURCES_DIR needs to be defined")
        sys.exit(1)
    resources_dirs = os.environ["DYNAWO_RESOURCES_DIR"].split(":")
    if os.getenv("DYNAWO_LOCALE") is None:
        print("environment variable DYNAWO_LOCALE needs to be defined")
        sys.exit(1)
    locale = os.environ["DYNAWO_LOCALE"]
    dicOppEvents = {}
    for dir in resources_dirs:
        sys.path.append(dir)
        for path in glob.glob(os.path.join(str(dir), '*_'+locale+'_oppositeEvents.py')):
            python_package = os.path.basename(path).replace(".py","")
            my_module = __import__(python_package)
            dicOppEvents.update(my_module.dicOppositeEvents)
            del sys.modules[python_package]

        sys.path.remove(dir)

    timeline = None
    if type == "TXT":
        timeline = read_txt(timeline_file)
    elif type == "XML":
        timeline = read_xml(timeline_file)

    timeline.filter_useless_events(dicOppEvents)
    if options.models is not None and len(options.models) > 0:
        timeline.filter_model(options.models)
    if type == "TXT":
        timeline.dump(os.path.join(os.path.dirname(timeline_file), "filtered_timeline.log"), type)
    elif type == "XML":
        timeline.dump(os.path.join(os.path.dirname(timeline_file), "filtered_timeline.xml"), type)


if __name__ == "__main__":
    main(sys.argv[1:])
