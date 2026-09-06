#!/bin/sh
# memwatch.sh LIMIT_MB LOG -- logs RSS of every python process matching our jobs every 20 s;
# kills any one past LIMIT_MB so a leak cannot take the machine down again.
LIMIT=$1; LOG=$2
while true; do
  ps -axo pid=,rss=,command= | grep -E "puffer train|tandoor_design_mcts|tandoor_design_readout|ckpt_compare" | grep -v grep | while read pid rss cmd; do
    mb=$((rss/1024)); echo "$(date +%H:%M:%S) pid $pid rss ${mb}MB $(echo "$cmd" | cut -c1-70)" >> $LOG
    if [ $mb -gt $LIMIT ]; then echo "$(date +%H:%M:%S) KILL pid $pid at ${mb}MB (limit ${LIMIT})" >> $LOG; kill $pid; fi
  done
  sleep 20
done
