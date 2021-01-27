package test.org.osflash.signals;

import haxe.Constraints.Function;
import org.osflash.signals.ISlot;
import org.osflash.signals.events.GenericEvent;
import org.osflash.signals.Signal;

class SignalTest extends SignalTestBase {

	override public function setup() {
		signal = new Signal();
	}

	public function test_dispatch_should_pass_event_to_listener_but_not_set_signal_or_target_properties() : Void {
		signal.add(testCheckGenericEvent);
		signal.dispatch(cast[new GenericEvent()]);
	}

	public function test_dispatch_non_IEvent_without_error() : Void {
		signal.addOnce(checkSprite);
		/** Sprite doesn't have a target property,
			so if the signal tried to set .target,
			an error would be thrown and this test would fail. */
		signal.dispatch(cast [new TestClass()]);
	}

	public function test_adding_dispatch_method_as_listener_does_not_throw_error() : Void {
		var arg: Array<Dynamic> = new Array<Dynamic>();
		arg.push(new GenericEvent());
		var redispatchSignal: Signal = new Signal(arg);
		signal = new Signal(cast [new GenericEvent()]);
		signal.add(redispatchSignal.dispatch);
		assertTrue(true);
	}

	public function test_slot_params_should_be_sent_through_to_listener() : Void {
		var slotParams: Array<Dynamic> = new Array<Dynamic>();
		slotParams = [12345, "text", new TestClass()];

		var slot : ISlot = signal.add((number : Int, string : String, sprite : TestClass)->{
			assertEquals(number, 12345);
			assertEquals(string, "text");
			assertEquals(sprite, slotParams[2]);
		});

		slot.params = slotParams;
		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	/** Test the function.apply - maying sure we get everything we ask for. */
	public function test_slot_params_with_with_10_params_should_be_sent_through_to_listener() : Void {
		var slotParams: Array<Dynamic> = new Array<Dynamic>();
		slotParams = [12345, "text", new TestClass(), "a", "b", "c", "d", "e", "f", "g"];

		var slot : ISlot = signal.add((
			number : Int,
			string : String,
			sprite : TestClass,
			alpha0 : String,
			alpha1 : String,
			alpha2 : String,
			alpha3 : String,
			alpha4 : String,
			alpha5 : String,
			alpha6 : String)-> {

			assertEquals(number, 12345);
			assertEquals(string, "text");
			assertEquals(sprite, slotParams[2]);
			assertEquals(alpha0, "a");
			assertEquals(alpha1, "b");
			assertEquals(alpha2, "c");
			assertEquals(alpha3, "d");
			assertEquals(alpha4, "e");
			assertEquals(alpha5, "f");
			assertEquals(alpha6, "g");

		});

		slot.params = slotParams;

		signal.dispatch(new Array<Dynamic>());
		assertTrue(true);
	}

	private function checkSprite(sprite : TestClass) : Void {
		assertTrue(Std.is(sprite, TestClass));
	}
}
