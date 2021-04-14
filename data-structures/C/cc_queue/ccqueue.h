#pragma once

//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdint.h>

typedef
struct queue {
	void ** elements;
	int32_t currentPosition;
	int32_t Length;
}CC_QUEUE;

int32_t QueueCreate(CC_QUEUE **Queue);

int32_t QueueDestroy(CC_QUEUE **Queue);

int32_t QueuePush(CC_QUEUE *Queue, void *Value);

int32_t QueueSize(CC_QUEUE *Queue);

void * QueuePop(CC_QUEUE *Queue);
