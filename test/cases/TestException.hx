package cases;

import utest.Assert;
import haxe.Exception;

class TestException extends BaseCase {
	public function testWrap() {
		var s = 'Terrible error';
		var e = Exception.wrap(s);
		Assert.equals(s, e.message);
		Assert.equals(e, Exception.wrap(e));
	}
}