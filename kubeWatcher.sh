

# set -eu

function _kubeExecuteKubeCommand(){
    eval "kubectl get pods -A --field-selector=metadata.namespace!=kube-system -o JSON"
}

function getPods(){
    _kubeExecuteKubeCommand | jq -c ' [.items[].metadata | {podName: .name , createdAt: .creationTimestamp}]'
}

function _getDiff(){
    state1=$1
    state2=$2
    echo $state1 | jq -cr ". - $state2"
}

function getNewPods(){
    newState=$1
    previousState=$2
    createdPods=$(_getDiff $previousState $newState )
    echo "CreateReport"
    echo "$createdPods" 
}

function getDeletedPods(){
    previousState=$1
    newState=$2
    removedPods=$(_getDiff $previousState $newState)
    echo "DeletedPods"
    echo "$removedPods" 
}

function kubeWatcher(){  
    pollInterval=$1
    lastPodPoll=$(getPods)
    echo "initial "
    echo $lastPodPoll
    while true 
    do
        newPollResult=$(getPods)
        getNewPods $lastPodPoll $newPollResult
        getDeletedPods $lastPodPoll $newPollResult
        sleep $pollInterval
        lastPodPoll=$newPollResult
    done
}
