//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdlib.h>
#include "cclist.h"

// ------------------------------------------------------
// -------------------- Utils ---------------------------

int32_t min(int32_t value1, int32_t value2)
{
	if (value1 < value2)
		return value1;
	return value2;
}

int32_t LstPushValue(CC_LIST_ENTRY *List, int32_t Value)
{
	if (NULL == List)
		return -1;

	struct Node * newNode = (struct Node*)malloc(sizeof(struct Node));
	newNode->list = List;
	newNode->next = NULL;
	newNode->element = (int32_t*)malloc(sizeof(int32_t));
	*(newNode->element) = Value;

	LstIterator * It = NULL;
	LstItCreate(&It, List);

	while (LstItHasNext(It)) {
		LstItNext(It);
	}

	LstItGetNode(It)->next = newNode;

	LstItDestroy(&It);

	return 0;
}

CC_LIST_ENTRY * LstCopy(CC_LIST_ENTRY * List, int32_t leftPosition, int32_t rightPosition)
{
	CC_LIST_ENTRY * newList = NULL;
	LstCreate(&newList);

	LstIterator * It = NULL;
	LstItCreate(&It, List);
	LstItNext(It);

	int32_t leftPositionCopy = leftPosition;
	while (leftPositionCopy) {
		LstItNext(It);
		leftPositionCopy -= 1;
	}

	while (isValidLstIt(It) && rightPosition - leftPosition + 1) {
		LstPushValue(newList, *(It->Cursor->element));
		LstItNext(It);
		rightPosition -= 1;
	}

	LstItDestroy(&It);
	return newList;
}

int32_t LstOverwrite(CC_LIST_ENTRY *Destination, CC_LIST_ENTRY *Source, int32_t beginning)
{

	LstIterator * sIt = NULL;
	LstItCreate(&sIt, Source);
	LstItNext(sIt);

	LstIterator * dIt = NULL;
	LstItCreate(&dIt, Destination);
	LstItNext(dIt);

	while (beginning) {
		beginning -= 1;
		LstItNext(dIt);
	}

	while (isValidLstIt(sIt) && isValidLstIt(dIt)) {
		*(LstItGetNode(dIt)->element) = *(LstItGetNode(sIt)->element);
		LstItNext(sIt);
		LstItNext(dIt);
	}

	LstItDestroy(&sIt);
	LstItDestroy(&dIt);

	return 0;

}

// ------------------------------------------------------
// ------ Implementation for a singly linked list -------

int32_t LstCreate(CC_LIST_ENTRY ** List)
{
	if (NULL != *List) {
		return -1;
	}

	*List = (CC_LIST_ENTRY*)malloc(sizeof(CC_LIST_ENTRY));
	if (NULL == *List)
		return -1;

	(*List)->list = *List;
	(*List)->element = NULL;
	(*List)->next = NULL;

	return 0;
}

int32_t LstDestroy(CC_LIST_ENTRY ** List)
{
	if (NULL == *List)
		return -1;

	LstIterator * It = NULL;
	LstItCreate(&It, *List);

	while (isValidLstIt(It)) {
		struct Node * destroyTarget = LstItGetNode(It);
		LstItNext(It);
		free(destroyTarget);
	}

	LstItDestroy(&It);
	*List = NULL;
	return 0;
}


int32_t LstInsertValue(CC_LIST_ENTRY *List, int32_t Value)
{
	if (NULL == List)
		return -1;

	struct Node * newNode = (struct Node*)malloc(sizeof(struct Node));
	newNode->list = List;
	newNode->next = NULL;
	newNode->element = (int32_t*)malloc(sizeof(int32_t));
	*(newNode->element) = Value;

	LstIterator * It = NULL;
	LstItCreate(&It, List);

	// If list is empty, the first node will be newNode
	if (NULL == LstItGetNode(It)->next)
		LstItGetNode(It)->next = newNode;
		// Otherwise newNode will take the address of first node and the pseudo node will point out to the newNode
	else {
		newNode->next = LstItGetNode(It)->next;
		LstItGetNode(It)->next = newNode;
	}

	LstItDestroy(&It);

	return 0;
}

