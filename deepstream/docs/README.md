# YOLOv5 on Deepstream with TensorRT

* [NGC Docker requirements](#ngc-docker-requirements)
* [Run the deepstream docker](#run-the-deepstream-docker)
* [Convert model](#convert-model)
* [Compile the lib](#compile-the-lib)
* [Edit the config_infer_primary_yoloV5 file](#edit-the-config_infer_primary_yolov5-file)
* [Edit the deepstream_app_config file](#edit-the-deepstream_app_config-file)
* [Testing the model](#testing-the-model)

### NGC Docker requirements

> **_NOTE:_**  Your system CUDA version has to be >= to the one of the docker container. Choose the docker version accordingly.

You will need this docker images for NGC catalog (remember to login with your ngc account)

```bash
docker login nvcr.io

Username: $oauthtoken
Password: <Your Key>

docker pull nvcr.io/nvidia/deepstream:6.1.1-devel
```

### Run the deepstream docker

Open an terminal

```bash
bash run_deepstream.sh
```

You need to edit the run_deepstream.sh selecting the correct version of the docker container (in this case 6.1.1). This script will run the Deepstream docker.

### Convert model to wts and compile the lib

Run the following to convert yolov5 model to wts and compile the lib using builded TensorRT container:

```bash
cd YoloV5-NVIDIA
bash launch_wts.sh yolov5n
```

Or inside the container the following will run:
```bash
bash convert_wts.sh yolov5n
```
You need to select the  yolov5 version (in this case yolov5n) according to the version you want to convert. This will generate a file called `yolov5n.wts` and `yolov5n.cfg`. Together with `libnvdsinfer_custom_impl_Yolo.so` we can now deploy to Deepstream.

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

### Edit the deepstream_app_config file

```
...
[primary-gie]
...
config-file=config_infer_primary_yoloV5.txt
```

### Testing the model

```
docker exec -it deepstream bash
cd YoloV5-NVIDIA/deepstream
deepstream-app -c deepstream_app_config.txt
```
