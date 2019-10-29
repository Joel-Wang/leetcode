#### 51 正则表达式匹配（面试题19）

请实现一个函数用来匹配包括'.'和'*'的正则表达式。模式中的字符'.'表示任意一个字符，而'*'表示它前面的字符可以出现任意次（包含0次）。 在本题中，匹配是指字符串的所有字符匹配整个模式。例如，字符串"aaa"与模式"a.a"和"ab*ac*a"匹配，但是与"aa.a"和"ab*a"均不匹配

* 使用递归的思想

>解这题需要把题意仔细研究清楚，反正我试了好多次才明白的。
>  首先，考虑特殊情况：
>      1>两个字符串都为空，返回true
>      2>当第一个字符串不空，而第二个字符串空了，返回false（因为这样，就无法
>      匹配成功了,而如果第一个字符串空了，第二个字符串非空，还是可能匹配成
>      功的，比如第二个字符串是“a*a*a*a*”,由于‘*’之前的元素可以出现0次，
>      所以有可能匹配成功）
>  之后就开始匹配第一个字符，这里有两种可能：匹配成功或匹配失败。但考虑到 pattern
>  下一个字符可能是‘*’， 这里我们分两种情况讨论：pattern下一个字符为 ‘*’ 或
>  不为 ‘*’：
>      1> pattern下一个字符不为‘*’：这种情况比较简单，直接匹配当前字符。如果
>       匹配成功，继续匹配下一个；如果匹配失败，直接返回false。注意这里的
>       “匹配成功”，除了两个字符相同的情况外，还有一种情况，就是pattern的
>        当前字符为‘.’,同时str的当前字符不为‘\0’。
>      2> pattern下一个字符为‘*’时，稍微复杂一些，因为‘*’可以代表0个或多个。
>        这里把这些情况都考虑到：
>           a>当‘*’匹配0个字符时，str当前字符不变，pattern当前字符后移两位，
>            跳过这个‘*’符号；
>           b>当‘*’匹配1个或多个时，str当前字符移向下一个，pattern当前字符
>            不变。（这里匹配1个或多个可以看成一种情况，因为：当匹配一个时，
>            由于str移到了下一个字符，而pattern字符不变，就回到了上边的情况a；
>            当匹配多于一个字符时，相当于从str的下一个字符继续开始匹配）
>之后再写代码就很简单了。
>

```c++
class Solution {
public:
    bool match(char* str, char* pattern)
    {
        if(*str=='\0' && *pattern=='\0')//同时为空，说明匹配成功；
            return true;
        if(*str!='\0' && *pattern=='\0')//字符串不为空而模式已经为空，说明匹配肯定不成功；
            return false;
        
        if(*(pattern+1)=='*'){
            //如果模式的下一位是*字符，那么对这种情况进行判断
            if(*str==*pattern || (*str!='\0' && *pattern=='.'))//当str与pattern对应字符匹配时
                //返回 匹配0个字符 || 匹配1个或多个字符
                return match(str,pattern+2) || match(str+1,pattern);
            else
                //由于不匹配，返回匹配0个字符的结果
                return match(str,pattern+2);
        }else{
            //如果模式的下一位是普通字符，那么当前字符必须匹配才有可能为true;不匹配一定为false;
            if(*str==*pattern || (*str!='\0' && *pattern=='.'))
                return match(str+1,pattern+1);
            else
                return false;
        }
    }
};
```

#### 52 表示数值的字符串（面试题20）

请实现一个函数用来判断字符串是否表示数值（包括整数和小数）。例如，字符串"+100","5e2","-123","3.1416"和"-1E-16"都表示数值。 但是"12e","1a3.14","1.2.3","+-5"和"12e+4.3"都不是。

* 我的代码，纯自然语言翻译，总共判断A , A.B , .B , AeC , A.BeC , .BeC六种情况，手动判断ABC三个部分；

```c++
class Solution {
public:
    bool isNumeric(char* string)
    {
        //A , A.B , .B , AeC , A.BeC , .BeC
        int i=0;
        if(*string=='\0' || *string=='e' || *string=='E') return false;//e10这种算错误；
        
        //检测A
        if(*(string+i)=='+'||*(string+i)=='-')
            i++;
        while(*(string+i)<='9' && *(string+i)>='0')
            i++;
        if(*(string+i)=='\0') return true;
        if(*(string+i)!='.' && *(string+i)!='e' && *(string+i)!='E')
            return false;
        
        //检测B部分
        if(*(string+i)=='.')
            i++;
        while(*(string+i)<='9' && *(string+i)>='0')
            i++;
        if(*(string+i)=='\0') return true;
        if(*(string+i)!='E' && *(string+i)!='e')
            return false;
        
        //检测C部分
        int flag=0;
        if(*(string+i)=='E' || *(string+i)=='e'){
            i++;flag=1;
        }
        if(*(string+i)=='+'||*(string+i)=='-')
            i++;
        while(*(string+i)<='9' && *(string+i)>='0'){
            i++;flag=0;
        }
        if(*(string+i)=='\0' && flag==0)
            return true;
        else
            return false;
    }

};
```

