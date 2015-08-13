package ;

import hunit.TestCase;


/**
 * Test call stack manipulations
 *
 */
class StackTest extends TestCase
{

    /**
     * `Exception.truncateStack()`
     *
     */
    public function testTruncate () : Void
    {
        var e = new Exception('Terrible error');
        var stackSize = e.stack.length;

        //target platform does not provide call stack
        if (stackSize == 0) {
            assert.success();
            return;
        }

        e.truncateStack(1);

        assert.equal(stackSize - 1, e.stack.length);
    }

}//class StackTest