package org.osflash.signals;

import haxe.Constraints.Function;

interface IOnceSignal {

    /** An optional array of classes defining the types of parameters sent to listeners. */
    @:isVar public var valueClasses(get, set): Array<Dynamic>;
    public function get_valueClasses(): Array<Dynamic>;
    public function set_valueClasses(value: Array<Dynamic>): Array<Dynamic>;

    /** The current number of listeners for the signal. */
    @:isVar public var numListeners(get, never): Int;
    public function get_numListeners(): Int;

    /** Subscribes a one-time listener for this signal. */
    function addOnce(listener: Function): ISlot;

    /** Dispatches an object to listeners. */
    function dispatch(valueObjects: Array<Dynamic> = null) : Void;

    /** Unsubscribes a listener from the signal. */
    function remove(listener: Function): ISlot;

    /** Unsubscribes all listeners from the signal. */
    function removeAll(): Void;
}