#pragma once

//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdint.h>

// ------------------------------------------------------
// ---------------- Structure of a node -----------------

typedef
struct Node
{
	struct Node * list;
	struct Node * next;
	int32_t * element;
} CC_LIST_ENTRY;

//  Allocated on stack:
//  linked list pointer
//        |
//  Heap: | (allocated on heap)
//  ______v____________________________________________________
// |   __head______________                                    |
// |   |                  |                                    |
// |   |      @0x10       |     @0x20              0x30        |
// |   | [ 0x20, 0x71  ] -|- [ 0x30, 0x75 ] -- [ null, 0x79 ]  |
// |    ----------|-------            |                 |      |
// |              |                   |                 |      |
// |              v                   v                 v      |
// |            @0x71               @0x75             @0x79    |
// |             [7]                 [3]               [1]     |
// |___________________________________________________________|
//


// --------- Headers for a singly linked list -----------

int32_t LstCreate(CC_LIST_ENTRY **List);

int32_t LstDestroy(CC_LIST_ENTRY **List);


int32_t LstInsertValue(CC_LIST_ENTRY *List, int32_t Value);

int32_t LstRemoveValue(CC_LIST_ENTRY *Node);

int32_t LstReverse(CC_LIST_ENTRY *List);

int32_t LstGetNodeValue(CC_LIST_ENTRY *List, CC_LIST_ENTRY *Node, int32_t *Value);

int32_t LstGetNthNode(CC_LIST_ENTRY *List, int32_t Index, CC_LIST_ENTRY **Node);

int32_t LstGetNodeCount(CC_LIST_ENTRY *List);

int32_t LstClear(CC_LIST_ENTRY *List);


int32_t LstSortByValues(CC_LIST_ENTRY *List);

int32_t LstMergeSortedLists(CC_LIST_ENTRY *Destination, CC_LIST_ENTRY *Source);


int32_t min(int32_t value1, int32_t value2);

int32_t LstPushValue(CC_LIST_ENTRY *List, int32_t Value);

CC_LIST_ENTRY * LstCopy(CC_LIST_ENTRY * List, int32_t left_position, int32_t right_position);

int32_t LstOverwrite(CC_LIST_ENTRY *Destination, CC_LIST_ENTRY *Source, int32_t beginning);

// ------------------------------------------------------
// ------------- Structure of a list iterator -----------

typedef
struct ListIterator
{
	CC_LIST_ENTRY *List;
	CC_LIST_ENTRY *Cursor;
}LstIterator;

// ------------- Headers for a list iterator -----------

int32_t LstItCreate(LstIterator **It, CC_LIST_ENTRY *List);

int32_t LstItDestroy(LstIterator **It);

int32_t LstItHasNext(LstIterator *It);

int32_t isValidLstIt(LstIterator *It);

int32_t LstItResetOnHead(LstIterator *It);

int32_t LstItNext(LstIterator *It);

struct Node* LstItGetNode(LstIterator *It);

struct Node* LstItGetSuccessor(LstIterator *It);
