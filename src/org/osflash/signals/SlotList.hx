package org.osflash.signals;

/** The SlotList class represents an immutable list of Slot objects. */
import haxe.Constraints.Function;
import openfl.errors.Error;

@:final class SlotList {
    /** Represents an empty list. Used as the list terminator. */
    public static var NIL : SlotList = new SlotList(null, null);

    /** Although those variables are not const, they would be if AS3 would handle it correctly. */
    public var head : ISlot;
    public var tail : SlotList;
    public var nonEmpty : Bool = false;

    /** Creates and returns a new SlotList object. */
    public function new(head : ISlot, tail : SlotList = null) {
        if (head == null && tail == null) {
            if (NIL != null) {
                throw new Error("Parameters head and tail are null. Use the NIL element instead.");
            }

            /** this is the NIL element as per definition */
            nonEmpty = false;
        }
        else if (head == null) {
            throw new Error("Parameter head cannot be null.");
        }
        else {
            this.head = head;
            if(tail == null){
                this.tail = NIL;
            } else {
                this.tail = tail;
            }
            //this.tail = tail || NIL;
            nonEmpty = true;
        }
    }

    @:isVar public var length(get, never) : Int;
    /** The number of slots in the list. */
    private function get_length() : Int {
        if (!nonEmpty) {
            return 0;
        }
        if (tail == NIL) {
            return 1;
        }

        /** We could cache the length, but it would make methods like filterNot unnecessarily complicated.
		    Instead we assume that O(n) is okay since the length property is used in rare cases.
			We could also cache the length lazy, but that is a waste of another 8b per list node (at least). */
        var result : Int = 0;
        var p : SlotList = this;

        while (p.nonEmpty) {
            ++result;
            p = p.tail;
        }

        return result;
    }

    /** Prepends a slot to this list. */
    public function prepend(slot : ISlot) : SlotList {
        return new SlotList(slot, this);
    }

    /** Appends a slot to this list. */
    public function append(slot : ISlot) : SlotList {
        if (slot == null) {
            return this;
        }
        if (!nonEmpty) {
            return new SlotList(slot);
        }

        /** Special case: just one slot currently in the list. */
        if (tail == NIL) {
            return new SlotList(slot).prepend(head);
        }

        /** The list already has two or more slots.
			We have to build a new list with cloned items because they are immutable. */
        var wholeClone : SlotList = new SlotList(head);
        var subClone : SlotList = wholeClone;
        var current : SlotList = tail;

        while (current.nonEmpty) {
            subClone = subClone.tail = new SlotList(current.head);
            current = current.tail;
        }
        /** Append the new slot last. */
        subClone.tail = new SlotList(slot);
        return wholeClone;
    }

    /** Insert a slot into the list in a position according to its priority. */
    public function insertWithPriority(slot : ISlot) : SlotList {
        if (!nonEmpty) {
            return new SlotList(slot);
        }

        var priority : Int = slot.priority;
        /** Special case: new slot has the highest priority. */
        if (priority > this.head.priority) {
            return prepend(slot);
        }

        var wholeClone : SlotList = new SlotList(head);
        var subClone : SlotList = wholeClone;
        var current : SlotList = tail;

        /** Find a slot with lower priority and go in front of it. */
        while (current.nonEmpty) {
            if (priority > current.head.priority) {
                subClone.tail = current.prepend(slot);
                return wholeClone;
            }
            subClone = subClone.tail = new SlotList(current.head);
            current = current.tail;
        }

        /** Slot has lowest priority. */
        subClone.tail = new SlotList(slot);
        return wholeClone;
    }

    /** Returns the slots in this list that do not contain the supplied listener. */
    public function filterNot(listener : Function) : SlotList {
        if (!nonEmpty || listener == null) {
            return this;
        }

        if (listener == head.listener) {
            return tail;
        }

        /** The first item wasn't a match so the filtered list will contain it. */
        var wholeClone : SlotList = new SlotList(head);
        var subClone : SlotList = wholeClone;
        var current : SlotList = tail;

        while (current.nonEmpty) {

            /** Splice out the current head. */
            if (current.head.listener == listener) {
                subClone.tail = current.tail;
                return wholeClone;
            }

            subClone = subClone.tail = new SlotList(current.head);
            current = current.tail;
        }

        /** The listener was not found so this list is unchanged. */
        return this;
    }

    /** Determines whether the supplied listener Function is contained within this list */
    public function contains(listener : Function) : Bool {
        if (!nonEmpty) {
            return false;
        }

        var p : SlotList = this;
        while (p.nonEmpty) {
            if (p.head.listener == listener) {
                return true;
            }
            p = p.tail;
        }

        return false;
    }

    /** Retrieves the ISlot associated with a supplied listener within the SlotList. */
    public function find(listener : Function) : ISlot {
        if (!nonEmpty) {
            return null;
        }

        var p : SlotList = this;
        while (p.nonEmpty) {
            if (p.head.listener == listener) {
                return p.head;
            }
            p = p.tail;
        }

        return null;
    }

    public function toString() : String {
        var buffer : String = "";
        var p : SlotList = this;

        while (p.nonEmpty) {
            buffer += p.head + " -> ";
            p = p.tail;
        }

        buffer += "NIL";

        return "[List " + buffer + "]";
    }
}