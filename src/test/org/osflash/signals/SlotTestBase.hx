package test.org.osflash.signals;

import haxe.Constraints.Function;

import org.osflash.signals.ISlot;
import org.osflash.signals.events.GenericEvent;
import org.osflash.signals.ISignal;

class SlotTestBase extends haxe.unit.TestCase {

	public var signal : ISignal;
	public var e : GenericEvent = new GenericEvent();

	override public function setup() {}

	override public function tearDown() {
		signal.removeAll();
		signal = null;
	}

	private function testCheckGenericEvent() : Void {
		/** event.signal is not set by Signal */
		assertTrue(e.signal == null);

		/** event.target is not set by Signal */
		assertTrue(e.target == null);
	}

	public function test_add_listener_pause_on_slot_should_not_dispatch() : Void {
		var slot : ISlot = signal.add(failIfCalled);
		slot.enabled = false;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_add_listener_switch_pause_and_resume_on_slot_should_not_dispatch() : Void {
		var slot : ISlot = signal.add(failIfCalled);
		slot.enabled = false;
		slot.enabled = true;
		slot.enabled = false;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_add_listener_then_dispatch_change_listener_on_slot_should_dispatch_second_listener() : Void {
		var slot : ISlot = signal.add(newEmptyHandler());
		signal.dispatch(new Array<Dynamic>());
		slot.listener = newEmptyHandler();

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_add_listener_then_dispatch_change_listener_on_slot_then_pause_should_not_dispatch_second_listener() : Void {
		var slot : ISlot = signal.add(newEmptyHandler());

		signal.dispatch(new Array<Dynamic>());

		slot.listener = cast failIfCalled;
		slot.enabled = false;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_add_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : Void {
		var slot : ISlot = signal.add(newEmptyHandler());

		signal.dispatch(new Array<Dynamic>());

		var listener : Function = slot.listener;

		slot.listener = cast failIfCalled;
		slot.listener = listener;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_addOnce_listener_pause_on_slot_should_not_dispatch() : Void {
		var slot : ISlot = signal.addOnce(failIfCalled);
		slot.enabled = false;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_addOnce_listener_switch_pause_and_resume_on_slot_should_not_dispatch() : Void {
		var slot : ISlot = signal.addOnce(failIfCalled);
		slot.enabled = false;
		slot.enabled = true;
		slot.enabled = false;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_addOnce_listener_then_dispatch_change_listener_on_slot_should_dispatch_second_listener() : Void {
		var slot : ISlot = signal.addOnce(newEmptyHandler());
		signal.dispatch(new Array<Dynamic>());
		slot.listener = newEmptyHandler();

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_addOnce_listener_then_dispatch_change_listener_on_slot_then_pause_should_not_dispatch_second_listener() : Void {
		var slot : ISlot = signal.addOnce(newEmptyHandler());

		signal.dispatch(new Array<Dynamic>());

		slot.listener = cast failIfCalled;
		slot.enabled = false;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_addOnce_listener_then_change_listener_then_switch_back_and_then_should_dispatch() : Void {
		var slot : ISlot = signal.addOnce(newEmptyHandler());

		signal.dispatch(new Array<Dynamic>());

		var listener : Function = slot.listener;

		slot.listener = cast failIfCalled;
		slot.listener = listener;

		signal.dispatch(new Array<Dynamic>());
		assertFalse(signal.valueClasses.length !=0);
	}

	public function test_add_listener_and_verify_once_is_false() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.add(listener);

		/** Slot once is false */
		assertFalse(slot.once);
	}

	public function test_add_listener_and_verify_priority_is_zero() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.add(listener);

		/** Slot priority is zero */
		assertTrue(slot.priority == 0);
	}

	public function test_add_listener_and_verify_slot_listener_is_same() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.add(listener);

		/** Slot listener is the same as the listener */
		assertTrue(slot.listener == listener);
	}

	public function test_add_same_listener_twice_and_verify_slots_are_the_same() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = signal.add(listener);
		var slot1 : ISlot = signal.add(listener);

		/** Slots are equal if they\'re they have the same listener */
		assertTrue(slot0 == slot1);
	}

	public function test_add_same_listener_twice_and_verify_slot_listeners_are_the_same() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = signal.add(listener);
		var slot1 : ISlot = signal.add(listener);

		/** Slot listener is the same as the listener */
		assertTrue(slot0.listener == slot1.listener);
	}

	public function test_add_listener_and_remove_using_slot() : Void {
		var slot : ISlot = signal.add(newEmptyHandler());
		slot.remove();

		/** Number of listeners should be 0 */
		assertTrue(signal.numListeners == 0);
	}

	public function test_add_same_listener_twice_and_remove_using_slot_should_have_no_listeners() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = signal.add(listener);
		signal.add(listener);

		slot0.remove();

		/** Number of listeners should be 0 */
		assertTrue(signal.numListeners == 0);
	}

	public function test_add_lots_of_same_listener_and_remove_using_slot_should_have_no_listeners() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = null;

		for (i in 0...100) {
			slot0 = signal.add(listener);
		}

		slot0.remove();

		/** Number of listeners should be 0 */
		assertTrue(signal.numListeners == 0);
	}

	@:meta(Test(expects="ArgumentError"))
	public function test_add_listener_then_set_listener_to_null_should_throw_ArgumentError() : Void {
		try {
			var slot : ISlot = signal.add(newEmptyHandler());
			slot.listener = null;
		} catch(e: js.lib.Error){
			assertTrue(true);
		}
	}

	public function test_add_listener_and_call_execute_on_slot_should_call_listener() : Void {
		var slot : ISlot = signal.add(newEmptyHandler());
		slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]);
		assertTrue(true);
	}

