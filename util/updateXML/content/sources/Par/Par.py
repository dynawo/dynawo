import os
import lxml.etree

from ..utils.UpdateXMLExceptions import *


class Par:
    """
    Represents a Par file

    Attributes
    ----------
    _filename : str
        name of the Par file
    _partree : lxml.etree._ElementTree
        lxml ElementTree of par XML file
    """
    def __init__(self, filepath):
        """
        Parse the Par file

        Parameter:
            filepath (str): filepath of the Par file to parse
        """
        self._filename = os.path.basename(filepath)
        try:
            self._partree = lxml.etree.parse(filepath)
        except OSError as exc:
            raise ParFileDoesNotExistError(filepath) from exc
