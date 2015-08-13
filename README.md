Exception
=========
`Exception` is the base class for your exceptions.
In addition to standard exception call stack `Exception` provides information about position where it was created in Haxe source code.
This feature can be handy when platform does not provide any useful information in call stack (like python or php targets in release mode).

Usage
--------
Creating your own exceptions:
```haxe
class TerribleErrorException extends Exception {}

throw new TerribleErrorException('OMG!');
```
Wrapping third-party exceptions:
```haxe
try {
    throw 'Terrible error!';
} catch (e:Dynamic) {
    //this new exception will point to the original exception call stack.
    throw Exception.wrap(e);
}
```

Enabling/Disabling call stack manipulations
-------
Call stack of `Exception` is calculated only in debug mode or if `-D EXCEPTION_STACK` compiler flag is specified.
In release mode without `-D EXCEPTION_STACK` you will only get information about position where exception was created in addition to standard platform specific exception stack.


API
-------
```haxe
/** Exception message */
public var message (default,null) : String;
/** Position where this exception was created */
public var pos (default,null) : PosInfos;
/** Call stack from the topmost call to the exception creation position */
public var stack (default,null) : Array<StackItem>;

/**
 * Creates `Exception` instance using `e` as message
 */
static public function wrap (e:Dynamic, ?pos:PosInfos) : Exception ;

/**
 * Handle call stack of all created exceptions.
 * By default does nothing.
 *
 * Usefull to remove common items of all call stacks on some platforms.
 * E.g. neko always adds `Called from SomeClass::$statics line 1` to call stack.
 * You can remove such items in this function.
 */
static public dynamic function processCallStackOnCreation (stack:Array<StackItem>) : Array<StackItem> ;

/**
 * Constructor.
 *
 * Exception's call stack will be truncated from the most recent call till the `pos`.
 * If you will not specify `pos` it will be set to the line where exception was created.
 */
public function new (message:String, ?pos:PosInfos) : Void ;

/**
 * Truncate call stack of this exception from the most recent call
 * till the `pos` position and/or by `count` items.
 */
public function truncateStack (pos:PosInfos = null, count:Int = 0) : Void ;

/**
 * Get call stack of this exception as string
 */
public function stringStack () : String ;

/**
 * Get string representation of this exception
 */
public function toString () : String ;
```
------
Happy throwing!