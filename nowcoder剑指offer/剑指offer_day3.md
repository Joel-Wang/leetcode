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

* O(n) time，O(1) space；先在每个节点后面插入节点，然后对链表的random进行复制，然后拆开链表；

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
        if(pHead==NULL) return NULL;//当pHead为NULL 后面很多表达都会出问题，所以需要先列出来；
        //不使用辅助空间达到O(n) time
        RandomListNode* p = pHead;

        //插入节点
        while(p!=NULL){
            RandomListNode* cur = p->next;
            RandomListNode* newNode = new RandomListNode(p->label);
            p->next=newNode;
            newNode->next=cur;
            p=cur;
            
        }
        //链接random
        p=pHead;
        while(p!=NULL){
            RandomListNode* newNode = p->next;
            RandomListNode* tar=p->random;
            if(tar!=NULL) newNode->random=tar->next;
            p=newNode->next;
        }
        
        //拆开链表
        RandomListNode* tmp;
        RandomListNode* pHead2=pHead->next;
        p=pHead;
        while(p->next!=NULL){
            tmp=p->next;
            p->next=tmp->next;
            p=tmp;
        }
        return pHead2;
    }
};
```

将其整合一下，然后封装成函数：

![复制复杂链表01](E:\Github\leetcode\nowcoder剑指offer\复制复杂链表01.png)

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
        if(pHead==NULL) return NULL;//排除NULL，以后函数中不用考虑为空；
        CloneNode(pHead);
        ConnectRandom(pHead);
        return ReconnectNodes(pHead);
        
    }
    void CloneNode(RandomListNode* pHead){
        RandomListNode* pNode=pHead;
        while(pNode!=NULL){
            RandomListNode* pCloned=new RandomListNode(pNode->label);
            pCloned->next=pNode->next;
            
            pNode->next=pCloned;
            pNode=pCloned->next;
        }
    }
    void ConnectRandom(RandomListNode* pHead){
        RandomListNode* pNode=pHead;
        while(pNode!=NULL){
            RandomListNode* pCloned=pNode->next;
            if(pNode->random!=NULL){
                pCloned->random=pNode->random->next;
            }
            pNode=pCloned->next;
        }
    }
    RandomListNode* ReconnectNodes(RandomListNode* pHead){
        RandomListNode* curNode=pHead;
        RandomListNode* pHead2=pHead->next;
        RandomListNode* tmp;
        while(curNode->next!=NULL){
            tmp=curNode->next;
            curNode->next=tmp->next;
            curNode=tmp;
        }
        return pHead2;
    }
};
```

#### 25二叉搜索树与双向链表

输入一棵二叉搜索树，将该二叉搜索树转换成一个排序的双向链表。要求不能创建任何新的结点，只能调整树中结点指针的指向。

* 使用一个queue存储中序遍历的结果，然后记录头结点，按照从左到右递增的顺序重新连接；需要O(n)的空间(队列存储节点指针），遍历二叉树需要O(n)时间

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
    TreeNode* Convert(TreeNode* pRootOfTree)
    {
        //用队列,从左到右为递增（也就是right指针指向的值都更大）
        queue<TreeNode*> q;
        if(pRootOfTree==NULL || (pRootOfTree->left==NULL&&pRootOfTree->right==NULL)) return pRootOfTree;
        
        inorder(pRootOfTree,q);
        TreeNode *a,*b,*pHead;
        b=q.front();pHead=q.front();q.pop();
        while(!q.empty()){
            a=b;b=q.front();q.pop();
            a->right=NULL;b->left=NULL;
            
            a->right=b;
            b->left=a;
        }
        return pHead;
    }
    void inorder(TreeNode* root,queue<TreeNode*> &q){
        if(root==NULL) return;
        inorder(root->left,q);
        q.push(root);
        inorder(root->right,q);
    }
};
```

* 不使用队列，直接使用递归的方法，采用中序遍历，对得到的pLastNode和当前Node的连接进行改变；然后对左子树和柚子树分别递归操作；

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
    TreeNode* Convert(TreeNode* pRootOfTree){
        TreeNode *pLastNode=NULL;
        ConvertNode(pRootOfTree,&pLastNode);
        TreeNode *pHeadOfList=pLastNode;
        while(pHeadOfList != NULL && pHeadOfList->left!=NULL){
            pHeadOfList=pHeadOfList->left;
        }
        return pHeadOfList;
    }
    void ConvertNode(TreeNode *pNode,TreeNode **pLastNode){
        //使用**pLastNode,pLastNode为指向指针的指针；方便最后记录末节点以及寻找头结点；
        if(pNode==NULL) return;
        TreeNode *pCurNode=pNode;
        if(pCurNode->left!=NULL)
            ConvertNode(pCurNode->left,pLastNode);
        
        pCurNode->left=*pLastNode;
        if(*pLastNode!=NULL)
            (*pLastNode)->right=pCurNode;
        *pLastNode=pCurNode;
        
        if(pCurNode->right!=NULL)
            ConvertNode(pCurNode->right,pLastNode);
    }
};
```

