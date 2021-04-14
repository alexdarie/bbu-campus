//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdlib.h>
#include <memory.h>
#include "cchashtable.h"

void mystrcpy(char ** dest, char * source){

    *dest = source;
    int32_t counter = 0;

    while(0 != **dest){
        counter += 1;
        *dest += 1;
    }

    *dest = (char*)malloc((counter + 1)*sizeof(char));

    int32_t index = 0;
    while(0 != *source){
        (*dest)[index] = *source;
        source += 1;
        index = index + 1;
    }

    (*dest)[index] = '\0';
}

int32_t mystrcmp(char * str1, char * str2){
	while(0 != *str1 || 0 != *str2){
		if(*str1 - *str2 != 0)
			return 1;
		str1 += 1;
		str2 += 1;
	}
	return 0;
}

int32_t doPreHash(char* Key)
{

	int32_t index = 0;
	int32_t result = 0;
	while (Key[index] != '\0') {
		result += (int32_t)Key[index];
		index += 1;
	}
	return result;
}

int32_t doHash(char* Key)
{
	return doPreHash(Key) % TABLE_SIZE;
}


int32_t HtCreate(CC_HASH_TABLE** HashTable)
{
	if (NULL == HashTable) {
		return -1;
	}

	if (NULL != *HashTable) {
		return -1;
	}

	*HashTable = (CC_HASH_TABLE*)malloc(sizeof(CC_HASH_TABLE));
	if (NULL == *HashTable) {
		return -1;
	}

	(*HashTable)->tableSize = TABLE_SIZE;
	(*HashTable)->count = 0;
	int32_t bytes = TABLE_SIZE * sizeof(void*);
	memset((*HashTable)->table, 0, bytes);
	(*HashTable)->preHashing = doPreHash;
	(*HashTable)->hashing = doHash;

	return 0;
}

int32_t HtDestroy(CC_HASH_TABLE** HashTable)
{
	if (NULL == HashTable) {
		return -1;
	}

	if (NULL == *HashTable) {
		return -1;
	}

	int32_t index = 0;
	for (; index < TABLE_SIZE; index++) {
		if (NULL != (*HashTable)->table[index]) {
			CC_HASH_NODE * head = (*HashTable)->table[index];
			CC_HASH_NODE * temp = NULL;
			while (NULL != head) {
				temp = head;
				head = head->next;
				free(temp);
			}
			(*HashTable)->table[index] = NULL;
		}
	}

	free(*HashTable);
	*HashTable = NULL;

	return 0;
}


int32_t HtSetKeyValue(CC_HASH_TABLE* HashTable, char* Key, int32_t Value)
{
	if (NULL == HashTable) {
		return -1;
	}

	if (NULL == Key) {
		return -1;
	}

	int32_t position = doHash(Key);

	// check if the key already exists

	CC_HASH_NODE * head = HashTable->table[position];

	while (NULL != head) {
		if (mystrcmp(head->key, Key) == 0) {
			// if so, replace its value and jump to the end
			head->value = Value;
			return 0;
		}
		head = head->next;
	}

	// if not, create a new node and insert it
	CC_HASH_NODE * NewNode = NULL;

	NewNode = (CC_HASH_NODE*)malloc(sizeof(CC_HASH_NODE));
	if (NULL == NewNode) {
		return -1;
	}

	NewNode->key = Key;
	NewNode->value = Value;

	head = HashTable->table[position];
	NewNode->next = head;
	HashTable->table[position] = NewNode;

	HashTable->count += 1;

	return 0;
}

int32_t HtGetKeyValue(CC_HASH_TABLE* HashTable, char* Key, int32_t *Value)
{
	if (NULL == HashTable) {
		return -1;
	}

	if (NULL == Key) {
		return -1;
	}

	int32_t position = doHash(Key);
	if (NULL == HashTable->table[position]) {
		return -1;
	}

	CC_HASH_NODE * head = HashTable->table[position];

	while (NULL != head) {
		if (mystrcmp(head->key, Key) == 0) {
			*Value = head->value;
			return 0;
		}
		head = head->next;
	}

	return -1;
}

