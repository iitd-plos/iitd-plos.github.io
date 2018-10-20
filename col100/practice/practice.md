## Practice Questions
<!-- added by sorav -->
1. **Big_O notation, Time Complexity of a Program**: In this question, we will learn about the time complexity of passing arguments by value and by reference:

   * What is the time-complexity of the following program. Assume size of input queue is N
 
```
1  #include <iostream>
2  using namespace std;
3  int get_queue_length(Queue<int> const &q)
4  {
5     return q.size();
6  }
7  int main()
8  {
9      cin >> n;   
10     Queue<int> q;
11     for (int i = 0; i < n; i++) {
12         q.enqueue(i);
13     }
14     while (!q.isEmpty()) {
15         cout << get_queue_length(q) << endl;
16         cout << q.dequeue() << endl;
17     }
18     return 0;
19 }
```

  * Now what is the time complexity of the followng program (notice that the argument is now pass-by-value)

```cpp
1  #include <iostream>
2  using namespace std;
3  int get_queue_length(Queue<int> q)
4  {
5     return q.size();
6  }
7  int main()
8  {
9      cin >> n;   
10     Queue<int> q;
11     for (int i = 0; i < n; i++) {
12         q.enqueue(i);
13     }
14     while (!q.isEmpty()) {
15         cout << get_queue_length(q) << endl;
16         cout << q.dequeue() << endl;
17     }
18     return 0;
19 }
```

  * And finally, what is the time complexity of the following program (notice that the argument is copied in a local variable before passing-by-reference)

```cpp
1  #include <iostream>
2  using namespace std;
3  int get_queue_length(Queue<int> const &q)
4  {
5     return q.size();
6  }
7  int main()
8  {
9      cin >> n;   
10     Queue<int> q;
11     for (int i = 0; i < n; i++) {
12         q.enqueue(i);
13     }
14     while (!q.isEmpty()) {
15         Queue<int> q2 = q;
16         cout << get_queue_length(q2) << endl;
17         cout << q.dequeue() << endl;
18     }
19     return 0;
20 }
```

<!-- added by paras -->
2. **Estimating the Output of a given program**: In these questions, we will learn about how to analyze a simple program and produce the output for it. 

**2.1** What is the output of the given program?
   
```cpp
1  #include <iostream> 
2  using namespace std; 
3  
4  int main() 
5  { 
6    int a = 32, *ptr = &a; 
7    char ch = 'A', &cho = ch; 
8  
9    cho += a; 
10   *ptr += ch; 
11   cout << a << ", " << ch << endl; 
12   return 0; 
13  } 
```
**2.2** What will i and j equal after the code below is executed? Explain your answer.
   
```cpp
int i = 5;
int j = i++;
```

<!-- added by paras -->
3. **Analyze the program**: In these questions, one need to analyze the given piece of code at multiple levels. 

**3.1** Is the program correct? If yes, what is the output of the given program? If not, what are the errors?
   
```cpp
1 #include <iostream> 
2 using namespace std; 
3  
4 int main() 
5 { 
6    const int i = 20; 
7    const int* const ptr = &i; 
8    (*ptr)++; 
9    int j = 15; 
10   ptr = &j; 
11   cout << i; 
12   return 0; 
13 } 
```

  **3.2** Consider the two code snippets below for printing a vector. Is there any advantage of one vs. the other? Explain.

Option 1:
```cpp
vector vec;
/* ... .. ... */
for (auto itr = vec.begin(); itr != vec.end(); itr++) {
	itr->print();
}
```
Option 2:

```cpp
vector vec;
/* ... .. ... */
for (auto itr = vec.begin(); itr != vec.end(); ++itr) {
	itr->print();
}
```

<!-- added by aman -->



