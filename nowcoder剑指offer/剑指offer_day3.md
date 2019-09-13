#### 21打印二叉树

从上往下打印出二叉树的每个节点，同层节点从左至右打印。

* 层序遍历

```c++
/*
struct TreeNode {
	int val;
	struct TreeNode *left;
	struct TreeNode *right;
	TreeNode(int x) :
			val(x), left(NULL), right(NULL) {
	}
};*/
class Solution {
public:
    vector<int> PrintFromTopToBottom(TreeNode* root) {
        queue<TreeNode*> q;
        vector<int> res;
        if(root==NULL) return {};
        q.push(root);
        while(!q.empty()){
            TreeNode* front=q.front();
            res.push_back(front->val);
            q.pop();
            if(front->left!=NULL) q.push(front->left);
            if(front->right!=NULL) q.push(front->right);
        }
        return res;
    }
};
```

#### 22二叉搜索书后序遍历的判断

输入一个整数数组，判断该数组是不是某二叉搜索树的后序遍历的结果。如果是则输出Yes,否则输出No。假设输入的数组的任意两个数字都互不相同。

* 直接使用递归，但这种对空的没法判断，简单办法是先判断是否空，然后在另一个函数递归；

```c++
class Solution {
public:
    bool VerifySquenceOfBST(vector<int> sequence) {
        if(sequence.size()==0) return false;
        if(sequence.size()<=2) return true;
        return isBST(sequence);
    }
    bool isBST(vector<int> sequence){
        if(sequence.size()<=2) return true;
        
        int flag=1,i=0,pivot=sequence[sequence.size()-1];
        vector<int> right,left;
        while(i<sequence.size()-1&&sequence[i]<pivot){
            right.push_back(sequence[i]);
            i++;
        }

        while(i<sequence.size()-1&&sequence[i]>pivot){
            left.push_back(sequence[i]);
            i++;
        }
        if(i!=sequence.size()-1)
            return false;
        else
            return isBST(left)&&isBST(right);
    }
};
```

#### 23二叉树中和为某一值的路径

输入一颗二叉树的根节点和一个整数，打印出二叉树中结点值的和为输入整数的所有路径。路径定义为从树的根结点开始往下一直到叶结点所经过的结点形成一条路径。(注意: 在返回值的list中，数组长度大的数组靠前)

* 先序遍历的变式，记录遍历的从根节点到当前节点的路径和路径和，当当前节点为叶节点的时候，比较期待值和路径和是否相等，如果相等则记录路径；相当于用vector实现了一个可以遍历的stack；

```c++
/*
struct TreeNode {
	int val;
	struct TreeNode *left;
	struct TreeNode *right;
	TreeNode(int x) :
			val(x), left(NULL), right(NULL) {
	}
};*/
class Solution {
public:
    vector<vector<int> > FindPath(TreeNode* root,int expectNumber) {
        if(root==NULL) return {};
        vector<int> path;
        int currentSum=0;
        Find(root,path,expectNumber,currentSum);
        return res;
    }
    void Find(TreeNode* root, vector<int> path, int expectNumber, int currentSum){
        currentSum+=root->val;
        path.push_back(root->val);
        if(root->left==NULL && root->right==NULL && currentSum==expectNumber){
            res.push_back(path);
        }
        if(root->left!=NULL) Find(root->left,path,expectNumber,currentSum);
        if(root->right!=NULL) Find(root->right,path,expectNumber,currentSum);
        path.pop_back();
    }
private:
    vector<vector<int> > res;
};
```

注意点：1）特殊测试：输入为NULL；2）有一条符合路径；3）有多条符合路径；4）没有符合路径；

#### 24复杂链表的复制

输入一个复杂链表（每个节点中有节点值，以及两个指针，一个指向下一个节点，另一个特殊指针指向任意一个节点），返回结果为复制后复杂链表的head。（注意，输出结果中请不要返回参数中的节点引用，否则判题程序会直接返回空）

* O(n^2)时间，先复制next, 再复制random，每次从头数，space O(1)；可以很明显看出双重循环；

```c++
/*
struct RandomListNode {
    int label;
    struct RandomListNode *next, *random;
    RandomListNode(int x) :
            label(x), next(NULL), random(NULL) {
    }
};
*/
class Solution {
public:
    RandomListNode* Clone(RandomListNode* pHead)
    {
        if(pHead==NULL) return NULL;
        RandomListNode* pOld=pHead->next;
        RandomListNode* pNew=new RandomListNode(pHead->label);
        RandomListNode* pHead2=pNew;
        //只复制next指针，random不赋值；
        while(pOld!=NULL){
            RandomListNode * cur= new RandomListNode(pOld->label);
            pOld=pOld->next;
            pNew->next=cur;
            pNew=cur;
        }
        pOld=pHead;pNew=pHead2;
        //复制random指针的值；
        while(pNew!=NULL){
            RandomListNode * tar=pOld->random;
            RandomListNode * p1=pHead;
            RandomListNode * p2=pHead2;
            while(p1!=tar){
                p1=p1->next;
                p2=p2->next;
            }
            pNew->random=p2;
            pNew=pNew->next;
            pOld=pOld->next;
        }
        return pHead2;
    }
};
```

* O(n)时间，用时间换空间，将旧链表与新链表用哈希表对应起来，即map[旧链表指针]=对应新链表指针，space O(n)

```c++
/*
struct RandomListNode {
    int label;
    struct RandomListNode *next, *random;
    RandomListNode(int x) :
            label(x), next(NULL), random(NULL) {
    }
};
*/
class Solution {
public:
    RandomListNode* Clone(RandomListNode* pHead)
    {
        if(pHead==NULL) return NULL;
        unordered_map<RandomListNode*,RandomListNode*> m;
        RandomListNode* pOld=pHead->next;
        RandomListNode* pNew=new RandomListNode(pHead->label);
        RandomListNode* pHead2=pNew;
        m[pHead]=pHead2;//复制链表头结点至哈希表；
        //复制next,并将对应关系存到哈希表
        while(pOld!=NULL){
            RandomListNode * cur= new RandomListNode(pOld->label);
            m[pOld]=cur;
            pOld=pOld->next;
            pNew->next=cur;
            pNew=cur;
        }
        pOld=pHead;pNew=pHead2;
        //复制random
        while(pNew!=NULL){
            RandomListNode * tar=pOld->random;
            pNew->random=m[tar];
            
            pNew=pNew->next;
            pOld=pOld->next;
        }
        return pHead2;
    }
};
```

* ​