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

