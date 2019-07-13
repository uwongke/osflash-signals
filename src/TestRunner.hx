package ;

import test.org.osflash.signals.SlotTest;
import test.org.osflash.signals.SlotListTest;
import test.org.osflash.signals.events.GenericEventTest;

class TestRunner {
    var r = new haxe.unit.TestRunner();

    public function new() {
        /** Add Test Cases here.... */
        //r.add(new GenericEventTest());
        //r.add(new SlotListTest());
        r.add(new SlotTest());


        /** Run the tests*/
        r.run();
    }
}