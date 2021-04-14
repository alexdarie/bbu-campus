//
// Created by Adascalitei Alexandru on 29/11/2017.
// Babes-Bolyai University Faculty of Mathematics Computer Science
// Group: 911
//

#include <stdlib.h>
#include "cctree.h"
#include "../cc_stack/ccstack.h"
#include "../cc_queue/ccqueue.h"

// --------------- Rotations ---------------

int32_t max(int32_t value1, int32_t value2) {
	return value1 < value2 ? value2 : value1;
}

int32_t LeftRotation(CC_TREE* parent, CC_TREE* A, CC_TREE* B, CC_TREE* C) {

	A->hr = B->hl;
	A->rightChild = B->leftChild;

	B->hl = max(A->hl, A->hr) + 1;
	B->leftChild = A;

	if (parent->leftChild == A) {
		parent->hl = max(B->hl, B->hr) + 1;
		parent->leftChild = B;
	}
	else {
		parent->hr = max(B->hl, B->hr) + 1;
		parent->rightChild = B;
	}
}

int32_t RightRotation(CC_TREE* parent, CC_TREE* A, CC_TREE* B, CC_TREE* C) {

	A->hl = B->hr;
	A->leftChild = B->rightChild;

	B->hr = max(A->hl, A->hr) + 1;
	B->rightChild = A;

	if (parent->leftChild == A) {
		parent->hl = max(B->hl, B->hr) + 1;
		parent->leftChild = B;
	}
	else {
		parent->hr = max(B->hl, B->hr) + 1;
		parent->rightChild = B;
	}

}

int32_t LeftRightRotation(CC_TREE* parent, CC_TREE* A, CC_TREE* B, CC_TREE* C) {

	A->hl = B->hr;
	A->leftChild = C;

	B->hr = C->hl;
	B->rightChild = C->leftChild;

	C->hl = max(B->hl, B->hr) + 1;
	C->leftChild = B;

	RightRotation(parent, A, C, B);

}

int32_t RightLeftRotation(CC_TREE* parent, CC_TREE* A, CC_TREE* B, CC_TREE* C) {

	A->hr = B->hl;
	A->rightChild = C;

	B->hl = C->hr;
	B->leftChild = C->rightChild;

	C->hr = max(B->hl, B->hr) + 1;
	C->rightChild = B;

	LeftRotation(parent, A, C, B);

}

int32_t updateHeights(CC_STACK * nodesStack, int32_t index) {

	CC_TREE * parent = NULL;
	CC_TREE * child = NULL;

	for (; index > 0; index--) {

		parent = (CC_TREE*)nodesStack->Elements[index - 1];
		child = (CC_TREE*)nodesStack->Elements[index];

		if (parent->leftChild == child) {
			parent->hl = max(child->hl, child->hr) + 1;
		}
		else {
			parent->hr = max(child->hl, child->hr) + 1;
		}

	}
}

// -----------------------------------------

int32_t TreeCreate(CC_TREE **Tree)
{
	if (NULL != *Tree) {
		return -1;
	}

	*Tree = (CC_TREE*)malloc(sizeof(CC_TREE));
	if (NULL == *Tree) {
		return -1;
	}

	(*Tree)->information = NULL;
	(*Tree)->leftChild = NULL;
	(*Tree)->rightChild = NULL;

	return 0;
}

int32_t TreeDestroy(CC_TREE **Tree)
{
	CC_TREE * root = *Tree;

	CC_STACK * nodesStack = NULL;
	StCreate(&nodesStack);

	if (NULL != root) {
		StPush(nodesStack, root);
	}

	root = StPop(nodesStack);

	while (NULL != root) {

		if (NULL != root->leftChild) {
			StPush(nodesStack, root->leftChild);
		}

		if (NULL != root->rightChild) {
			StPush(nodesStack, root->rightChild);
		}

		free(root);

		root = StPop(nodesStack);
	}

	*Tree = NULL;
	return 0;
}

