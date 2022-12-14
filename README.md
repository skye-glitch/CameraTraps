# CameraTraps 
## Inference:
Install and activate environment, then run megadetector, follow the instrutions on
[CameraTraps github repo](https://github.com/microsoft/CameraTraps/blob/main/megadetector.md#using-the-model). This is the instruction to run megadetector
```
python detection/run_detector.py "path/to/md_v5a.0.0.pt" --image_file "path/to/img.jpg" --threshold 0.2 
```
 
## Training:

### Data Preprocessing
Split data into train and test set: 1st answer in the [post](https://stackoverflow.com/questions/57394135/split-image-dataset-into-train-test-datasets)
 
Data format conversion with this code: [Coco to yolo](https://github.com/qwirky-yuzu/COCO-to-YOLO)

### Launch training
Single GPU:
[yolo tutorial](https://docs.ultralytics.com/tutorials/multi-gpu-training/) Chapter Single GPU:
```
python train.py --data your_new_training_data.yaml --weights path/to/md_v5a.0.0.pt
```
 
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
300 epochs completed in 17.4 hours. If only validate final epoch, training time is 15.5 hours for 300 epochs.
2 nodes, 8 gpus, batch size 32, imgzsz 1280

Training statistics can be found in results.csv
 
 
 

