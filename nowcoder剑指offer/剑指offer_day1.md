#### 01，二维数组中的查找
在一个二维数组中（每个一维数组的长度相同），每一行都按照从左到右递增的顺序排序，每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。
```c++
class Solution {
public:
    bool Find(int target, vector<vector<int> > array) {
        int lr=array.size(), lc=array[0].size();
        int i=0, j=lc-1;
        while(i>=0 && i<lr && j<lc && j>=0){
            if(array[i][j]==target) return true;
            if(array[i][j]<target)
                i++;
            else
                j--;
        }
        return false;
    }
};
```
* 暴力搜索n^2
* 从右上角开始搜索，O(n)


#### 02，替换空格
请实现一个函数，将一个字符串中的每个空格替换成“%20”。例如，当字符串为We Are Happy.则经过替换之后的字符串为We%20Are%20Happy。

* 从前往后替换n^2
* 从后往前替换O(n)

```c++
#include <iostream>

using namespace std;
class Solution {
public:
	void replaceSpace(char *str,int length) {
	    int numofspace=0, newlength;
	    for(int i=0;i<length;i++){
	        if(str[i]==' ')
	            numofspace++;
	    }
	    newlength=length+2*numofspace;
	    int id_old=length, id_new=newlength;
	    while(id_old>=0 && id_old<id_new){
	        if(str[id_old]==' '){
	            str[id_new--]='0';
	            str[id_new--]='2';
	            str[id_new--]='%';
	            id_old--;
	        }else{
	            str[id_new--]=str[id_old--];
	        }
	    }
	}
};
int main()
{
    char str[15]="We Are Happy";
    Solution().replaceSpace(str,12);
    int i=0;
    while(str[i]!='\0'){
        cout<<str[i++];
    }
    cout<<endl;
    return 0;
}
```
#### 03 从尾到头打印链表

输入一个链表，按链表从尾到头的顺序返回一个ArrayList。

* 基于stl的栈，用循环
* 函数栈，递归来做，
* 可以修改原数据，翻转链表，

```c++
/**
*  struct ListNode {
*        int val;
*        struct ListNode *next;
*        ListNode(int x) :
*              val(x), next(NULL) {
*        }
*  };
*/
class Solution {
public:
    vector<int> printListFromTailToHead(ListNode* head) {
        stack<int> s;
        ListNode *p=head;
        while(p!=NULL){
            s.push(p->val);
            p=p->next;
        }
        vector<int> res;
        while(!s.empty()){
            res.push_back(s.top());
            s.pop();
        }
        return res;
    }
};
```

#### 04 前序遍历中序遍历重建二叉树

输入某二叉树的前序遍历和中序遍历的结果，请重建出该二叉树。假设输入的前序遍历和中序遍历的结果中都不含重复的数字。例如输入前序遍历序列{1,2,4,7,3,5,6,8}和中序遍历序列{4,7,2,1,5,3,8,6}，则重建二叉树并返回。

* 注意：不含重复数字
* 递归重建

```c++
/**
 * Definition for binary tree
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class Solution {
public:
    TreeNode* reConstructBinaryTree(vector<int> pre,vector<int> vin) {
        if(pre.size()==0) return NULL;
        TreeNode* root=new TreeNode(pre[0]);
        int id=0;
        while(vin[id]!=pre[0]){
            id++;
        }
        cout<<id<<endl;
        vector<int> lpre,rpre,lvin,rvin;
        for(int i=0;i<id;i++){
            lpre.push_back(pre[i+1]);
            lvin.push_back(vin[i]);
        }
        for(int i=id+1;i<pre.size();i++){
            rpre.push_back(pre[i]);
            rvin.push_back(vin[i]);
        }
        root->left=reConstructBinaryTree(lpre,lvin);
        root->right=reConstructBinaryTree(rpre,rvin);
        return root;
    }
};
```



#### 05用两个栈实现队列

用两个栈来实现一个队列，完成队列的Push和Pop操作。 队列中的元素为int类型。

* 直接使用两个stack，push为正常的push操作，pop时，如果stack2为空，则将stack1的元素从顶到底push进入stack2,然后popstack2的栈顶；如果stack2非空，则直接pop stack2的栈顶；



```c++
class Solution
{
public:
    void push(int node) {
        stack1.push(node);
    }

    int pop() {
        if(stack2.empty()){
            while(!stack1.empty()){
                stack2.push(stack1.top());
                stack1.pop();
            }
        }
        int res=-1;
        if(!stack2.empty()){
            res=stack2.top();
            stack2.pop();
        }
        return res;
    }

private:
    stack<int> stack1;
    stack<int> stack2;
};
```





#### 06 旋转数组的最小数字

