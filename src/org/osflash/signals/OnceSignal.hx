package org.osflash.signals;

import haxe.Constraints.Function;

/** Allows the valueClasses to be set in MXML */
@:meta(DefaultProperty(name="valueClasses"))
class OnceSignal implements IOnceSignal {

    private var _valueClasses : Array<Dynamic>;  /** of Class */
    private var slots : SlotList = SlotList.NIL;

    /** Creates a Signal instance to dispatch value objects. */
    public function new(valueClasses : Array<Dynamic> = null){
        this.valueClasses = ((valueClasses.length == 1 && Std.is(valueClasses[0], Array))) ? valueClasses[0] : valueClasses;
    }

    @:isVar public var valueClasses(get, set) : Array<Dynamic>;
    @:meta(ArrayElementType(name="Class"))

    public function get_valueClasses() : Array<Dynamic>{
        return _valueClasses;
    }

    public function set_valueClasses(value : Array<Dynamic>) : Array<Dynamic> {
        /** Clone so the Array cannot be affected from outside. */
        _valueClasses = (value != null) ? value.copy() : [];

        var i : Int = _valueClasses.length;
        if(value.length !=0){
            while(i >= 0){
                if (!(Std.is(_valueClasses[i], Class))){
                    throw new js.lib.Error("Invalid valueClasses argument: " +
                    "item at index " + i + " should be a Class but was:<" +
                    _valueClasses[i] + ">." + Type.getClassName(_valueClasses[i]));
                }
                i--;
            }
        }

        return value;
    }

    @:isVar public var numListeners(get, never) : Int;
    public function get_numListeners() : Int{
        return slots.length;
    }

    public function addOnce(listener : Function) : ISlot{
        return registerListener(listener, true);
    }

    public function remove(listener : Function) : ISlot{
        var slot : ISlot = slots.find(listener);
        if (slot == null){
            return null;
        }

        slots = slots.filterNot(listener);
        return slot;
    }

    public function removeAll() : Void{
        slots = SlotList.NIL;
    }

    /** If valueClasses is empty, value objects are not type-checked. */
    public function dispatch(valueObjects : Array<Dynamic> = null) : Void{
        var numValueClasses : Int = _valueClasses.length;
        var numValueObjects : Int = valueObjects.length;

        /** Cannot dispatch fewer objects than declared classes. */
        if (numValueObjects < numValueClasses){
            throw new js.lib.Error("Incorrect number of arguments. " +
            "Expected at least " + numValueClasses + " but received " +
            numValueObjects + ".");
        }

        /** Cannot dispatch differently typed objects than declared classes. */

        /** Optimized for the optimistic case that values are correct. */
        for (i in 0...numValueClasses){
            if (Std.is(valueObjects[i], _valueClasses[i]) || valueObjects[i] == null){
                continue;
            }

            throw new js.lib.Error("Value object <" + valueObjects[i] + "> is not an instance of <" + _valueClasses[i] + ">.");
        }

        /** Broadcast to listeners. */
        var slotsToProcess : SlotList = slots;
        if (slotsToProcess.nonEmpty){
            while (slotsToProcess.nonEmpty){
                slotsToProcess.head.execute(valueObjects);
                slotsToProcess = slotsToProcess.tail;
            }
        }
    }

    private function registerListener(listener : Function, once : Bool = false) : ISlot {
        if (registrationPossible(listener, once)){
            var newSlot : ISlot = new Slot(listener, this, once);
            slots = slots.prepend(newSlot);
            return newSlot;
        }

        return slots.find(listener);
    }

    private function registrationPossible(listener : Function, once : Bool) : Bool{
        if (!slots.nonEmpty){
            return true;
        }

        var existingSlot : ISlot = slots.find(listener);
        if (existingSlot == null){
            return true;
        }

        /** If the listener was previously added, definitely don't add it again.
		    But throw an exception if their once values differ. */
        if (existingSlot.once != once){
            throw new js.lib.Error("You cannot addOnce() then add() the same listener without removing the relationship first.");
        }

        return false;
    }
}