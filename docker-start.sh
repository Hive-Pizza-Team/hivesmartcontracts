#!/bin/bash
sleep 10

echo $RESTORE_PARTIAL
# if database restore is requested
if [[ "${RESTORE_PARTIAL}" ]]; then
    node --max-old-space-size=4096 restore_partial.js -d
fi

node --max-old-space-size=4096 app.js