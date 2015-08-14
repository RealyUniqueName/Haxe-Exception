package;

import hunit.TestCase;




/**
 * Tests compatibility of `Exception` with different targets.
 *
 */
class GeneralTest extends TestCase
{

    /**
     * On php & python targets `Exception` class name breaks native exceptions functionality.
     * This test ensures that 'exception' library avoids such problems.
     */
    public function testNativeInference () : Void
    {
        /**
         * Python symptoms: iteration over keys of any map becomes broken,
         * because StopIteration exception is not catchable anymore
         */
        var map = ['hello' => 1, 'world' => 2];
        for (key in map.keys()) {
            //Iteration does not stop after last key, but raises StopIteration exception instead
        }

        /**
         * PHP symptoms: any attempt to create an instance of `Exception` produces fatal error "access to undeclared property"
         */
        var e = new Exception('Hello, world');

        //all trials passed
        assert.success();
    }

}//class GeneralTest