package org.osflash.signals;

import haxe.Constraints.Function;

/** The ISlot interface defines the basic properties of a
	listener associated with a Signal. */
interface ISlot {

	/** The listener associated with this slot. */
	@:isVar public var listener(get, set): Function;
	public function get_listener(): Function;
	public function set_listener(value: Function): Function;

	/** Allows the ISlot to inject parameters when dispatching. The params will be at
		the tail of the arguments and the ISignal arguments will be at the head. */
	@:isVar public var params(get, set): Array<Dynamic>;
	public function get_params(): Array<Dynamic>;
	public function set_params(value: Array<Dynamic>): Array<Dynamic>;

	/** Whether this slot is automatically removed after it has been used once. */
	@:isVar public var once(get, null): Bool;
	public function get_once(): Bool;

	/** The priority of this slot should be given in the execution order.
		An IPrioritySignal will call higher numbers before lower ones. */
	@:isVar public var priority(get, null): Int;
	public function get_priority(): Int;

	@:isVar public var enabled(get, set): Bool;
	public function get_enabled(): Bool;
	public function set_enabled(value: Bool): Bool;

	/** Executes a listener without arguments. */
	function execute0():Void;

	/** Dispatches one argument to a listener. */
	function execute1(value:Dynamic):Void;

	/** Executes a listener */
	function execute(valueObjects:Array<Dynamic>):Void;

	/** Removes the slot from its signal. */
	function remove():Void;
}
