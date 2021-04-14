#pragma once

//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include "../cc_vector/ccvector.h"
#include <stdint.h>

typedef struct Heap {
	int32_t * elements;
	int32_t currentPosition;
	int32_t length;
	int32_t sign;
} CC_HEAP;

// HpCreateMaxHeap and HpCreateMinHeap should create a max heap or a min heap,
// respectively. InitialElements is an optional parameter and, if it is not null, the constructed
// heap should initially contain all the elements in the provided vector.
int32_t HpCreateMaxHeap(CC_HEAP **MaxHeap, CC_VECTOR* InitialElements);
int32_t HpCreateMinHeap(CC_HEAP **MinHeap, CC_VECTOR* InitialElements);
int32_t HpDestroy(CC_HEAP **Heap);

int32_t HpInsert(CC_HEAP *Heap, int32_t Value);

// HpRemove should remove all elements with the value Value in the heap
int32_t HpRemove(CC_HEAP *Heap, int32_t Value);

// HpGetExtreme should return the maximum/minumum value in the heap, depending on the
// type of heap constructed
int32_t HpGetExtreme(CC_HEAP *Heap, int32_t* ExtremeValue);

// HpPopExtreme should return the maximum/minimum value in the heap, and remove all
// instances of said value from the heap
int32_t HpPopExtreme(CC_HEAP *Heap, int32_t* ExtremeValue);

int32_t HpGetElementCount(CC_HEAP *Heap);

// HpSortToVector should construct and return (in the SortedVector parameter) a vector
// sorted in increasing order containing all the elements present in the heap
int32_t HpSortToVector(CC_HEAP *Heap, CC_VECTOR* SortedVector);