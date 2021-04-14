//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdlib.h>
#include "ccqueue.h"
#define INITIAL_SIZE 20

int32_t QueueCreate(CC_QUEUE **Queue)
{
	if (NULL == Queue)
		return -1;

	if (NULL != *Queue)
		return -1;

	*Queue = (CC_QUEUE*)malloc(sizeof(CC_QUEUE));
	if (NULL == *Queue)
		return -1;

	(*Queue)->elements = malloc(INITIAL_SIZE * sizeof(void *));
	if (NULL == (*Queue)->elements)
		return -1;

	(*Queue)->currentPosition = 0;
	(*Queue)->Length = INITIAL_SIZE;

	return 0;
}

int32_t QueueDestroy(CC_QUEUE **Queue)
{
	if (NULL == Queue)
		return -1;

	if (NULL == *Queue)
		return -1;

	if (NULL != (*Queue)->elements) {
		free((*Queue)->elements);
		(*Queue)->elements = NULL;
	}

	(*Queue)->currentPosition = 0;
	(*Queue)->Length = 0;

	free(*Queue);
	*Queue = NULL;

	return 0;
}

int32_t QueueReallocate(CC_QUEUE * Queue, float resizeFactor)
{
	if (NULL == Queue) {
		return -1;
	}

	int32_t current_capacity = Queue->Length;

	int32_t new_capacity = (int32_t)(current_capacity * resizeFactor);
	int32_t bytes = new_capacity * sizeof(void *);

	if (new_capacity < current_capacity) {
		return -1;
	}

	if (bytes < new_capacity) {
		return -1;
	}

	void ** temp_location = realloc(Queue->elements, bytes);
	if (NULL == temp_location) {
		return -1;
	}

	Queue->elements = temp_location;
	Queue->Length = (int32_t)(Queue->Length * resizeFactor);

	return 0;
}

int32_t QueuePush(CC_QUEUE *Queue, void *Value)
{
	if (NULL == Queue)
		return -1;

	if (NULL == Queue->elements)
		return -1;

	if (NULL == Value) {
		return -1;
	}

	int32_t enoughSpace = 0;

	if (Queue->currentPosition == Queue->Length) {
		enoughSpace = QueueReallocate(Queue, 2);
	}

	if (enoughSpace == 0) {
		Queue->elements[Queue->currentPosition] = Value;
		Queue->currentPosition += 1;
		return 0;
	}
	return -1;
}

int32_t QueueSize(CC_QUEUE *Queue)
{
	if (NULL == Queue)
		return -1;
	return Queue->currentPosition;
}

void * QueuePop(CC_QUEUE *Queue)
{

	void* Value = NULL;

	if (NULL != Queue && Queue->currentPosition > 0) {
		Value = Queue->elements[0];

		int32_t index = 0;
		for (index; index < Queue->currentPosition - 1; index++) {
			Queue->elements[index] = Queue->elements[index + 1];
		}

		Queue->currentPosition -= 1;
	}

	return Value;

}