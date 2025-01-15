#!/bin/bash -l

#SBATCH --job-name=build_image
#SBATCH --time=01:00:00
#SBATCH --nodelist=nv178
#SBATCH --gres=gpu:1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH -o .build_image_%j.log

# Define variables
BASE_IMAGE="/purestorage/project/tyk/0_Software/sqsh/t21_ready.sqsh"       # Base enroot image name
OUTPUT_IMAGE="autodistill.sqsh" # Output image name
TEMP_CONTAINER="temp_container"     # Temporary container name

# Start the container
enroot create --name $TEMP_CONTAINER $BASE_IMAGE
enroot start --rw $TEMP_CONTAINER bash << EOF
pip install --no-cache-dir pip
pip install --no-cache-dir --user roboflow autodistill autodistill-grounded-sam autodistill-yolov8 supervision
pip uninstall opencv-python -y
pip install --no-cache-dir --user --upgrade numpy opencv-python==4.6.0.66
exit
EOF

# Export the container to a new image
enroot export --output $OUTPUT_IMAGE $TEMP_CONTAINER
enroot remove -f $TEMP_CONTAINER


# pip install --no-cache-dir pip
# pip install --no-cache-dir --user roboflow autodistill autodistill-grounded-sam autodistill-yolov8 supervision