int32_t LstRemoveValue(CC_LIST_ENTRY *Node)
{
	// I considered that a node has to be associated to a list, and we have three cases:
	//      > its list is the null list
	//      > we say that is associated to a list but isn't present in that list
	//      > we say that is associated to a list and it really is present in that list

	if (NULL == Node)
		return -1;

	if (NULL == Node->list)
		return -1;

	LstIterator * It = NULL;
	LstItCreate(&It, Node->list);

	while (LstItHasNext(It) && LstItGetSuccessor(It) != Node)
		LstItNext(It);

	if (!LstItHasNext(It))
		return -1;

	struct Node * linkHolder = LstItGetSuccessor(It);
	LstItGetNode(It)->next = linkHolder->next;
	free(linkHolder);

	LstItDestroy(&It);
	return 0;

}

int32_t LstReverse(CC_LIST_ENTRY *List){

	if(NULL == List){
		return -1;
	}

	CC_LIST_ENTRY * left = NULL;
    CC_LIST_ENTRY *right = NULL;
    CC_LIST_ENTRY * temp = NULL;

    left = List->next;
	if(NULL != left) {
		right = left->next;
	} else {
		return 0;
	}

	while(NULL != right){
		temp = right->next;
		right->next = left;
		left = right;
		right = temp;
	}

    List->next->next = NULL;
    List->next = left;

    return 0;
}

int32_t LstGetNodeValue(CC_LIST_ENTRY *List, CC_LIST_ENTRY *Node, int32_t *Value)
{
	LstIterator * It = NULL;

	if (-1 == LstItCreate(&It, List))
		return -1;

	while (isValidLstIt(It) && LstItGetNode(It) != Node) {
		LstItNext(It);
	}

	if (!isValidLstIt(It))
		return -1;

	if (NULL == Value)
		return -1;

	*Value = *(LstItGetNode(It)->element);
	LstItDestroy(&It);

	return 0;

}

int32_t LstGetNthNode(CC_LIST_ENTRY *List, int32_t Index, CC_LIST_ENTRY **Node)
{
	LstIterator * It = NULL;
	if (-1 == LstItCreate(&It, List))
		return -1;

	Index += 1;

	while (isValidLstIt(It) && 0 < Index) {
		Index -= 1;
		LstItNext(It);
	}

	if (!isValidLstIt(It))
		return -1;

	*Node = LstItGetNode(It);
	LstItDestroy(&It);

	return 0;
}

int32_t LstGetNodeCount(CC_LIST_ENTRY *List)
{
	if (NULL == List)
		return 0;

	LstIterator * It = NULL;
	LstItCreate(&It, List);

	int32_t counter = 0;
	LstItNext(It);

	while (isValidLstIt(It)) {
		counter++;
		LstItNext(It);
	}

	LstItDestroy(&It);
	return counter;

}

int32_t LstClear(CC_LIST_ENTRY *List)
{
	if (NULL == List)
		return -1;

	LstIterator * It = NULL;
	LstItCreate(&It, List);

	// I don't want to deallocate the first node, just to reset its fields with null
	LstItNext(It);

	while (isValidLstIt(It)) {
		struct Node * destroyTarget = NULL;
		destroyTarget = LstItGetNode(It);
		LstItNext(It);
		free(destroyTarget);
	}

	LstItDestroy(&It);

	List->next = NULL;
	List->element = NULL;

	return 0;
}

