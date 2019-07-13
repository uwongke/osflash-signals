package org.osflash.utils;
class ArrayUtils {
    public function new() {}
    @:generic static public function new_Array<T>(ArrayType:T, Length:Int):Array<T> {
        var empty:Null<T> = null;
        var newArray:Array<T> = new Array<T>();

        for (i in 0...Length) {
            newArray.push(empty);
        }

        return newArray;
    }
}
