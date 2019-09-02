

#### 11数值的整数次方

给定一个double类型的浮点数base和int类型的整数exponent。求base的exponent次方。

保证base和exponent不同时为0

* O(n) 解法：循环一次

```c++
class Solution {
public:
    double Power(double base, int exponent) {
        double b=base;
        int e=exponent;
        if(b==0) return 0;
        if(e==0) return 1;
        
        
        if(e<0){
            b=1.0/b;
            e=-e;
        }
        double res=b;
        for(int i=1;i<e;i++){
            res*=b;
        }
        return res;
    }
};
```

* O(logn)解法：利用递归的思想

```c++
class Solution {
public:
    double Power(double base, int exponent) {
        double b=base;
        int e=exponent;
        if(b==0) return 0;
        if(e==0) return 1;
        
        
        if(e<0){
            b=1.0/b;
            e=-e;
        }
        double res=b;
        
        return p(b,e);
    }
    double p(double b,int e){
        if(e==0) return 1;
        if(e==1) return b;
        if(e%2==0)
            return p(b,e/2)*p(b,e/2);
        else
            return p(b,e/2)*p(b,e/2)*b;
    }
};
```

* 利用递归的思想用循环来做