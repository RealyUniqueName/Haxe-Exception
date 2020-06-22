package cases;

import utest.Assert;

class TestException extends BaseCase {
	public function testWrap() {
		var s = 'Terrible error';
		var e = HaxeException.wrap(s);
		Assert.equals(s, e.message);
		Assert.equals(e, HaxeException.wrap(e));
	}
}