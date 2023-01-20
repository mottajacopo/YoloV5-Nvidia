model=$1

docker run --name=yolov5_wts_convert --rm -it --gpus '"device=0"' -v ${PWD}:/workspace tensorrt-22.07-py3-opencv4:latest convert_wts.sh $model
