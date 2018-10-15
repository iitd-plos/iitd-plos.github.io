## Practice Questions

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
16     }
17     return 0;
18 }
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
16     }
17     return 0;
18 }
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
17     }
18     return 0;
19 }
```
