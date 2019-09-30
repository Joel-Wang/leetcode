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

* 丑数肯定是只喊2,3,5因子，因此所有的丑数都是2,3,5