int32_t TreeInsert(CC_TREE *Tree, int32_t Value)
{
	if (NULL == Tree) {
		return -1;
	}

	CC_STACK * nodesStack = NULL;
	StCreate(&nodesStack);

	// Parent tell us which is the parent of the node we insert now, in order to know which parent to update.
	CC_TREE * father = Tree;

	CC_TREE * root = Tree->leftChild;

	StPush(nodesStack, father);
	StPush(nodesStack, root);

	// Left and right tell us which was the parent's last child side.
	int32_t left = 1;
	int32_t right = 0;

	while (NULL != root) {

		// Father saves the value of root because the root will change somehow
		father = root;

		left = 0;
		right = 0;

		if (Value < *(root->information)) {
			root = root->leftChild;
			StPush(nodesStack, root);
			left = 1;
		}
		else if (Value > *(root->information)) {
			root = root->rightChild;
			StPush(nodesStack, root);
			right = 1;
		}
		else {
			root->duplicateFactor += 1;
			goto noNodeWasInserted;
		}

		// Now, if the root becomes NULL we'll know which child of the root is NULL, and more important is that this
		// child will hold the new node. We can set this child from NULL to the new node only because we have saved it's
		// parent. When we jump on a node because the rule lead us there and the node is NULL the root becomes NULL, but
		// the parent isn't updated in order to keep the parent of the child, parent which will set the child to hold
		// the new node.
	}

	struct TreeNode * newNode = (struct TreeNode *)malloc(sizeof(struct TreeNode));
	newNode->information = (int32_t*)malloc(sizeof(int32_t));
	*(newNode->information) = Value;
	newNode->leftChild = NULL;
	newNode->rightChild = NULL;
	newNode->hl = newNode->hr = 0;
	newNode->duplicateFactor = 1;

	if (left) {
		father->leftChild = newNode;
	}

	if (right) {
		father->rightChild = newNode;
	}

	StPush(nodesStack, newNode);

	// Every time we insert a new node height of a subtree may be modified so we have to check going through the stack
	// top - down

	updateHeights(nodesStack, nodesStack->StackIndex);

	// Nodes were updated. Now that we have created the stack we'll check if somehow the tree was unbalanced after last
	// insert going through the stack from top to the bottom. Last node can't be unbalanced and also his parent.

	int32_t loopIndex = nodesStack->StackIndex - 2;
	struct TreeNode * currentNode = NULL;
	struct TreeNode * parent = NULL;

	while (0 < loopIndex) {

		currentNode = nodesStack->Elements[loopIndex];
		parent = nodesStack->Elements[loopIndex - 1];

		if (currentNode->hl - currentNode->hr > 1 || currentNode->hr - currentNode->hl > 1) {

			if (currentNode->hl > currentNode->hr) {                    //     o
																		//    /
																		//   o

				if (currentNode->leftChild->hl < currentNode->leftChild->hr) {
					LeftRightRotation(parent,
						currentNode,                                       //    o
						nodesStack->Elements[loopIndex + 1],               //   /
						nodesStack->Elements[loopIndex + 2]);              //  o
					StSwap(nodesStack, loopIndex, loopIndex + 2);                        //   \
																						                                                                                          //    o


				}
				else {
					RightRotation(parent,                                                //     o
						currentNode,                                           //    /
						nodesStack->Elements[loopIndex + 1],                   //   o
						nodesStack->Elements[loopIndex + 2]);                  //  /
					StSwap(nodesStack, loopIndex, loopIndex + 1);                        // o
					StSwap(nodesStack, loopIndex + 1, loopIndex + 2);


				}

			}
			else if (currentNode->hl < currentNode->hr) {
				//   o
				//    \
				                                                                        //     o

				if (currentNode->rightChild->hl < currentNode->rightChild->hr) {
					LeftRotation(parent,
						currentNode,
						nodesStack->Elements[loopIndex + 1],
						nodesStack->Elements[loopIndex + 2]);                   // o
					StSwap(nodesStack, loopIndex, loopIndex + 1);                        //  \
																						                                                                                          //   o
//    \
                                                                                         //     o


				}
				else {
					RightLeftRotation(parent,
						currentNode,
						nodesStack->Elements[loopIndex + 1],
						nodesStack->Elements[loopIndex + 2]);
					StSwap(nodesStack, loopIndex + 1, loopIndex + 2);                   //  o
					StSwap(nodesStack, loopIndex, loopIndex + 1);                       //   \
																						                                                                                         //    o
//   /
				}                                                                        //  o

			}

			// We are going down on the stack updating the other nodes in order to know at the next step if the tree is
			// still unbalanced or if this step balanced it.

			updateHeights(nodesStack, loopIndex);

		}

		loopIndex -= 1;
	}

	StDestroy(&nodesStack);

noNodeWasInserted:
	return 0;

}

