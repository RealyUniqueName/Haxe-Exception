Exception
=========
[![TravisCI Build Status](https://travis-ci.org/RealyUniqueName/Haxe-Exception.svg?branch=master)](https://travis-ci.org/RealyUniqueName/Haxe-Exception)

`haxe.Exception` is the base class for your exceptions.

Usage
--------
Creating your own exceptions:
```haxe
class TerribleErrorException extends haxe.Exception {}

throw new TerribleErrorException('OMG!');
```
Wrapping third-party exceptions:
```haxe
try {
	throw 'Terrible error!';
} catch (e:Dynamic) {
	throw haxe.Exception.wrap(e);
}
```
Rethrowing exceptions:
```haxe
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
```
That second exception will look like this when stringified:
```
Test.hx:22: Exception: OMG!
Stack:
Called from Test::fail line 4
Called from Test::rethrow line 8

Next Exception: Rethrown
Stack:
Called from Test::rethrow line 10
Called from Test::doStuff line 15
Called from Test::main line 20
Called from StringBuf::$statics line 1
```

API
-------
Module `haxe.Exception`:
```haxe
class Exception {
	/** Message of this exception. */
	public var message(default,null):String;
	/** Call stack of the line where this exception was created. */
	public var stack(default,null):Stack;
	/** Previously caught exception. */
	public var previous(default,null):Null<Exception>;
	/**
	 *  Creates an instance of `Exception` using `e` as message.
	 *  If `e` is already an instance of `Exception` then `e` is returned as-is.
	 */
	static public inline function wrap (e:Dynamic):Exception;
	/**
	 *  String representation of this exception.
	 *  Includes message, stack and the previous exception (if set).
	 */
	public function toString():String;
}

/**
 *  Call stack for exceptions
 */
@:forward(length,copy)
abstract Stack(Array<StackItem>) from Array<StackItem> to Array<StackItem> {
	/**
	 *  Get current call stack.
	 */
	public inline function new();
	/**
	 *  Returns string representation of this call stack.
	 */
	public inline function toString():String;
	/**
	 *  Iterator to be able to iterate over items of this stack.
	 */
	public inline function iterator():StackIterator<StackItem>;
	/**
	 *  Array access for reading arbitrary items of this stack.
	 */
	@:arrayAccess inline function get(index:Int):StackItem;
	/**
	 *  Returns a range of entries of current stack from the beginning to the the common part of this and `stack`.
	 */
	public function subtract(stack:Stack):Stack;
}
```
------
Happy throwing!