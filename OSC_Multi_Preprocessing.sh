# get directory from this file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# get working directory from argument
workdir=$1
cd $workdir

# create a process directory if it doesn't exist
if [ ! -d "process" ]; then
    mkdir process
fi

# get subdirectories in the working directory
nights=($(ls $workdir))

# define counter for calibrated light frames
counter=0

# Loop through each night
for night in "${nights[@]}"; do
    
    # Skip if the directory is not a directory
    if [ ! -d $night ]; then
        continue
    fi

    cd $night

    # Skip if the directory has no biases, darks, flats, or lights subdirectories
    if [ ! -d "biases" ] || [ ! -d "darks" ] || [ ! -d "flats" ] || [ ! -d "lights" ]; then
        echo "No biases, darks, flats, or lights subdirectories found in ${night}. Skipping..."
        cd ..
        continue
    fi

    # Calibrate the light frames
    echo "Calibrating like frames from directory: ${night}"
    siril -s $DIR/calibration.ssf -d "."

    # move the calibration files to the processed_lights directory
    # and rename them to pp_light_<counter>.fit
    echo "Moving calibrated light frames to the process directory"
    for file in process/pp_light_*.fit; do
        if [ -f $file ]; then
            mv $file ../process/pp_light_${counter}.fit
            counter=$((counter+1))
            echo "Moved ${file} to ../process/pp_light_${counter}.fit"
        fi
    done

    # removing the masters and process directories
    echo "Removing masters and process directories"
    rm -r masters
    rm -r process
    cd ..

done

# Stack the calibrated light frames
echo "Stacking calibrated light frames"
siril -s $DIR/stacking.ssf -d "."

# Removing process directory
echo "Removing process directory"
rm -r process

# Open the stacked file
echo "Done! Opening the stacked file"
siril result_*.fit