把一个数组最开始的若干个元素搬到数组的末尾，我们称之为数组的旋转。输入一个非递减排序的数组的一个旋转，输出旋转数组的最小元素。例如数组{3,4,5,1,2}为{1,2,3,4,5}的一个旋转，该数组的最小值为1。
NOTE：给出的所有元素都大于0，若数组大小为0，请返回0。

* 二分查找变式，将数组分为两个递增数组，二分查找找到第一个递增数组3 4 5的末尾，和第二个递增数组1 2的开头，则最小值为第二个递增数组的开头，当前后两个指针距离为1时可知是结束了。

```c++
class Solution {
public:
    int minNumberInRotateArray(vector<int> rotateArray) {
        if(rotateArray.size()==0) return 0;
        int left=0,right=rotateArray.size()-1,mid=0;
        while(rotateArray[left]>=rotateArray[right]){
            if(right-left==1){
                mid=right;break;
            }
            mid=left+(right-left)/2;
            if(rotateArray[left]==rotateArray[right] && rotateArray[left]==rotateArray[mid]){
                return inorder(rotateArray);
            }
            if(rotateArray[left]<=rotateArray[mid]){
                left=mid;
            }else{
                right=mid;
            }
        }
        return rotateArray[mid];
    }
    int inorder(vector<int> rotateArray){
        int res=rotateArray[0];
        for(int i=0;i<rotateArray.size();i++){
            if(res>rotateArray[i])
                res=rotateArray[i];
        }
        return res;
    }
};
```


#### 07 斐波那契数列
大家都知道斐波那契数列，现在要求输入一个整数n，请你输出斐波那契数列的第n项（从0开始，第0项为0）。n<=39、

* 最节省时间和空间，循环，O(n) time,O(1) space

```c++
class Solution {
public:
    int Fibonacci(int n) {
        int a=0,b=1;
        for(int i=0;i<n;i++){
            b=a+b,a=b-a;
        }
        return a;
    }
};
```
* 递归法：2^n复杂度，超时

```c++
class Solution {
public:
    int Fibonacci(int n) {
        if(n==0) return 0;
        if(n==1) return 1;
        return Fibonacci(n-1)+Fibonacci(n-2);
    }
};
```

#### 07跳台阶
一只青蛙一次可以跳上1级台阶，也可以跳上2级。求该青蛙跳上一个n级的台阶总共有多少种跳法（先后次序不同算不同的结果）。
```c++
class Solution {
public:
    int jumpFloor(int number) {
        if(number<=1) return number;
        int a=0,b=1;
        for(int i=0;i<=number;i++){
            b=a+b;
            a=b-a;
        }
        return a;
    }
};
```

#### 08变态跳台阶
一只青蛙一次可以跳上1级台阶，也可以跳上2级……它也可以跳上n级。求该青蛙跳上一个n级的台阶总共有多少种跳法。
* 按贪心算法，每个台阶的跳法等于之前的总和；

```c++
class Solution {
public:
    int jumpFloorII(int number) {
        if(number>1){
            int tmp=0;
            for(int i=2;i<=number;i++){
                tmp=0;
                for(int j=0;j<i;j++){
                    tmp+=steps[j];
                }
                steps.push_back(tmp);
            }
        }
        return steps[number];
    }
private:
    vector<int> steps={1,1};
};
```
* 但实际这道题有规律，答案为2的n-1次方，计算出来就可以；

```c++
class Solution {
public:
    int jumpFloorII(int number) {
        if(number<=2) return number;
        int res=2;
        for(int i=2;i<number;i++){
            res<<=1;
        }
        return res;
    }
};
```

#### 09矩形覆盖
我们可以用2 * 1的小矩形横着或者竖着去覆盖更大的矩形。请问用n个2 * 1的小矩形无重叠地覆盖一个2 * n 的大矩形，总共有多少种方法？
* 仍然是斐波那契数列的间接形式，可以打表找规律，也可以递归；

```c++
class Solution {
public:
    int rectCover(int number) {
        int a=1,b=2;
        if(number<=2) return number;
        for(int i=2;i<number;i++){
            b=a+b;
            a=b-a;
        }
        return b;
    }
};
```
#### 10二进制中1的个数
输入一个整数，输出该数二进制表示中1的个数。其中负数用补码表示。
* 包括负数
* 负数算1时包括符号位，也就是说-1的二进制表示包含32个1
* 负数右移会在最左边符号位补1，如果负数右移操作最终会变为111111111...
* n=n&(n-1)即消去二进制数最右边的1；
```c++
class Solution {
public:
     int  NumberOf1(int n) {
         int cnt=0;
         while(n){
             n=n&(n-1);
             cnt++;
         }
         return cnt;
     }
};
```
