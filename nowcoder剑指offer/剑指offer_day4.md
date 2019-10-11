#### 31把数组排成最小的数

输入一个正整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。例如输入数组{3，32，321}，则打印出这三个数字能排成的最小数字为321323。

* 思路1：将所有数组全排列，然后分别计算每一个数，比较得到最小的；出现的问题：组合起来的数过大溢出，时间复杂度O(n!)过高；
* 思路2：为了防止溢出，将数字转换成字符串；为了降低复杂度，定义一个特定的排序规则，当m<n，m应该排在n的前面，将m和n拼接起来得到mn和nm，然后通过字符串大小比较规则来比较；最后将排完序的结果合并；timeO(nlogn)，spaceO(n)需要额外的空间存储字符串，也可以不存，但会稍微麻烦点；

```c++
class Solution {
public:
    static bool cmp(string s1,string s2){
        string cmp1=s1+s2;
        string cmp2=s2+s1;
        for(int i=0;i<cmp1.size();i++){
            if(cmp1[i]==cmp2[i])
                continue;
            if(cmp1[i]<cmp2[i])
                return 1;
            else
                return 0;
                
        }
    }
    string PrintMinNumber(vector<int> numbers) {
        vector<string> nums;
        string res="";
        //转化为string;
        for(int i=0;i<numbers.size();i++){
            string tmp="";
            stack<int> s;
            int num=numbers[i];
            while(num>0){
                int r=num%10;
                s.push(r);
                num=num/10;
            }
            while(!s.empty()){
                tmp.push_back(s.top()+'0');
                s.pop();
            }
            nums.push_back(tmp);
        }
        //排序
        sort(nums.begin(),nums.end(),cmp);
        //合并
        for(int i=0;i<nums.size();i++){
            res+=nums[i];
        }
        return res;
    }
};
```

#### 32丑数

把只包含质因子2、3和5的数称作丑数（Ugly Number）。例如6、8都是丑数，但14不是，因为它包含质因子7。 习惯上我们把1当做是第一个丑数。求按从小到大的顺序的第N个丑数。

* 丑数肯定是只含2,3,5因子，因此所有的丑数都是现有的丑数乘以2,3,5得到的。用arr[id]数组记录第id个丑数，采用三个指针 i j k，分别指向2,3,5所对应的三个数，这三个数与对应的因子2,3,5的乘积（记作x,y,z）应该大于已经计算出来的最右边的丑数，取right=min(x,y,z)，将right添加到arr数组的最右边，直到填充完index个丑数。返回arr[index].

```c++
class Solution {
public:
    int nextnum(int x,int y,int z){
        int res=x;
        if(res>y) res=y;
        if(res>z) res=z;
        return res;
    }
    int GetUglyNumber_Solution(int index) {
        if(index<=0) return 0;
        if(index<=6) return index;
        vector<int> arr={0,1,2,3,4,5,6};
        int i,j,k;
        i=3,j=2,k=1;
        int right=6;
        
        while(arr.size()<=index){
            while(arr[i]*2<=right)
                i++;
            while(arr[j]*3<=right)
                j++;
            while(arr[k]*5<=right)
                k++;
            right = nextnum(2*arr[i],3*arr[j],5*arr[k]);
            arr.push_back(right);
        }
        return arr[index];
    }
};
```

#### 33第一个只出现1次的字符

在一个字符串(0<=字符串长度<=10000，全部由字母组成)中找到第一个只出现一次的字符,并返回它的位置, 如果没有则返回 -1（需要区分大小写）.

* 直接用哈希表，映射字母和次数，time O(n) space O(1)

```c++
class Solution {
public:
    int FirstNotRepeatingChar(string str) {
        //先统计次数，再从左到右遍历一遍找到次数为1的；time O(n)
        vector<int> hasha(26,0);
        vector<int> hashA(26,0);
        for(int i=0;i<str.size();i++){
            if(str[i]>='a' && str[i]<='z'){
                hasha[str[i]-'a']++;
            }else if(str[i]>='A' && str[i]<='Z'){
                hashA[str[i]-'A']++;
            }
        }
        for(int i=0;i<str.size();i++){
            if( (str[i]>='a' && str[i]<='z' && hasha[str[i]-'a']==1) || (str[i]>='A' && str[i]<='Z' && hashA[str[i]-'A']==1) )
                return i;
        }
        return -1;
    }
};
```

#### 34 数组中的逆序对

