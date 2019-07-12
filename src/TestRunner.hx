package ;

import test.org.osflash.signals.SlotTestBase;
import test.org.osflash.signals.events.GenericEventTest;

class TestRunner {
    var r = new haxe.unit.TestRunner();

    public function new() {
        /** Add Test Cases here.... */
        r.add(new GenericEventTest());
        //r.add(new SlotTestBase());
        /** Run the tests*/
        r.run();
    }
}