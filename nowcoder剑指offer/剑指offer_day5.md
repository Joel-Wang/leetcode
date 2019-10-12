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

* 先对整句话翻转，然后对每个单词翻转；

```c++
class Solution {
public:
    void ReverseSentence(string &str, int start_id,int end_id){
        int l=start_id;int r=end_id;
        while(l<r){
            char tmp=str[l];
            str[l]=str[r];
            str[r]=tmp;
            l++,r--;
        }
    }
    string ReverseSentence(string str) {
        int len=str.size();
        ReverseSentence(str,0,len-1);
        int l;int r=-2;int i=0;
        while(i<len){
            while(i<len && str[i]!=' ')
                i++;
            l=r+2,r=i-1;
            ReverseSentence(str,l,r);
            i++;
        }
        return str;
    }
};
```

#### 44扑克牌顺子

LL今天心情特别好,因为他去买了一副扑克牌,发现里面居然有2个大王,2个小王(一副牌原本是54张^_^)...他随机从中抽出了5张牌,想测测自己的手气,看看能不能抽到顺子,如果抽到的话,他决定去买体育彩票,嘿嘿！！“红心A,黑桃3,小王,大王,方片5”,“Oh My God!”不是顺子.....LL不高兴了,他想了想,决定大\小 王可以看成任何数字,并且A看作1,J为11,Q为12,K为13。上面的5张牌就可以变成“1,2,3,4,5”(大小王分别看作2和4),“So Lucky!”。LL决定去买体育彩票啦。 现在,要求你使用这幅牌模拟上面的过程,然后告诉我们LL的运气如何， 如果牌能组成顺子就输出true，否则就输出false。为了方便起见,你可以认为大小王是0。