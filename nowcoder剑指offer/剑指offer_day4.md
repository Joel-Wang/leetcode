#### 31把数组排成最小的数

输入一个正整数数组，把数组里所有数字拼接起来排成一个数，打印能拼接出的所有数字中最小的一个。例如输入数组{3，32，321}，则打印出这三个数字能排成的最小数字为321323。

* 思路1：将所有数组全排列，然后分别计算每一个数，比较得到最小的；出现的问题：组合起来的数过大溢出，时间复杂度O(n!)过高；
* 思路2：为了防止溢出，将数字转换成字符串；为了降低复杂度，定义一个特定的排序规则，当m<n，m应该排在n的前面，将m和n拼接起来得到mn和nm，然后通过字符串大小比较规则来比较；最后将排完序的结果合并；timeO(nlogn)，spaceO(n)需要额外的空间存储字符串，也可以不存，但会稍微麻烦点；

```c++
class Solution {
public:
    static bool cmp(string s1,string s2){
        string cmp1=s1+s2;
        string cmp2=s2+s1;
        for(int i=0;i<cmp1.size();i++){
            if(cmp1[i]==cmp2[i])
                continue;
            if(cmp1[i]<cmp2[i])
                return 1;
            else
                return 0;
                
        }
    }
    string PrintMinNumber(vector<int> numbers) {
        vector<string> nums;
        string res="";
        //转化为string;
        for(int i=0;i<numbers.size();i++){
            string tmp="";
            stack<int> s;
            int num=numbers[i];
            while(num>0){
                int r=num%10;
                s.push(r);
                num=num/10;
            }
            while(!s.empty()){
                tmp.push_back(s.top()+'0');
                s.pop();
            }
            nums.push_back(tmp);
        }
        //排序
        sort(nums.begin(),nums.end(),cmp);
        //合并
        for(int i=0;i<nums.size();i++){
            res+=nums[i];
        }
        return res;
    }
};
```

#### 32丑数

把只包含质因子2、3和5的数称作丑数（Ugly Number）。例如6、8都是丑数，但14不是，因为它包含质因子7。 习惯上我们把1当做是第一个丑数。求按从小到大的顺序的第N个丑数。

* 丑数肯定是只含2,3,5因子，因此所有的丑数都是现有的丑数乘以2,3,5得到的。用arr[id]数组记录第id个丑数，采用三个指针 i j k，分别指向2,3,5所对应的三个数，这三个数与对应的因子2,3,5的乘积（记作x,y,z）应该大于已经计算出来的最右边的丑数，取right=min(x,y,z)，将right添加到arr数组的最右边，直到填充完index个丑数。返回arr[index].

```c++
class Solution {
public:
    int nextnum(int x,int y,int z){
        int res=x;
        if(res>y) res=y;
        if(res>z) res=z;
        return res;
    }
    int GetUglyNumber_Solution(int index) {
        if(index<=0) return 0;
        if(index<=6) return index;
        vector<int> arr={0,1,2,3,4,5,6};
        int i,j,k;
        i=3,j=2,k=1;
        int right=6;
        
        while(arr.size()<=index){
            while(arr[i]*2<=right)
                i++;
            while(arr[j]*3<=right)
                j++;
            while(arr[k]*5<=right)
                k++;
            right = nextnum(2*arr[i],3*arr[j],5*arr[k]);
            arr.push_back(right);
        }
        return arr[index];
    }
};
```

#### 33第一个只出现1次的字符

在一个字符串(0<=字符串长度<=10000，全部由字母组成)中找到第一个只出现一次的字符,并返回它的位置, 如果没有则返回 -1（需要区分大小写）.

* 直接用哈希表，映射字母和次数，time O(n) space O(1)

```c++
class Solution {
public:
    int FirstNotRepeatingChar(string str) {
        //先统计次数，再从左到右遍历一遍找到次数为1的；time O(n)
        vector<int> hasha(26,0);
        vector<int> hashA(26,0);
        for(int i=0;i<str.size();i++){
            if(str[i]>='a' && str[i]<='z'){
                hasha[str[i]-'a']++;
            }else if(str[i]>='A' && str[i]<='Z'){
                hashA[str[i]-'A']++;
            }
        }
        for(int i=0;i<str.size();i++){
            if( (str[i]>='a' && str[i]<='z' && hasha[str[i]-'a']==1) || (str[i]>='A' && str[i]<='Z' && hashA[str[i]-'A']==1) )
                return i;
        }
        return -1;
    }
};
```





#### 35数字在排序数组中出现的次数

统计一个数字在排序数组中出现的次数。

* 定位到数字（可能有重复多个）最左端的二分查找的方法，即在data[mid]==k的情况下令r=mid，与data[mid]>k时相同；而data[mid]<k时令l=mid+1;

```c++
class Solution {
public:
    int GetNumberOfK(vector<int> data ,int k) {
        //设计二分查找找到k的左端，然后开始向右计数,time O(logn),space O(1)
        int l,r;
        l=0,r=data.size()-1;
        while(l<r){
            int mid=l+(r-l)/2;
            if(data[mid]>=k)
                r=mid;
            else
                l=mid+1;
        }
        //向右计数
        int cnt=0;
        for(int i=l;i<data.size();i++){
            if(data[i]==k)
                cnt++;
            else
                break;
        }
        return cnt;
    }
};
```

