import haxe.Exception;

class Test {
	static function fail() throw new Exception('OMG!');

	static function rethrow() {
		try {
			fail();
		} catch(e:Exception) {
			throw new Exception('Rethrown', e);
		}
	}

	static function doStuff() {
		rethrow();
	}

	static public function main() {
		try {
			doStuff();
		} catch(e:Exception) {
			trace(e);
		}
	}
}