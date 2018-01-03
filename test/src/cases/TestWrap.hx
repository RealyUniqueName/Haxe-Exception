package cases;

import haxe.CallStack;

/**
 * Test `Exception.wrap()`
 *
 */
class TestWrap extends BaseCase
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

            assert.equals(e, wrapped.message);
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

        assert.equals(original, wrapped);
    }

}//class WrapTest
