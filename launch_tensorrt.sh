model=$1

docker run --name=yolov5_trt_convert --rm -it --gpus '"device=0"' -v ${PWD}:/workspace tensorrt-py3-opencv4 convert_trt.sh $model
