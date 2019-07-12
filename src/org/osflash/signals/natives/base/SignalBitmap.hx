//package org.osflash.signals.natives.base;
//
//import openfl.display.Bitmap;
//
//class SignalBitmap extends Bitmap {
//    public var signals(get, never) : DisplayObjectSignalSet;
//
//    private var _signals : DisplayObjectSignalSet;
//
//    private function get_signals() : DisplayObjectSignalSet {
//        return _signals = (_signals != null) ? _signals : new DisplayObjectSignalSet(this);
//    }
//
//    public function new() {
//        super();
//    }
//}