	public function test_add_listener_twice_and_call_execute_on_slot_should_call_listener_and_not_on_signal_listeners() : Void {
		signal.add(failIfCalled);

		var slot : ISlot = signal.add(newEmptyHandler());
		slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]);
		assertTrue(true);
	}

	public function test_addOnce_listener_and_verify_once_is_true() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.addOnce(listener);

		/** Slot once is true */
		assertTrue(slot.once == true);
	}

	public function test_addOnce_listener_and_verify_priority_is_zero() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.addOnce(listener);

		/** Slot priority is zero */
		assertTrue(slot.priority == 0);
	}

	public function test_addOnce_listener_and_verify_slot_listener_is_same() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.addOnce(listener);

		/** Slot listener is the same as the listener */
		assertTrue(slot.listener == listener);
	}

	public function test_addOnce_same_listener_twice_and_verify_slots_are_the_same() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = signal.addOnce(listener);
		var slot1 : ISlot = signal.addOnce(listener);

		/** Slots are equal if they\'re they have the same listener */
		assertTrue(slot0 == slot1);
	}

	public function test_addOnce_same_listener_twice_and_verify_slot_listeners_are_the_same() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = signal.addOnce(listener);
		var slot1 : ISlot = signal.addOnce(listener);

		/** Slot listener is the same as the listener */
		assertTrue(slot0.listener == slot1.listener);
	}

	public function test_addOnce_listener_and_remove_using_slot() : Void {
		var slot : ISlot = signal.addOnce(newEmptyHandler());
		slot.remove();

		/** Number of listeners should be 0 */
		assertTrue(signal.numListeners == 0);
	}

	public function test_addOnce_same_listener_twice_and_remove_using_slot_should_have_no_listeners() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = signal.addOnce(listener);
		signal.addOnce(listener);

		slot0.remove();

		/** Number of listeners should be 0 */
		assertTrue(signal.numListeners == 0);
	}

	public function test_addOnce_lots_of_same_listener_and_remove_using_slot_should_have_no_listeners() : Void {
		var listener : Function = newEmptyHandler();
		var slot0 : ISlot = null;

		for (i in 0...100) {
			slot0 = signal.addOnce(listener);
		}

		slot0.remove();

		/** Number of listeners should be 0 */
		assertTrue(signal.numListeners == 0);
	}

	/** We expect this to throw... */
	public function test_addOnce_listener_then_set_listener_to_null_should_throw_ArgumentError() : Void {
		try {
			var slot : ISlot = signal.addOnce(newEmptyHandler());
			slot.listener = null;
		} catch(error: js.lib.Error){
			assertTrue(true);
		}
	}

	public function tsst_addOnce_listener_and_call_execute_on_slot_should_call_listener() : Void {
		var slot : ISlot = signal.addOnce(newEmptyHandler());
		slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]);
		assertTrue(true);
	}

	public function test_addOnce_listener_twice_and_call_execute_on_slot_should_call_listener_and_not_on_signal_listeners() : Void {
		signal.addOnce(failIfCalled);

		var slot : ISlot = signal.addOnce(newEmptyHandler());
		slot.execute([1, 2, 3, 4, 5, 6, 7, 8, 9]);
		assertTrue(true);
	}

	public function test_slot_params_are_null_when_created() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.add(listener);

		/** params should be null */
		assertTrue(slot.params == null);
	}

	public function test_slot_params_should_not_be_null_after_adding_array() : Void {
		var listener : Function = newEmptyHandler();
		var slot : ISlot = signal.add(listener);
		slot.params = [];

		/** params should not be null */
		assertTrue(slot.params != null);
	}

	public function test_slot_params_with_one_param_should_be_sent_through_to_listener() : Void {
		var slot: ISlot = signal.add((args: Dynamic)-> {
			assertTrue(args !=null);
			assertTrue(Std.is(args[0], Int));
			assertEquals(args[0], 1234);
		});
		slot.params = new Array<Dynamic>();
		slot.params= [[1234]];

		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	public function test_slot_params_with_multiple_params_should_be_sent_through_to_listener() : Void {
		var slotParams: Array<Dynamic> = [[12345, "text", new TestClass()]];

		var slot: ISlot = signal.add((args : Array<Dynamic>)-> {
			assertTrue(args !=null);
			assertTrue(Std.is(args[0], Int));
			assertEquals(args[0], 12345);
			assertTrue(Std.is(args[1], String));
			assertEquals(args[1], "text");

			var sp: Array<Dynamic> = slotParams[0];
			assertTrue(Std.is(sp[2], TestClass));
			assertTrue(true);
		});

		slot.params = slotParams;
		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	public function test_slot_params_should_not_effect_other_slots() : Void {
		signal.add((args : Array<Dynamic>)->{
			assertFalse(args !=null);
		});

		var slot: ISlot = signal.add((args : Array<Dynamic>)->{
			assertTrue(args !=null);
			assertEquals(args.length, 1);
			assertEquals(args[0], 123456);
		});
		slot.params = [[123456]];

		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	public function test_verify_chaining_of_slot_params() : Void {
		signal.add((args : Array<Dynamic>)->{
			assertTrue(args !=null);
			assertEquals(args.length, 1);
			assertEquals(args[0], 1234567);
		}).params = [[1234567]];

		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	public function test_verify_chaining_and_concat_of_slot_params() : Void {
		signal.add((args : Array<Dynamic>)->{
			assertTrue(args !=null);
			assertEquals(args.length, 2);
		}).params = [[12345678].concat(cast ["text"])];

		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	public function test_verify_chaining_and_pushing_on_to_slot_params() : Void {
		/** This is ugly, but I put money on somebody will attempt to do this! (original author comment) */
		var slots : ISlot;
		(slots = signal.add((args : Array<Dynamic>)->{
			assertTrue(args !=null);
			assertEquals(cast args.length, 2);
			assertEquals(args[0], 123456789);
			assertEquals(args[1], "text");
		})).params = [[123456789]];
		var args: Array<Dynamic> = slots.params[0];
		args.push("text");

		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	private static function newEmptyHandler() : Function {
		return function(e : Dynamic = null, args : Array<Dynamic> = null) : Void {};
	}

	private static function failIfCalled(e : Dynamic = null) : Void {
		throw new js.lib.Error("This function should not have been called.");
	}
}