int32_t LstSortByValues(CC_LIST_ENTRY *List)
{
	int32_t scale = 0;
	int32_t jump = 0;
	int32_t size = LstGetNodeCount(List);
	int32_t beginning = 0;
	int32_t middle = 0;
	int32_t end = 0;

	for (scale = 1; scale < size; scale *= 2) {

		//      0   1   2   3    4   5   6    7   8
		//    ---------------------------------------
		//    | 9 | 0 | 3 | -1 | 2 | 5 | 10 | 0 | 8 |
		//
		//        step 1:           scale: 1   jump = 2                           V merge V
		//                          beginning = 0, middle = 0, end = 1   -> [0], [1]
		//
		//            overwrite:  * 0 * 9 * 3 | -1 | 2 | 5 | 10 | 0 | 8 |
		//
		//                          beginning = 2, middle = 2, end = 3   -> [2], [3]
		//                          beginning = 4, middle = 4, end = 5   -> [4], [5]
		//                          beginning = 8, middle = 6, end = 7   -> [6], [7]
		//
		//        step 2:           scale: 2   jump = 4
		//                          beginning = 0, middle = 1, end = 3   -> [0,1], [2,3]
		//                          beginning = 4, middle = 5, end = 7   -> [4,5], [6,7]
		//                          beginning = 8, middle = 9, end = 11  -> [8,9], [10,11]
		//
		//        step 3:           scale: 4   jump = 8
		//                          beginning = 0, middle = 3, end = 7   -> [0,1,2,3], [4,5,6,7]
		//                          beginning = 8, middle = 11, end = 15 -> [8], []
		//
		//        step 4:           scale: 8   jump: 16
		//                          beginning = 0, middle = 7, end = 15  -> [0,1,2,3,4,5,6,7], [8]
		//

		for (jump = 0; jump < size; jump += 2 * scale) {

			beginning = jump;
			end = beginning + 2 * scale - 1;
			middle = (beginning + end) / 2;

			CC_LIST_ENTRY * a = LstCopy(List, beginning, middle);
			CC_LIST_ENTRY * b = LstCopy(List, middle + 1, end);

			LstMergeSortedLists(a, b);
			LstOverwrite(List, a, beginning);

			LstDestroy(&a);
			LstDestroy(&b);
		}
	}

	return 0;
}

