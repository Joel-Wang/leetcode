

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

