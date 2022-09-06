#!/bin/bash
NGPUS=4
NNODES=1
MASTER=""
LOCAL_RANK=$PMI_RANK

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | sed 's/^[^=]*=//g'`
    if [[ "$VALUE" == "$PARAM" ]]; then
        shift
        VALUE=$1
    fi
    case $PARAM in
        --ngpus)
            NGPUS=$VALUE
        ;;
        --nnodes)
            NNODES=$VALUE
        ;;
        --master)
            MASTER=$VALUE
        ;;  
        *)
          echo "ERROR: unknown parameter \"$PARAM\""
          exit 1
        ;;
    esac
    shift
done

# CMD="python -m torch.distributed.launch --nnodes=$NNODES \
# --nproc_per_node=$NGPUS --node_rank=$LOCAL_RANK \
# --master_addr=$MASTER /work2/07980/sli4/frontera/ICICLE/yolov5/train.py \
# --batch-size -1 --data \
# /work2/07980/sli4/frontera/ICICLE/CameraTraps/detection/detector_training/experiments/megadetector_v5_yolo/test.yml \
# --weights /work2/07980/sli4/frontera/ICICLE/yolov5/runs/train/exp11/weights/last.pt  --save-period=10 --resume"
# echo $CMD
# $CMD

CMD="python -m torch.distributed.launch --nnodes=$NNODES \
--nproc_per_node=$NGPUS --node_rank=$LOCAL_RANK \
--master_addr=$MASTER /work2/07980/sli4/frontera/ICICLE/yolov5/train.py \
--batch-size 32 --data \
/work2/07980/sli4/frontera/ICICLE/CameraTraps/detection/detector_training/experiments/megadetector_v5_yolo/test.yml \
--weights /work2/07980/sli4/frontera/ICICLE/md_v5a.0.0.pt  --save-period=10 --imgsz 1280 \
--hyp=/work2/07980/sli4/frontera/ICICLE/CameraTraps/detection/detector_training/experiments/megadetector_v5_yolo/hyp_no_mosaic.yml"
echo $CMD
$CMD
