import logging
from colorlog import ColoredFormatter

def setup_logging():

    # Define the format for colored output
    color_formatter = ColoredFormatter(
        "%(asctime)s - %(name)-20s - %(log_color)s%(levelname)s%(reset)s -- %(message)s",
        datefmt='%Y-%m-%d %H:%M:%S',
        log_colors={
            'DEBUG': 'cyan',
            'INFO': 'green',
            'WARNING': 'yellow',
            'ERROR': 'red',
            'CRITICAL': 'bold_red',
        }
    )

    # Apply the formatter to the handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(color_formatter)

    # Configure the logging
    logging.basicConfig(
        level=logging.INFO,  # Set the default logging level
        handlers=[
            # logging.FileHandler("app.log"),  # Log to a file
            console_handler  #  Log to console
        ]
    )
