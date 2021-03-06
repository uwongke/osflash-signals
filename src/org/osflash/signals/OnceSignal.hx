package org.osflash.signals;

import haxe.Constraints.Function;
import openfl.errors.Error;

using Std;

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

	/** This setter has been completely refactored from the original SVN code @ Wolfie */
	public function set_valueClasses(value : Array<Dynamic>) : Array<Dynamic> {
		_valueClasses = new Array<Dynamic>();

		var classes: Array<Dynamic> = value[0];
		for (i in 0..._valueClasses.length) {
			if(classes[i] != null) {
				if(Std.is(classes[i], Class)){
					_valueClasses.push(classes[i]);
				}
			}
		}

		return _valueClasses;
	}

	@:isVar public var numListeners(get, never) : Int;
	public function get_numListeners() : Int{
		return slots.length;
	}

	public function addOnce(listener:Function) : ISlot{
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
		if(valueObjects == null){
			valueObjects = new Array<Dynamic>();
		}

		if (!valueObjects.is(Array)) {
			throw "Caller to dispatch() passed a non-array element.  \n" +
				  "If this is called via Reflect.callMethod(...), then the \n" +
				  "arguments must be wrapped in an array (e.g. [args]).\n" +
				  'Argument recieved was [$valueObjects]';
		}

		var numValueClasses : Int = _valueClasses.length;
		var numValueObjects : Int = valueObjects.length;

		/** Cannot dispatch fewer objects than declared classes. */
		if (numValueObjects < numValueClasses){
			throw new Error("Incorrect number of arguments. " +
			"Expected at least " + numValueClasses + " but received " +
			numValueObjects + ".");
		}

		/** Cannot dispatch differently typed objects than declared classes. */

		/** Optimized for the optimistic case that values are correct. */
		for (i in 0...numValueClasses){
			if (Std.is(valueObjects[i], _valueClasses[i]) || valueObjects[i] == null){
				continue;
			}

			throw new Error("Value object <" + valueObjects[i] + "> is not an instance of <" + _valueClasses[i] + ">.");
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

	/** Create a new slot and prepend it to the slot list **/
	private function registerListener(listener : Function, once : Bool = false) : ISlot {
		if (registrationPossible(listener, once)){
			var newSlot : ISlot = new Slot(listener, this, once);
			slots = slots.prepend(newSlot);
			return newSlot;
		}

		return slots.find(listener);
	}

	/** Registration is possible if the listener doesn't already exists in the slot list **/
	private function registrationPossible(listener : Function, once : Bool) : Bool{
		if(slots == null){
			slots = SlotList.NIL;
		}
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
			throw new Error("You cannot addOnce() then add() the same listener without removing the relationship first.");
		}
		return false;
	}
}
