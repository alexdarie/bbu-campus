//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdlib.h>
#include "ccheap.h"
#include "../cc_vector/ccvector.h"

#define INITIAL_SIZE 10

int32_t minimum(int32_t value1, int32_t value2)
{
	return value1 < value2 ? value1 : value2;
}

int32_t HpCreateMaxHeap(CC_HEAP **MaxHeap, CC_VECTOR* InitialElements)
{
	if (NULL == MaxHeap) {
		return -1;
	}

	if (NULL != *MaxHeap) {
		return -1;
	}

	*MaxHeap = (CC_HEAP*)malloc(sizeof(CC_HEAP));
	if (NULL == *MaxHeap) {
		return -1;
	}


	int32_t initial_size = INITIAL_SIZE;
	if (NULL != InitialElements) {
		if (InitialElements->CurrentPosition > initial_size) {
			initial_size = InitialElements->CurrentPosition;
		}
		(*MaxHeap)->currentPosition = InitialElements->CurrentPosition;
	}

	(*MaxHeap)->elements = malloc(initial_size * sizeof(int32_t));
	if (NULL == (*MaxHeap)->elements) {
		return -1;
	}

	(*MaxHeap)->currentPosition = 0;
	(*MaxHeap)->length = initial_size;
	(*MaxHeap)->sign = 1;

	if (NULL != InitialElements) {

		int32_t index;
		for (index = 0; index < InitialElements->CurrentPosition; index++) {
			(*MaxHeap)->elements[index] = InitialElements->Elements[index];
		}

		int32_t root = 0, parent = 0, son = 0, valueOfCurrentNode = 0, length = (*MaxHeap)->currentPosition;
		for (root = (length - 2) / 2; root >= 0; root--) {

			parent = root;
			son = parent * 2 + 1;
			valueOfCurrentNode = (*MaxHeap)->elements[root];

			while (son <= length - 1) {
				if (son < length - 1) {
					if ((*MaxHeap)->elements[son] < (*MaxHeap)->elements[son + 1])
						son += 1;
				}

				if (valueOfCurrentNode < (*MaxHeap)->elements[son]) {
					(*MaxHeap)->elements[parent] = (*MaxHeap)->elements[son];
					parent = son;
					son = son * 2 + 1;
				}
				else {
					break;
				}
			}

			(*MaxHeap)->elements[parent] = valueOfCurrentNode;

		}
	}

	return 0;
}

int32_t HpCreateMinHeap(CC_HEAP **MinHeap, CC_VECTOR* InitialElements)
{
	if (NULL == MinHeap) {
		return -1;
	}

	if (NULL != *MinHeap) {
		return -1;
	}

	*MinHeap = (CC_HEAP*)malloc(sizeof(CC_HEAP));
	if (NULL == *MinHeap) {
		return -1;
	}

	int32_t initial_size = INITIAL_SIZE;
	if (NULL != InitialElements) {
		if (InitialElements->CurrentPosition > initial_size) {
			initial_size = InitialElements->CurrentPosition;
		}
		(*MinHeap)->currentPosition = InitialElements->CurrentPosition;
	}

	(*MinHeap)->elements = malloc(initial_size * sizeof(int32_t));
	if (NULL == (*MinHeap)->elements) {
		return -1;
	}

	(*MinHeap)->currentPosition = 0;
	(*MinHeap)->length = initial_size;
	(*MinHeap)->sign = -1;

	if (NULL != InitialElements) {

		int32_t index;
		for (index = 0; index < InitialElements->CurrentPosition; index++) {
			(*MinHeap)->elements[index] = InitialElements->Elements[index];
		}

		int32_t root = 0;
		int32_t parent = 0;
		int32_t son = 0;
		int32_t valueOfCurrentNode = 0;
		int32_t length = (*MinHeap)->currentPosition;

		for (root = (length - 2) / 2; root >= 0; root--) {

			parent = root;
			son = parent * 2 + 1;
			valueOfCurrentNode = (*MinHeap)->elements[root];

			while (son <= length - 1) {
				if (son < length - 1) {
					if ((*MinHeap)->elements[son] >(*MinHeap)->elements[son + 1])
						son += 1;
				}

				if (valueOfCurrentNode > (*MinHeap)->elements[son]) {
					(*MinHeap)->elements[parent] = (*MinHeap)->elements[son];
					parent = son;
					son = son * 2 + 1;
				}
				else {
					break;
				}
			}

			(*MinHeap)->elements[parent] = valueOfCurrentNode;

		}
	}

	return 0;
}

int32_t HpDestroy(CC_HEAP **Heap)
{
	if (NULL == Heap) {
		return -1;
	}

	if (NULL == *Heap) {
		return -1;
	}

	if (NULL != (*Heap)->elements) {
		free((*Heap)->elements);
	}

	free(*Heap);

	return 0;
}

