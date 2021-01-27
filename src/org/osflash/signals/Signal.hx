package org.osflash.signals;

import org.osflash.signals.OnceSignal;
import org.osflash.signals.ISlot;
import haxe.Constraints.Function;
import org.osflash.signals.ISignal;

/** Allows the valueClasses to be set in MXML */
@:meta(DefaultProperty(name="valueClasses"))

/** Signal dispatches events to multiple listeners. */
class Signal extends OnceSignal implements ISignal {

	/** Creates a Signal instance to dispatch value objects. */
	public function new(valueClasses : Array<Dynamic> = null){
		if(valueClasses == null){
			valueClasses = new Array<Dynamic>();
		} else {
			valueClasses = ((valueClasses.length == 1 && Std.is(valueClasses[0], Array))) ? valueClasses[0] : valueClasses;
		}
		super(valueClasses);

		/** Warning! Hack! It should never happen but it does! I'm too lazy to
			investigate it further so I've added... this ~ Michael */
		 if(this.slots == null) {
			this.slots = SlotList.NIL;
		}
	}

	public function add(listener : Function) : ISlot{
		return registerListener(listener);
	}
}