int32_t TreeFindMin(CC_TREE *Tree, CC_TREE **Child, CC_TREE **Parent)
{
	*Child = NULL;
	*Parent = NULL;

	if (NULL == Tree)
		return -1;

	if (NULL == Tree->leftChild) {
		*Child = *Parent = Tree;
		return 0;
	}

	CC_TREE *parent = Tree;
	CC_TREE *root = Tree->leftChild;

	while (NULL != root->leftChild) {
		parent = root;
		root = root->leftChild;
	}

	*Child = root;
	*Parent = parent;

	return 0;
}

CC_TREE* TreeFindMaxParent(CC_TREE *Tree)
{

	if (NULL == Tree)
		return NULL;

	CC_TREE *root = Tree;
	while (NULL != root->rightChild) {
		root = root->rightChild;
	}

	return root;
}

int32_t TreeRemove(CC_TREE *Tree, int32_t Value)
{
	CC_TREE * root = Tree->leftChild;
	CC_TREE * parent = Tree;
	int32_t left = 1;

	CC_STACK * nodesStack = NULL;
	StCreate(&nodesStack);
	StPush(nodesStack, parent);

	while (NULL != root) {
		if (Value == *(root->information)) {
			StPush(nodesStack, root);
			break;
		}
		else if (Value < *(root->information)) {
			left = 1;
			parent = root;
			StPush(nodesStack, root);
			root = root->leftChild;
		}
		else {
			left = 0;
			parent = root;
			StPush(nodesStack, root);
			root = root->rightChild;
		}
	}

	if (NULL == root) {
		StDestroy(&nodesStack);
		return -1;
	}

	if (NULL == root->leftChild && NULL == root->rightChild) {
		StPop(nodesStack);

		if (left) {
			parent->hl = 0;
			parent->leftChild = NULL;
		}
		else {
			parent->hr = 0;
			parent->rightChild = NULL;
		}
		free(root);
	}

	else if (NULL != root->leftChild && NULL == root->rightChild) {
		StPop(nodesStack);

		if (left) {
			parent->hl = max(root->leftChild->hl, root->leftChild->hr) + 1;
			parent->leftChild = root->leftChild;
		}
		else {
			parent->hr = max(root->leftChild->hl, root->leftChild->hr) + 1;
			parent->rightChild = root->leftChild;
		}
		free(root);
	}

	else if (NULL != root->rightChild && NULL == root->leftChild) {
		StPop(nodesStack);

		if (left) {
			parent->hl = max(root->rightChild->hl, root->rightChild->hr) + 1;
			parent->leftChild = root->rightChild;
		}
		else {
			parent->hr = max(root->rightChild->hl, root->rightChild->hr) + 1;
			parent->rightChild = root->rightChild;
		}
		free(root);
	}

	else {

		// min node from right subtree

		CC_TREE * minNode = NULL;
		CC_TREE * minNodeParent = NULL;
		TreeFindMin(root->rightChild, &minNode, &minNodeParent);
		*(root->information) = *(minNode->information);

		// The node which contains the minimum can have only a right child, otherwise it wouldn't be the min value.
		// It can be exactly the right child of the root. In this case the left subtree of root's right child is
		// empty. It means that we have to link root's right child to the right child of root's right child. If left
		// subtree of root's right child isn't empty, then the node which contains the minimum will be a left child, as
		// far as left, situation in which we link its parent left child to its right child.

		if (*(minNode->information) == *(minNodeParent->information)) {
			root->rightChild = root->rightChild->rightChild;
			if (NULL != root->rightChild)
				root->hr = max(root->rightChild->hr, root->rightChild->hl) + 1;
			else root->hr = 0;
		}
		else {
			minNodeParent->leftChild = minNode->rightChild;
			if (NULL != root->rightChild)
				minNodeParent->hl = max(minNode->rightChild->hr, minNode->rightChild->hl) + 1;
			else
				minNodeParent->hl = 0;
		}
		free(minNode);
	}

	updateHeights(nodesStack, nodesStack->StackIndex);

	// Now that we probably erased an element we have to check if the tree is unbalanced.

	int32_t loopIndex = nodesStack->StackIndex;

	while (0 < loopIndex) {

		CC_TREE * currentNode = nodesStack->Elements[loopIndex];
		parent = nodesStack->Elements[loopIndex - 1];

		if (currentNode->hl - currentNode->hr > 1 || currentNode->hr - currentNode->hl > 1) {

			if (currentNode->hl > currentNode->hr) {                    //     o
																		//    /
																		//   o

				if (currentNode->leftChild->hl < currentNode->leftChild->hr) {
					LeftRightRotation(parent,
						currentNode,                                       //    o
						currentNode->leftChild,                            //   /
						currentNode->leftChild->rightChild);               //  o
																		   //   \
																		                                                                                            //    o

				}
				else {
					RightRotation(parent,                                                //     o
						currentNode,                                           //    /
						currentNode->leftChild,                                //   o
						currentNode->leftChild->leftChild);                    //  /
																			   // o

				}

			}
			else if (currentNode->hl < currentNode->hr) {
				//   o
				//    \
				                                                                        //     o

				if (currentNode->rightChild->hl < currentNode->rightChild->hr) {
					LeftRotation(parent,
						currentNode,
						currentNode->rightChild,                                // o
						currentNode->rightChild->rightChild);                   //  \
																				                                                                                         //   o
//    \
                                                                                         //     o

				}
				else {
					RightLeftRotation(parent,
						currentNode,
						currentNode->rightChild,                           //  o
						currentNode->rightChild->leftChild);               //   \
																		                                                                                            //    o
//   /
//  o
				}

			}

			// We are going down on the stack updating the other nodes in order to know at the next step if the tree is
			// still unbalanced or if this step balanced it.

			updateHeights(nodesStack, loopIndex);

		}

		loopIndex -= 1;
	}

	StDestroy(&nodesStack);
	return 0;
}

