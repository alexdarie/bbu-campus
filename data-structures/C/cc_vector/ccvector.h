#pragma once

//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

// ----------------------------------------------------------
// --------------- Structure of a dynamic array -------------

#include <stdint.h>

typedef
struct _CC_VECTOR
{
	int32_t * Elements;
	int32_t CurrentPosition;
	int32_t Length;
} CC_VECTOR;


//  Stack:
//  linked list pointer
//        |
//  Heap: |
//  ______v____________________________________________________
// |   __vector____________                                    |
// |   | current          |                                    |
// |   |------------------|                                    |
// |   | length           |                                    |
// |   |------------------|                                    |
// |   |[ 0x20 ]         -|-> [ ] [ ] [ ] [ ] [ ] [ ] [ ]      |
// |    ------------------                                     |
// |___________________________________________________________|
//


// --------------- Headers for dynamic vector ---------------


int32_t VecCreate(CC_VECTOR **Vector);

int32_t VecDestroy(CC_VECTOR **Vector);


int32_t VecInsertTail(CC_VECTOR *Vector, int32_t Value);

int32_t VecInsertHead(CC_VECTOR *Vector, int32_t Value);

int32_t VecInsertAfterIndex(CC_VECTOR *Vector, int32_t Index, int32_t Value);

int32_t VecRemoveByIndex(CC_VECTOR *Vector, int32_t Index);

int32_t VecGetValueByIndex(CC_VECTOR *Vector, int32_t Index, int32_t *Value);

int32_t VecGetCount(CC_VECTOR *Vector);


int32_t VecClear(CC_VECTOR *Vector);

int32_t VecSort(CC_VECTOR *Vector);