#### 26字符串的排列

输入一个字符串,按字典序打印出该字符串中字符的所有排列。例如输入字符串abc,则打印出由字符a,b,c所能排列出来的所有字符串abc,acb,bac,bca,cab和cba。
输入描述:

>输入一个字符串,长度不超过9(可能有字符重复),字符只包括大小写字母。

* 直接使用库函数sort和next_permutation,都可以对数组，vector,string进行排序和排列，使用方式为 func(左迭代器，右迭代器，比较函数（不写默认从小到大）)；如string a="CBA"；next_permutation(a.begin(),a.end())，其中区间为[ , )；对CBA执行此操作为ABC，重新升序，因此返回false;

```c++
class Solution {
public:
    vector<string> Permutation(string str) {
        if(str.size()==0) return {};
        sort(str.begin(),str.end());
        vector<string> res;
        string origin=str;
        res.push_back(str);
        while(next_permutation(str.begin(),str.end())){
            res.push_back(str);
        }
        return res;
    }
};
```

* **递归求全排列**：使用递归的思想，将大问题分解为小问题：即划分为，将第一个字母与任意一个不同的字母交换（包括自己），然后固定第一个字母，对后面的也采用这样的操作，直到结束；（这样缺点是没有字典序，需要再自己对得到的序列进行排序；

```c++
class Solution {
public:
    vector<string> Permutation(string str) {
        if(str.size()==0) return {};
        sort(str.begin(),str.end());
        vector<string> res;
        per(str,0,res);
        sort(res.begin(),res.end());//使得输出按字典序排序
        return res;
    }
    //判断是否能够交换，（出现重复返回false,不重复可以交换返回true）
    bool is_swap(string str,int start,int end){
        for(int i=start;i<end;i++){
            if(str[i]==str[end])
                return false;
        }
        return true;
    }
    void per(string str,int id,vector<string>& res){
        if(id==str.size()){
            res.push_back(str);
            return;
        }
        for(int i=id;i<str.size();i++){
            if(str[i]==str[id] && i!=id) continue;
            if(i>id && !is_swap(str,id,i)) continue;
            char tmp=str[i];
            str[i]=str[id];
            str[id]=tmp;
            per(str,id+1,res);
            tmp=str[i];
            str[i]=str[id];
            str[id]=tmp;
        }
    }
};
```

* 直接递归全排列为字典序：取消递归之后的复位操作，从而直接输出字典序；

```c++
class Solution {
public:
    vector<string> Permutation(string str) {
        if(str.size()==0) return {};
        sort(str.begin(),str.end());
        vector<string> res;
        per(str,0,res);
 
        return res;
    }
    //判断是否能够交换，（出现重复返回false,不重复可以交换返回true）
    bool is_swap(string str,int start,int end){
        for(int i=start;i<end;i++){
            if(str[i]==str[end])
                return false;
        }
        return true;
    }
    void per(string str,int id,vector<string>& res){
        if(id==str.size()){
            res.push_back(str);
            return;
        }
        for(int i=id;i<str.size();i++){
            if(str[i]==str[id] && i!=id) continue;
            if(i>id && !is_swap(str,id,i)) continue;
            char tmp=str[i];
            str[i]=str[id];
            str[id]=tmp;
            per(str,id+1,res);

        }
    }
};
```



