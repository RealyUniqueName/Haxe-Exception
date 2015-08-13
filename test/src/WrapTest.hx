package ;

import haxe.CallStack;
import hunit.TestCase;




/**
 * Test `Exception.wrap()`
 *
 */
class WrapTest extends TestCase
{

    /**
     * Wrap dynamic exception
     *
     */
    public function testDynamic () : Void
    {
        try {
            throw 'I am exception';
        } catch (e:Dynamic) {
            var wrapped = Exception.wrap(e);

            assert.equal(e, wrapped.message);
        }
    }


    /**
     * Wrap exceptions which already are instances of `Exception`
     *
     */
    public function testException () : Void
    {
        var original = new Exception('Hello');
        var wrapped  = Exception.wrap(original);

        assert.equal(original, wrapped);
    }

}//class WrapTest
