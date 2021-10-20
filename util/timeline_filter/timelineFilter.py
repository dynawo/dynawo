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
import glob
from lxml import etree
import zipfile



def ImportXMLFile(path):
    if isinstance(path,str):
        if (not os.path.isfile(path)):
            print("No file found. Unable to import")
            return None
    return etree.parse(path).getroot()

def ImportXMLFileExtended(path):
    root = ImportXMLFile(path)
    return (root, root.nsmap, root.prefix)

def FindAll(root, prefix, element, ns):
    prefix_str = "{" + str(ns[prefix]) + "}" if prefix in ns else ""
    return root.findall(".//" + prefix_str + element)

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
        print ("[INFO] Filtering duplicated events")
        for time in self.time_to_events:
            event_found = set()
            events = self.time_to_events[time]
            new_events = []
            for event in reversed(events):
                if event.to_string() not in event_found:
                    new_events.insert(0, event)
                    event_found.add(event.to_string())
            self.time_to_events[time] = new_events

        print ("[INFO] Removing opposed events")
        use_iso88591 = False
        for event in events:
            try:
                event.event.decode('utf-8')
            except (UnicodeEncodeError,UnicodeDecodeError):
                use_iso88591 = True
                break
        if not use_iso88591:
            for event in dicOppositeEvents:
                try:
                    event.decode('utf-8')
                    for msg in dicOppositeEvents[event]:
                        msg.decode('utf-8')
                except UnicodeDecodeError:
                    use_iso88591 = True
                    break
        for time in self.time_to_events:
            events = self.time_to_events[time]
            idx_to_check = 1
            while idx_to_check <= len(events) - 1:
                curr_event = events[len(events) - idx_to_check]
                if use_iso88591:
                    curr_event.event = curr_event.event.encode('iso8859-1')
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
        if models_to_keep is not None and len(models_to_keep) > 0:
            print ("[INFO] Filtering model")
            for time in self.time_to_events:
                events = self.time_to_events[time]
                new_events = []
                for i in range(-1, len(events) -1):
                    if events[i].model in models_to_keep:
                        new_events.append(events[i])
                self.time_to_events[time] = new_events


    def dump(self, filepath, type):
        print ("[INFO] dumping result into " + filepath)
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
            f.write("<dyn:timeline xmlns:dyn=\"http://www.rte-france.com/dynawo\">\n")
            for time in sorted_keys:
                events = self.time_to_events[time]
                for event in events:
                    try:
                        fixEncoding(event)
                        if event.priority == None:
                            f.write("<dyn:event time=\"" + str(event.time) + "\" modelName=\"" + event.model+ "\" message=\"" + event.event + "\"/>\n")
                        else:
                            f.write("<dyn:event time=\"" + str(event.time) + "\" modelName=\"" + event.model+ "\" message=\"" + event.event+ "\" priority=\"" + event.priority + "\"/>\n")
                    except UnicodeEncodeError:
                        fixEncoding(event)
                        if event.priority == None:
                            f.write("<dyn:event time=\"" + str(event.time).encode('iso8859-1') + "\" modelName=\"" + event.mode.encode('iso8859-1')+ "\" message=\"" + event.event.encode('iso8859-1') + "\"/>\n")
                        else:
                            f.write("<dyn:event time=\"" + str(event.time).encode('iso8859-1') + "\" modelName=\"" + event.model.encode('iso8859-1')+ "\" message=\"" + event.event.encode('iso8859-1')+ "\" priority=\"" + event.priority.encode('iso8859-1') + "\"/>\n")
            f.write("</dyn:timeline>\n")
            f.close()

    def filterTimeLine(self, filename, dicOppositeEvents, modelsToKeep, outputName = None):
        self.filter_useless_events(dicOppositeEvents)
        self.filter_model(modelsToKeep)
        if getFileType(filename) == "TXT":
            self.dump(os.path.join(os.path.dirname(filename), "filtered_timeline.log"), getFileType(filename))
        elif getFileType(filename) == "XML":
            if outputName is None:
                self.dump(os.path.join(os.path.dirname(filename), "filtered_timeline.xml"), getFileType(filename))
            else:
                self.dump(os.path.join(os.path.dirname(filename), outputName), getFileType(filename))

