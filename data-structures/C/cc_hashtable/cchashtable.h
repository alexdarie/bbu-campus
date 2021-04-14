#pragma once

//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdint.h>
// I choose this size to be easier to debug
#define TABLE_SIZE 37

typedef struct hashTableNode {
	char* key;
	int32_t value;
	struct hashTableNode * next;
} CC_HASH_NODE;

typedef struct _CC_HASH_TABLE {
	CC_HASH_NODE* table[TABLE_SIZE];
	int32_t(*preHashing)(char*);
	int32_t(*hashing)(char*);
	int32_t tableSize;
	int32_t count;
} CC_HASH_TABLE;

int32_t HtCreate(CC_HASH_TABLE** HashTable);
int32_t HtDestroy(CC_HASH_TABLE** HashTable);

int32_t HtSetKeyValue(CC_HASH_TABLE* HashTable, char* Key, int32_t Value);
int32_t HtGetKeyValue(CC_HASH_TABLE* HashTable, char* Key, int32_t *Value);
int32_t HtRemoveKey(CC_HASH_TABLE* HashTable, char* Key);
int32_t HtHasKey(CC_HASH_TABLE* HashTable, char* Key);
int32_t HtGetNthKey(CC_HASH_TABLE* HashTable, int32_t Index, char** Key);
int32_t HtClear(CC_HASH_TABLE* HashTable);
int32_t HtGetKeyCount(CC_HASH_TABLE* HashTable);


typedef struct HashIterator {
	CC_HASH_TABLE * table;
	CC_HASH_NODE * currentNode;
	int32_t currentPosition;
} CC_HASH_ITERATOR;

int32_t HtItCreate(CC_HASH_ITERATOR ** It, CC_HASH_TABLE * hashTable);
int32_t HtItNext(CC_HASH_ITERATOR * It);
int32_t HtItHasNext(CC_HASH_ITERATOR *It);
int32_t HtItDestroy(CC_HASH_ITERATOR **It);
