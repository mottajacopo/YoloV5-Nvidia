#!/bin/bash

model=$1
last_letter="${model: -1}"

cd /workspace

wget https://github.com/ultralytics/yolov5/releases/download/v6.1/$model.pt -P /workspace/yolov5 -O /workspace/yolov5/$model.pt

cp tensorrtx/yolov5/gen_wts.py yolov5

cd /workspace/yolov5

# pip install -r requirements.txt

python /workspace/yolov5/gen_wts.py -w /workspace/yolov5/$model.pt -o /workspace/yolov5/$model.wts

echo "Successfully converted medel to wts"

cd /workspace/tensorrtx/yolov5

#rm -rf /workspace/tensorrtx/yolov5/build

mkdir -p /workspace/tensorrtx/yolov5/build

cd /workspace/tensorrtx/yolov5/build
# update CLASS_NUM in yololayer.h if your model is trained on custom dataset
cp /workspace/yolov5/$model.wts /workspace/tensorrtx/yolov5/build
cmake ..
make -j16

# changes the last letter of the model to use as argument
/workspace/tensorrtx/yolov5/build/yolov5 -s /workspace/tensorrtx/yolov5/build/$model.wts /workspace/tensorrtx/yolov5/build/$model.engine $last_letter

echo "Successfully converted medel to tensorrt"
#exec "$@"
