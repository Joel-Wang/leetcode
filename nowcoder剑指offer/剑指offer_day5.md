#### 41 和为S的两个数字（面试题57）

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



#### 43翻转单词顺序列（面试题58，翻转字符串）

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

#### 44扑克牌顺子（面试题61）

LL今天心情特别好,因为他去买了一副扑克牌,发现里面居然有2个大王,2个小王(一副牌原本是54张^_^)...他随机从中抽出了5张牌,想测测自己的手气,看看能不能抽到顺子,如果抽到的话,他决定去买体育彩票,嘿嘿！！“红心A,黑桃3,小王,大王,方片5”,“Oh My God!”不是顺子.....LL不高兴了,他想了想,决定大\小 王可以看成任何数字,并且A看作1,J为11,Q为12,K为13。上面的5张牌就可以变成“1,2,3,4,5”(大小王分别看作2和4),“So Lucky!”。LL决定去买体育彩票啦。 现在,要求你使用这幅牌模拟上面的过程,然后告诉我们LL的运气如何， 如果牌能组成顺子就输出true，否则就输出false。为了方便起见,你可以认为大小王是0。

* 用空间换时间 timeO(n) space O(n) ，用排序则为O(nlogn)

```c++
class Solution {
public:
    bool IsContinuous( vector<int> numbers ) {
        /*记牌的数目为cnt_0,cnt_p分别为0的数目和正数的数目，left,right为非0数的最小最大值，定义长度len=right-left+1;
        现在验证抽到的牌能否组成1个顺子，首先除去2中false情况：
        1. cnt_0+cnt_p>13 or cnt_0+cnt_p<1，牌数多于13或小于1不可能组成顺子，
        2. 用哈希表记录每个牌的个数，非0牌有重复则不可能组成顺子
        然后判断cnt_0>=len-cnt_p是否成立，成立则true，否则false;
        */
        if(numbers.size()>13 || numbers.size()<1) return false;
        
        int cnt_0=0;int cnt_p=0;
        int left=14;int right=0;
        vector<int> hash(14,0);
        
        for(int i=0;i<numbers.size();i++){
            if(numbers[i]==0)
                cnt_0++;
            else
                cnt_p++;
            hash[numbers[i]]++;
            
            if(numbers[i]!=0){
                if(hash[numbers[i]]>=2) return false;
                if(numbers[i]<left) left=numbers[i];
                if(numbers[i]>right) right=numbers[i];
            }
        }
        int len=right-left+1;
        if(cnt_0>=len-cnt_p)
            return true;
        else
            return false;
    }
};
```

#### 45 孩子们的游戏（圆圈中最后剩下的数字，面试题62）

每年六一儿童节,牛客都会准备一些小礼物去看望孤儿院的小朋友,今年亦是如此。HF作为牛客的资深元老,自然也准备了一些小游戏。其中,有个游戏是这样的:首先,让小朋友们围成一个大圈。然后,他随机指定一个数m,让编号为0的小朋友开始报数。每次喊到m-1的那个小朋友要出列唱首歌,然后可以在礼品箱中任意的挑选礼物,并且不再回到圈中,从他的下一个小朋友开始,继续0...m-1报数....这样下去....直到剩下最后一个小朋友,可以不用表演,并且拿到牛客名贵的“名侦探柯南”典藏版(名额有限哦!!^_^)。请你试着想下,哪个小朋友会得到这份礼品呢？(注：小朋友的编号是从0到n-1)

如果没有小朋友，请返回-1

* 最基本的方法， 建立一个环形链表，然后模拟整个过程，最后剩下的小朋友可以拿到礼品；特殊情况没有小朋友，a. n<=0即本来就有0个小朋友；b. m<=0每次不可能有对应编号的小朋友出列；这两种情况 return -1；

```c++
struct Lists{
    int val;
    struct Lists* next;
    Lists(int x): val(x),next(NULL){}
};
class Solution {
public:
    int LastRemaining_Solution(int n, int m)
    {
        //time O(mn) space O(n);
        //初始化环形链表；
        if(n<=0 || m<=0) return -1;
        Lists *head=new Lists(0);
        Lists *pre=head;
        for(int i=1;i<n;i++){
            Lists *cur=new Lists(i);
            pre->next=cur;
            pre=cur;
        }
        pre->next=head;
        //模拟报数，直到剩下一个小朋友；
        Lists *p=head;
        while(p->next!=p){
            for(int i=1;i<m-1;i++){
                p=p->next;
            }
            p->next=p->next->next;
            p=p->next;
        }
        return p->val;
    }
};
```

#### 46 求1+2+3+···+n

求1+2+3+...+n，要求不能使用乘除法、for、while、if、else、switch、case等关键字及条件判断语句（A?B:C）。

* 递归

```c++
class Solution {
public:
    int Sum_Solution(int n) {
        if(n<=1) return n;
        return Sum_Solution(n-1)+n;
    }
};
```

* 利用构造函数，相关知识参考：<https://www.cnblogs.com/joelwang/p/11693514.html>

