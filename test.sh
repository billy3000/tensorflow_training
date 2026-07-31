#!/bin/bash
#$ -cwd
#$ -l gpu_1=1
#$ -N gpu_read
#$ -l h_rt=0:3:00

USER_HOME="$HOME"
USER_WORK="${USER_HOME/home/work}"
OUTPUT_DIR="${USER_WORK}/containers"
OUTPUT_SIF="${OUTPUT_DIR}/tf_2.20_jupyter.sif"

apptainer exec --nv $OUTPUT_SIF python3 -c "
import tensorflow as tf
import tensorboard
import pandas
import sklearn
import scipy
import matplotlib
print('--- Import Check OK ---')
print('TensorFlow Version:', tf.__version__)
print(tf.config.list_physical_devices('GPU'))
"