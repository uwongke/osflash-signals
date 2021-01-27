package test.org.osflash.signals;

import org.osflash.signals.PrioritySignal;
import org.osflash.signals.Signal;
import org.osflash.signals.Slot;
import org.osflash.signals.SlotList;
import org.osflash.signals.ISlot;

import haxe.Constraints.Function;

class SlotListTest extends haxe.unit.TestCase {

	private var signal : Signal;
	private var listenerA : Function;
	private var listenerB : Function;
	private var listenerC : Function;
	private var slotA : ISlot;
	private var slotB : ISlot;
	private var slotC : ISlot;
	private var listOfA : SlotList;
	private var listOfAB : SlotList;
	private var listOfABC : SlotList;

	override public function setup() {
		signal = new Signal();
		listenerA = cast function(e : Dynamic = null) : Void {};
		listenerB = cast function(e : Dynamic = null) : Void {};
		listenerC = cast function(e : Dynamic = null) : Void {};
		slotA = new Slot(listenerA, signal);
		slotB = new Slot(listenerB, signal);
		slotC = new Slot(listenerC, signal);
		listOfA = new SlotList(slotA);
		listOfAB = listOfA.append(slotB);
		listOfABC = listOfAB.append(slotC);
	}

	public function test_NIL_has_length_zero() : Void {
		assertEquals(0, SlotList.NIL.length);
	}

	public function test_tail_defaults_to_NIL_if_omitted_in_constructor() : Void {
		var noTail : SlotList = new SlotList(slotA);
		assertEquals(SlotList.NIL, noTail.tail);
	}

	public function test_tail_defaults_to_NIL_if_passed_null_in_constructor() : Void {
		var nullTail : SlotList = new SlotList(slotA, null);
		assertEquals(SlotList.NIL, nullTail.tail);
	}

	/** We are expecting this to throw.. that's the desired outcome. */
	@:meta(Test(expects="ArgumentError"))
	public function test_constructing_with_null_head_throws_error() : Void {
		try{
			new SlotList(null, listOfA);
		}catch(error: js.lib.Error){
			assertTrue(true);
		}
	}

	public function test_list_with_one_listener_contains_it() : Void {
		assertTrue(listOfA.contains(listenerA));
	}

	public function test_find_the_only_listener_yields_its_slot() : Void {
		assertEquals(slotA, listOfA.find(listenerA));
	}

	public function test_list_with_one_listener_has_it_in_its_head() : Void {
		assertEquals(listenerA, listOfA.head.listener);
	}

	public function test_NIL_does_not_contain_anonymous_listener() : Void {
		assertFalse(SlotList.NIL.contains(function() : Void {}));
	}

	public function test_find_in_empty_list_yields_null() : Void {
		assertEquals(SlotList.NIL.find(listenerA), null);
	}

	public function test_NIL_does_not_contain_null_listener() : Void {
		assertFalse(SlotList.NIL.contains(null));
	}

	public function test_find_the_1st_of_2_listeners_yields_its_slot() : Void {
		assertEquals(slotA, listOfAB.find(listenerA));
	}

	public function test_find_the_2nd_of_2_listeners_yields_its_slot() : Void {
		assertEquals(slotB, listOfAB.find(listenerB));
	}

	public function test_find_the_1st_of_3_listeners_yields_its_slot() : Void {
		assertEquals(slotA, listOfABC.find(listenerA));
	}

	public function test_find_the_2nd_of_3_listeners_yields_its_slot() : Void {
		assertEquals(slotB, listOfABC.find(listenerB));
	}

	public function test_find_the_3rd_of_3_listeners_yields_its_slot() : Void {
		assertEquals(slotC, listOfABC.find(listenerC));
	}

	public function test_prepend_a_slot_makes_it_head_of_new_list() : Void {
		var newList : SlotList = listOfA.prepend(slotB);
		assertEquals(slotB, newList.head);
	}

