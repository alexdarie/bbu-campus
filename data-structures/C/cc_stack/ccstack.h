#pragma once

//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdint.h>

typedef
struct stack {
	void ** Elements;
	int32_t StackIndex;
	int32_t Length;
} CC_STACK;

int32_t StCreate(CC_STACK ** Stack);

int32_t StDestroy(CC_STACK ** Stack);

int32_t StPush(CC_STACK * Stack, void * Value);

int32_t StSwap(CC_STACK * Stack, int32_t pos1, int32_t pos2);

void * StPop(CC_STACK * Stack);
