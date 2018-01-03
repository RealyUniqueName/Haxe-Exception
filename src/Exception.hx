package ;

import haxe.CallStack;
import haxe.PosInfos;

using StringTools;
using Type;
using exception.StackTools;


#if (php || python)
typedef Exception = HException;
#end

/**
 * Base class for exceptions
 *
 */
#if (php || python)
private class HException #if python extends python.Exceptions.Exception #end
#else
class Exception
#end
{
    /** Exception message */
    public var message (default,null) : String;
    /** Position where this exception was created */
    public var pos (default,null) : PosInfos;
    /** Call stack from the topmost call to the exception creation position */
    public var stack (default,null) : Array<StackItem>;


    /**
     * Creates `Exception` instance using `e` as message
     *
     */
    @:noUsing
    static public function wrap (e:Dynamic, ?pos:PosInfos) : Exception
    {
        if (Std.is(e, Exception)) return e;

        var exceptionStack = CallStack.exceptionStack();
        var exception = new Exception(Std.string(e), pos);

        //Use original exception stack if available.
        if (exceptionStack.length > 0) {
            exception.stack = exceptionStack;
        }

        return exception;
    }


    /**
     * Handle call stack of all created exceptions.
     * By default does nothing.
     */
    static public dynamic function processCallStackOnCreation (stack:Array<StackItem>) : Array<StackItem>
    {
        return stack;
    }


    /**
     * Constructor.
     *
     * Always add `?pos:PosInfos` as last argument in constructors of descendant exception classes.
     */
    public function new (message:String, ?pos:PosInfos) : Void
    {
        #if python super(); #end

        this.message = message;
        this.pos     = (pos == null ? throw "position cannot be null" : pos);

        #if (debug || EXCEPTION_STACK)
            this.stack = buildStack(CallStack.callStack());
        #else
            this.stack = [];
        #end
    }


    /**
     * Truncate call stack of this exception from the most recent call till `pos` position and/or by `count` items.
     *
     */
    public function truncateStack (pos:PosInfos = null, count:Int = 0) : Void
    {
        #if (!debug && !EXCEPTION_STACK)
            return;
        #else

            if (pos != null) {
                stack = stack.truncate(pos);
            }

            if (count > 0) {
                stack = stack.slice(count);
            }
        #end
    }


    /**
     * Get call stack of this exception as string
     *
     */
    public function stringStack () : String
    {
        return CallStack.toString(stack);
    }


    /**
     * Get string representation of this exception
     *
     */
    public function toString () : String
    {
        var className = this.getClass().getClassName();
        var position  = (pos == null ? 'unknown position' : pos.fileName + ':' + pos.lineNumber);

        var msg = '$className: $message\n\tCreated at $position';
        msg += CallStack.toString(stack).replace('\n', '\n\t');

        return msg;
    }


    /**
     * Build call stack for current exception based on `stack`
     *
     */
    private function buildStack (stack:Array<StackItem>) : Array<StackItem>
    {
        var stack = stack.truncate(pos);

        return processCallStackOnCreation(stack);
    }

}//class Exception