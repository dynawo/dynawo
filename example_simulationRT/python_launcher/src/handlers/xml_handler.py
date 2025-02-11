from abc import ABC
import os
from pathlib import Path
from lxml import etree

class XmlHandler(ABC):

    XSD_FILE = None

    def __init__(self, xml_file: Path):

        if not os.path.isfile(xml_file):
            return FileExistsError("Job file {job_file} does not exist")

        self._file: Path = xml_file

        if self.XSD_FILE is None:
            parser = etree.XMLParser()
        else:
            schema_root = etree.parse(self.XSD_FILE)
            schema = etree.XMLSchema(schema_root)

            parser = etree.XMLParser(schema = schema)

        self._tree = etree.parse(self._file, parser=parser)
        self._nsmap = self._tree.getroot().nsmap
        self._nsmap["dyn"] = "http://www.rte-france.com/dynawo" # For RTE exported cases where "dyn" is None

    def flush_to_file(self):
        self._tree.write(self._file)