int32_t LstMergeSortedLists(CC_LIST_ENTRY *Destination, CC_LIST_ENTRY *Source)
{
	if (NULL == Destination || NULL == Source)
		return -1;

	if (NULL == Destination->next) {
		Destination->next = Source->next;
		return 0;
	}

	if (NULL == Source->next)
		return 0;

	// Create an iterator on the destination list which will point to the first node which is a pseudo node (doesn't
	// hold something):

	LstIterator * dIt = NULL;
	LstItCreate(&dIt, Destination->next);

	// Create an iterator on the source list which will point to the first node which is a pseudo node (doesn't
	// hold something):

	LstIterator * sIt = NULL;
	LstItCreate(&sIt, Source->next);

	// In order to merge those two lists we have to decide which list has the smallest first element. We have to keep
	// in mind that we are talking about the first element which has a value attached to it. This decision will affect
	// the iterators, destination being always the one that has the smallest element on the first position. It is possible
	// to change the destination because of the pseudo node which is passed inside this function via list pointer.

	if (*(LstItGetNode(sIt)->element) < *(LstItGetNode(dIt)->element)) {

		// Because the first node isn't a storage node, only a pseudo node, we have to increment the iterator to a node
		// that actually holds something:

		sIt->Cursor = Destination->next;
		dIt->Cursor = Source->next;

		// Modify the destination because the source list has the smallest element:

		Destination->next = Source->next;
	}

	// We'll use the "cut" node to store the address of the node before which we have cut the list in order to put the
	// source iterator to that "position" in the list.

	struct Node * lastCut = NULL;

	//
	//   dIt  * * * * * * * * * * * * * * * * * * *   --------- sIt ( it holds the list )
	//                                            *  |
	//   sIt  *                                   V  v
	//        *      destination : | 0x10 | --> * 0x20 * --> | 0x30 | --> | 0x40 | --> | 0x50 | --> | null |
	//        *                    | null |     *   0  *     |   1  |     |   3  |     |   7  |     |   9  |
	//        *
	//        *                                       --------- dIt
	//        * * * * * * * * * * * * * * * * * * *  |
	//                                            v  v
	//                source     : | 0x60 | --> * 0x70 * --> | 0x80 | --> | 0x90 | --> | null |
	//                             | null |     *   -1 *     |   2  |     |   5  |     |   8  |
	//
	//  ----------------------------------------------------------------------------------------------------
	//                destination: | 0x60 | -------
	//                             | null |        |
	//                                             v
	//                source     : | 0x60 | --> | 0x70 | --> | 0x80 | --> | 0x90 | --> | null |
	//                             | null |     |   -1 |     |   2  |     |   5  |     |   8  |
	//

	while (isValidLstIt(sIt)) {
		while (LstItHasNext(dIt) && *(LstItGetSuccessor(dIt)->element) <= *(LstItGetNode(sIt)->element))
			LstItNext(dIt);
		lastCut = LstItGetSuccessor(dIt);
		dIt->Cursor->next = sIt->Cursor;
		dIt->Cursor = sIt->Cursor;
		sIt->Cursor = lastCut;
	}

	//
	//                                    --------- dIt
	//                                   |
	//                                   v
	//                               | 0x20 | --> | 0x70 |  -> | 0x80 |  -> | 0x90 |  -> | null |
	//                               |   0  |     |   1  |  |  |   3  |  |  |   7  |  |  |   9  |
	//                                  ^            |  ----      |   ---      |   ---
	//                                  |            v |          v  |         v  |
	//    source      : | 0x60 | --> | 0x10 |     | 0x40 |     | 0x50 |     | 0x50 |
	//                  | null |     |   -1 |     |   2  |     |   5  |     |   8  |
	//                                  ^
	//                                  |
	//    destination : | 0x60 | -------
	//                  | null |
	//
	//    source      : | null |     Otherwise when the source will be destroyed we'll encounter the situation in which
	//                  | null |     we already freed those nodes back when we had destroyed the destination.
	//

	Source->next = NULL;
	return 0;
}

// ------------------------------------------------------
// ---------- Implementation for its iterator -----------

int32_t LstItCreate(LstIterator **It, CC_LIST_ENTRY *List)
{
	if (NULL == It) {
		return -1;
	}

	// if it is not NULL then something was probably allocated at this address
	if (NULL != *It) {
		return -1;
	}

	*It = (LstIterator*)malloc(sizeof(LstIterator));

	if (NULL == *It)
		return -1;

	(*It)->List = List;
	(*It)->Cursor = List;

	return 0;
}

int32_t LstItDestroy(LstIterator **It)
{
	if (NULL == It) {
		return -1;
	}

	if (NULL == *It)
		return -1;

	free(*It);
	*It = NULL;
	return 0;
}

int32_t LstItHasNext(LstIterator *It)
{
	if (NULL == It)
		return 0;
	if (NULL == It->Cursor)
		return 0;
	return (NULL != It->Cursor->next);
}

int32_t isValidLstIt(LstIterator *It)
{
	if (NULL == It)
		return 0;
	if (NULL == It->Cursor)
		return 0;
	return 1;
}

int32_t LstItResetOnHead(LstIterator *It)
{
	if (NULL != It) {
		It->Cursor = It->List;
		return 0;
	}
	return -1;
}

int32_t LstItNext(LstIterator *It)
{
	if (NULL != It && NULL != It->Cursor) {
		It->Cursor = It->Cursor->next;
		return 1;
	}
	return 0;
}

struct Node * LstItGetNode(LstIterator *It)
{
	if (NULL != It)
		return It->Cursor;
	else
		return NULL;
}

struct Node * LstItGetSuccessor(LstIterator *It)
{
	return It->Cursor->next;
}
