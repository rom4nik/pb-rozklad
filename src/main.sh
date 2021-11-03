#!/bin/bash
# load config file with env variables
source $1

# prepare data directory
mkdir -p /data/workdir 
if [ $ARCHIVE_LOCAL = true ]; then mkdir -p /data/archive; fi


cd /data/workdir
# check if PDF exists on webserver
http_status=$(curl -o /dev/null -LIsw "%{http_code}" $PDF_URL)
if [ $http_status -ne 200 ]; then
    echo "Error: server returned status code" $http_status
    exit 1
fi
# if PDF exists, download it
curl -so "current.pdf" $PDF_URL

# check if PDF for previous schedule exists, compare with current if it does
if [ -r "previous.pdf" ]; then
    diff "previous.pdf" "current.pdf"
    diff_exitcode=$?
    if [ $diff_exitcode -eq 0 ]; then # PDFs are the same
        rm "current.pdf"
        exit 0
    elif [ $diff_exitcode -ne 1 ]; then # some error thrown
        echo "Diff exited with code" $diff_exitcode
        exit 1
    fi
else
    # PDF for previous schedule doesn't exist
    # don't create a comparison image, send PNG of only the current PDF
    diff_exitcode=-1
fi

# create a PNG of current PDF
convert -flatten -density 400 "current.pdf" "current.png"
convert_exitcode=$?
# if convert fails
if [$convert_exitcode -ne 0]; then
    echo "Current PDF might be damaged, convert exited with code" $convert_exitcode
    rm "current.pdf"
    exit 1
fi

# if current and previous PDFs differ
if [ $diff_exitcode -eq 1 ]; then
	convert -flatten -density 400 "previous.pdf" "previous.png"
    # important order of arguments: current PNG will be the background,
    # parts of it where blocks were added or removed will appear with a red overlay
	compare "current.png" "previous.png" "comparison.png"
fi

# create a symlink of current PDF with a nicer name for upload and local archive
pdf_nice="$(date $PDF_DATE_FORMAT)"
ln -s "current.pdf" $pdf_nice

if [ $DC_ENABLED = true ]; then
    export DC_WEBHOOK DC_MESSAGE pdf_nice diff_exitcode
    bash /app/msg_discord.sh
fi

if [ $FB_ENABLED = true ]; then
    export FB_THREAD_ID FB_MESSAGE pdf_nice diff_exitcode
    node /app/msg_facebook/msg_facebook.js
fi

if [ $MX_ENABLED = true ]; then
    export MX_ROOM_ID MX_MESSAGE pdf_nice diff_exitcode
    bash /app/msg_matrix.sh
fi

# TODO: check if that still works
if [ $ARCHIVE_WAYBACK = true ]; then
    curl -o /dev/null "https://web.archive.org/save/$PDF_URL" -w %{url_effective} -Ls
fi
if [ $ARCHIVE_LOCAL = true ]; then
    cp $pdf_nice "/data/archive/"
fi

# cleanup
rm "current.png"
if [ $diff_exitcode -eq 1 ]; then
    rm "previous.png" "comparison.png"
fi
rm $pdf_nice
mv "current.pdf" "previous.pdf"
