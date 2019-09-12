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

