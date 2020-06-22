package cases;

import utest.Assert;

class TestStack extends BaseCase {
	public function testSubtract() {
		var e = deeperStack();
		var result = e.stack.subtract(new HaxeException('error', e).stack);
		Assert.equals(2, result.length);
	}

	function deeperStack():HaxeException {
		return new HaxeException('error');
	}
}