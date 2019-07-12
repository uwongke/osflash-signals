package org.osflash.signals.events;

interface IEvent {

    /** The object that originally dispatched the event.
        When dispatched from an signal, the target is the object containing the signal. */
    @:isVar public var target(get, set): Dynamic;
    public function get_target(): Dynamic;
    public function set_target(value: Dynamic): Dynamic;

    /** The object that added the listener for the event. */
    @:isVar public var currentTarget(get, set): Dynamic;
    public function get_currentTarget(): Dynamic;
    public function set_currentTarget(value: Dynamic): Dynamic;

    /** The signal that dispatched the event. */
    @:isVar public var signal(get, set): IPrioritySignal;
    public function get_signal(): IPrioritySignal;
    public function set_signal(value: IPrioritySignal): IPrioritySignal;

    /** Indicates whether the event is a bubbling event. */
    @:isVar public var bubbles(get, set): Bool;
    public function get_bubbles(): Bool;
    public function set_bubbles(value: Bool): Bool;

    /** Returns a new copy of the instance. */
    function clone():IEvent;
}
