# CameraTraps
Inference:
Install and activate environment according to 
[CameraTraps github repo](https://github.com/microsoft/CameraTraps/blob/main/megadetector.md#using-the-model)

 
## Inference:
```
python detection/run_detector.py "path/to/md_v5a.0.0.pt" --image_file "path/to/img.jpg" --threshold 0.2 
```
 
## Train:

### Data Preprocessing
Split data: 1st answer in the [post](https://stackoverflow.com/questions/57394135/split-image-dataset-into-train-test-datasets)
 
[Coco to yolo](https://github.com/qwirky-yuzu/COCO-to-YOLO)

### Launch training
Single GPU:
```python train.py --data your_new_training_data.yaml --weights path/to/md_v5a.0.0.pt```
 
Multi-GPU single node:
[yolo tutorial](https://docs.ultralytics.com/tutorials/multi-gpu-training/) Chapter Multi-GPU DistributedDataParallel Mode:
pass 
```
python -m torch.distributed.launch --nproc_per_node
```
followed by the usual arguments.
 
Multi-node:
Use mpiexec.hydra in slurm to launch a bash script. Launch torch.distributed.launch in bash script:
```
mpiexec.hydra -np $NNODES -ppn 1 path/to/yolov5/train.sh \
--ngpus $GPU_PER_NODE --nnodes $NNODES --master $MAIN_RANK (in slurm)
```
```
python -m torch.distributed.launch --nnodes=$NNODES \
--nproc_per_node=$NGPUS --node_rank=$LOCAL_RANK \
--master_addr=$MASTER path/to/train.py –arguments (in train.sh)
```
 
Scripts I used to do data preprocess and training launching are in this repo
 
 
Training time:
300 epochs completed in 17.4 hours.
2 nodes, 8 gpus, batch size 32, imgzsz 1280
 
 
 
 

