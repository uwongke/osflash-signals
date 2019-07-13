package test.org.osflash.signals;

import org.osflash.signals.events.GenericEvent;
import org.osflash.signals.ISlot;
import org.osflash.signals.Signal;

class SlotTest extends SlotTestBase {
    override public function setup() {
        signal = new Signal();
    }

    override public function tearDown() {}

    public function test_add_listener_pause_then_resume_on_slot_should_dispatch() : Void {
        var slot : ISlot = signal.add(testCheckGenericEvent);
        slot.enabled = false;
        slot.enabled = true;

        signal.dispatch(cast[new GenericEvent()]);
    }

    public function test_addOnce_listener_pause_then_resume_on_slot_should_dispatch() : Void {
        var slot : ISlot = signal.addOnce(testCheckGenericEvent);
        slot.enabled = false;
        slot.enabled = true;

        signal.dispatch(cast[new GenericEvent()]);
    }
}