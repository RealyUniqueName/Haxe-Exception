package haxe;

import haxe.CallStack;

/**
 * Base class for exceptions
 */
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
	 *
	 */
	@:noUsing
	static public function wrap (e:Dynamic, exceptionStack:Array<StackItem> = null):Exception {
		return Std.is(e, Exception) ? e : new Exception(Std.string(e));
	}

	public function new (message:String = '', previous:Exception = null) {
		this.message = message;
		this.previous = previous;
		stack = new Stack();
		//remove stack entries related to a line where `new Stack()` was called
		#if neko
		stack = (stack:Array<StackItem>).slice(3);
		#elseif (cs || (java && debug) || lua)
		stack = (stack:Array<StackItem>).slice(2);
		#elseif !interp
		(stack:Array<StackItem>).shift();
		#end
	}

	/**
	 *  String representation of this exception.
	 *  Includes message, stack and the previous exception (if set).
	 */
	public function toString():String {
		var result = '';
		var e:Null<Exception> = this;
		var prev:Null<Exception> = null;
		while(e != null) {
			if(prev == null) {
				result = 'Exception: ${e.message}\nStack:${e.stack}' + result;
			} else {
				result = 'Exception: ${e.message}\nStack:${e.stack.subtract(prev.stack)}\n\nNext ' + result;
			}
			prev = e;
			e = e.previous;
		}
		return result;
	}

	/**
	 *  Replace call stack stored in this exception
	 */
	public function setStack(stack:Array<StackItem>):Exception {
		this.stack = stack;
		return this;
	}
}

/**
 *  Call stack for exceptions
 */
@:forward(length,copy)
abstract Stack(Array<StackItem>) from Array<StackItem> to Array<StackItem> {
	/**
	 *  Get current call stack
	 */
	public inline function new() {
		this = CallStack.callStack();
	}

	/**
	 *  Returns string representation of this call stack
	 */
	public inline function toString():String {
		return CallStack.toString(this);
	}

	/**
	 *  Returns a range of entries of current stack from the beginning to the the common part of this and `stack`.
	 */
	public function subtract(stack:Stack):Stack {
		var startIndex = -1;
		var i = -1;
		while(++i < this.length) {
			for(j in 0...stack.length) {
				if(equalItems(this[i], stack[j])) {
					if(startIndex < 0) {
						startIndex = i;
					}
					++i;
					if(i >= this.length) break;
				} else {
					startIndex = -1;
				}
			}
			if(startIndex >= 0) break;
		}
		return startIndex >= 0 ? this.slice(0, startIndex) : this;
	}

	@:arrayAccess inline function get(index:Int):StackItem {
		return this[index];
	}

	public inline function iterator():StackIterator<StackItem> {
		return new StackIterator(this);
	}

	static function equalItems(item1:Null<StackItem>, item2:Null<StackItem>):Bool {
		#if (haxe_ver < '4.0.0')
		// TODO: Remove this #if-branch upon 4.0.0 release
		return Type.enumEq(item1, item2);
		#else
		return switch([item1, item2]) {
			case [null, null]: true;
			case [CFunction, CFunction]: true;
			case [Module(m1), Module(m2)]: m1 == m2;
			#if (haxe_ver >= '4.0.0')
			case [FilePos(item1, file1, line1, col1), FilePos(item2, file2, line2, col2)]:
				file1 == file2 && line1 == line2 && col1 == col2 && equalItems(item1, item2);
			#else
			case [FilePos(item1, file1, line1), FilePos(item2, file2, line2)]:
				file1 == file2 && line1 == line2 && equalItems(item1, item2);
			#end
			case [Method(class1, method1), Method(class2, method2)]: class1 == class2 && method1 == method2;
			case [LocalFunction(v1), LocalFunction(v2)]: v1 == v2;
			case _: false;
		}
		#end
	}
}

private class StackIterator<StackItem> {
	var array:Array<StackItem>;
	var current:Int = 0;
	public inline function new(array:Array<StackItem>) this.array = array;
	public inline function hasNext() return current < array.length;
	public inline function next() return array[current++];
}