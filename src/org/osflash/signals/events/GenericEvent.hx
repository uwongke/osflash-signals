package org.osflash.signals.events;

class GenericEvent implements IEvent {

    private var _bubbles : Bool;
    private var _target : Dynamic;
    private var _currentTarget : Dynamic;
    private var _signal : IPrioritySignal;

    public function new(bubbles : Bool = false) {
        _bubbles = bubbles;
    }

    @:isVar public var signal(get, set): IPrioritySignal;
    public function get_signal() : IPrioritySignal {
        return _signal;
    }
    public function set_signal(value : IPrioritySignal) : IPrioritySignal {
        _signal = value;
        return value;
    }

    @:isVar public var target(get, set): Dynamic;
    public function get_target() : Dynamic {
        return _target;
    }
    public function set_target(value : Dynamic) : Dynamic {
        _target = value;
        return value;
    }

    @:isVar public var currentTarget(get, set): Dynamic;
    public function get_currentTarget() : Dynamic {
        return _currentTarget;
    }
    public function set_currentTarget(value : Dynamic) : Dynamic {
        _currentTarget = value;
        return value;
    }

    @:isVar public var bubbles(get, set): Bool;
    public function get_bubbles() : Bool {
        return _bubbles;
    }
    public function set_bubbles(value : Bool) : Bool {
        _bubbles = value;
        return value;
    }

    public function clone() : IEvent {
        return new GenericEvent(_bubbles);
    }
}