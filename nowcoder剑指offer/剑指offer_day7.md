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
    char* Serialize(TreeNode *root) {    
        char str[]="";
        char *p=str;
        if(root==NULL){
            *str='#';
            return str;
        }else{
            Serial(root,str);
            return p;
        }
    }
    void Serialize(TreeNode* root,char* str){
        if(root==NULL){
            *str++='#';
            *str++='!';
            *(str+1)='\0';
            return;
        }
        
        int num=root->val;
        stack<int> st;
        while(num!=0){
            int r=num%10;
            num=num/10;
            st.push(r);
        }
        while(!st.empty()){
            *str++='0'+st.top();
            st.pop();
        }
        *str++='!';
        *(str+1)='\0';
        
        Serialize(root->left,str);
        Serialize(root->right,str);
    }
    TreeNode* Deserialize(char *str) {
        if(str==NULL) return NULL;
        TreeNode* root;
        int isend=0;
        Deserialize(root,str,isend);
        return root;
    }
    TreeNode* Deserialize(TreeNode* root,char* str,int& isend){
        if(**str=='#'){
            return NULL;
        }
        int num=0;
        while(*str!='!'){
            num=num*10+*str-'0';
            str++;
        }
        root->val=num;
        root->left=Deserialize(root->left,str++);
        root->right=Deserialize(root->right,str++);
        
    }
};
```

