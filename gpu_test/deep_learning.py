import sys
import time

from torch import Tensor
from torch.nn import CrossEntropyLoss as CEloss
from torch.nn import Module
from torch.optim import SGD, Optimizer
from torch.utils.data import DataLoader, Dataset
from torchvision.datasets import ImageNet
from torchvision.models import get_model, get_weight

from utils import nvidia_smi, save_result

BATCH_SIZE_SEARCH = 50
MARGIN = 500
NUM_WORKERS = 5
EPOCH = 10
MODEL = "resnet50"
WEIGHT = "ResNet50_Weights.DEFAULT"


def main(device):
    result = {}

    # Load model
    print("Model Loading...")
    model = get_model(MODEL, weights="DEFAULT")
    model = model.to(device)
    transform = get_weight(WEIGHT).transforms()
    criterion = CEloss()
    optimizer = SGD(model.parameters(), lr=1e-3)
    print("Model Loaded")

    # Load dataset
    print("Dataset Loading...")
    dataset = ImageNet(root="storage", split="val", transform=transform)
    batch_size, gpu_info = set_batch_size(model, dataset, criterion, optimizer, device)
    dataloader = DataLoader(dataset, batch_size, num_workers=NUM_WORKERS, shuffle=True)
    print("Dataset Loaded")

    # training
    print("Training Start")
    timekeeper = time.time()
    train(model, dataloader, criterion, optimizer, device)
    result["time"] = time.time() - timekeeper
    print("Training End")

    # save result
    result["test"] = "deep_learning"
    result["batch_size"] = batch_size
    result["used_memory"] = gpu_info["memory.used"]
    result["total_memory"] = gpu_info["memory.total"]
    result["num_workers"] = NUM_WORKERS
    result["model"] = MODEL
    result["device"] = device
    return result


def train(
    model: Module,
    dataloader: DataLoader,
    criterion: Module,
    optimizer: Optimizer,
    device: int,
):
    for epoch in range(EPOCH):
        for batch, (x, y) in enumerate(dataloader):
            print(f"\r{epoch = } {batch = }/{len(dataloader)}", end="")
            x, y = x.to(device), y.to(device)
            _train(model, x, y, criterion, optimizer, device)
        print(f"\r{epoch = } {batch = }/{len(dataloader)}")


def _train(
    model: Module,
    x: Tensor,
    y: Tensor,
    criterion: Module,
    optimizer: Optimizer,
    device: int,
):
    loss = criterion(model(x), y)
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
    gpu_info = nvidia_smi(device)
    del loss
    return gpu_info


def set_batch_size(
    model: Module,
    dataset: Dataset,
    criterion: Module,
    optimizer: Optimizer,
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
        gpu_info = _train(model, x, y, criterion, optimizer, device)
        print(f"{batch_size = } -> {gpu_info['memory.used']} (MiB)")
        if 2 * gpu_info["memory.used"] - used_memory > total_memory - MARGIN:
            break
        else:
            used_memory = gpu_info["memory.used"]
            batch_size += BATCH_SIZE_SEARCH
    return batch_size, gpu_info


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise ValueError("Usage: python deep_learning.py [gpu|cpu|device_id]")
    elif sys.argv[1] == "cpu":
        device = "cpu"
    elif sys.argv[1].isdigit():
        device = int(sys.argv[1])
    else:
        raise ValueError("invalid device")
    result = main(device)
    save_result(result)
