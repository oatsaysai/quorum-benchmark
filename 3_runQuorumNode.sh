#!/bin/bash

if hash jq 2>/dev/null; then
  echo "JQ installed.. Proceeding...";
else
  echo "JQ is not installed.. Installing JQ.."
  sudo apt install jq
fi

jq -c '.[] | { id, user, ip}' server.json | while read i; do
  ID=`echo $i | jq -r .id`
  USER=`echo $i | jq -r .user`
  IP=`echo $i | jq -r .ip`

  echo "run docker quorum at node $ID"
  ssh -n $USER@$IP "docker rm quorum -f"
  ssh -n $USER@$IP "docker run -d -e 'NODE=$ID' --name quorum -p 22000:22000 -p 21000:21000 -p 54000:54000 -v ~/ethereum-benchmark/quorum_Node:/quorum_script quorum"
done

sleep 10