int32_t TreeContains(CC_TREE *Tree, int32_t Value)
{
	CC_TREE * root = Tree->leftChild;

	while (NULL != root) {
		if (Value == *(root->information)) {
			return 1;
		}
		else if (Value < *(root->information)) {
			root = root->leftChild;
		}
		else {
			root = root->rightChild;
		}
	}

	return 0;
}

int32_t TreeGetCount(CC_TREE *Tree)
{

	int32_t treeNodesCount = 0;
	int32_t queueNodesCount = 0;

	CC_TREE *node = NULL;
	CC_TREE *root = Tree->leftChild;

	if (NULL == root)
		return treeNodesCount;

	CC_QUEUE *nodesQueue = NULL;
	QueueCreate(&nodesQueue);

	if (NULL != root)
		QueuePush(nodesQueue, root);

	while (1) {

		queueNodesCount = QueueSize(nodesQueue);
		if (queueNodesCount == 0)
			return treeNodesCount;

		while (queueNodesCount) {
			node = QueuePop(nodesQueue);
			treeNodesCount += 1;
			if (NULL != node->leftChild)
				QueuePush(nodesQueue, node->leftChild);
			if (NULL != node->rightChild)
				QueuePush(nodesQueue, node->rightChild);
			queueNodesCount -= 1;
		}

	}

}

int32_t TreeGetHeight(CC_TREE *Tree)
{
	int32_t treeHeight = 0;
	int32_t nodesCount = 0;

	CC_TREE * node = NULL;
	CC_TREE * root = Tree->leftChild;

	if (NULL == root)
		return treeHeight;

	CC_QUEUE * nodesQueue = NULL;
	QueueCreate(&nodesQueue);

	if (NULL != root)
		QueuePush(nodesQueue, root);

	while (1) {

		nodesCount = QueueSize(nodesQueue);
		if (nodesCount == 0)
			return treeHeight;

		treeHeight += 1;

		while (nodesCount) {
			node = QueuePop(nodesQueue);
			if (NULL != node->leftChild)
				QueuePush(nodesQueue, node->leftChild);
			if (NULL != node->rightChild)
				QueuePush(nodesQueue, node->rightChild);
			nodesCount -= 1;
		}

	}

}

int32_t TreeClear(CC_TREE *Tree)
{
	TreeDestroy(&(Tree->leftChild));
	return 0;
}

int32_t TreeGetNthPreorder(CC_TREE *Tree, int32_t Index, int32_t *Value)
{
	CC_TREE * root = Tree->leftChild;

	CC_STACK * nodesStack = NULL;
	StCreate(&nodesStack);

	if (NULL != root) {
		StPush(nodesStack, root);
	}

	root = StPop(nodesStack);

	while (NULL != root) {

		Index -= 1;
		if (0 == Index) {
			*Value = *(root->information);
			StDestroy(&nodesStack);
			return 0;
		}

		if (NULL != root->rightChild) {
			StPush(nodesStack, root->rightChild);
		}

		if (NULL != root->leftChild) {
			StPush(nodesStack, root->leftChild);
		}

		root = StPop(nodesStack);
	}

	StDestroy(&nodesStack);
	return -1;
}

