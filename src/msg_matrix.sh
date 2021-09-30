#!/bin/bash

# workaround for matrix.sh storing config file in ~/.matrix.sh
HOME=/data/matrix.sh

/data/matrix.sh/matrix.sh --room=$MX_ROOM_ID --send "$MX_MESSAGE"
/data/matrix.sh/matrix.sh --room=$MX_ROOM_ID --file=/data/workdir/current.png --image
if [ $diff_exitcode -eq 1 ]; then /data/matrix.sh/matrix.sh --room=$MX_ROOM_ID --file=/data/workdir/comparison.png --image; fi
/data/matrix.sh/matrix.sh --room=$MX_ROOM_ID --file=/data/workdir/$pdf_nice
