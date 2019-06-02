#Leetcode 第1题

[![Travis](https://img.shields.io/badge/language-C++-red.svg)](https://developer.apple.com/.md)

##题目描述

给定一个整数数组`nums`和一个目标值`target`，请你在该数组中找出和为目标值的那**两个**整数，并返回他们的下标。

你可以假设每种输入只会对应一个回答。但是，你不能重复利用这个数组中同样的元素。

**示例：**

```
给定 nums = [2, 7, 11, 15], target = 9

因为 nums[0] + nums[1] = 2 + 7 = 9
所以返回 [0, 1]
```

##代码实现

```cplusplus
// 1. Two Sum
// https://leetcode.com/problems/two-sum/description/
// 时间复杂度：O(n)
// 空间复杂度：O(n)
class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int target) {
        //使用哈希表
        vector<int> re;
        unordered_map<int,int> m;
        for(int i=0;i<nums.size();i++){
            m[nums[i]]=i;
        }
        for(int i=0;i<nums.size();i++){
            int temp=target-nums[i];
            if(m.count(temp)>0&&m[temp]!=i){
                int j=m[temp];
                if(i>j) swap(i,j);
                re.push_back(i);
                re.push_back(j);
                break;
            }
        }
        return re;
    }
};
```
