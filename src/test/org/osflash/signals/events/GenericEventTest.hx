package test.org.osflash.signals.events;

import org.osflash.signals.events.IEvent;
import org.osflash.signals.events.GenericEvent;

class GenericEventTest extends haxe.unit.TestCase {
    private var instance:GenericEvent;

    override public function setup() {
        instance = new GenericEvent();
    }

    override public function tearDown() {
        instance = null;
    }

    public function testInstantiated():Void {
        assertTrue(Std.is(instance, GenericEvent));
        assertTrue(instance.target == null);
        assertFalse(instance.bubbles);
    }

    public function test_bubbles_roundtrips_through_constructor():Void {
        var bubblingEvent:GenericEvent = new GenericEvent(true);
        assertTrue(bubblingEvent.bubbles);
    }

    public function test_clone_should_be_instance_of_original_event_class():Void {
        var theClone:IEvent = instance.clone();
        assertTrue(Std.is(theClone, GenericEvent));
    }

    public function test_clone_non_bubbling_event_should_have_bubbles_false():Void {
        var theClone:GenericEvent = new GenericEvent();
        instance.clone();
        assertFalse(theClone.bubbles);
    }

    public function test_clone_bubbling_event_should_have_bubbles_true():Void {
        var bubblingEvent:GenericEvent = new GenericEvent(true);
        var theClone:IEvent = bubblingEvent.clone();
        assertTrue(theClone.bubbles);
    }
}