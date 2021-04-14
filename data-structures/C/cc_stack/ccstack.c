//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdlib.h>
#include "ccstack.h"
#define INITIAL_SIZE 20

int32_t StCreate(CC_STACK ** Stack)
{
	if (NULL == Stack) {
		return -1;
	}

	if (NULL != *Stack) {
		return -1;
	}

	*Stack = (CC_STACK *)malloc(sizeof(CC_STACK));

	if (NULL == *Stack) {
		return -1;
	}

	(*Stack)->Elements = malloc(INITIAL_SIZE * sizeof(void *));
	if (NULL == (*Stack)->Elements)
		return -1;

	(*Stack)->StackIndex = -1;
	(*Stack)->Length = INITIAL_SIZE;

	return 0;
}

int32_t StDestroy(CC_STACK ** Stack)
{
	if (NULL == Stack) {
		return -1;
	}

	if (NULL == *Stack) {
		return -1;
	}

	if (NULL != (*Stack)->Elements) {
		free((*Stack)->Elements);
		(*Stack)->Elements = NULL;
	}

	(*Stack)->StackIndex = -1;
	(*Stack)->Length = 0;

	free(*Stack);
	*Stack = NULL;

	return 0;
}

int32_t StackReallocate(CC_STACK * Stack, float resizeFactor)
{

	if (NULL == Stack) {
		return -1;
	}

	int32_t currentCapacity = Stack->Length;

	int32_t newCapacity = (int32_t)(currentCapacity * resizeFactor);
	int32_t bytes = newCapacity * sizeof(void *);

	if (newCapacity < currentCapacity) {
		return -1;
	}

	if (bytes < newCapacity) {
		return -1;
	}

	void ** tempLoc = realloc(Stack->Elements, bytes);
	if (NULL == tempLoc) {
		return -1;
	}

	Stack->Elements = tempLoc;
	Stack->Length = newCapacity;

	return 0;

}

int32_t StPush(CC_STACK * Stack, void * Value)
{
	if (NULL == Stack) {
		return -1;
	}

	if (NULL == Stack->Elements) {
		return -1;
	}

	if (NULL == Value) {
		return -1;
	}

	int32_t enoughSpace = 0;

	if (Stack->StackIndex == Stack->Length) {
		enoughSpace = StackReallocate(Stack, 2);
	}

	if (enoughSpace == 0) {
		Stack->StackIndex += 1;
		Stack->Elements[Stack->StackIndex] = Value;
		return 0;
	}

	return -1;
}

void * StPop(CC_STACK * Stack)
{
	void * Element = NULL;

	if (NULL != Stack && Stack->StackIndex >= 0) {
		Element = Stack->Elements[Stack->StackIndex];
		Stack->StackIndex -= 1;
	}

	return Element;
}

int32_t StSwap(CC_STACK * Stack, int32_t pos1, int32_t pos2) {

	if (NULL == Stack) {
		return -1;
	}

	if (pos1 < 0) {
		return -1;
	}

	if (pos2 > Stack->StackIndex) {
		return -1;
	}

	void* aux = Stack->Elements[pos2];
	Stack->Elements[pos2] = Stack->Elements[pos1];
	Stack->Elements[pos1] = aux;

	return 0;
}