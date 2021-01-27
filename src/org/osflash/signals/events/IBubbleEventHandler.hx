package org.osflash.signals.events;

interface IBubbleEventHandler {
	/** Handler for event bubbling. */
	function onEventBubbled(event : IEvent) : Bool;
}