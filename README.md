# YOLOv5 on Triton Inference Server or Deepstream with TensorRT

This repository shows how to deploy YOLOv5 as an optimized [TensorRT] engine to [Triton Inference Server] and [Deepstream].

This project is based on (https://github.com/wang-xinyu/tensorrtx)  
This project is based on (https://github.com/NVIDIA/triton-inference-server)  
This project is based on (https://github.com/marcoslucianops/DeepStream-Yolo)  
This project is based on (https://github.com/ultralytics/yolov5)  

### Requirements

* [Ubuntu] 20.04
* [python]	>=3.6.9<3.7
* [docker-ce]	>19.03.5	
* [nvidia-container-toolkit] >1.3.0-1	
* [nvidia-container-runtime]	3.4.0-1	
* [nvidia-docker2]	2.5.0-1	
* [nvidia-driver]	> 515	
* [python-pip]	> 21.06	

### Build docker from Dockerfile

This docker is needed to deploy yolov5 on Triton or Deepstream

```bash
cd Yolov5-NVIDIA
docker build -t tensorrt-22.07-py3-opencv4:latest -f tensorrt.Dockerfile .
```

Docker will download the TensorRT container. You need to select the version (in this case 22.07) according to the version of Triton that you want to use later to ensure the TensorRT versions match. Matching NGC version tags use the same TensorRT version.

> **_NOTE:_**  Your installed CUDA version has to be >= to the one of the docker container.

### Getting started

* [YOLOv5 Deepstream usage](deepstream/)
* [YOLOv5 Triton usage](triton-deploy/)


