#!/bin/bash

model=$1
last_letter="${model: -1}"

cd /workspace

wget https://github.com/ultralytics/yolov5/releases/download/v6.1/$model.pt -P /workspace/yolov5 -O /workspace/yolov5/$model.pt

cp deepstream/utils/gen_wts_yoloV5.py yolov5

cd /workspace/yolov5

# pip install -r requirements.txt

python /workspace/yolov5/gen_wts_yoloV5.py -w /workspace/yolov5/$model.pt

echo "Successfully converted medel to wts"

cp $model.wts $model.cfg /workspace/deepstream

cd /workspace/deepstream

#rm -rf /workspace/tensorrtx/yolov5/build

CUDA_VER=11.7 make -C nvdsinfer_custom_impl_Yolo

echo "Successfully compiled the lib"

#exec "$@"