#### 27数组中出现次数超过一半的数字

数组中有一个数字出现的次数超过数组长度的一半，请找出这个数字。例如输入一个长度为9的数组{1,2,3,2,2,2,5,4,2}。由于数字2在数组中出现了5次，超过数组长度的一半，因此输出2。如果不存在则输出0。

* 不改变原数组：

```c++
class Solution {
public:
    //哈希，O(n) space O(n) time;
    //摩尔投票， O(1） space O（n）time;
    bool check(vector<int> & numbers,int x){
        //检验输入数组是否有效
        int len=numbers.size();
        int cnt=0;
        for(int i=0;i<len;i++){
            if(numbers[i]==x) cnt++;
        }
        if(cnt*2>len)
            return true;
        else
            return false;
    }
    int MoreThanHalfNum_Solution(vector<int> numbers) {
        if(numbers.size()==0) return 0;
        int flag=1,v=numbers[0];
        for(int i=0;i<numbers.size();i++){
            if(v!=numbers[i])
                flag--;
            else
                flag++;
            if(flag==0){
                flag=1;v=numbers[i];
            }
        }
        if(check(numbers,v))
            return v;
        else
            return 0;
    }
};
```

* 改变原数组，快速排序partition的思想（与28题类似）


```c++
待补充
```



#### 28最小的k个数

输入n个整数，找出其中最小的K个数。例如输入4,5,1,6,2,7,3,8这8个数字，则最小的4个数字是1,2,3,4,。

* 大顶堆，使用vector作为大顶堆的容器；time O(nlogk)

```c++
class Solution {
public:
    void heapfiy(vector<int> &heap,int j){
        int len=heap.size();
        int tar=j;
        while(2*j+1<len){
            if(heap[2*j+1]>heap[tar]){
                tar=2*j+1;
            }
            if(2*j+2<len && heap[2*j+2]>heap[tar]){
                tar=2*j+2;
            }
            if(tar==j) break;
            int tmp=heap[tar];
            heap[tar]=heap[j];
            heap[j]=tmp;
            j=tar;
        }
    }
    void buildheap(vector<int> &heap){
        int len=(heap.size()-2)/2;
        for(int i=len;i>=0;i--){
            heapfiy(heap,i);
        }
    }
    vector<int> GetLeastNumbers_Solution(vector<int> input, int k) {
        if(k<=0 || k>input.size()) return {};
        vector<int> heap(k,0);
        for(int i=0;i<k;i++){
            heap[i]=input[i];
        }
        buildheap(heap);
        for(int i=k;i<input.size();i++){
            if(input[i]<heap[0]){
                heap[0]=input[i];
                heapfiy(heap,0);
            }
        }
        return heap;
    }
};
```

* 排序：quicksort, mergesort等；time O(nlogn)；

```c++
class Solution {
public:
    int partition(vector<int> &input,int start,int end){
        int pivot=input[start];
        int i=start,j=end;

        while(i<j){
            while(i<j && input[j]>=pivot)
                j--;
            input[i]=input[j];
            while(i<j && input[i]<=pivot)
                i++;
            input[j]=input[i];
        }
        input[i]=pivot;
        return i;
    }
    void quickSort(vector<int> &input,int start,int end){
        if(start>=end) return;
        int pivotkey=partition(input,start,end);
        quickSort(input,start,pivotkey-1);
        quickSort(input,pivotkey+1,end);
    }
    vector<int> GetLeastNumbers_Solution(vector<int> input, int k) {
        if(k<=0 || k>input.size()) return{};
        quickSort(input,0,input.size()-1);
        vector<int> tmp;
        for(int i=0;i<k;i++){
            tmp.push_back(input[i]);
        }
        return tmp;
    }
};
```

* 快速排序的思想：partition的思想，当partition的key值刚好下标为k时，说明左侧即为最小的k个数；结合二分查找法，逼近所在的区间；这应该是本题最快的解法；O(logn)时间复杂度；