>题目描述
>在数组中的两个数字，如果前面一个数字大于后面的数字，则这两个数字组成一个逆序对。输入一>个数组,求出这个数组中的逆序对的总数P。并将P对1000000007取模的结果输出。 即输出>P%1000000007
>输入描述:
>题目保证输入的数组中没有的相同的数字
>
>数据范围：
>
>	对于%50的数据,size<=10^4
>	对于%75的数据,size<=10^5
>	对于%100的数据,size<=2*10^5
>
>示例1
>输入
>1,2,3,4,5,6,7,0
>输出
>7

* 递归，归并排序的变式 time O(nlogn) space O(n)
```c++
class Solution {
public:
    void Merge(vector<int> &data,int start,int mid,int end){
        vector<int> tmp;
        int i,j;
        i=start,j=mid+1;
        while(i<=mid && j<=end){
            if(data[i]>data[j])
                cnt+=end-j+1;
            if(cnt>=1000000007) cnt=cnt%1000000007;
            int val = data[i]>data[j]?data[i++]:data[j++];
            tmp.push_back(val);
        }
        while(i<=mid)
            tmp.push_back(data[i++]);
        while(j<=end)
            tmp.push_back(data[j++]);
        for(int k=0;k<tmp.size();k++){
            data[start+k]=tmp[k];
        }
    }
    void MergeCount(vector<int>& data,int start, int end){
        if(start>=end) return;
        int mid=start+(end-start)/2;
        MergeCount(data,start,mid);
        MergeCount(data,mid+1,end);
        Merge(data,start,mid,end);
    }
    int InversePairs(vector<int> data) {
        cnt=0;
        MergeCount(data,0,data.size()-1);
        return cnt;
    }
private:
    int cnt;
};
```

#### 35 两个链表的第一个公共节点

输入两个链表，找出它们的第一个公共结点。

* 双指针法

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
    ListNode* FindFirstCommonNode( ListNode* pHead1, ListNode* pHead2) {
        if(pHead1==NULL || pHead2==NULL) return NULL;
        ListNode* p1=pHead1;
        ListNode* p2=pHead2;
        while(!(p1==NULL && p2==NULL)){
            if(p1==p2) return p1;
            p1 = (p1==NULL)? pHead2 : p1->next;
            p2 = (p2==NULL)? pHead1 : p2->next;
        }
        return NULL;
    }
};
```

#### 36 数字在排序数组中出现的次数

统计一个数字在排序数组中出现的次数。

* 定位到数字（可能有重复多个）最左端的二分查找的方法，即在data[mid]==k的情况下令r=mid，与data[mid]>k时相同；而data[mid]<k时令l=mid+1;

```c++
class Solution {
public:
    int GetNumberOfK(vector<int> data ,int k) {
        //设计二分查找找到k的左端，然后开始向右计数,time O(logn),space O(1)
        int l,r;
        l=0,r=data.size()-1;
        while(l<r){
            int mid=l+(r-l)/2;
            if(data[mid]>=k)
                r=mid;
            else
                l=mid+1;
        }
        //向右计数
        int cnt=0;
        for(int i=l;i<data.size();i++){
            if(data[i]==k)
                cnt++;
            else
                break;
        }
        return cnt;
    }
};
```

#### 37二叉树的深度

$\color{red}{未找到最优解}$

输入一棵二叉树，求该树的深度。从根结点到叶结点依次经过的结点（含根、叶结点）形成树的一条路径，最长路径的长度为树的深度。

* 二叉树递归遍历的变式1

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
    void dfs(TreeNode* root,int &res){
        if(root==NULL) return;
        depth++;
        if(depth>res) res=depth;
        dfs(root->left,res);
        dfs(root->right,res);
        depth--;
    }
    int TreeDepth(TreeNode* pRoot)
    {
        int res=0;
        dfs(pRoot,res);
        return res;
    }
private:
    int depth=0;
};
```

