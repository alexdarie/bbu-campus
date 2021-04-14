//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdlib.h>
#include <memory.h>
#include "ccvector.h"

#define INITIAL_SIZE 10
#define RESIZE_FACTOR 2

int32_t VecCreate(CC_VECTOR ** Vector)
{
	if (NULL == Vector) {
		return -1;
	}

	if (NULL != *Vector) {
		return -1;
	}

	*Vector = (CC_VECTOR*)malloc(sizeof(CC_VECTOR));
	(*Vector)->CurrentPosition = 0;
	(*Vector)->Length = 0;

	int32_t bytes = INITIAL_SIZE * sizeof(int32_t);

	//     If the value representing the amount of bytes gives us an integer overflow error we'll encounter the
	//     situation in which we put our trust in the allocation of a smaller amount of bytes because of the overflow.
	//     So we have to check if an overflow occurred...

	if (bytes < INITIAL_SIZE) {
		return -1;
	}

	(*Vector)->Elements = malloc(bytes);

	//     If the allocation wasn't successful we initialise the array length with 0 then return the error code

	if (NULL == (*Vector)->Elements) {
		return -1;
	}

	//     Otherwise everything is going fine so the array length is the initial size value. We have to set all bytes
	//     on 0, involving to set integers on 32 bits (all groups of 4 bytes) with 0.

	(*Vector)->Length = INITIAL_SIZE;
	memset((*Vector)->Elements, 0, bytes);
	return 0;

}

int32_t VecDestroy(CC_VECTOR ** Vector)
{

	CC_VECTOR * pVector = *Vector;
	if (NULL == pVector->Elements) {
		return -1;
	}

	free(pVector->Elements);
	free(pVector);

	*Vector = NULL;

	return 0;
}

int32_t VecReallocate(CC_VECTOR * Vector, float resizeFactor)
{

	int32_t current_capacity = Vector->Length;

	// If the value representing the new capacity or the amount of bytes
	// gives us an integer overflow error we'll encounter the situation
	// in which we put our trust in the allocation of a smaller amount
	// of bytes because of the overflow. So we have to check if an overflow
	// happened twice..

	int32_t new_capacity = (int32_t)(current_capacity * resizeFactor);
	int32_t bytes = new_capacity * sizeof(int32_t);

	if (new_capacity < current_capacity) {
		return -1;
	}

	if (bytes < new_capacity) {
		return -1;
	}

	int32_t * temp_location = realloc(Vector->Elements, bytes);
	if (NULL == temp_location) {
		return -1;
	}

	//
	//   0   1   2   3   4   5    6    7   8   9   10  11  12  13  14  15  16  17  18  19  20
	//  ----------------------------------------- *******************************************
	// | 2 | 9 | 0 | 1 | 3 | -7 | 10 | 0 | 0 | 0 |                something                 |
	//

	memset(temp_location + current_capacity, 0, current_capacity * sizeof(int32_t));

	//
	//   0   1   2   3   4   5    6    7   8   9   10  11  12  13  14  15  16  17  18  19  20
	//  ----------------------------------------- *******************************************
	// | 2 | 9 | 0 | 1 | 3 | -7 | 10 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
	//

	Vector->Elements = temp_location;
	Vector->Length = (int32_t)(Vector->Length * resizeFactor);

	return 0;
}

int32_t VecInsertTail(CC_VECTOR * Vector, int32_t newVectorElement)
{

	int32_t enoughSpace = 0;

	if (Vector->CurrentPosition == Vector->Length) {
		enoughSpace = VecReallocate(Vector, RESIZE_FACTOR);
	}

	// If we have enough space reallocation method will return code 0, otherwise -1

	if (0 == enoughSpace) {

		int32_t current_position = Vector->CurrentPosition;
		Vector->Elements[current_position] = newVectorElement;
		Vector->CurrentPosition += 1;

		return 0;
	}

	return -1;

}

int32_t VecInsertHead(CC_VECTOR * Vector, int32_t newVectorElement)
{
	int32_t enoughSpace = 0;

	if (Vector->CurrentPosition == Vector->Length) {
		enoughSpace = VecReallocate(Vector, RESIZE_FACTOR);
	}

	// If we have enough space reallocation method will return code 0, otherwise -1

	if (0 == enoughSpace) {

		int32_t index = 0;
		int32_t indexPredecessor = 0;

		for (index = Vector->CurrentPosition; index >= 0; index--) {

			indexPredecessor = index - 1;
			Vector->Elements[index] = Vector->Elements[indexPredecessor];

		}

		Vector->CurrentPosition += 1;
		Vector->Elements[0] = newVectorElement;

		return 0;
	}

	return -1;
}

