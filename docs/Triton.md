# YOLOv5 on Triton Inference Server with TensorRT

* [Build TensorRT engine](#build-tensort-engine)
* [Build TensorRT engine](#build-tensorrt-engine)
* [Start Triton Server](#start-triton-server)
* [Client](#client)
* [Benchmark](#benchmark)

You will need this docker images for NGC catalog (remember to login with your ngc account)

```bash
docker login nvcr.io

Username: $oauthtoken
Password: <Your Key>

docker pull nvcr.io/nvidia/tritonserver:22.07-py3-sdk
docker pull nvcr.io/nvidia/tritonserver:22.07-py3
```


### Build docker from Dockerfile
```bash
cd tensorrt-triton-yolov5
sudo docker build -t baohuynhbk/tensorrt-22.07-py3-opencv4:latest -f tensorrt.Dockerfile .
```

Docker will download the TensorRT container. You need to select the version (in this case 22.07) according to the version of Triton that you want to use later to ensure the TensorRT versions match. Matching NGC version tags use the same TensorRT version.


## Convert model to TensorRT engine and compile the lib 

Run the following to get a running TensorRT container with our repo code:

```bash
cd tensorrt-triton-yolov5
bash launch_tensorrt.sh yolov5n
```

Or inside the container the following will run:
```bash
bash convert_tet.sh yolov5n
```
You need to select the  yolov5 version (in this case yolov5n) according to the version you want to convert. This will generate a file called `yolov5n.engine`, which is our serialized TensorRT engine. Together with `libmyplugins.so` we can now deploy to Triton Inference Server.

## Deploy to Triton Inference Server

### Start Triton Server

Open an terminal

```bash
bash run_triton.sh
```

You need to edit the run_triton.sh selecting the correct version of the docker container (in this case 22.07) and yolov5 models. This script will run the Triton server docker.

### Client
Should install tritonclient first (better if insider a python virtualenv):
```bash
mkvirtualenv triton_dev
workon triton_dev

sudo apt update
sudo apt install libb64-dev

pip install nvidia-pyindex
pip install tritonclient[all]
```
Open another terminal.
This repo contains a python client.

Inference on image:
```bash
cd triton-deploy/clients/python
python client.py -m yolov5n -o data/dog_result.jpg image data/dog.jpg
```

Inference on video:
```bash
cd triton-deploy/clients/python
python client.py -m yolov5n -o data/TownCentre_result.mp4 video data/TownCentre.mp4
```

### Benchmark

To benchmark the performance of the model, we can run [Tritons Performance Client](https://docs.nvidia.com/deeplearning/triton-inference-server/user-guide/docs/optimization.html#perf-client).

To run the perf_client, run the Triton Client SDK docker container (tritonserver:22.07-py3-sdk), which ships with perf_client as a preinstalled binary.

```bash
docker run -it --rm --ipc=host --net=host nvcr.io/nvidia/tritonserver:22.07-py3-sdk perf_client -m yolov5m -u 127.0.0.1:8221 -i grpc --shared-memory system --concurrency-range 1:4
```

Concurrency is the number of concurrent clients invoking inference on the Triton server via grpc.
Results are total frames per second (FPS) of all clients combined and average latency in milliseconds for every single respective client.

Alternatively you can run the python client with a dummy input to test a more realistic situation. This will run inference for 10 seconds and print FPS.

Inference on dummy:
```bash
cd triton-deploy/clients/python
python client.py -m yolov5n dummy
```
