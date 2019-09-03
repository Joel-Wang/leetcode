

#### 11数值的整数次方

给定一个double类型的浮点数base和int类型的整数exponent。求base的exponent次方。

保证base和exponent不同时为0

* O(n) 解法：循环一次

```c++
class Solution {
public:
    double Power(double base, int exponent) {
        double b=base;
        int e=exponent;
        if(b==0) return 0;
        if(e==0) return 1;
        
        
        if(e<0){
            b=1.0/b;
            e=-e;
        }
        double res=b;
        for(int i=1;i<e;i++){
            res*=b;
        }
        return res;
    }
};
```

* O(logn)解法：利用递归的思想

```c++
class Solution {
public:
    double Power(double base, int exponent) {
        double b=base;
        int e=exponent;
        if(b==0) return 0;
        if(e==0) return 1;
        
        
        if(e<0){
            b=1.0/b;
            e=-e;
        }
        double res=b;
        
        return p(b,e);
    }
    double p(double b,int e){
        if(e==0) return 1;
        if(e==1) return b;
        if(e%2==0)
            return p(b,e/2)*p(b,e/2);
        else
            return p(b,e/2)*p(b,e/2)*b;
    }
};
```

* 利用递归的思想用循环来做



#### 12 调整数组顺序，使得奇数位于偶数前面

输入一个整数数组，实现一个函数来调整该数组中数字的顺序，使得所有的奇数位于数组的前半部分，所有的偶数位于数组的后半部分，并保证奇数和奇数，偶数和偶数之间的相对位置不变。

* 冒泡法：从右向左，寻找偶数，然后不断向右与相邻的奇数交换，如果右侧相邻为偶数，则交换完毕；

```c++
class Solution {
public:
    void reOrderArray(vector<int> &array) {
        //冒泡法：
        int p=array.size()-1;
        while(p>=0){
            if(array[p]%2==0){
                for(int i=p;i<array.size()-1;i++){
                    if(array[i+1]%2==0) break;
                    swap(array[i],array[i+1]);
                }
            }
            p--;
        }
    }
};
```



#### 13 链表中的倒数第k个节点

输入一个链表，输出该立案表中倒数第K个节点；

* 遍历两遍，获得链表的长度，然后第二次获得链表的倒数k节点；

```c++
class Solution {
public:
    ListNode* FindKthToTail(ListNode* pListHead, unsigned int k) {
        
        ListNode* p=pListHead;
        int len=0;
        while(p!=NULL){
            len++;
            p=p->next;
        }
        p=pListHead;
        int i=0;
        while(i<len-k && p!=NULL){
            p=p->next;i++;
        }
        return p;
    }
};
```

#### 14 翻转链表
输入一个链表，反转链表后，输出新链表的表头

* 直接使用双指针依次翻转，初始化pre=NULL, cur=pHead,这样反转后保证结尾指向NULL

```c++
/*
struct ListNode {
	int val;
	struct ListNode *next;
	ListNode(int x) :
			val(x), next(NULL) {
	}
};*/
class Solution {
public:
    ListNode* ReverseList(ListNode* pHead) {
        ListNode* pre,* cur,* nxt;
        if(pHead==NULL || pHead->next==NULL) return pHead;
        pre=NULL,cur=pHead;
        while(cur!=NULL){
            nxt=cur->next;
            cur->next=pre;
            pre=cur;
            cur=nxt;
        }
        return pre;
    }
};
```

#### 15 合并两个排序链表

输入两个单调递增的链表，输出两个链表合成后的链表，当然我们需要合成后的链表满足单调不减规则。

* 非原地合并的代码，借助第三条链表，依次将最小的节点值，按顺序赋给第3个链表；

```c++
/*
struct ListNode {
	int val;
	struct ListNode *next;
	ListNode(int x) :
			val(x), next(NULL) {
	}
};*/
class Solution {
public:
    ListNode* Merge(ListNode* pHead1, ListNode* pHead2)
    {
        ListNode *p, *head, *p1=pHead1,*p2=pHead2;
        if(p1==NULL) return p2;
        if(p2==NULL) return p1;
        if(p1!=NULL && p2!=NULL){
            if(p1->val<=p2->val){
                p=new ListNode(p1->val);
                head=p;
                p1=p1->next;
            }else{
                p=new ListNode(p2->val);
                head=p;
                p2=p2->next;
            }
        }
        while(p1!=NULL && p2!=NULL){
            if(p1->val<=p2->val){
                ListNode* cur=new ListNode(p1->val);
                p->next=cur;
                p1=p1->next;
            }else{
                ListNode* cur=new ListNode(p2->val);
                p->next=cur;
                p2=p2->next;
            }
            p=p->next;
        }
        while(p1!=NULL){
            ListNode* cur=new ListNode(p1->val);
            p->next=cur;
            p=p->next;
            p1=p1->next;
        }
        while(p2!=NULL){
            ListNode* cur=new ListNode(p2->val);
            p->next=cur;
            p=p->next;
            p2=p2->next;
        }
        return head;
    }
};
```

#### 16 判断树的子结构

输入两棵二叉树A，B，判断B是不是A的子结构。（ps：我们约定空树不是任意一个树的子结构）

