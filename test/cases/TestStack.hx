package cases;

import utest.Assert;
import haxe.Exception;

class TestStack extends BaseCase {
	public function testSubtract() {
		var stack = deeperStack();
		var result = stack.subtract(new Stack());
		Assert.equals(2, result.length);
	}

	function deeperStack():Stack {
		return new Stack();
	}
}