package exception;

import haxe.CallStack;
import haxe.PosInfos;

using StringTools;



/**
 * Additional tools to deal with call stack.
 *
 */
class StackTools
{

    /**
     * Truncate `stack` from the most recent call till `pos`.
     *
     * @param stack
     * @param pos Truncate till this position
     * @param fromTop Truncate from the topmost call till `pos` (true) or from the most recent call till `pos` (false).
     */
    static public inline function truncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        #if (!debug && !EXCEPTION_STACK)
            return stack;
        #else
            #if neko        return nekoTruncate(stack, pos, fromTop);
            #elseif cpp     return cppTruncate(stack, pos, fromTop);
            #elseif js      return jsTruncate(stack, pos, fromTop);
            #elseif php     return phpTruncate(stack, pos, fromTop);
            #elseif cs      return csTruncate(stack, pos, fromTop);
            #elseif java    return javaTruncate(stack, pos, fromTop);
            #elseif flash   return flashTruncate(stack, pos, fromTop);
            #else           return stack;
            #end
        #end
    }


#if neko
    static private function nekoTruncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        var posIndex = 0;

        var from = (fromTop ? stack.length - 1 : 0);
        var till = (fromTop ? - 1 : stack.length);

        for (i in new IntIterator(from, till)) {
            switch(stack[i]) {
                case FilePos(_, file, line):
                #if debug
                    if (file == '${pos.className}::${pos.methodName}' && line == pos.lineNumber) {
                        posIndex = i;
                        break;
                    }
                #else
                    if (file.indexOf(pos.fileName) + pos.fileName.length == file.length && line == pos.lineNumber) {
                        posIndex = i;
                        break;
                    }
                #end
                case _:
            }
        }

        return (fromTop ? stack.slice(0, posIndex + 1) : stack.slice(posIndex));
    }
#end


#if cpp
    static private function cppTruncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        var posIndex = 0;

        var from = (fromTop ? stack.length - 1 : 0);
        var till = (fromTop ? - 1 : stack.length);

        for (i in new IntIterator(from, till)) {
            switch(stack[i]) {
                case FilePos(Method(className, methodName), file, line):
                    #if (debug || HXCPP_STACK_LINE)
                        if (className == pos.className && methodName == pos.methodName && line == pos.lineNumber) {
                            posIndex = i;
                            break;
                        }
                    #elseif HXCPP_STACK_TRACE
                        if (className == pos.className && methodName == pos.methodName) {
                            posIndex = i;
                            break;
                        }
                    #end
                case _:
            }
        }

        return (fromTop ? stack.slice(0, posIndex + 1) : stack.slice(posIndex));
    }
#end


#if js
    static private function jsTruncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        var posIndex = 0;
        var posClass = pos.className.replace('.', '_');
        for (i in 0...stack.length) {
            switch(stack[i]) {
                case FilePos(Method(className, methodName), file, line):
                    if (className == posClass && methodName == pos.methodName) {
                        posIndex = i;
                        break;
                    }
                case _:
            }
        }

        return (fromTop ? stack.slice(0, posIndex + 1) : stack.slice(posIndex));
    }
#end


#if php
    static private function phpTruncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        var posIndex = 0;

        var from = (fromTop ? stack.length - 1 : 0);
        var till = (fromTop ? - 1 : stack.length);

        for (i in new IntIterator(from, till)) {
            switch(stack[i]) {
                case Method(className, methodName):
                    if (className == pos.className && methodName == pos.methodName) {
                        posIndex = i;
                        break;
                    }
                case _:
            }
        }

        return (fromTop ? stack.slice(0, posIndex + 1) : stack.slice(posIndex));
    }
#end


#if cs
    static private function csTruncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        var posIndex = 0;

        var from = (fromTop ? stack.length - 1 : 0);
        var till = (fromTop ? - 1 : stack.length);

        for (i in new IntIterator(from, till)) {
            switch(stack[i]) {
                case FilePos(Method(className, methodName), file, line):
                    if (className == pos.className && methodName == pos.methodName) {
                        posIndex = i;
                        break;
                    }
                case _:
            }
        }

        return (fromTop ? stack.slice(0, posIndex + 1) : stack.slice(posIndex));
    }
#end


#if java
    static private function javaTruncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        var posIndex = 0;

        var from = (fromTop ? stack.length - 1 : 0);
        var till = (fromTop ? - 1 : stack.length);

        for (i in new IntIterator(from, till)) {
            switch(stack[i]) {
                case FilePos(Method(className, methodName), file, line):
                    if (className == pos.className && methodName == pos.methodName) {
                        posIndex = i;
                        break;
                    }
                case _:
            }
        }

        return (fromTop ? stack.slice(0, posIndex + 1) : stack.slice(posIndex));
    }
#end


#if flash
    static private function flashTruncate (stack:Array<StackItem>, pos:PosInfos, fromTop:Bool = false) : Array<StackItem>
    {
        var posIndex = 0;

        var from = (fromTop ? stack.length - 1 : 0);
        var till = (fromTop ? - 1 : stack.length);

        for (i in new IntIterator(from, till)) {
            switch(stack[i]) {
                #if debug
                case FilePos(Method(className, methodName), file, line):
                    if (className == pos.className && methodName == pos.methodName && line == pos.lineNumber) {
                        posIndex = i;
                        break;
                    }
                #else
                case Method(className, methodName):
                    if (className == pos.className && methodName == pos.methodName) {
                        posIndex = i;
                        break;
                    }
                #end
                case _:
            }
        }

        return (fromTop ? stack.slice(0, posIndex + 1) : stack.slice(posIndex));
    }
#end

}//class StackTools



private class IntIterator {
    var current : Int = 0;
    var till    : Int = 0;

    public inline function new (from:Int, till:Int) : Void
    {
        this.current = from;
        this.till    = till;
    }

    public inline function hasNext() : Bool
    {
        return (current != till);
    }

    public inline function next() : Int
    {
        return (current < till ? current++ : current--);
    }
}