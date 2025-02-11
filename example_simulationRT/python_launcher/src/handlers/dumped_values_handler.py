import logging
import re


logger = logging.getLogger(__name__)

class DumpedValueData:
    def __init__(self, name, data_type, values) -> None:
        self.name = name
        self.type = data_type
        self.values = values

    def __str__(self):
        return f"{self.name} ({self.type}): {self.values}"

class DumpedValuesHandler:
    PATTERN_TITLE =  " ====== (.*) VALUES ======"

    def __init__(self, dumped_values_file) -> None:

        self._dumped_values_file = dumped_values_file
        self.data = self._extract_values_from_file()


    def _extract_values_from_file(self):
        # Regular expression to capture the first substring and all numeric values
        pattern_title = r'======\s*(.*?)\s*VALUES\s*======'
        # pattern_data = r'^(\S+)(.*?([-+]?\d*\.\d+|\d+))*'
        pattern_value = r'.*?([-+]?\d*\.\d+|\d+).*?'

        # Dictionary to store results with the first substring as keys
        results = []
        data_type = None
        # Open the file and read it line by line
        with open(self._dumped_values_file, 'r') as file:
            for line in file:
                title_match = re.findall(pattern_title, line)
                if len(title_match) > 0:
                    data_type = title_match[0]
                    continue
                if data_type is None:
                    msg = "Error: could not parse dumped values handler, value type header is missing"
                    logger.error(msg)
                    raise RuntimeError(msg)
                items = line.split("=")
                name = items[0].split()[0]
                values = [match for k in items[1:] for match in re.findall(pattern_value, k)]
                if len(values) > 0:
                    results.append(DumpedValueData(name, data_type, values))

        return results

    def get_dvd_by_type(self, data_type:str):
        return [e for e in self.data if e.type == data_type]
