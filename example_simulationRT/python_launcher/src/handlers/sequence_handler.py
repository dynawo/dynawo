from typing import List
from lxml import etree

from handlers.xml_handler import XmlHandler
from utils import JOBS_XSD_PATH

class ModData:
    par_file: str
    set_id: str
    par_name: str
    par_value: str|int|float

class StepData:
    stop_time: int
    mods: List[ModData]

    def __init__(self):
        self.mods = []

class SequenceHandler(XmlHandler):

    XSD_FILE = None

    def get_sequence(self):
        sequence: list[StepData] = []
        for step_elem in self._tree.findall("step"):
            step = StepData()
            step.stop_time = int(step_elem.attrib["stopTime"])
            sequence.append(step)
            for mod_elem in step_elem.findall("mod"):
                mod = ModData()
                step.mods.append(mod)
                mod.par_file = mod_elem.attrib["file"]
                mod.set_id = mod_elem.attrib["id"]
                mod.par_name = mod_elem.attrib["name"]
                mod.par_value = mod_elem.attrib["value"]
        return sequence
