# YOLOv5 on Deepstream with TensorRT

* [Convert model](#convert-model)
* [Compile the lib](#compile-the-lib)
* [Edit the config_infer_primary_yoloV5 file](#edit-the-config_infer_primary_yolov5-file)
* [Edit the deepstream_app_config file](#edit-the-deepstream_app_config-file)
* [Testing the model](#testing-the-model)

You will need this docker images for NGC catalog (remember to login with your ngc account)

```bash
docker login nvcr.io

Username: $oauthtoken
Password: <Your Key>

docker pull nvcr.io/nvidia/deepstream:6.1.1-devel

xhost +

docker run --gpus all -it -d --rm --name deepstream --net=host --privileged -v path_to/repo_folder:/opt/nvidia/deepstream/deepstream-6.1/repo_folder -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -w /opt/nvidia/deepstream/deepstream-6.1 nvcr.io/nvidia/deepstream:6.1.1-devel
```

### Build docker from Dockerfile
```bash
cd tensorrt-triton-yolov5
sudo docker build -t tensorrt-22.07-py3-opencv4:latest -f tensorrt.Dockerfile .
```

Docker will download the TensorRT container. You need to select the version (in this case 22.07) according to the version of Triton that you want to use later to ensure the TensorRT versions match. Matching NGC version tags use the same TensorRT version.

##

### Convert model to wts and compile the lib

Run the following to get a running TensorRT container with our repo code:

```bash
cd tensorrt-triton-yolov5
bash launch_wts.sh yolov5n
```

Or inside the container the following will run:
```bash
bash convert_wts.sh yolov5n
```
You need to select the  yolov5 version (in this case yolov5n) according to the version you want to convert. This will generate a file called `yolov5n.wts` and `yolov5n.cfg`. Together with `libnvdsinfer_custom_impl_Yolo.so` we can now deploy to Deepstream.

##

### Edit the config_infer_primary_yoloV5 file

Edit the `config_infer_primary_yoloV5.txt` file according to your model (example for YOLOv5s)

```
[property]
...
custom-network-config=yolov5s.cfg
model-file=yolov5s.wts
model-engine-file=yolov5s.engine
...
```

##

### Edit the deepstream_app_config file

```
...
[primary-gie]
...
config-file=config_infer_primary_yoloV5.txt
```

##

### Testing the model

```
docker exec -it deepstream bash
cd /opt/nvidia/deepstream/deepstream-6.1/repo_folder/deepstream
deepstream-app -c deepstream_app_config.txt
```
