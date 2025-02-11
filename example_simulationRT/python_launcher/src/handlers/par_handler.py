import logging

from handlers.xml_handler import XmlHandler
from utils import PAR_XSD_PATH

logger = logging.getLogger(__name__)

class ParHandler(XmlHandler):
    XSD_FILE = PAR_XSD_PATH

    def modify_par(self, set_id, par_name, par_value):
        par_list = self._tree.findall(f"set[@id='{set_id}']/par[@name='{par_name}']", namespaces=self._nsmap)
        if len(par_list) == 0:
            msg = f"Parameter {set_id}::{par_name} not found in {self._file}"
            logger.error(msg)
            raise RuntimeError(msg)
        if len(par_list) > 1:
            msg = f"Parameter {set_id}::{par_name} is not unique in {self._file}"
            logger.error(msg)
            raise RuntimeError(msg)
        logger.info(
            f"Parameter update: file: {self._file.name}, set id: {set_id} par name: {par_name}, value: {par_value}")
        par_list[0].attrib["value"] = str(par_value)

    def get_values(self, set_id):
        par_list = self._tree.findall(f"set[@id='{set_id}']/par", namespaces=self._nsmap)
        par_dict = {}
        for p in par_list:
            par_dict[p.attrib["name"]] = p.attrib["value"]
        return par_dict