4. **Bitwise Operators**: In this question we, will learn about some of the bitwise operators.

  * &  : Binary AND operator
  * \| : Binary OR operator
  * ^  : Binary XOR operator
  * << : Binary Left shift operator
  * \>\> : Binary Right shift operator

  Read More at [https://www.geeksforgeeks.org/bitwise-operators-in-c-cpp/](https://www.geeksforgeeks.org/bitwise-operators-in-c-cpp/)

  **4.1** Check if two numbers are equal without using arithmetic operators or comparison operators.
  
  **4.2** Divide an integer by 2^k and return the integer quotient. Do not use any arithmetic operator, loops or pow function.

  ```cpp
  int divide(int n, int k){
    /* Do not use any arithmetic operators or loops or pow function */
  }
  ```

  **4.3** Find the kth bit of an integer. Return 1 if it is 1 and 0 otherwise. You should not use any loop, or arithmetic operators. Complete the function below. Bit counting is done from the least significant bit and starts from 0. For example, for n = 19, its binary representation is 10011 the second bit is 0 while the first bit is 1 and the zeroth bit is 1.
  
  ```cpp
  int kthbit(int n, int k){
    /* Do not use any loop or arithmetic operators */
  }
  ```

  **4.4** Find if the number is a power of two, without using any other function call or loop. Complete the if condition below
  
  ```cpp
    int main(){
      int n;
      cin>>n;
      if(/* ... */)
        cout<<"Number is power of 2"<<endl;
      else
        cout<<"Number is not a power of two"<<endl;
      return 0;
    }
  ```

<br>
<!-- added by Ankesh -->
**5. Analysing an algorithm.**

Given below is a function/algorithm: *You'll enjoy foo!*

```cpp
int foo(int a,int b)
{
  int ans=1;
  int temp=a;

  while(b)
  {
    if(b&1)
      ans*=temp;
    temp*=temp;
    b/=2;
  }

  return ans;
}
```
  **5.1** Predict the output for **foo(3,5)**.  
  **5.2** What is **foo(a,b)** computing for general a,b>=0, both integers.  
  **5.3** What is time complexity of **foo(a,b)** for general a,b>=0, both integers. You should report bigO complexity in terms of a and b.  
  **5.4** Can you point out a problem with this code?  
          (**Spoiler:** Will this code produce correct results for large a's and b's?)  
  **5.5** How can you handle negative b?(Note: You can change **function declaration** to double **foo(int a,int b)**)  
  **5.6** Will this logic/algorithm work if **a** were **float** instead of **int**.(Refer to code below)  
```cpp
double foo(double a,int b)
{
  double ans=1;
  double temp=a;

  while(b)
  {
    if(b&1)
      ans*=temp;
    temp*=temp;
    b/=2;
  }

  return ans;
}
```
  *By now, I know you are tired of this foo function - just 1 more to go :p*  

  **5.7** This logic/algorithm won't work if **b** were **float** instead of **int**. Why?  
  **5.8** **Tough, can be skipped-** Can you suggest some way to handle floating b? This will create a general function for task identified in **5.2**.  

  *End of chapter foo :)*  


<!-- added by Sourabh -->
**6.Recursion**

Recursion is a very powerful and an extremely useful tool. It is astonishing that with it's level of functionality,recursion is actually a very simple concept. Recursion formally defined as(source:[wiki/Recursion](https://en.wikipedia.org/wiki/Recursion))

* A class of objects or methods exhibit recursive behavior when they can be defined by two properties: 
  1. A simple base case (or cases)—a terminating scenario that does not use recursion to produce an answer.
  2. A set of rules that reduce all other cases toward the base case.


Every recurive function has the following general format

``` 
recfunc(params):
  if _BaseCondition_ :
    return _corresponding BaseResult_

  else :
    solve _corresponding subproblems_
    return result
```


Now lets work out a example.

* **GCD(a,b)**
   * Base Condition:  b=0 =>  GCD = a
   * Recurrence relation: GCD(a,b) = GCD(b,a%b)

```
int gcd(int a,int b) {
  int gcd_ab;

  if(b==0) {
    gcd_ab = a;
  } else {
    gcd_ab = gcd(b,a%b);
  }

  return gcd_ab;
}
```

Try the following questions on your own. Identify the base condition and reccurence relation.

1. **Factorial**
   * Factorial of a non-negtaive integer **n** is denoted by **n!** or **fact(n)** and is defined as the product of all positive integers <= **n**.

2. **Fibonnaci**
   * Fibonnaci sequence is a sequence of integers following the property that every number is the sum of two numbers preceding it.

