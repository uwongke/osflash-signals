package org.osflash.signals.natives;

import openfl.errors.ArgumentError;
import haxe.Constraints.Function;
import org.osflash.signals.ISlot;
import org.osflash.signals.Slot;
import org.osflash.signals.SlotList;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.events.IEventDispatcher;

/** Allows the eventClass to be set in MXML, e.g. */
@:meta(DefaultProperty(name="eventClass"))

/** The NativeSignal class provides a strongly-typed facade for an IEventDispatcher.
	A NativeSignal is essentially a mini-dispatcher locked to a specific event type and class.
	It can become part of an interface. */
class NativeSignal implements INativeDispatcher {

    private var _target : IEventDispatcher;
    private var _eventType : String;
    private var _eventClass : Class<Dynamic>;
    private var _valueClasses : Array<Dynamic>;
    private var slots : SlotList;

    /** Creates a NativeSignal instance to dispatch events on behalf of a target object. */
    public function new(target : IEventDispatcher = null, eventType : String = "", eventClass : Class<Dynamic> = null) {
        slots = SlotList.NIL;
        this.target = target;
        this.eventType = eventType;
        this.eventClass = eventClass;
    }

    /** eventType Property */
    public var eventType(get, set) : String;
    public function get_eventType() : String {
        return _eventType;
    }
    public function set_eventType(value : String) : String {
        _eventType = value;
        return value;
    }

    /** eventClass Property */
    public var eventClass(get, set) : Class<Dynamic>;
    public function get_eventClass() : Class<Dynamic> {
        return _eventClass;
    }

    public function set_eventClass(value : Class<Dynamic>) : Class<Dynamic> {
        //_eventClass = value || Event;
        _eventClass = value != null ? value: Event;
        _valueClasses = [_eventClass];
        return value;
    }

    /** valueClasses Property */
    @:meta(ArrayElementType(name="Class"))
    public var valueClasses(get, set) : Array<Dynamic>;
    private function get_valueClasses() : Array<Dynamic> {
        return _valueClasses;
    }

    private function set_valueClasses(value : Array<Dynamic>) : Array<Dynamic> {
        eventClass = (value != null && value.length > 0) ? value[0] : null;
        return value;
    }

    /** numListeners Property */
    public var numListeners(get, never) : Int;
    private function get_numListeners() : Int {
        return slots.length;
    }

    /** target Property */
    public var target(get, set) : IEventDispatcher;
    public function get_target() : IEventDispatcher {
        return _target;
    }

    public function set_target(value : IEventDispatcher) : IEventDispatcher {
        if (value == _target) {
            return value;
        }
        if (_target != null) {
            removeAll();
        }
        _target = value;
        return value;
    }



    public function add(listener : Function) : ISlot {
        return addWithPriority(listener);
    }

    public function addWithPriority(listener : Function, priority : Int = 0) : ISlot {
        return registerListenerWithPriority(listener, false, priority);
    }

    public function addOnce(listener : Function) : ISlot {
        return addOnceWithPriority(listener);
    }

    public function addOnceWithPriority(listener : Function, priority : Int = 0) : ISlot {
        return registerListenerWithPriority(listener, true, priority);
    }

    public function remove(listener : Function) : ISlot {
        var slot : ISlot = slots.find(listener);
        if (slot == null) {
            return null;
        }
        _target.removeEventListener(_eventType, slot.execute1);
        slots = slots.filterNot(listener);
        return slot;
    }

    public function removeAll() : Void {
        var slotsToProcess : SlotList = slots;
        while (slotsToProcess.nonEmpty) {
            target.removeEventListener(_eventType, slotsToProcess.head.execute1);
            slotsToProcess = slotsToProcess.tail;
        }
        slots = SlotList.NIL;
    }

    public function dispatch(valueObjects : Array<Dynamic> = null) : Void {

        if (null == valueObjects) {
            throw new ArgumentError("Event object expected.");
        }

        if (valueObjects.length != 1) {
            throw new ArgumentError("No more than one Event object expected.");
        }

        dispatchEvent(try cast(valueObjects[0], Event) catch(e:Dynamic) null);
    }

    /** Unlike other signals, NativeSignal does not dispatch null
		   because it causes an exception in EventDispatcher. */
    public function dispatchEvent(event : Event) : Bool {
        if (target == null) {
            throw new ArgumentError("Target object cannot be null.");
        }
        if (event == null) {
            throw new ArgumentError("Event object cannot be null.");
        }

        if (!(Std.is(event, eventClass))) {
            throw new ArgumentError("Event object " + event + " is not an instance of " + eventClass + ".");
        }

        if (event.type != eventType) {
            throw new ArgumentError("Event object has incorrect type. Expected <" + eventType + "> but was <" + event.type + ">.");
        }

        return target.dispatchEvent(event);
    }

    private function registerListenerWithPriority(listener : Function, once : Bool = false, priority : Int = 0) : ISlot {
        if (target == null) {
            throw new ArgumentError("Target object cannot be null.");
        }

        if (registrationPossible(listener, once)) {
            var slot : ISlot = new Slot(listener, cast this, once, priority);
            /** Not necessary to insertWithPriority() because the target takes care of ordering. */
            slots = slots.prepend(slot);
            _target.addEventListener(_eventType, slot.execute1, false, priority);
            return slot;
        }

        return slots.find(listener);
    }

    private function registrationPossible(listener : Function, once : Bool) : Bool {
        if (!slots.nonEmpty) {
            return true;
        }

        var existingSlot : ISlot = slots.find(listener);
        if (existingSlot != null) {
            if (existingSlot.once != once){
                /** If the listener was previously added, definitely don't add it again.
					But throw an exception if their once value differs. */

                throw new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first.");
            }

            /** Listener was already added. */
            return false;
        }

        /** This listener has not been added before. */
        return true;
    }
}
