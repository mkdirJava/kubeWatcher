
set -eu
source "./kubeWatcher.sh"
source "./test/resources/kubeWatcher_tool_test.sh"

TEMPFILE=/tmp/$$.tmp
echo 1 > $TEMPFILE
# Monkey Patch this method for mocks
function _kubeExecuteKubeCommand(){
    callCounter=$(cat $TEMPFILE)
    if [ $callCounter -eq 1 ] ; then
        _getInitialLoad
    elif [ $callCounter -eq 2 ] ; then 
        _getDeletedPodsLoad
    else
        >&2 echo "error"
    fi
    callCounter=$((callCounter+1)) 
    $(echo $callCounter > $TEMPFILE)
}

function testDeleteReport(){
    origionalKube=$(getPods)
    newKube=$(getPods)
    result=$(getDeletedPods $origionalKube $newKube)
    expectedResult="DeletedPods
[{\"podName\":\"pod2\",\"createdAt\":\"2025-06-09T03:46:00Z\"}]"
    if [ "$result" != "$expectedResult" ] ; then 
        echo "testDeleteReport test failed"
        else
        echo "testDeleteReport pass"
    fi
    _finishTest
}


function _finishTest(){
    unlink $TEMPFILE
}
