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
2. **Estimating the Output of a given program**: In this question, we will learn about how to analyze a simple program and product the output for it. 


    * What is the output of the given program?
   
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
   * What will i and j equal after the code below is executed? Explain your answer.
   
```cpp
1  int i = 5;
2  int j = i++;
```

<!-- added by paras -->
3. **Analyze the program**: In this question, you have to analyze the given piece of code at mutiple level. 


   * Is the program correct? If yes, what is the output of the given program? If not, what are the errors?
   
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

  * Consider the two code snippets below for printing a vector. Is there any advantage of one vs. the other? Explain.

Option 1:

vector vec;
/* ... .. ... */
for (auto itr = vec.begin(); itr != vec.end(); itr++) {
	itr->print();
}
Option 2:

vector vec;
/* ... .. ... */
for (auto itr = vec.begin(); itr != vec.end(); ++itr) {
	itr->print();
}
