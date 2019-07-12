package org.osflash.signals;

import haxe.Constraints.Function;

interface IPrioritySignal {
    /** Subscribes a listener for the signal. */
    function addWithPriority(listener : Function, priority : Int = 0) : ISlot;

    /** Subscribes a one-time listener for this signal. */
    function addOnceWithPriority(listener : Function, priority : Int = 0) : ISlot;
}
