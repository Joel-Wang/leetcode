# LeetCode 第 2 号问题：两数相加

## 题目描述

给出两个 **非空** 的链表用来表示两个非负的整数。其中，它们各自的位数是按照 **逆序** 的方式存储的，并且它们的每个节点只能存储 **一位** 数字。

如果，我们将这两个数相加起来，则会返回一个新的链表来表示它们的和。

您可以假设除了数字 0 之外，这两个数都不会以 0 开头。

**示例：**

```
输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
输出：7 -> 0 -> 8
原因：342 + 465 = 807
```

## 题目解析

由于两个数字是按个位往高位的顺序来排列，因此使用合并有序数组的方法，采用三个while循环：

## 代码实现

```
/// 时间复杂度: O(n)
/// 空间复杂度: O(n)
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode(int x) : val(x), next(NULL) {}
 * };
 */
class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        ListNode* a=new ListNode(-1);
        ListNode*pre,*cur;
        pre=a;
        int flag=0;
        while(l1&&l2){
            int v=l1->val+l2->val+flag;
            flag=0;
            if(v>=10){flag=1,v=v%10;}
            cur=new ListNode(v);
            pre->next=cur;pre=cur;
            l1=l1->next,l2=l2->next;
        }
        while(l1){
            int v=l1->val+flag;
            flag=0;
            if(v>=10){flag=1,v=v%10;}
            cur=new ListNode(v);
            pre->next=cur;pre=cur;
            l1=l1->next;
        }
        while(l2){
            int v=l2->val+flag;
            flag=0;
            if(v>=10){flag=1,v=v%10;}
            cur=new ListNode(v);
            pre->next=cur;pre=cur;
            l2=l2->next;
        }
        if(flag){
            cur=new ListNode(1);
            pre->next=cur;
        }
        return a->next;
    }
};

```