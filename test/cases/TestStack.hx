package cases;

import utest.Assert;
import haxe.Exception;

class TestStack extends BaseCase {
	public function testSubtract() {
		var e = deeperStack();
		trace(e.stack);
		trace('=======');
		var result = e.stack.subtract(new Exception('error', e).stack);
		trace(result);
		Assert.equals(2, result.length);
	}

	function deeperStack():Exception {
		return new Exception('error');
	}
}