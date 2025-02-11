import logging

from handlers.xml_handler import XmlHandler
from utils import TL_XSD_PATH

logger = logging.getLogger(__name__)

class TimelineHandler(XmlHandler):

    XSD_FILE = TL_XSD_PATH

    def absorb(self, other_tl_file):
        tl_handler = TimelineHandler(other_tl_file)
        events_sorted = sorted(list(self._tree.getroot().getchildren() + list(tl_handler._tree.getroot().getchildren())), key=lambda e: float(e.get('time')))
        self._tree.getroot().clear()
        for e in events_sorted:
            self._tree.getroot().append(e)
