#pragma once

//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdint.h>

typedef struct TreeNode {
	int32_t * information;
	int32_t duplicateFactor;
	int32_t hr, hl;
	struct TreeNode * leftChild;
	struct TreeNode * rightChild;
} CC_TREE;

int32_t TreeCreate(CC_TREE **Tree);

int32_t TreeDestroy(CC_TREE **Tree);


// Duplicates are allowed
int32_t TreeInsert(CC_TREE *Tree, int32_t Value);

// Removes all elements equal to Value
int32_t TreeRemove(CC_TREE *Tree, int32_t Value);

// Return:
//     1   - Tree contains value
//     0   - Tree does not contain Value
int32_t TreeContains(CC_TREE *Tree, int32_t Value);

int32_t TreeGetCount(CC_TREE *Tree);

int32_t TreeGetHeight(CC_TREE *Tree);

int32_t TreeClear(CC_TREE *Tree);


int32_t TreeGetNthPreorder(CC_TREE *Tree, int32_t Index, int32_t *Value);

int32_t TreeGetNthInorder(CC_TREE *Tree, int32_t Index, int32_t *Value);

int32_t TreeGetNthPostorder(CC_TREE *Tree, int32_t Index, int32_t *Value);
