xhost +

docker run --gpus all -it -d --name deepstream --net=host --privileged -v $(pwd):/opt/nvidia/deepstream/deepstream-6.1/YoloV5-NVIDIA -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -w /opt/nvidia/deepstream/deepstream-6.1 nvcr.io/nvidia/deepstream:6.1.1-devel