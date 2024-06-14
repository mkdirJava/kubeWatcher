
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
        _getCreatedPodsLoad
    else
        >&2 echo "error"
    fi
    callCounter=$((callCounter+1)) 
    $(echo $callCounter > $TEMPFILE)
}

function testCreateReport(){
    origionalKube=$(getPods)
    newKube=$(getPods)
    result=$(getNewPods $origionalKube $newKube )
    expectedResult="CreateReport
[{\"podName\":\"a-new-pod\",\"createdAt\":\"9022-06-08T03:46:12Z\"}]"
    if [ "$result" != "$expectedResult" ] ; then 
        echo "testCreateReport test failed"
        else
        echo "testCreateReport pass"
    fi
    _finishTest
}


function _finishTest(){
    unlink $TEMPFILE
}
