

### Getting started

* [Requirements](#requirements)
* [dGPU installation](#dgpu-installation)
* [Basic usage](#basic-usage)
* [Docker usage](#docker-usage)
* [Yolov5 usage](docs/Yolov5.md)

##

### Requirements

* [Ubuntu] 20.04
* [python]	>=3.6.9<3.7
* [docker-ce]	>19.03.5	
* [nvidia-container-toolkit] >1.3.0-1	
* [nvidia-container-runtime]	3.4.0-1	
* [nvidia-docker2]	2.5.0-1	
* [nvidia-driver]	> 515	
* [python-pip]	> 21.06	

#### DeepStream 6.1.1 on x86 platform using Docker

### Docker usage

* x86 platform

  ```
  docker login nvcr.io

  Username: $oauthtoken
  Password: <Your Key> 

  docker pull nvcr.io/nvidia/deepstream:6.1.1-devel

  xhost +

  docker run --gpus all -it -d --rm --name deepstream --net=host --privileged -v custom_path:/workspace -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -w /opt/nvidia/deepstream/deepstream-6.1 nvcr.io/nvidia/deepstream:6.1.1-devel

  ```

##

### Basic usage


#### 3. Compile the lib

* DeepStream 6.1.1 on x86 platform

  ```
  CUDA_VER=11.7 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.1 on x86 platform

  ```
  CUDA_VER=11.6 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.0.1 / 6.0 on x86 platform

  ```
  CUDA_VER=11.4 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.1.1 / 6.1 on Jetson platform

  ```
  CUDA_VER=11.4 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.0.1 / 6.0 on Jetson platform

  ```
  CUDA_VER=10.2 make -C nvdsinfer_custom_impl_Yolo
  ```

#### 4. Edit the `config_infer_primary.txt` file according to your model (example for YOLOv4)

```
[property]
...
custom-network-config=yolov4.cfg
model-file=yolov4.weights
...
```

#### 5. Run

```
deepstream-app -c deepstream_app_config.txt
```

**NOTE**: If you want to use YOLOv2 or YOLOv2-Tiny models, change the `deepstream_app_config.txt` file before run it

```
...
[primary-gie]
...
config-file=config_infer_primary_yoloV2.txt
...
```

##

### NMS Configuration

To change the `nms-iou-threshold`, `pre-cluster-threshold` and `topk` values, modify the config_infer file and regenerate the model engine file

```
[class-attrs-all]
nms-iou-threshold=0.45
pre-cluster-threshold=0.25
topk=300
```

**NOTE**: It is important to regenerate the engine to get the max detection speed based on `pre-cluster-threshold` you set.

**NOTE**: Lower `topk` values will result in more performance.

**NOTE**: Make sure to set `cluster-mode=2` in the config_infer file.

##

### INT8 calibration

#### 1. Install OpenCV

```
sudo apt-get install libopencv-dev
```

#### 2. Compile/recompile the `nvdsinfer_custom_impl_Yolo` lib with OpenCV support

* DeepStream 6.1.1 on x86 platform

  ```
  CUDA_VER=11.7 OPENCV=1 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.1 on x86 platform

  ```
  CUDA_VER=11.6 OPENCV=1 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.0.1 / 6.0 on x86 platform

  ```
  CUDA_VER=11.4 OPENCV=1 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.1.1 / 6.1 on Jetson platform

  ```
  CUDA_VER=11.4 OPENCV=1 make -C nvdsinfer_custom_impl_Yolo
  ```

* DeepStream 6.0.1 / 6.0 on Jetson platform

  ```
  CUDA_VER=10.2 OPENCV=1 make -C nvdsinfer_custom_impl_Yolo
  ```

#### 3. For COCO dataset, download the [val2017](https://drive.google.com/file/d/1gbvfn7mcsGDRZ_luJwtITL-ru2kK99aK/view?usp=sharing), extract, and move to DeepStream-Yolo folder

* Select 1000 random images from COCO dataset to run calibration

  ```
  mkdir calibration
  ```

  ```
  for jpg in $(ls -1 val2017/*.jpg | sort -R | head -1000); do \
      cp ${jpg} calibration/; \
  done
  ```

* Create the `calibration.txt` file with all selected images

  ```
  realpath calibration/*jpg > calibration.txt
  ```

* Set environment variables

  ```
  export INT8_CALIB_IMG_PATH=calibration.txt
  export INT8_CALIB_BATCH_SIZE=1
  ```

* Edit the `config_infer` file

  ```
  ...
  model-engine-file=model_b1_gpu0_fp32.engine
  #int8-calib-file=calib.table
  ...
  network-mode=0
  ...
  ```

    To

  ```
  ...
  model-engine-file=model_b1_gpu0_int8.engine
  int8-calib-file=calib.table
  ...
  network-mode=1
  ...
  ```

* Run

  ```
  deepstream-app -c deepstream_app_config.txt
  ```

**NOTE**: NVIDIA recommends at least 500 images to get a good accuracy. On this example, I used 1000 images to get better accuracy (more images = more accuracy). Higher `INT8_CALIB_BATCH_SIZE` values will result in more accuracy and faster calibration speed. Set it according to you GPU memory. This process can take a long time.

##

### Extract metadata

You can get metadata from DeepStream using Python and C/C++. For C/C++, you can edit the `deepstream-app` or `deepstream-test` codes. For Python, your can install and edit [deepstream_python_apps](https://github.com/NVIDIA-AI-IOT/deepstream_python_apps).

Basically, you need manipulate the `NvDsObjectMeta` ([Python](https://docs.nvidia.com/metropolis/deepstream/python-api/PYTHON_API/NvDsMeta/NvDsObjectMeta.html) / [C/C++](https://docs.nvidia.com/metropolis/deepstream/sdk-api/struct__NvDsObjectMeta.html)) `and NvDsFrameMeta` ([Python](https://docs.nvidia.com/metropolis/deepstream/python-api/PYTHON_API/NvDsMeta/NvDsFrameMeta.html) / [C/C++](https://docs.nvidia.com/metropolis/deepstream/sdk-api/struct__NvDsFrameMeta.html)) to get the label, position, etc. of bboxes.
