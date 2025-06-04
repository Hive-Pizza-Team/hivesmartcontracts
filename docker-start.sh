#!/bin/bash

sleep 2
mongo mongodb://mongo --eval "rs.initiate();"
mongo mongodb://mongo --eval "rs.status();"
mongo mongodb://mongo --eval "db.adminCommand({setParameter:1, internalQueryMaxBlockingSortMemoryUsageBytes:2097152000});"
mongo mongodb://mongo --eval "db.adminCommand({setParameter: 1, transactionLifetimeLimitSeconds: 120})"

if [[ !$RESTORE_PARTIAL && $(node find_divergent_block.js) =~ "divergent" ]]; then
    echo "*** ERROR! Node has diverged - need to restart with RESTORE_PARTIAL=1" >&2
else
    echo "*** SUCCESS! Divergence check passed. ***"
fi

echo RESTORE_PARTIAL=$RESTORE_PARTIAL
# if database restore is requested
if [[ "${RESTORE_PARTIAL}" ]]; then
    node --max-old-space-size=4096 restore_partial.js -d
fi

node --max-old-space-size=4096 app.js