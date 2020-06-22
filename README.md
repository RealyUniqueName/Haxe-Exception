Exception [![TravisCI Build Status](https://travis-ci.org/RealyUniqueName/Haxe-Exception.svg?branch=master)](https://travis-ci.org/RealyUniqueName/Haxe-Exception)
=========

`HaxeException` is the base class for your exceptions.

**DEPRECATION NOTICE**

As of Haxe 4.1 standard library contains its own `haxe.Exception` type, which should be used instead of this library.
See https://haxe.org/manual/expression-throw.html#since-haxe-4.1.0 and https://haxe.org/manual/expression-try-catch.html#since-haxe-4.1

**END OF DEPRECATION NOTICE**

Usage
--------
Creating your own exceptions:
```haxe
class TerribleErrorException extends HaxeException {}

throw new TerribleErrorException('OMG!');
```
Wrapping third-party exceptions:
```haxe
import HaxeException;

try {
	throw 'Terrible error!';
} catch (e:Dynamic) {
	throw Exception.wrap(e);
	//or if you want to keep original exception stack
	throw Exception.wrap(e).setStack(haxe.CallStack.exceptionStack());
}
```
Rethrowing exceptions:
```haxe
class Test {
	static function fail() throw new HaxeException('OMG!');

	static function rethrow() {
		try {
			fail();
		} catch(e:HaxeException) {
			throw new HaxeException('Rethrown', e);
		}
	}

	static function doStuff() {
		rethrow();
	}

	static public function main() {
		try {
			doStuff();
		} catch(e:HaxeException) {
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
Module `HaxeException`:
```haxe
class HaxeException {
	/** Message of this exception. */
	public var message(default,null):String;
	/** Call stack of the line where this exception was created. */
	public var stack(default,null):Stack;
	/** Previously caught exception. */
	public var previous(default,null):Null<HaxeException>;
	/**
	 *  Creates an instance of `HaxeException` using `e` as message.
	 *  If `e` is already an instance of `HaxeException` then `e` is returned as-is.
	 */
	static public inline function wrap (e:Dynamic):HaxeException;
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