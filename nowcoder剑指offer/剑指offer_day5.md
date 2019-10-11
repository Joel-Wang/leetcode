#### 41 和为S的两个数字

题目描述：

> 输入一个递增排序的数组和一个数字S，在数组中查找两个数，使得他们的和正好是S，如果有多对数字的和等于>S，输出两个数的乘积最小的。

输出描述:

>对应每个测试案例，输出两个数，小的先输出。

* 使用哈希表time O(n) spaceO(n);

```c++
class Solution {
public:
    vector<int> FindNumbersWithSum(vector<int> array,int sum) {
        //哈希timeO(n) spaceO(n)
        int a=sum;int b=sum;
        if(array.size()<2) return {};
        unordered_map<int,int> m;
        int product=INT_MAX;
        for(int i=0;i<array.size();i++){
            m[array[i]]=i+1;
        }
        for(int i=0;i<array.size();i++){
            int j=m[sum-array[i]]-1;
            if(j>=0 && i!=j && array[i]*array[j]<INT_MAX){
                a=array[i],b=array[j];
            }
        }
        if(a>b){
            a=a-b;b=b+a;a=b-a;
        }
        if(a==sum && b==sum)
            return {};
        else
            return {a,b};
    }
};
```

* 双指针，利用有序数组的特点，只需要time O(n) spaceO(1)

```c++
class Solution {
public:
    vector<int> FindNumbersWithSum(vector<int> array,int sum) {
        //利用不等式可以证明，对于a<b 且 （a+x）<(b-x)必有ab<(a+x)*(b-x)。
        //即两个正数越靠近乘积越大；
        int left=0,right=array.size()-1;
        int a=sum;int b=sum;
        int product=INT_MAX;
        while(left<right){
            int twosum=array[left]+array[right];
            if(twosum==sum){
                if(array[left]*array[right]<product)
                    a=array[left],b=array[right],product=array[left]*array[right];
                left++,right--;
            }
            if(twosum>sum)
                right--;
            else
                left++;
        }
        if(a==sum && b==sum)
            return {};
        else
            return {a,b};
    }
};
```

#### 42左旋转字符串

汇编语言中有一种移位指令叫做循环左移（ROL），现在有个简单的任务，就是用字符串模拟这个指令的运算结果。对于一个给定的字符序列S，请你把其循环左移K位后的序列输出。例如，字符序列S=”abcXYZdef”,要求输出循环左移3位后的结果，即“XYZdefabc”。是不是很简单？OK，搞定它！

```c++
class Solution {
public:
    string LeftRotateString(string str, int n) {
        string res="";
        for(int i=n;i<str.size();i++){
            res+=str[i];
        }
        for(int i=0;i<n;i++){
            res+=str[i];
        }
        return res;
    }
};
```



#### 43翻转单词顺序列

牛客最近来了一个新员工Fish，每天早晨总是会拿着一本英文杂志，写些句子在本子上。同事Cat对Fish写的内容颇感兴趣，有一天他向Fish借来翻看，但却读不懂它的意思。例如，“student. a am I”。后来才意识到，这家伙原来把句子单词的顺序翻转了，正确的句子应该是“I am a student.”。Cat对一一的翻转这些单词顺序可不在行，你能帮助他么？

