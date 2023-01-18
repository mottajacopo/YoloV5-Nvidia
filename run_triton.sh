mkdir -p triton-deploy/models/yolov5n/1/
mkdir -p triton-deploy/models/yolov5s/1/
mkdir -p triton-deploy/models/yolov5m/1/
mkdir -p triton-deploy/models/yolov5l/1/
mkdir -p triton-deploy/models/yolov5x/1/
mkdir -p triton-deploy/plugins

cp tensorrtx/yolov5/build/yolov5n.engine triton-deploy/models/yolov5n/1/model.plan
cp tensorrtx/yolov5/build/yolov5s.engine triton-deploy/models/yolov5s/1/model.plan
cp tensorrtx/yolov5/build/yolov5m.engine triton-deploy/models/yolov5m/1/model.plan
cp tensorrtx/yolov5/build/yolov5l.engine triton-deploy/models/yolov5l/1/model.plan
cp tensorrtx/yolov5/build/yolov5x.engine triton-deploy/models/yolov5x/1/model.plan
cp tensorrtx/yolov5/build/libmyplugins.so triton-deploy/plugins/

docker run --gpus "device=0" --name tritonserver-22.07 --rm -it --shm-size=1g --ipc=host --ulimit memlock=-1 --ulimit stack=67108864 -p8220:8000 -p8221:8001 -p8222:8002 -v$(pwd)/triton-deploy/models:/models -v$(pwd)/triton-deploy/plugins:/plugins --env LD_PRELOAD=/plugins/libmyplugins.so nvcr.io/nvidia/tritonserver:22.07-py3 tritonserver --model-repository=/models --strict-model-config=false --grpc-infer-allocation-pool-size=16
