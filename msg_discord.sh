#!/bin/bash
genpostdata () {
    cat << EOF
{"content": "$DC_MESSAGE"}
EOF
}

curl -o /dev/null -H "Content-Type: application/json" -d "$(genpostdata)" $DC_WEBHOOK -s
curl -o /dev/null -F "data=@current.png" $DC_WEBHOOK -s
if [ $diff_exitcode -eq 1 ]; then curl -o /dev/null -F "data=@comparison.png" $DC_WEBHOOK -s; fi
curl -o /dev/null -F "data=@"$pdf_nice $DC_WEBHOOK -s