	public function test_prepend_a_slot_makes_the_old_list_the_tail() : Void {
		var newList : SlotList = listOfA.prepend(slotB);
		assertEquals(listOfA, newList.tail);
	}

	public function test_after_prepend_slot_new_list_contains_its_listener() : Void {
		var newList : SlotList = listOfA.prepend(slotB);
		assertTrue(newList.contains(slotB.listener));
	}

	public function test_append_a_slot_yields_new_list_with_same_head() : Void {
		var oldHead : ISlot = listOfA.head;
		var newList : SlotList = listOfA.append(slotB);
		assertEquals(oldHead, newList.head);
	}

	public function test_append_to_list_of_one_yields_list_of_length_two() : Void {
		var newList : SlotList = listOfA.append(slotB);
		assertEquals(2, newList.length);
	}

	public function test_after_append_slot_new_list_contains_its_listener() : Void {
		var newList : SlotList = listOfA.append(slotB);
		assertTrue(newList.contains(slotB.listener));
	}

	public function test_append_slot_yields_a_different_list() : Void {
		var newList : SlotList = listOfA.append(slotB);
		assertTrue(listOfA !=newList);
	}

	public function test_append_null_yields_same_list() : Void {
		var newList : SlotList = listOfA.append(null);
		assertEquals(listOfA, newList);
	}

	public function test_filterNot_on_empty_list_yields_same_list() : Void {
		var newList : SlotList = SlotList.NIL.filterNot(listenerA);
		assertEquals(SlotList.NIL, newList);
	}

	public function test_filterNot_null_yields_same_list() : Void {
		var newList : SlotList = listOfA.filterNot(null);
		assertEquals(listOfA, newList);
	}

	public function test_filterNot_head_from_list_of_1_yields_empty_list() : Void {
		var newList : SlotList = listOfA.filterNot(listOfA.head.listener);
		assertEquals(SlotList.NIL, newList);
	}

	public function test_filterNot_1st_listener_from_list_of_2_yields_list_of_2nd_listener() : Void {
		var newList : SlotList = listOfAB.filterNot(listenerA);
		assertEquals(listenerB, newList.head.listener);
		assertEquals(1, newList.length);
	}

	public function test_filterNot_2nd_listener_from_list_of_2_yields_list_of_head() : Void {
		var newList : SlotList = listOfAB.filterNot(listenerB);
		assertEquals(listenerA, newList.head.listener);
		assertEquals(1, newList.length);
	}

	public function test_filterNot_2nd_listener_from_list_of_3_yields_list_of_1st_and_3rd() : Void {
		var newList : SlotList = listOfABC.filterNot(listenerB);
		assertEquals(listenerA, newList.head.listener);
		assertEquals(listenerC, newList.tail.head.listener);
		assertEquals(2, newList.length);
	}

	public function test_insertWithPriority_adds_4_slots_without_losing_any() : Void {
		var s : PrioritySignal = new PrioritySignal();
		var l1 : Function = function() : Void {}
		var l2 : Function = function() : Void {}
		var l3 : Function = function() : Void {}
		var l4 : Function = function() : Void {}
		var slot1 : ISlot = new Slot(l1, s);
		var slot2 : ISlot = new Slot(l2, s, false, -1);
		var slot3 : ISlot = new Slot(l3, s);
		var slot4 : ISlot = new Slot(l4, s);
		var list : SlotList = new SlotList(slot1);
		list = list.insertWithPriority(slot2);
		list = list.insertWithPriority(slot3);
		list = list.insertWithPriority(slot4);

		/** This was failing because one slot was being lost. */
		assertEquals(4, list.length);  // number of slots in list */
		assertEquals(slot1, list.head);
		assertEquals(slot3, list.tail.head);
		assertEquals(slot4, list.tail.tail.head);
		assertEquals(slot2, list.tail.tail.tail.head);
	}

	override public function tearDown() {}
}