int32_t HtRemoveKey(CC_HASH_TABLE* HashTable, char* Key)
{
	if (NULL == HashTable) {
		return -1;
	}

	if (NULL == Key) {
		return -1;
	}

	int32_t position = doHash(Key);
	if (NULL == HashTable->table[position]) {
		return -1;
	}

	CC_HASH_NODE * parent = HashTable->table[position];
	CC_HASH_NODE * successor = parent->next;

	if (mystrcmp(parent->key, Key) == 0) {
		HashTable->table[position] = successor;
		free(parent);
		goto DecrementCounter;
	}

	while (NULL != successor) {
		if (mystrcmp(successor->key, Key) == 0) {
			parent->next = successor->next;
			free(successor);
			goto DecrementCounter;
		}
		parent = successor;
		successor = parent->next;
	}

DecrementCounter:
	HashTable->count -= 1;

	return 0;
}

int32_t HtHasKey(CC_HASH_TABLE* HashTable, char* Key)
{
	if (NULL == HashTable) {
		return -1;
	}

	if (NULL == Key) {
		return -1;
	}

	int32_t position = doHash(Key);
	CC_HASH_NODE * head = HashTable->table[position];

	while (NULL != head) {
		if (mystrcmp(head->key, Key) == 0) {
			return 1;
		}
		head = head->next;
	}

	return 0;
}

int32_t HtGetNthKey(CC_HASH_TABLE* HashTable, int32_t Index, char** Key)
{
	if (NULL == HashTable) {
		return -1;
	}

	CC_HASH_ITERATOR *It = NULL;
	int32_t hasNext = HtItCreate(&It, HashTable);

	while (0 == hasNext && 0 < Index) {
		Index -= 1;
		HtItNext(It);
	}

	if (NULL != It->currentNode) {
		mystrcpy(Key, It->currentNode->key);
		HtItDestroy(&It);
		return 0;
	}

	HtItDestroy(&It);
	return -1;
}

int32_t HtClear(CC_HASH_TABLE* HashTable)
{
	if (NULL == HashTable) {
		return -1;
	}

	int32_t index = 0;
	for (; index < TABLE_SIZE; index++) {
		if (NULL != HashTable->table[index]) {
			CC_HASH_NODE * head = HashTable->table[index];
			CC_HASH_NODE * temp = NULL;
			while (NULL != head) {
				temp = head;
				head = head->next;
				free(temp);
			}
			HashTable->table[index] = NULL;
		}
	}

	HashTable->count = 0;

	return 0;
}

int32_t HtGetKeyCount(CC_HASH_TABLE* HashTable)
{
	if (NULL == HashTable) {
		return 0;
	}
	return HashTable->count;
}


int32_t HtItCreate(CC_HASH_ITERATOR ** It, CC_HASH_TABLE * hashTable)
{
	if (NULL == It) {
		return -1;
	}

	// if it is not NULL then something was probably allocated at this address
	if (NULL != *It) {
		return -1;
	}

	*It = (CC_HASH_ITERATOR*)malloc(sizeof(CC_HASH_ITERATOR));
	if (NULL == *It) {
		return -1;
	}

	(*It)->currentPosition = 0;
	(*It)->table = hashTable;
	(*It)->currentNode = NULL;

	int32_t index = (*It)->currentPosition;
	CC_HASH_NODE * head = NULL;
	while (index < TABLE_SIZE) {
		head = hashTable->table[index];
		if (NULL != head) {
			(*It)->currentNode = head;
			(*It)->currentPosition = index;
			return 0;
		}
		index += 1;
	}

	return -1;

}

int32_t HtItNext(CC_HASH_ITERATOR * It)
{
	if (NULL == It) {
		return -1;
	}

	if (NULL == It->currentNode || NULL == It->currentNode->next) {
		int32_t index = It->currentPosition + 1;
		CC_HASH_NODE * head = NULL;
		while (index < TABLE_SIZE) {
			head = It->table->table[index];
			if (NULL != head) {
				It->currentNode = head;
				It->currentPosition = index;
				return 0;
			}
			index += 1;
		}
		return -1;
	}

	It->currentNode = It->currentNode->next;

	return 0;
}

int32_t HtItHasNext(CC_HASH_ITERATOR *It)
{
	if (NULL == It) {
		return 0;
	}

	if (NULL == It->currentNode) {
		return 0;
	}

	return (NULL != It->currentNode->next);
}

int32_t HtItDestroy(CC_HASH_ITERATOR **It)
{
	if (NULL == It) {
		return -1;
	}

	if (NULL == *It) {
		return -1;
	}

	free(*It);
	*It = NULL;

	return 0;
}
