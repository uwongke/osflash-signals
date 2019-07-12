package org.osflash.signals;

import haxe.Constraints.Function;

interface ISignal extends IOnceSignal {
    /** Subscribes a listener for the signal. */
    function add(listener : Function) : ISlot;
}