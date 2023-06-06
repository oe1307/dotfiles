import atexit
import os
import readline

histfile = os.path.join(os.path.expanduser("~"), ".local/state/python_history")
os.makedirs(os.path.dirname(histfile), exist_ok=True)
try:
    readline.read_history_file(histfile)
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)
