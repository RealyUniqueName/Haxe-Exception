package cases;

/**
 * Test call stack manipulations
 *
 */
class TestStack extends BaseCase
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
            assert.pass();
            return;
        }

        e.truncateStack(1);

        assert.equals(stackSize - 1, e.stack.length);
    }

}//class StackTest