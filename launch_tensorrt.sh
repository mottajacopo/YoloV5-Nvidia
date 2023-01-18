model=$1

sudo docker run --name=yolov5_trt_convert --rm -it --gpus '"device=0"' -v ${PWD}:/workspace tensorrt-22.07-py3-opencv4:latest convert_trt.sh $model
