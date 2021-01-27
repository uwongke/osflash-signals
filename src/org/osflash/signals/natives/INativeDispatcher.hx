package org.osflash.signals.natives;

import openfl.events.Event;
import openfl.events.IEventDispatcher;

/** Similar to IDispatcher but using strong types specific to Flash's native event system. */
interface INativeDispatcher extends IPrioritySignal {

	/** The type of event permitted to be dispatched. Corresponds to flash.events.Event.type. */
	@:isVar public var eventType(get, never) : String;
	public function get_eventType(): String;

	/** The class of event permitted to be dispatched. Will be flash.events.Event or a subclass. */
	@:isVar public var eventClass(get, never) : Class<Dynamic>;
	public function get_eventClass(): Class<Dynamic>;

	/** The object considered the source of the dispatched events. */
	@:isVar public var target(get, set) : IEventDispatcher;
	public function get_target(): IEventDispatcher;
	public function set_target(value: IEventDispatcher): IEventDispatcher;

	/** Dispatches an event to listeners. */
	function dispatchEvent(event : Event) : Bool;
}