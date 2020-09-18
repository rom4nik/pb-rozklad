#!/bin/bash
if (( $# != 1 )); then
    echo "Usage:"
    echo $0 "config-file"
    exit 1
fi
source $1

if [ "$DOCKER" = true ]; then
    script_path="/pb-rozklad"
    cd /data
else
    script_path=$(dirname $(realpath $0))
    cd $script_path
    cd "data"
fi
mkdir -p "workdir" 
if [ $ARCHIVE_LOCAL = true ]; then mkdir -p "archive"; fi
cd "workdir"


http_status=$(curl -o /dev/null -LIsw "%{http_code}" $PDF_URL)
if [ $http_status -ne 200 ]; then
    echo "Error: server returned status code" $http_status
    exit 1
fi
curl -o "current.pdf" $PDF_URL -s

if [ -r "previous.pdf" ]; then
    diff "previous.pdf" "current.pdf"
    diff_exitcode=$?
    if [ $diff_exitcode -eq 0 ]; then
        rm "current.pdf"
        exit 0
    elif [ $diff_exitcode -ne 1 ]; then
        echo "Diff exited with code" $diff_exitcode
        exit 1
    fi
else
    diff_exitcode=-1
fi

convert -flatten -density 400 "current.pdf" "current.png"
if [ $diff_exitcode -eq 1 ]; then
	convert -flatten -density 400 "previous.pdf" "previous.png"
	compare "current.png" "previous.png" "comparison.png"
fi

# nicer name for Discord upload and local archive
pdf_nice="$(date $PDF_DATE_FORMAT)"
ln -s "current.pdf" $pdf_nice

if [ $DC_ENABLED = true ]; then
    export DC_WEBHOOK DC_MESSAGE pdf_nice diff_exitcode
    bash $script_path"/msg_discord.sh"
fi
if [ $FB_ENABLED = true ]; then
    export FB_ENABLED FB_EMAIL FB_PASS FB_TOTP FB_GROUP_ID FB_MESSAGE diff_exitcode
    #source $script_path"/venv/bin/activate"
    python3 $script_path"/msg_facebook.py"
fi

if [ $ARCHIVE_WAYBACK = true ]; then
    curl -o /dev/null "https://web.archive.org/save/$ROZKLAD_URL" -w %{url_effective} -Ls
fi
if [ $ARCHIVE_LOCAL = true ]; then
    if [ "$DOCKER" = true ]; then
        cp $pdf_nice "/data/archive/"
    else
        cp $pdf_nice $script_path"/data/archive/"
    fi
fi

# cleanup
rm "current.png"
if [ $diff_exitcode -eq 1 ]; then
    rm "previous.png" "comparison.png"
fi
rm $pdf_nice
mv "current.pdf" "previous.pdf"