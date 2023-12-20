import os
import platform
import subprocess
import time
from datetime import datetime

import torch


def nvidia_smi(device: int):
    """Get gpu information from nvidia-smi"""
    property = (
        "gpu_name",
        "index",
        "memory.total",
        "memory.used",
        "memory.free",
        "utilization.gpu",
        "utilization.memory",
    )
    cmd = f"nvidia-smi --query-gpu={','.join(property)} --format=csv,noheader,nounits"
    time.sleep(3)
    cmd_res = subprocess.check_output(cmd, shell=True)
    gpu_lines = cmd_res.decode().split("\n")
    gpu_lines = [line.strip() for line in gpu_lines if line.strip() != ""]
    gpu_info = [
        {k: v for k, v in zip(property, line.split(", "))} for line in gpu_lines
    ]
    gpu_info = gpu_info[device]
    gpu_info["memory.total"] = int(gpu_info["memory.total"])
    gpu_info["memory.used"] = int(gpu_info["memory.used"])
    return gpu_info


def save_result(result: dict):
    """Save the result of the experiment"""
    os.makedirs("result", exist_ok=True)
    hostname = os.uname()[1]
    git_hash = subprocess.check_output(["git", "rev-parse", "HEAD"]).decode().strip()
    with open(f"result/{hostname}.txt", "a+") as file:
        print("", file=file)
        print("date:", datetime.now().strftime("%Y-%m-%d_%H:%M:%S"), file=file)
        print("test:", result["test"], file=file)
        print("os:", os.uname()[0], file=file)
        print("hostname:", hostname, file=file)
        print("compiler:", os.uname()[4], file=file)
        print("python version:", platform.python_version(), file=file)
        print("num_workers:", result["num_workers"], file=file)
        print("model:", result["model"], file=file)
        print("device:", result["device"], file=file)
        print("cuda version:", torch.version.cuda, file=file)
        print("git hash:", git_hash[:7], file=file)
        print("torch version:", torch.__version__, file=file)
        print("batch_size:", result["batch_size"], file=file)
        print("memory:", result["used_memory"], file=file, end="")
        print(" /", result["total_memory"], "(MiB)", file=file)
        print(f"time: {result['time']:.2f} (sec)", file=file)
        print("", file=file)
        print("-" * 20, file=file)