```c++
class Temp {
public:
    Temp(){++N;Sum+=N;}
    
    static void Reset(){N=0;Sum=0;}
    static int GetSum(){return Sum;}
private:
    static int N;
    static int Sum;
};
int Temp::N=0;
int Temp::Sum=0;

class Solution {
public:
    int Sum_Solution(int n) {
        Temp::Reset();
        Temp* a = new Temp[n];
        delete []a;
        a = nullptr;
        return Temp::GetSum();
    }
};
```

* 利用虚函数

```c++
class A;
A* Array[2];
class A{
    public:
    virtual int Sum(int n){
        return 0;
    }
};
class B:public A{
    public:
    virtual int Sum(int n){
        return Array[!!n]->Sum(n-1)+n;
    }
};
class Solution {
public:
    int Sum_Solution(int n) {
        A a;
        B b;
        Array[0]=&a;
        Array[1]=&b;
        int val=Array[1]->Sum(n);
        return val;
    }
};
```

#### 47 不使用加减乘除做加法（面试题65）

写一个函数，求两个整数之和，要求在函数体内不得使用+、-、*、/四则运算符号。

* 使用位运算；

```c++
class Solution {
public:
    int Add(int num1, int num2){
        //分为两步：a.不进位加法（按位异或运算^）结果sum；b.记下进位（按位与运算&）结果carry；
        //重复制导carry==0;
        int sum, carry;
        do{
            sum=num1^num2;
            carry=(num1&num2)<<1;
            num1=sum;
            num2=carry;
        }while(carry!=0);
        return sum;
    }
};
```

#### 48把字符串转换成整数（面试题67）

题目描述
>将一个字符串转换成一个整数，要求不能使用字符串转换整数的库函数。 数值为0或者字符串不是一个合法的数值则返回0

输入描述:
>输入一个字符串,包括数字字母符号,可以为空

输出描述:
>如果是合法的数值表达则返回该数字，否则返回0

示例1
>输入
>+2147483647
>1a33
>输出
>2147483647
>0

* 对边界情况的处理：通过 isnum是否为true，来标识是否是合法的输入（由于数字0的存在，因此要单设置一个全局变量来标识）；

  1. 当输入为正常的数字和符号时判断是否非法（数字溢出或空字符，符号字符等无意义的情况）：

  ​	a. 记录除符号位以外的数字部分为有效数字，假如有效数字的长度len==0则说明输入str要么为空，要么只有符号位，都是非法输入；

  ​	b. 当有效数字的长度len>10则说明肯定溢出，也是非法输入；

  ​	c. 当有效数字的长度len==10，但大于INT_MAX或小于INT_MIN时为非法；

  2. 当输入不是数字式看做非法：当第一位输入是‘+’ ‘-’和数字以外的符号为非法，2~末位为0~9以外的符号为非法（输入掺杂字母和其他字符等的非法输入）；

```c++
bool isnum=true;//标记是否合法字符，与输入数字0相区别；
class Solution {
public:
    int StrToInt(string str) {
        //检测第一位是否符号，并获取；如果是符号则i++;
        //考虑非法输入；考虑溢出；
        int i=0;
        int sign=1;
        if(str[i]=='+' || str[i]=='-'){
            sign=str[i]=='-'?-1:1;i++;
        }
        
        int num=0;
        
        //判断溢出
        string limitmax="2147483647";
        string limitmin="2147483648";
        int len=str.size()-i;
        if(len>10 || len<=0) {isnum=false;return 0;}
        if(len==10 && sign==1){
            for(int j=0;j<10;j++){
                if(str[i+j]<limitmax[j]) break;
                if(str[i+j]>limitmax[j]) {isnum=false;return 0;}
            }
        }else if( len==10 && sign==-1){
            for(int j=0;j<10;j++){
                if(str[i+j]<limitmin[j]) break;
                if(str[i+j]>limitmin[j]) {isnum=false;return 0;}
            }
        }
        //转换数字
        while(i<str.size()){
            if(str[i]>'9' || str[i]<'0') {isnum=false;return 0;}
            int val=str[i]-'0';
            num=num*10+val;
            i++;
        }
        return num*sign;
    }
};
```

#### 49数组中重复的数字

在一个长度为n的数组里的所有数字都在0到n-1的范围内。 数组中某些数字是重复的，但不知道有几个数字是重复的。也不知道每个数字重复几次。请找出数组中任意一个重复的数字。 例如，如果输入长度为7的数组{2,3,1,0,2,5,3}，那么对应的输出是第一个重复的数字2。

* 创建一个哈希表映射numbers[i]的值和出现的次数；

```c++
class Solution {
public:
    // Parameters:
    //        numbers:     an array of integers
    //        length:      the length of array numbers
    //        duplication: (Output) the duplicated number in the array number
    // Return value:       true if the input is valid, and there are some duplications in the array number
    //                     otherwise false
    bool duplicate(int numbers[], int length, int* duplication) {
        int hash[length];
        for(int i=0;i<length;i++){
            hash[i]=0;
        }
        for(int i=0;i<length;i++){
            if(hash[numbers[i]]>0){
                *duplication=numbers[i];
                return true;
            }
            hash[numbers[i]]++;
        }
        return false;
    }
};
```