int32_t TreeGetNthInorder(CC_TREE *Tree, int32_t Index, int32_t *Value)
{
	CC_TREE * root = Tree->leftChild;
	CC_STACK * nodesStack = NULL;
	StCreate(&nodesStack);

	while (NULL != root) {
		StPush(nodesStack, root);
		root = root->leftChild;
	}

//
//   |              |                                      A: [ root ]
//   |     -0-      |                                      /         \
//   |              |         first pop                   /           \
//   |              |            |         B: [ leftChild ]             C: [ rightChild ]
//   |              |            V           /     \
//   |              |       ****************/*      \                                 \
//   |              |       *D: [ leftChild ]*       E: [ rightChild ]                 F: [ rightChild ]
//   |              |       ******************         /
//   |              |                                 /
//   | D[rightChild]|                          G: [ leftChild ]
//   | B[leftChild] |
//   |   A [root]   |
//   ----------------
//



	root = StPop(nodesStack);

	while (NULL != root) {

		Index -= 1;
		if (0 == Index) {

			*Value = *(root->information);
			StDestroy(&nodesStack);

			return 0;

		}

		if (NULL != root->rightChild) {

			root = root->rightChild;

			while (NULL != root) {
				StPush(nodesStack, root);
				root = root->leftChild;
			}
		}

		root = StPop(nodesStack);

	}

//                                                            second pop
//   |              |   |              |                          |           A: [ root ]
//   |     -1-      |   |     -2-      |                          V           /         \
//   |              |   |              |                     ****************/*          \
//   |              |   |              |                     *B: [ leftChild ]*            C: [ rightChild ]
//   |              |   |              |                     ******************                       \
//   |              |   |              |                      /      \                                 \
//   |              |   |              |                     /        \                                 \
//   |              |   |              |      D: [ leftChild ]         E: [ rightChild ]                 F: [ rightChild ]
//   |              |   | G[leftChild] |                                  /          ^
//   |              |   | E[rightChild]|                                 /           |
//   | B[leftChild] |   | B[leftChild] |                          G: [ leftChild ]   |
//   |   A [root]   |   |   A [root]   |                                       ^     |
//   ----------------   ----------------                                       |     |
//                                                                             |     |
//                                                                          two elements added
//                                                                          on the stack
//
//
//   |              |   |              |                                      A: [ root ]
//   |     -3-      |   |     -4-      |                                      /         \
//   |              |   |              |                                     /           \
//   |              |   |              |                      B: [ leftChild ]             C: [ rightChild ]
//   |              |   |              |                      /      \                                 \
//   |              |   |              |                     /        \                                 \
//   |              |   |              |      D: [ leftChild ]         E: [ rightChild ]                 F: [ rightChild ]
//   |              |   |              |                                  /
//   | E[rightChild]|   | E[rightChild]|                         ********/*********
//   | B[leftChild] |   | B[leftChild] |                         *G: [ leftChild ]*
//   |   A [root]   |   |   A [root]   |                         ******************
//   ----------------   ----------------                                 ^
//                                                                       |
//                                                                       |
//                                                                   third pop
//

	StDestroy(&nodesStack);
	return -1;

}

int32_t TreeGetNthPostorder(CC_TREE *Tree, int32_t Index, int32_t *Value)
{
	CC_TREE * root = Tree->leftChild;

	CC_STACK * bufferStack = NULL;
	StCreate(&bufferStack);

	CC_STACK * finalStack = NULL;
	StCreate(&finalStack);

	if (NULL != root) {
		StPush(bufferStack, root);
	}

	root = StPop(bufferStack);

	while (NULL != root) {

		StPush(finalStack, root);

		if (NULL != root->leftChild) {
			StPush(bufferStack, root->leftChild);
		}

		if (NULL != root->rightChild) {
			StPush(bufferStack, root->rightChild);
		}

		root = StPop(bufferStack);

	}

	int32_t stackSize = finalStack->StackIndex;

	if (stackSize - Index + 1 >= 0) {

		finalStack->StackIndex = stackSize - Index + 1;
		CC_TREE * holder = StPop(finalStack);
		*Value = *(holder->information);

		StDestroy(&finalStack);
		StDestroy(&bufferStack);

		return 0;
	}

	return -1;
}
