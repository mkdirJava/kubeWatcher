
set -eu

function _getInitialLoad(){
    cat "test/resources/initialLoadPods.json"
}

function _getCreatedPodsLoad(){
    cat "test/resources/getCreatedPods.json"
}

function _getDeletedPodsLoad(){
    cat "test/resources/getDeletedPods.json"
}
