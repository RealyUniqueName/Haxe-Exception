package cases;

import haxe.Exception;

class TestException extends BaseCase {
	public function testWrap() {
		var s = 'Terrible error';
		var e = Exception.wrap(s);
		assert.equals(s, e.message);
		assert.equals(e, Exception.wrap(e));
	}
}