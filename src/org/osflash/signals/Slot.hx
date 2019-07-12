package org.osflash.signals;

import openfl.errors.Error;
import openfl.errors.ArgumentError;
import haxe.Constraints.Function;

/** The Slot class represents a signal slot. */
class Slot implements ISlot {
    private var _listener : Function;
    private var _signal : IOnceSignal;
    private var _once : Bool = false;
    private var _priority : Int = 0;
    private var _enabled : Bool = true;
    private var _params : Array<Dynamic>;

    /** Creates and returns a new Slot object. */
    public function new(listener : Function, signal : IOnceSignal, once : Bool = false, priority : Int = 0) {
        _listener = listener;
        _once = once;
        _signal = signal;
        _priority = priority;

        verifyListener(listener);
    }

    @:isVar public var listener(get, set) : Function;
    private function get_listener() : Function {
        return _listener;
    }

    private function set_listener(value : Function) : Function {
        if (null == value) {
            throw new ArgumentError(
            "Given listener is null.\nDid you want to set enabled to false instead?");
        }

        verifyListener(value);
        _listener = value;
        return value;
    }

    @:isVar public var once(get, never) : Bool;
    private function get_once() : Bool { return _once; }

    public var priority(get, never) : Int;
    private function get_priority() : Int { return _priority; }

    public var enabled(get, set) : Bool;
    private function get_enabled() : Bool { return _enabled; }

    private function set_enabled(value : Bool) : Bool {
        _enabled = value;
        return value;
    }

    public var params(get, set) : Array<Dynamic>;
    private function get_params() : Array<Dynamic> { return _params;}

    private function set_params(value : Array<Dynamic>) : Array<Dynamic> {
        _params = value;
        return value;
    }

    public function execute0() : Void {
        if (!_enabled) {
            return;
        }
        if (_once) {
            remove();
        }
        if (_params != null && _params.length) {
            Reflect.callMethod(null, _listener, _params);
            return;
        }
        _listener();
    }

    public function execute1(value : Dynamic) : Void {
        if (!_enabled) {
            return;
        }
        if (_once) {
            remove();
        }
        if (_params != null && _params.length) {
            Reflect.callMethod(null, _listener, [value].concat(_params));
            return;
        }
        _listener(value);
    }

    public function execute(valueObjects : Array<Dynamic>) : Void {
        if (!_enabled) {
            return;
        }
        if (_once) {
            remove();
        }

        /** If we have parameters, add them to the valueObject
			Note: This could be expensive if we're after the fastest dispatch possible. */
        if (_params != null && _params.length) {
            valueObjects = valueObjects.concat(_params);
        }

        /** NOTE: simple ifs are faster than switch: http://jacksondunstan.com/articles/1007 */
        var numValueObjects : Int = valueObjects.length;
        if (numValueObjects == 0) {
            _listener();
        }
        else if (numValueObjects == 1) {
            _listener(valueObjects[0]);
        }
        else if (numValueObjects == 2) {
            _listener(valueObjects[0], valueObjects[1]);
        }
        else if (numValueObjects == 3) {
            _listener(valueObjects[0], valueObjects[1], valueObjects[2]);
        }
        else {
            Reflect.callMethod(null, _listener, valueObjects);
        }
    }

    /** Creates and returns the string representation of the current object. */
    public function toString() : String {
        return "[Slot listener: " + _listener + ", once: " + _once + ", priority: " + _priority + ", enabled: " + _enabled + "]";
    }

    public function remove() : Void {
        _signal.remove(_listener);
    }

    private function verifyListener(listener : Function) : Void {
        if (null == listener) {
            throw new ArgumentError("Given listener is null.");
        }

        if (null == _signal) {
            throw new Error("Internal signal reference has not been set yet.");
        }
    }

}
