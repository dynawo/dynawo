import logging

from handlers.xml_handler import XmlHandler
from models.events import EVENT_CLASS
from utils import DYD_XSD_PATH

logger = logging.getLogger(__name__)

class DydHandler(XmlHandler):
    XSD_FILE = DYD_XSD_PATH

    def get_events(self):
        event_list = self._tree.getroot().xpath('dyn:blackBoxModel[starts-with(@lib, "Event")]', namespaces=self._nsmap)
        event_dict = {}
        for e in event_list:
            event_dict[e.attrib["id"]] = EVENT_CLASS[e.attrib["lib"]](e.attrib["id"], e.get("parId"))
        return event_dict
