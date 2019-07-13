package test.org.osflash.signals;

import org.osflash.signals.ISlot;
import haxe.Constraints.Function;
import org.osflash.signals.ISignal;

class SignalTestBase extends haxe.unit.TestCase {

    private var signal : ISignal;

    public function destroySignal() : Void {
        //signal.removeAll();
        //signal = null;
    }

    override public function setup() {}
    override public function tearDown() {}

    public function test_numListeners_is_0_after_creation(): Void {
        assertEquals(0, signal.numListeners);
    }

    public function test_addOnce_and_dispatch_should_remove_listener_automatically() : Void {
        signal.addOnce(newEmptyHandler());
        dispatchSignal();

        /** there should be no listeners */
        assertEquals(0, signal.numListeners);
    }
//
//    public function test_add_listener_then_remove_then_dispatch_should_not_call_listener() : Void {
//        signal.add(failIfCalled);
//        signal.remove(failIfCalled);
//        dispatchSignal();
//    }
//
//    public function test_add_listener_then_remove_function_not_in_listeners_should_do_nothing() : Void {
//        signal.add(newEmptyHandler());
//        signal.remove(newEmptyHandler());
//        assertEquals(1, signal.numListeners);
//    }
//
//    public function test_add_2_listeners_remove_2nd_then_dispatch_should_call_1st_not_2nd_listener() : Void {
//        var called : Bool = false;
//        signal.add(function(e : Dynamic = null) : Void {
//            called = true;
//        });
//        signal.add(failIfCalled);
//        signal.remove(failIfCalled);
//        dispatchSignal();
//        assertTrue(called);
//    }
//
//    public function test_add_2_listeners_should_yield_numListeners_of_2() : Void {
//        signal.add(newEmptyHandler());
//        signal.add(newEmptyHandler());
//        assertEquals(2, signal.numListeners);
//    }
//
//    public function add_2_listeners_then_remove_1_should_yield_numListeners_of_1() : Void {
//        var firstFunc : Function = newEmptyHandler();
//        signal.add(firstFunc);
//        signal.add(newEmptyHandler());
//        signal.remove(firstFunc);
//
//        assertEquals(1, signal.numListeners);
//    }
//
//    public function test_add_2_listeners_then_removeAll_should_yield_numListeners_of_0() : Void {
//        signal.add(newEmptyHandler());
//        signal.add(newEmptyHandler());
//        signal.removeAll();
//        assertEquals(0, signal.numListeners);
//    }
//
//    public function test_add_same_listener_twice_should_only_add_it_once() : Void {
//        var func : Function = newEmptyHandler();
//        signal.add(func);
//        signal.add(func);
//        assertEquals(1, signal.numListeners);
//    }
//
//    public function test_addOnce_same_listener_twice_should_only_add_it_once() : Void {
//        var func : Function = newEmptyHandler();
//        signal.addOnce(func);
//        signal.addOnce(func);
//        assertEquals(1, signal.numListeners);
//    }
//
//    public function test_add_two_listeners_and_dispatch_should_call_both() : Void {
//        var calledA : Bool = false;
//        var calledB : Bool = false;
//        signal.add(function(e : Dynamic = null) : Void {
//            calledA = true;
//        });
//
//        signal.add(function(e : Dynamic = null) : Void {
//            calledB = true;
//        });
//
//        dispatchSignal();
//        assertTrue(calledA);
//        assertTrue(calledB);
//    }
//
//    public function test_add_the_same_listener_twice_should_not_throw_error() : Void {
//        var listener : Function = newEmptyHandler();
//        signal.add(listener);
//        signal.add(listener);
//    }
//
//    public function test_can_use_anonymous_listeners(): Void {
//        var slots : Array<Dynamic> = [];
//
//        for (i in 0...10) {
//            slots.push(signal.add(newEmptyHandler()));
//        }
//        /** there should be 10 listeners */
//        assertEquals(10, signal.numListeners);
//
//        for (slot in slots) {
//            signal.remove(slot.listener);
//        }
//        /** all anonymous listeners removed */
//        assertEquals(0, signal.numListeners);
//    }
//
//    public function test_can_use_anonymous_listeners_in_addOnce() : Void {
//        var slots : Array<Dynamic> = [];
//
//        for (i in 0...10) {
//            slots.push(signal.addOnce(newEmptyHandler()));
//        }
//
//        /** there should be 10 listeners */
//        assertEquals(10, signal.numListeners);
//
//        for (slot in slots) {
//            signal.remove(slot.listener);
//        }
//
//        /** all anonymous listeners removed */
//        assertEquals(0, signal.numListeners);
//    }
//
//    public function test_add_listener_returns_slot_with_same_listener() : Void {
//        var listener : Function = newEmptyHandler();
//        var slot : ISlot = signal.add(listener);
//        assertEquals(listener, slot.listener);
//    }
//
//    public function test_remove_listener_returns_same_slot_as_when_it_was_added() : Void {
//        var listener : Function = newEmptyHandler();
//        var slot : ISlot = signal.add(listener);
//        assertEquals(slot, signal.remove(listener));
//    }
//
//
//    /** UTILITY METHODS */
//
    private function addListenerDuringDispatch(e : Dynamic = null): Void {
        signal.add(failIfCalled);
    }

    private function allRemover(e : Dynamic = null): Void {
        signal.removeAll();
    }

    private function selfRemover(e : Dynamic = null) : Void {
        signal.remove(selfRemover);
    }

    private function dispatchSignal() : Void {
        signal.dispatch(new Array<Dynamic>());
    }

    private static function newEmptyHandler(): Function {
        return function(args: Array<Dynamic> = null): Void {};
    }

    private static function failIfCalled(e : Dynamic = null) : Void {
        throw new js.lib.Error("This function should not have been called.");
    }
}


/** Possibly excluded due to missing 'async' */

//public function test_dispatch_2_listeners_1st_listener_removes_itself_then_2nd_listener_is_still_called() : Void {
//signal.add(selfRemover);
/** async.add verifies the second listener is called */
//signal.add(async.add(newEmptyHandler(), 10));
//dispatchSignal();
//}

//public function test_dispatch_2_listeners_1st_listener_removes_all_then_2nd_listener_is_still_called() : Void {
//    signal.add(async.add(allRemover, 10));
//    signal.add(async.add(newEmptyHandler(), 10));
//    dispatchSignal();
//}

//public function test_adding_a_listener_during_dispatch_should_not_call_it(): Void {
//    signal.add(async.add(addListenerDuringDispatch, 10));
//    dispatchSignal();
//}