```c++
class Solution {
public:
    int partition(vector<int> &input,int start,int end){
        int pivot=input[start];
        int i=start,j=end;
        while(i<j){
            while(i<j && input[j]>=pivot)
                j--;
            input[i]=input[j];
            while(i<j && input[i]<=pivot)
                i++;
            input[j]=input[i];
        }
        input[i]=pivot;
        return i;
    }
    vector<int> GetLeastNumbers_Solution(vector<int> input, int k) {
        if(k<=0 || k>input.size()) return {};
        int i=0,j=input.size()-1;
        int pivotkey;
        while(i<j){
            pivotkey=partition(input,i,j);
            if(k==pivotkey) break;
            if(k<pivotkey){
                j=pivotkey-1;
            }else{
                i=pivotkey+1;
            }
        }
        vector<int> tmp;
        for(int i=0;i<k;i++){
            tmp.push_back(input[i]);
        }
        return tmp;
    }
};
```

#### 29 连续子数组的最大和

HZ偶尔会拿些专业问题来忽悠那些非计算机专业的同学。今天测试组开完会后,他又发话了:在古老的一维模式识别中,常常需要计算连续子向量的最大和,当向量全为正数的时候,问题很好解决。但是,如果向量中包含负数,是否应该包含某个负数,并期望旁边的正数会弥补它呢？例如:{6,-3,-2,7,-15,1,2,2},连续子向量的最大和为8(从第0个开始,到第3个为止)。给一个数组，返回它的最大连续子序列的和，你会不会被他忽悠住？(子向量的长度至少是1)

*  最简单的想法是将每个i到j下标之间的数字加起来，然后与最大值比较，这样遍历的次数为n(n+1)/2；然后每次加起来的平均复杂度n/2；因此总的世间复杂度为O(n3) ,space O(1);
* 采用mem记忆矩阵可以将之前所求和存储起来，此时时间O(n2), spaceO(n2);

```c++
class Solution {
public:
    //time O(n2),space O(n2)
    int FindGreatestSumOfSubArray(vector<int> array) {
        int n=array.size();
        if(n==0) return 0;
        int res=array[0];
        vector<vector<int>> mem(n,vector<int>(n,0));
        for(int i=0;i<n;i++){
            mem[i][i]=array[i];
        }
        for(int i=0;i<n;i++){
            for(int j=i;j<n;j++){
                if(i==j)
                    mem[i][j]=array[i];
                else
                    mem[i][j]=mem[i][j-1]+array[j];
                if(mem[i][j]>res) res=mem[i][j];
            }
        }
        return res;
    }
};
```

* 采用动态规划的思想 time O(n)，space O(1)，遍历一遍，sum初始化为0，当之前的 连续最大和与当前值相加，如果是正数，那么证明继续相加有可能达到更大值，如果是负数，则后面的最大值计算不需要前面的数字（因为前面的和为负数，与后面相加会使得最大值变小，因此sum赋值为0，考虑全负的情况，此时res应该与当前值进行比较，而不是与sum比较；

伪代码：

```c++
初始值sum=0; res=array[0];

for i: 0 ---->len-1:
    //以当前数结尾的子序列的最大值sum更新；
	情况1： sum+array[i]>0: sum=sum+array[i];
	情况2： sum+array[i]<=0: sum=0;
	
    //以当前数结尾的数组最大子序列和的结果res更新
	情况1： 当sum==0时，res= max(res, array[i]);
	情况2： 当sum>0 时，res=max(res, sum);
```



```c++
class Solution {
public:
    //O(n)
    int FindGreatestSumOfSubArray(vector<int> array) {
        int len=array.size();
        if(len==0) return 0;
        int sum=0;

        int res=array[0];
        for(int i=0;i<len;i++){
            if(sum+array[i]<0)
                sum=0;
            else
                sum+=array[i];
            if(sum==0)
                res=res>array[i]? res:array[i];
            else
                res=res>sum?res:sum;
        }
        return res;
    }
};
```

#### 30整数中1出现的次数

求出1~13的整数中1出现的次数,并算出100~1300的整数中1出现的次数？为此他特别数了一下1~13中包含1的数字有1、10、11、12、13因此共出现6次,但是对于后面问题他就没辙了。ACMer希望你们帮帮他,并把问题更加普遍化,可以很快的求出任意非负整数区间中1出现的次数（从1 到 n 中1出现的次数）。