int32_t VecInsertAfterIndex(CC_VECTOR *Vector, int32_t Index, int32_t Value)
{
	int32_t enoughSpace = 0;

	if (Index < -1)
		return -1;

	while (Vector->Length <= Index + 1 && enoughSpace == 0) {
		enoughSpace = VecReallocate(Vector, RESIZE_FACTOR);
	}

	// If we have enough space reallocation method will return code 0, otherwise -1

	if (0 == enoughSpace) {

		Vector->Elements[Index + 1] = Value;
		Vector->CurrentPosition = Index + 2;
		return 0;
	}

	return -1;
}

int32_t VecRemoveByIndex(CC_VECTOR * Vector, int32_t Index)
{
	if (Index < 0 || Index >= Vector->CurrentPosition) {
		return -1;
	}

	int32_t loop_position = Index;
	int32_t lastButOne = Vector->Length - 1;

	for (;loop_position < lastButOne; loop_position++) {
		Vector->Elements[loop_position] = Vector->Elements[loop_position + 1];
	}

	Vector->Elements[lastButOne] = 0;
	Vector->CurrentPosition -= 1;

	return 0;
}

int32_t VecGetValueByIndex(CC_VECTOR *Vector, int32_t Index, int32_t *Value)
{
	if (Index < 0 || Index >= Vector->CurrentPosition)
		return -1;

	*Value = Vector->Elements[Index];
	return 0;
}

int32_t VecGetCount(CC_VECTOR *Vector)
{
	return Vector->CurrentPosition;
}

int32_t VecClear(CC_VECTOR *Vector)
{

	if (0 == Vector->CurrentPosition)
		return -1;

	while (Vector->Length > INITIAL_SIZE) {
		VecReallocate(Vector, 0.5);
	}

	Vector->CurrentPosition = 0;
	memset(Vector, 0, INITIAL_SIZE * sizeof(int32_t));

	return 0;
}

int32_t VecSwap(CC_VECTOR *Vector, int32_t leftPosition, int32_t rightPosition)
{

	if (leftPosition < rightPosition && (leftPosition < 0 || rightPosition >= Vector->CurrentPosition)) {
		return -1;
	}

	if (leftPosition > rightPosition && (rightPosition < 0 || leftPosition >= Vector->CurrentPosition)) {
		return -1;
	}

	if (leftPosition == rightPosition) {
		return 0;
	}

	int32_t auxValue = Vector->Elements[leftPosition];
	Vector->Elements[leftPosition] = Vector->Elements[rightPosition];
	Vector->Elements[rightPosition] = auxValue;

	return 0;
}

int32_t VecSort(CC_VECTOR *Vector) {

	CC_VECTOR * PairsOfPositions = NULL;
	VecCreate(&PairsOfPositions);

	VecInsertTail(PairsOfPositions, 0);
	VecInsertTail(PairsOfPositions, VecGetCount(Vector) - 1);

	int32_t middlePosition, leftEnd, rightEnd, i, j, pivot;
	int32_t index = 0;

	for (index = 0; index < VecGetCount(PairsOfPositions); index += 2) {

		leftEnd = PairsOfPositions->Elements[index];
		rightEnd = PairsOfPositions->Elements[index + 1];

		i = leftEnd;
		j = rightEnd;

		middlePosition = (leftEnd + rightEnd) / 2;

		VecGetValueByIndex(Vector, middlePosition, &pivot);

		do {
			while (i < rightEnd && pivot > Vector->Elements[i]) i += 1;
			while (j > leftEnd && pivot < Vector->Elements[j]) j -= 1;
			if (i <= j) {
				VecSwap(Vector, i, j);
				i += 1;
				j -= 1;
			}
		} while (i <= j);

		if (leftEnd < j) {
			VecInsertTail(PairsOfPositions, leftEnd);
			VecInsertTail(PairsOfPositions, j);
		}

		if (i < rightEnd) {
			VecInsertTail(PairsOfPositions, i);
			VecInsertTail(PairsOfPositions, rightEnd);
		}

	}

	VecDestroy(&PairsOfPositions);

	return 0;
}