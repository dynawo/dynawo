import logging
from lxml import etree

from handlers.xml_handler import XmlHandler
from utils import JOBS_XSD_PATH

logger = logging.getLogger(__name__)

class JobsHandler(XmlHandler):

    XSD_FILE = JOBS_XSD_PATH

    def set_initial_state(self, initial_state_file):
        initial_state_elem = self._tree.getroot().find("dyn:job/dyn:modeler/dyn:initialState", self._nsmap)
        if initial_state_elem is None:
            modeler_elem = self._tree.getroot().find("dyn:job/dyn:modeler", self._nsmap)
            precompiled_models_elem = modeler_elem.find("dyn:precompiledModels", self._nsmap)
            initial_state_elem = etree.Element(f"{{{self._nsmap['dyn']}}}initialState", nsmap=self._nsmap)
            modeler_elem.insert(modeler_elem.index(precompiled_models_elem), initial_state_elem)
        initial_state_elem.attrib["file"] = initial_state_file
        logger.info(f"Jobs initial state dmp set: {initial_state_file}")

    def set_iidm(self, iidm_file):
        network_elem = self._tree.getroot().find("dyn:job/dyn:modeler/dyn:network", self._nsmap)
        network_elem.attrib["iidmFile"] = iidm_file
        logger.info(f"Jobs IIDM set: {iidm_file}")

    def set_simulation_time(self, start, stop):
        simulation_start_elem = self._tree.getroot().find("dyn:job/dyn:simulation", self._nsmap)
        simulation_start_elem.attrib["startTime"] = str(start)
        simulation_start_elem.attrib["stopTime"] = str(stop)
        logger.info(f"Jobs simulation state set: startTime: {start}, stopTime: {stop}")