#### 53  字符流中第一个不重复的字符 （面试题50）

>请实现一个函数用来找出字符流中第一个只出现一次的字符。例如，当从字符流中只读出前两个字符"go"时，第一个只出现一次的字符是"g"。当从该字符流中读出前六个字符“google"时，第一个只出现一次的字符是"l"。
>
>输出描述:
>
>如果当前字符流没有存在出现一次的字符，返回#字符。
>

* 如果过将所有的字母存起来，并且从第一个字母开始每个与后面比较看是否出现来寻找，那么时间复杂度为O(n2）空间复杂度O(n)；
* 现在采用一个256长度的哈希表，下标表示字符，value值有3种状态；为-1表示从未出现过，为-2表示已经出现过两次，为0~index表示出现过1次，并且出现的位置是value的值。这样inset为O(1)，search 的时间为O(1)；整体的时间复杂度O(n), 空间复杂度O(1);

```c++
class Solution
{
public:
  //Insert one char from stringstream
    Solution(){
        for(int i=0;i<256;i++)
            hash[i]=-1;
        index=0;
    }
    void Insert(char ch)
    {
        index++;
        int id=ch;
        if(hash[id]==-1)
            hash[id]=index;
        else
            hash[id]=-2;
    }
  //return the first appearence once char in current stringstream
    char FirstAppearingOnce()
    {
        int id=index+1;
        char res=-1;
        for(int i=0;i<256;i++){
            if(hash[i]>=0 && hash[i]<id){
                id=hash[i],res=i;
            }
        }
        if(res==-1)
            return '#';
        else
            return res;
    }
private:
    int index;//表示输入到第index个字符
    int hash[256];
};
```

#### 54 环形链表的入口结点

给一个链表，若其中包含环，请找出该链表的环的入口结点，否则，输出null。

```c++
/*
struct ListNode {
    int val;
    struct ListNode *next;
    ListNode(int x) :
        val(x), next(NULL) {
    }
};
*/
class Solution {
public:
    ListNode* EntryNodeOfLoop(ListNode* pHead)
    {
        set<ListNode*> s;
        ListNode* p=pHead;
        while(p!=NULL && s.count(p)==0){
            s.insert(p);
            p=p->next;
        }
        return p;
    }
};
```

#### 55删除链表重复结点（面试题18，题目二）

> 在一个排序的链表中，存在重复的结点，请删除该链表中重复的结点，重复的结点不保留，返回链表头指针。 例如，链表1->2->3->3->4->4->5 处理后为 1->2->5

* 用pre记录当前节点的前驱，如果当前节点p重复，那么就删除所有与当前节点值相同的相邻节点，然后让pre指向下一个节点。由于头结点也可能会重复，因此初始化pre 为-1，指向pHead; 

```c++
/*
struct ListNode {
    int val;
    struct ListNode *next;
    ListNode(int x) :
        val(x), next(NULL) {
    }
};
*/
class Solution {
public:
    ListNode* deleteDuplication(ListNode* pHead)
    {
        if(pHead==NULL || pHead->next==NULL) return pHead;
        int flag=1;
        ListNode* pre=new ListNode(-1);
        ListNode* pnewHead, *p;
        pnewHead=pre,p=pHead;
        pre->next=p;
        while(p!=NULL){
            //如果当前节点重复，那么删除，直到p为空或者p-val不再是重复值；
            if(p->next!=NULL && p->val==p->next->val){
                int v=p->val;
                while(p!=NULL && v==p->val){
                    ListNode* tmp=p->next;
                    delete p;
                    p=tmp;
                }
                pre->next=p;
            }else{
            //如果当前节点不重复，直接将pre和p向后移一位；
                pre=p;p=p->next;
            }
        }
        ListNode* res=pnewHead->next;
        delete pnewHead;
        return res;
    }
};
```

> 变式：删除重复结点中多余的节点，如1->2->3->3->4->4->5 处理后为 1->2->3->4->5

```c++
/*
struct ListNode {
    int val;
    struct ListNode *next;
    ListNode(int x) :
        val(x), next(NULL) {
    }
};
*/
class Solution {
public:
    ListNode* deleteDuplication(ListNode* pHead)
    {
        if(pHead==NULL || pHead->next==NULL) return pHead;
        ListNode* p=pHead->next;
        ListNode* pre=pHead;
        while(p!=NULL){
            if(pre->val==p->val){
                pre->next=p->next;
                delete p;
                p=pre->next;
            }else{
                pre=p;
                p=p->next;
            }
        }
        return pHead;
    }
};
```

#### 56 二叉树的下一个节点

给定一个二叉树和其中的一个结点，请找出中序遍历顺序的下一个结点并且返回。注意，树中的结点不仅包含左右子结点，同时包含指向父结点的指针。

* 按中序遍历递归和回溯两种情况分别求next值，具体见代码

```c++
/*
struct TreeLinkNode {
    int val;
    struct TreeLinkNode *left;
    struct TreeLinkNode *right;
    struct TreeLinkNode *next;
    TreeLinkNode(int x) :val(x), left(NULL), right(NULL), next(NULL) {
        
    }
};
*/
class Solution {
public:
    TreeLinkNode* GetNext(TreeLinkNode* pNode)
    {
        //由于中序遍历根节点的下一个节点一定在右子树里（假设存在），因此按照有无右子树划分为两种情况分别处理；
        if(pNode==NULL || (pNode->left==NULL && pNode->right==NULL && pNode->next==NULL)) return NULL;
        TreeLinkNode* pNext=NULL;
        if(pNode->right==NULL){
            //如果右子树为空，那么pNode下一个节点应该为父节点pFather，且这个父节点的左孩子为pNode;如果不满足则向上回溯；
            pNext=pNode->next;
            while(pNext!=NULL && pNext->right==pNode){
                pNode=pNext;
                pNext=pNode->next;
            }
        }else{
            //右子树不为空，next节点应为右孩子的最底层的左孩子；
            pNext=pNode->right;
            while(pNext->left!=NULL)
                pNext=pNext->left;
        }
        return pNext;
    }
};
```

#### 57 对称的二叉树

*未做出最优解*

请实现一个函数，用来判断一颗二叉树是不是对称的。注意，如果一个二叉树同此二叉树的镜像是同样的，定义其为对称的。

* **思路：** 采用‘#’来代替层序遍历的空字符，然后对每一层检测对称性。当上一层对称时，下一层必须对称才能是二叉树对称，否则二叉树不对称；

```c++
/*
struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
    TreeNode(int x) :
            val(x), left(NULL), right(NULL) {
    }
};
*/
class Solution {
public:
    bool isSymmetrical(TreeNode* pRoot)
    {
        //层序遍历，带着空字符
        if(pRoot==NULL) return true;
        queue<TreeNode*> q;
        q.push(pRoot);
        while(!q.empty()){
            int len=q.size();
            string str="";
            for(int i=0;i<len;i++){
                TreeNode* curNode=q.front();
                q.pop();
                if(curNode!=NULL){
                    q.push(curNode->left);
                    q.push(curNode->right);
                    str.push_back(curNode->val+'0');
                }else{
                    str.push_back('#');
                }
            }
            int l=0;int r=str.size()-1;
            while(l<r){
                if(str[l++]!=str[r--]) return false;
            }
        }
        return true;
    }

};
```

* **递归** 找到递归子结构，即比较左右两个子节点得值，如果相等，递归比较左节点的左孩子与右节点的右孩子，左节点的右孩子和右节点的左孩子；

```c++
/*
struct TreeNode {
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
    TreeNode(int x) :
            val(x), left(NULL), right(NULL) {
    }
};
*/
class Solution {
public:
    bool isSymmetrical(TreeNode* pRoot)
    {
        //找到递归子结构
        if(pRoot==NULL)
            return true;
        else
            return isSymmetrical(pRoot->left,pRoot->right);
    }
    bool isSymmetrical(TreeNode* pleft,TreeNode* pright){
        //左右孩子同时为空，空节点对称
        if(pleft==NULL && pright==NULL) return true;
        //左右一个为空一个不为空，则一定不对称
        if(!(pleft!=NULL && pright!=NULL)) return false;
        //左右节点值相等，则比较右节点的右孩子，左节点的左孩子；右节点的左孩子，左节点的右孩子；取与；
        if(pleft->val==pright->val)
            return isSymmetrical(pleft->left,pright->right) && isSymmetrical(pleft->right,pright->left);
        else
            return false;
    }

};
```