* 后序遍历的变式，递归表达式为：根节点的深度=左右子树深度较大的+1

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
    int TreeDepth(TreeNode* pRoot)
    {
        if(pRoot==NULL) return 0;
        int nleft=TreeDepth(pRoot->left);
        int nright=TreeDepth(pRoot->right);
        return (nleft>nright) ? (nleft+1) : (nright+1);
    }
};
```

#### 38 平衡二叉树

$\color{red}{未做出}$

输入一棵二叉树，判断该二叉树是否是平衡二叉树。

* 判断深度,这种类似于先序遍历，需要递归两次；但比较好理解；

```c++
class Solution {
public:
    int TreeDepth(TreeNode* pRoot){
        if(pRoot==NULL) return 0;
        int nleft=TreeDepth(pRoot->left);
        int nright=TreeDepth(pRoot->right);
        return (nleft>nright)?(nleft+1):(nright+1);
    }
    bool IsBalanced_Solution(TreeNode* pRoot) {
        if(pRoot==NULL) return true;
        int nleft=TreeDepth(pRoot->left);
        int nright=TreeDepth(pRoot->right);
        int diff=nright-nleft;
        if(diff>1 || diff<-1)
            return false;
        return IsBalanced_Solution(pRoot->left) && IsBalanced_Solution(pRoot->right);
    }
};
```

* 后序遍历的变式，递归表达式：判断当前节点root左右子树是否为平衡二叉树。在递归判断某节点是否为平衡二叉树时，同时记录该节点的深度。所以在root左右子树判断完后，已经知道了左右子树的深度，从而判断root是否为平衡二叉树，并记录root的深度，否则返回false。

```c++
class Solution {
public:
    bool IsBalanced_Solution(TreeNode* pRoot,int &depth){
        if(pRoot==NULL){
            depth=0;
            return true;
        }
        int left,right;
        if(IsBalanced_Solution(pRoot->left,left) && IsBalanced_Solution(pRoot->right,right)){
            int diff=right-left;
            if(diff<=1 && diff>=-1){
                depth=(left>right)?(left+1):(right+1);
                return true;
            }
        }
        return false;
    }
    bool IsBalanced_Solution(TreeNode* pRoot) {
        int depth=0;
        return IsBalanced_Solution(pRoot,depth);
    }
};
```

#### 39数组中只出现一次的数字

$\color{red}{难，未做出最优解}$ 即time O(n) space O(1)

一个整型数组里除了两个数字之外，其他的数字都出现了两次。请写程序找出这两个只出现一次的数字。

* 最简单哈希表的办法，但是基于此题特殊性，使用位运算可以节省空间；首先将数组分为两半，然后分别使用位运算得到对应的数；
* 第一次异或运算之后得到的num其中为1的位代表着a和b该位必然是不同的，如5(101), 6(110)异或结果为num=011。那么此时对于任意一个数，根据num为1的位是否为1，就可以将数组中的a和b分开。而又因为两个相同数字的任意一位都是相同的，所以不可能将两个相同的数字分到两个不同的组去。因此数组成功分开。


```c++
class Solution {
public:
    int FindFirstBit(int num){
        //找到a&b最右边第一个不为1的位置；
        int indexBit=1;
        int i=0;
        while(((indexBit&num)==0) && (i<32)){
            indexBit=indexBit<<1;
            i++;
        }
        return indexBit;
    }
    void FindNumsAppearOnce(vector<int> data,int* num1,int *num2) {
        //找到a&b，并找到其右边第一个不为1的位置
        int num=0;
        for(int i=0;i<data.size();i++){
            num=num^data[i];
        }
        if(num==0) return;
        int indexBit=FindFirstBit(num);
        //按该位置是否为1将数组分为两半，然后按照只有1个数字出现一次来算
        *num1=*num2=0;
        for(int i=0;i<data.size();i++){
            if((indexBit&data[i])==0)
                *num1^=data[i];
            else
                *num2^=data[i];
        }
    }
};
```

#### 40和为S的连续正数序列

题目描述

> 小明很喜欢数学,有一天他在做数学作业时,要求计算出9~16的和,他马上就写出了正确答案是100。但是他并不满足于此,他在想究竟有多少种连续的正数序列的和为100(至少包括两个数)。没多久,他就得到另一组连续正数和为100的序列:18,19,20,21,22。现在把问题交给你,你能不能也很快的找出所有和为S的连续正数序列? Good Luck!

输出描述:

> 输出所有和为S的连续正数序列。序列内按照从小至大的顺序，序列间按照开始数字从小到大的顺序

* 穷举，双重循环

```c++
class Solution {
public:
    vector<vector<int> > FindContinuousSequence(int sum) {
        vector<vector<int> > res;
        for(int i=1;i<=sum/2;i++){
            vector<int> tmp;
            int num=0;
            for(int j=i;j<sum;j++){
                tmp.push_back(j);
                num+=j;
                if(num==sum)
                    res.push_back(tmp);
                if(num>=sum)
                    break;
            }
        }
        return res;
    }
};
```