3. **Tower of Hanoi**  
   * The Tower of Hanoi is a mathematical game or puzzle. It consists of three rods and a number of disks of different sizes, which can slide onto any rod. The puzzle starts with the disks in a neat stack in ascending order of size on one rod, the smallest at the top, thus making a conical shape.(source:[wiki/Tower_of_Hanoi](https://en.wikipedia.org/wiki/Tower_of_Hanoi))

   * The objective of the puzzle is to move the entire stack to another rod, obeying the following simple rules: 
     1. Only one disk can be moved at a time.
     2. Each move consists of taking the upper disk from one of the stacks and placing it on top of another stack or on an empty rod.
     3. No disk may be placed on top of a smaller disk.
   * The question is to print the sequence of moves which acheive the above objective for **n** disks and three towers named **A,B,C**. Every move should be in the format of **move from T1 to T2**  where **T1,T2** are the names of the towers. All the disks are initially at Tower **A**. At the end of all the moves they should be at Tower **B**. Think of **A** as the starting tower, **B** as the final tower and **C** as the supporting tower.
      * **Hint1:** Try identifying the simplest case which you can solve. Think in terms of number of disks.
      * **Hint2:** Observe the fact that if you had the solution for movement from **A** to **B**. The same solution is applicable for movement from **A** to **C** by simply swapping **B** and **C** in every move.
      * **Hint3:** What if you had the solution for **n-1** disks? Can you use that for the solution of n disks?

<!-- added by Parag -->
**7. Merge sorted vectors**
Write a function mergeSortedVecs(Vector<Vector<int>> vecs) which takes a Vector of Vectors as an argument, where each constitutent Vector is a Vector of integers in the sorted (ascending) order. For example, vecs could be a Vector of the form
<pre>
"{ {1,3,4,5}, {4,6,24,35},{34,100,101} }"
</pre>. Note that vecs consists of three sorted Vectors of integers in this case. Your function should compute a single sorted (ascending) Vector of integers obtained by merging the constituent vectors. For example, in the above case, the return answer should be
<pre>
"{1,3,4,4,5,6,24,34,35,100,101}"
</pre>. Your merge function should take care of duplicates appropriately as shown in the example above (i.e., duplicate elements should be repeated as many times as in the original set of vectors). Write out the function to achieve this functionality. What is the time complexity of your function in terms of the sizes of the original Vectors?

  Note: This is a generalization of the merge function in Minor 2 where you were asked to merge two sorted vectors. This question can be somewhat on the harder side. So you may want to spend time thinking about it before you start implementing. You can also start with writing the pseudocode for a function which merges k given sorted vectors (for some value of k).

<!-- added by Parag -->
**8. Is this a prime?**

We say a number (greater than equal to two) is prime if it is divisble only by itself and 1. Given a number n (n >=2), write a program to check whether a number is prime or not. How much time does your program take? Can you now write an improved program which runs in time O(square_root_of(n)). For this question, you can assume that integer division takes constant time.

<!-- added by Parag -->
**9. Order Order**

Given a Vector of numbers, we say that numbers at positions i and j are out of ascending order if (1) i < j and (2) v_i > v_j. Here v_i and v_j denote the elements at positions i and j, respectively in the Vector. Write a function countOutOfOrder(Vector<int> v), which takes as argument a Vector v, and returns the count of the number of pairs which are out of ascending order. You can assume that all the elements in v are unique. What is the time complexity of your program? To take an example, if the vector is
<pre>
"{1,13,41,5,6}"
</pre>
then the number of pairs which are out ascending order is 4.

<!-- added by Vaibhav -->
**10. Inverse of a Matrix**

Given a Grid of floating point numbers, find its inverse. You need to implement the following function:

```
int computeInverse(Grid<float> &inverse, Grid<float> &input_grid) {
  // input_grid is the input matrix
  // inverse is the grid in which the inverse should be computed
  // Return 0, if the inverse of the input_grid exists else return -1
}
```

Take into consideration, the following points while solving this problem:

1. When does the inverse of an input grid exist and when does it not
  - Will all grids have an inverse or do they need to be of a particular shape
  - If yes, is it necessary that all the grids of that particular shape will have inverses, or something more is required
2. Consider the various algorithms which you have studied, to compute the inverse of a matrix
  - Using `determinant` and `adjoint` of a matrix
  - Using matrix transformations. In particular, read about [Row Echelon Form](https://en.wikipedia.org/wiki/Row_echelon_form) of a matrix and how it is used to compute the inverse
3. What is the time complexity of each of the above methods


<!-- added by Saket -->
**11. Numbers are life**

**11.1** Given a number, can you find the sum of it's divisors? Complete the function below 

```
int DivisorSum(int num) {
  // num is the input number
  // return an integer containing sum of divisors
  // for example - if num = 6 return 1 + 2 + 3 + 6 = 12
}
```

**11.2** Now let's try to find prime factorization of an integer. If you have already implemented a function to check if a number is prime, then this is gonna be easy ! (isn't it?) Complete the function below 

```
vector <int> PrimeFactorization(int num) {
  // num is the input number
  // return a vector containing prime factorization of the number
  // for example - if num = 6 return [2,3]
  // if num = 24 return [2,2,2,3], if num = 7 return [7]
}
```

**11.3** Well now, you know there exists a formula for finding sum of divisors using prime factorization of a number [Read Here](https://oeis.org/wiki/Sum_of_divisors_function#Formulae_for_the_sum_of_divisors_function). So why not modify our DivisorSum to use this formula ? 

```
int DivisorSum(int num) {
  vector <int> prime_fact = PrimeFactorization(num);
  // now use this prime_fact and formula above to compute the sum of divisors
}
```


<!-- added by Sangnie -->
**12. Anagram Strings**

Given 2 strings, report if they are anagrams of each other. You need to implement the following function:

```
bool isAnagram(string s1, string s2) {
  // Return true, if s1 and s2 are anagrams of each other else return false
}
```

A string is an anagram of another if it can be formed by rearranging the characters of the original string. For example, dog is an anagram of god, but not of cat. Head over to [Anagram](https://en.wikipedia.org/wiki/Anagram) for more fun examples.

Note:
1. Ignore case. \"Dog\" is a valid anagram of \"god\".
2. Consider only strings containing characters from the English alphabet.