* 先层序遍历寻找可能的根节点，然后层序遍历比较，注意，当B树存在节点时才可push A的节点；

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
    bool HasSubtree(TreeNode* pRoot1, TreeNode* pRoot2)
    {
        bool res=false;
        queue<TreeNode*> q;
        TreeNode *p1=pRoot1,*p2=pRoot2;
        if(p1==NULL || p2==NULL) return res;
        q.push(p1);
        while(!q.empty()){
            TreeNode *front=q.front();
            
            if(front->val==p2->val){
                res=cmp(front,p2);
            }
            if(res==true) return res;
            q.pop();
            if(front->left!=NULL) q.push(front->left);
            if(front->right!=NULL) q.push(front->right);
        }
        return res;
    }
    bool cmp(TreeNode *p1, TreeNode *p2){
        queue<TreeNode*> q1,q2;
        q1.push(p1),q2.push(p2);
        while(!q1.empty()&& !q2.empty()){
            TreeNode *f1=q1.front(),*f2=q2.front();
            if(f1->val!=f2->val) return false;
            q1.pop(),q2.pop();
            if(f2->left!=NULL && f1->left!=NULL) q1.push(f1->left);
            if(f2->right!=NULL && f1->right!=NULL) q1.push(f1->right);
            if(f2->left!=NULL) q2.push(f2->left);
            if(f2->right!=NULL) q2.push(f2->right);
        }
        if(q2.empty()) return true;
    }
};
```

#### 17镜像二叉树

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
    void Mirror(TreeNode *pRoot) {
        if(pRoot==NULL) return;
        TreeNode *p=pRoot;
        queue<TreeNode*> q;
        q.push(p);
        while(!q.empty()){
            TreeNode* front=q.front();
            q.pop();
            
            TreeNode* left=front->left;
            TreeNode* right=front->right;
            if(left!=NULL) q.push(left);
            if(right!=NULL) q.push(right);
            front->left=right;
            front->right=left;
        }
    }
};
```

#### 18顺时针打印矩阵

输入一个矩阵，按照从外向里以顺时针的顺序依次打印出每一个数字，例如，如果输入如下4 X 4矩阵： 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 则依次打印出数字1,2,3,4,8,12,16,15,14,13,9,5,6,7,11,10.

* 使用普通的循环
* 利用图遍历的思想

```c++
class Solution {
public:
    vector<vector<int> > dirs={{0,1},{1,0},{0,-1},{-1,0}};
    vector<int> printMatrix(vector<vector<int> > matrix) {
        int m=matrix.size();
        if(m==0) return {};
        int n=matrix[0].size();
        if(n==0) return {};
        vector<vector<int> > visit(m,vector<int>(n,0));
        int len=(min(m,n)+1)/2;
        int x=0,y=0;
        vector<int> res;
        res.push_back(matrix[x][y]);
        visit[x][y]=1;
        for(int i=0;i<len;i++){
            for(int j=0;j<4;j++){
                int dx=dirs[j][0],dy=dirs[j][1];
                while(x+dx>=0 && x+dx<m && y+dy>=0 && y+dy<n && visit[x+dx][y+dy]==0){
                    x=x+dx;y=y+dy;
                    res.push_back(matrix[x][y]);
                    visit[x][y]=1;
                }
            }
        }
        return res;
    }
};
```

#### 19 包含min函数的栈

定义栈的数据结构，请在该类型中实现一个能够得到栈中所含最小元素的min函数（时间复杂度应为O（1））。

* 采用一个辅助的min栈来帮助存储数据的data栈存储最小值；

* 例如：  data栈 依次入栈元素 5,   4,   3,   8,   10,   11,   12,   1；

  ​               min栈 依次入栈元素 5， 4,   3，3,    3，  3，   3， 1。

  出栈时，min的栈与栈data均要出栈。

```c++
class Solution {
public:
    void push(int value) {
        s.push(value);
        if(help.empty()){
            help.push(value);
        }
        if(value<help.top()){
            help.push(value);
        }else{
            help.push(help.top());
        }
    }
    void pop() {
        s.pop();
        help.pop();
    }
    int top() {
        return s.top();
    }
    int min() {
        return help.top();
    }
private:
    stack<int> s;
    stack<int> help;
};
```



#### 20栈的压入、弹出序列

输入两个整数序列，第一个序列表示栈的压入顺序，请判断第二个序列是否可能为该栈的弹出顺序。假设压入栈的所有数字均不相等。例如序列1,2,3,4,5是某栈的压入顺序，序列4,5,3,2,1是该压栈序列对应的一个弹出序列，但4,3,5,1,2就不可能是该压栈序列的弹出序列。（注意：这两个序列的长度是相等的）

```c++
class Solution {
public:
    bool IsPopOrder(vector<int> pushV,vector<int> popV) {
        stack<int> s;
        int i=0,j=0,len=pushV.size();
        while(j<len && i<len){
            s.push(pushV[i++]);
            while(i<len && s.top()!=popV[j]){
                s.push(pushV[i++]);
            }
            while(j<len && !s.empty() && s.top()==popV[j]){
                s.pop();
                j++;
            }
        }
        return s.empty();
    }
};
```

