package org.osflash.signals;

import haxe.Constraints.Function;
class PrioritySignal extends Signal implements IPrioritySignal {

    public function new(valueClasses : Array<Dynamic> = null) {
        if(valueClasses == null){
            valueClasses = new Array<Dynamic>();
        } else {
            valueClasses = ((valueClasses.length == 1 && Std.is(valueClasses[0], Array))) ? valueClasses[0] : valueClasses;
        }
        super(valueClasses);
    }

    public function addWithPriority(listener : Function, priority : Int = 0) : ISlot {
        return registerListenerWithPriority(listener, false, priority);
    }

    public function addOnceWithPriority(listener : Function, priority : Int = 0) : ISlot {
        return registerListenerWithPriority(listener, true, priority);
    }

    override private function registerListener(listener : Function, once : Bool = false) : ISlot {
        return registerListenerWithPriority(listener, once);
    }

    private function registerListenerWithPriority(listener : Function, once : Bool = false, priority : Int = 0) : ISlot {
        if (registrationPossible(listener, once)) {
            var slot : ISlot = new Slot(listener, this, once, priority);
            slots = slots.insertWithPriority(slot);
            return slot;
        }

        return slots.find(listener);
    }
}