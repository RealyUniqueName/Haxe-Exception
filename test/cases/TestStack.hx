package cases;

import haxe.Exception;

class TestStack extends BaseCase {
	public function testSubtract() {
		var stack = deeperStack();
		var result = stack.subtract(new Stack());
		assert.equals(2, result.length);
	}

	function deeperStack():Stack {
		return new Stack();
	}
}