def fixEncoding(event):
    if "<" in event.event:
        event.event = event.event.replace("<", "&lt;")
    if ">" in event.event:
        event.event = event.event.replace(">", "&gt;")

def getFileType(filename):
    if zipfile.is_zipfile(filename):
        return "ZIP"
    elif os.path.basename(filename).endswith(".log") or os.path.basename(filename).endswith(".txt"):
        return "TXT"
    elif os.path.basename(filename).endswith(".xml"):
        return "XML"
    else:
        print("[ERROR] unrecognized file extension.")
        exit(1)

def checkEnvVar():
    if os.getenv("DYNAWO_RESOURCES_DIR") is None:
        print("environment variable DYNAWO_RESOURCES_DIR needs to be defined")
        exit(1)
    if os.getenv("DYNAWO_LOCALE") is None:
        print("environment variable DYNAWO_LOCALE needs to be defined")
        exit(1)

def loadOppositeEventsTable():
    resources_dirs = os.environ["DYNAWO_RESOURCES_DIR"].split(":")
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
    return dicOppEvents

def parseXml(filepath, timeline):
    try:
        (root, ns, prefix) = ImportXMLFileExtended(filepath)
    except:
        print ("Fail to import XML file " + filepath)
        sys.exit(1)

    for event_timeline in FindAll(root, prefix, "event", ns):
        event = Event()
        time = float(event_timeline.attrib['time'])
        event.time = time
        event.model = event_timeline.attrib['modelName'].strip()
        event.event = event_timeline.attrib['message'].rstrip().lstrip()
        if 'priority' in event_timeline.attrib:
            event.priority = event_timeline.attrib['priority'].rstrip().lstrip()
        timeline.add_event(event)

def parseTxt(filepath, timeline):
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

def parseFile(filename, infile = None):
    timeline = Timeline()
    if getFileType(filename) == "XML":
        if infile is not None:
            parseXml(infile, timeline)
        else:
            parseXml(filename, timeline)
    elif getFileType(filename) == "TXT":
        if infile is not None:
            parseTxt(infile, timeline)
        else:
            parseTxt(filename, timeline)
    return timeline

def checkOptions(options):
    if (options.timeline_file is None):
        print("[ERROR] parameter '--timelineFile' is missing.")
        exit(1)
    if (not os.path.isfile(options.timeline_file)):
        print("[ERROR] " +options.timeline_file+" not found.")
        exit(1)

def filterZipContent(filename, dicOppositeEvents, modelsToKeep):
    os.rename(filename, filename.replace('.zip','')+('_old.zip'))
    new_name= filename.replace('.zip','')+('_old.zip')
    with zipfile.ZipFile(new_name) as inzip, zipfile.ZipFile(filename, "w") as outzip:
        for inzipinfo in inzip.infolist():
            with inzip.open(inzipinfo) as infile:
                if "timeline" in inzipinfo.filename:
                    timeline = parseFile(inzipinfo.filename, infile)
                    timeline.filterTimeLine(inzipinfo.filename.replace('/',''), dicOppositeEvents, modelsToKeep, inzipinfo.filename.replace('/',''))
                    outzip.write(inzipinfo.filename.replace('/',''), inzipinfo.filename)
                    os.remove(inzipinfo.filename.replace('/',''))
                else:
                    outzip.writestr(inzipinfo.filename, infile.read())
    os.remove(new_name)

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

    checkOptions(options)
    checkEnvVar()

    filename = options.timeline_file
    modelsToKeep = options.models

    dicOppEvents = loadOppositeEventsTable()
    if getFileType(filename) == "TXT" or getFileType(filename) == "XML":
        timeline = parseFile(filename)
        timeline.filterTimeLine(filename, dicOppEvents, modelsToKeep)
    elif getFileType(filename) == "ZIP":
        filterZipContent(filename, dicOppEvents, modelsToKeep)


if __name__ == "__main__":
    main(sys.argv[1:])
