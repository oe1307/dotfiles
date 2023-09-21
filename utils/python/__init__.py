import os
import random
import traceback
from functools import wraps

from .color_print import ProgressBar, printc
from .config_parser import config_parser

config = config_parser()

__all__ = [
    "printc",
    "ProgressBar",
    "config_parser",
]


def rename_dir(dir_path):
    dir_name = dir_path.rstrip("/")
    count = 1
    dir_path = f"{dir_name}{count}/"
    while os.path.exists(dir_path):
        count += 1
        dir_path = f"{dir_name}{count}/"
    os.makedirs(dir_path, exist_ok=True)
    printc("cyan", f"[ SAVEDIR ] {dir_path}")
    return dir_path


def reproducibility(seed=0, use_numpy=True, use_torch=True):
    """Set random seed for reproducibility"""
    random.seed(seed)
    os.environ["PYTHONHASHSEED"] = str(seed)
    os.environ["CUBLAS_WORKSPACE_CONFIG"] = ":4096:8"
    if use_numpy:
        import numpy as np

        np.random.seed(seed)
    if use_torch:
        import torch

        torch.manual_seed(seed)
        torch.backends.cudnn.benchmark = False
        torch.backends.cudnn.deterministic = True

        # raise error if non-deterministic
        torch.use_deterministic_algorithms(True)


def save_error():
    def _save_error(function):
        @wraps(function)
        def wrapper(*args, **kwargs):
            try:
                return function(*args, **kwargs)
            except Exception as error:
                if not hasattr(config, "savedir"):
                    config.savedir = "../result"
                    os.makedirs(config.savedir, exist_ok=True)
                print(
                    traceback.format_exc(),
                    file=open(f"{config.savedir}/error.txt", "a+"),
                )
                raise error

        return wrapper

    return _save_error
