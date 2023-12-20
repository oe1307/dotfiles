import sys
import time

import torch
from torch import Tensor
from torch.nn import CrossEntropyLoss as CEloss
from torch.nn import Module
from torch.utils.data import DataLoader, Dataset
from torchvision.datasets import ImageNet
from torchvision.models import get_model, get_weight

from utils import nvidia_smi, save_result

BATCH_SIZE_SEARCH = 100
MARGIN = 500
NUM_WORKERS = 5
N_ITER = 100
MODEL = "resnet50"
WEIGHT = "ResNet50_Weights.DEFAULT"


def main(device: int):
    result = {}

    # Load model
    print("Model Loading...")
    model = get_model(MODEL, weights="DEFAULT")
    model = model.to(device)
    transform = get_weight(WEIGHT).transforms()
    criterion = CEloss(reduction="none")
    print("Model Loaded")

    # Load dataset
    print("Dataset Loading...")
    dataset = ImageNet(root="storage", split="val", transform=transform)
    batch_size, gpu_info = set_batch_size(model, dataset, criterion, device)
    dataloader = DataLoader(dataset, batch_size, num_workers=NUM_WORKERS)
    print("Dataset Loaded")

    # attack
    print("Attack Start")
    timekeeper = time.time()
    attack(model, dataloader, criterion, device)
    result["time"] = time.time() - timekeeper
    print("Attack End")

    # save result
    result["test"] = "adversarial_attack"
    result["batch_size"] = batch_size
    result["used_memory"] = gpu_info["memory.used"]
    result["total_memory"] = gpu_info["memory.total"]
    result["num_workers"] = NUM_WORKERS
    result["model"] = MODEL
    result["device"] = device
    return result


def attack(
    model: Module,
    dataloader: DataLoader,
    criterion: Module,
    device: int,
):
    model.eval()
    for batch, (x, y) in enumerate(dataloader):
        x, y = x.to(device), y.to(device)
        x_adv = x.clone().requires_grad_()
        for iter in range(N_ITER):
            print(f"\r{batch = } iter {iter + 1}/{N_ITER}", end="")
            loss = criterion(model(x_adv), y).sum()
            grad = torch.autograd.grad(loss, [x_adv])[0].detach()
            x_adv = x_adv - 0.01 * torch.sign(grad).clamp(0, 1)
            del loss, grad
        print(f"\r{batch = } iter {iter + 1}/{N_ITER}")


def _attack(
    model: Module,
    x: Tensor,
    y: Tensor,
    criterion: Module,
    device: int,
):
    model.eval()
    x = x.clone().requires_grad_()
    loss = criterion(model(x), y).sum()
    grad = torch.autograd.grad(loss, [x])[0].detach()
    gpu_info = nvidia_smi(device)
    del loss, grad
    return gpu_info


def set_batch_size(
    model: Module,
    dataset: Dataset,
    criterion: Module,
    device: int,
):
    gpu_info = nvidia_smi(device)
    total_memory = gpu_info["memory.total"]
    used_memory = total_memory - MARGIN
    batch_size = BATCH_SIZE_SEARCH
    while True:
        dataloader = DataLoader(dataset, batch_size, num_workers=NUM_WORKERS)
        x, y = next(iter(dataloader))
        x, y = x.to(device), y.to(device)
        gpu_info = _attack(model, x, y, criterion, device)
        print(f"{batch_size = } -> {gpu_info['memory.used']} (MiB)")
        if 2 * gpu_info["memory.used"] - used_memory > total_memory - MARGIN:
            break
        else:
            used_memory = gpu_info["memory.used"]
            batch_size += BATCH_SIZE_SEARCH
    return batch_size, gpu_info


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise ValueError("Usage: python adversarial_attack.py [gpu|cpu|gpu_id]")
    elif sys.argv[1] == "cpu":
        device = "cpu"
    elif sys.argv[1].isdigit():
        device = int(sys.argv[1])
    else:
        raise ValueError("invalid device")
    result = main(device)
    save_result(result)