int32_t HeapRealloc(CC_HEAP *Heap, float resizeFactor)
{

	if (NULL == Heap) {
		return -1;
	}

	int32_t current_capacity = Heap->length;

	int32_t new_capacity = (int32_t)(current_capacity * resizeFactor);
	int32_t bytes = new_capacity * sizeof(int32_t);

	if (new_capacity < current_capacity) {
		return -1;
	}

	if (bytes < new_capacity) {
		return -1;
	}

	int32_t * temp_loc = realloc(Heap->elements, bytes);
	if (NULL == temp_loc) {
		return -1;
	}

	Heap->elements = temp_loc;
	Heap->length = new_capacity;
	return 0;
}

int32_t HpInsert(CC_HEAP *Heap, int32_t Value)
{
	if (NULL == Heap) {
		return -1;
	}

	int32_t enoughSpace = 0;

	if (Heap->currentPosition >= Heap->length) {
		enoughSpace = HeapRealloc(Heap, 2);
	}

	if (0 == enoughSpace) {

		int32_t son = 0, parent = 0;
		son = Heap->currentPosition;
		parent = (son - 1) / 2;

		Heap->currentPosition += 1;

		// sign is a convention to know if is a min or max heap
		while (son > 0 && Heap->elements[parent] * (Heap->sign) < Value*(Heap->sign)) {

			Heap->elements[son] = Heap->elements[parent];
			son = parent;
			parent = (son - 1) / 2;

		}

		Heap->elements[son] = Value;

	}

	return 0;
}

int32_t HpRemove(CC_HEAP *Heap, int32_t Value)
{
	if (NULL == Heap) {
		return -1;
	}

	int32_t index = 0;
	int32_t parent = 0;
	int32_t son = 0;

	while (index < Heap->currentPosition) {
		if (Heap->elements[index] == Value) {

			Heap->elements[index] = Heap->elements[Heap->currentPosition - 1];
			int32_t pushedValueFromLastPosition = Heap->elements[index];

			Heap->currentPosition -= 1;

			parent = index;
			son = parent * 2 + 1;

			while (son <= Heap->currentPosition - 1) {
				if (son < Heap->currentPosition - 1) {
					if (Heap->elements[son] * Heap->sign < Heap->elements[son + 1] * Heap->sign)
						son += 1;
				}

				if (pushedValueFromLastPosition*Heap->sign < Heap->elements[son] * Heap->sign) {
					Heap->elements[parent] = Heap->elements[son];
					parent = son;
					son = parent * 2 + 1;
				}
				else {
					break;
				}
			}

			Heap->elements[parent] = pushedValueFromLastPosition;

		}
		else {
			index += 1;
		}
	}

	return 0;
}

int32_t HpGetExtreme(CC_HEAP *Heap, int32_t* ExtremeValue)
{
	if (NULL == Heap || NULL == ExtremeValue)
		return -1;

	*ExtremeValue = Heap->elements[0];

	return 0;
}

int32_t HpPopExtreme(CC_HEAP *Heap, int32_t* ExtremeValue)
{
	if (NULL == Heap) {
		return -1;
	}

	if (NULL == ExtremeValue) {
		return -1;
	}

	*ExtremeValue = Heap->elements[0];
	HpRemove(Heap, *ExtremeValue);

	return 0;
}

int32_t HpGetElementCount(CC_HEAP *Heap)
{
	if (NULL == Heap) {
		return -1;
	}

	return Heap->currentPosition;
}

int32_t HpSortToVector(CC_HEAP *Heap, CC_VECTOR* SortedVector)
{
	if (NULL == Heap) {
		return -1;
	}

	if (NULL == SortedVector) {
		return -1;
	}

	int32_t index = Heap->currentPosition - 1;
	int32_t aux = 0;
	int32_t son = 0;
	int32_t parent = 0;

	while (index > 0) {

		aux = Heap->elements[0];
		Heap->elements[0] = Heap->elements[index];
		Heap->elements[index] = aux;

		int32_t newTop = Heap->elements[0];

		index -= 1;

		parent = 0;
		son = (2 * parent) + 1;
		while (son <= index) {
			if (son < index) {
				if (Heap->elements[son] * Heap->sign < Heap->elements[son + 1] * Heap->sign)
					son += 1;
			}

			if (newTop*Heap->sign < Heap->elements[son] * Heap->sign) {
				Heap->elements[parent] = Heap->elements[son];
				parent = son;
				son = parent * 2 + 1;
			}
			else {
				break;
			}
		}
		Heap->elements[parent] = newTop;

	}

	for (index = 0; index < Heap->currentPosition; index++) {
		VecInsertTail(SortedVector, Heap->elements[index]);
	}

	return 0;
}