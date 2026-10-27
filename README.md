<h1>The wirewrite Programming Language</h1>
wirewrite is a programming language designed to make it feel like you're typing wires and gates, like an assembly language. It has a fake, binary memory that your wirewrite script uses to store values, receive user input, and print to the terminal. The language isn't ideal and it's made to just to offer a challenge to programmers.
<h2>How's it Built?</h2>
wirewrite is an interpreted language programmed using the <a href="https://dlang.org" target="_blank">D programming language</a> (aka Dlang). Since wirewrite code gets very complicated and involves an enormous amount of steps to just do one simple thing, it's expected for it to run pretty slowly, even compared to other interpreted languages like Python or Ruby.
<h2>Fake Memory</h2>
Fake memory is binary based. 0 represents off/false and 1 represents on/true.
<br></br>

```
010010
```

Memory bit addresses are counted up, starting from 0. Each bit has a value of either 0 or 1.

```
010010
^^^^^^
012345
```

The fake memory is always all 0s to start. wirewrite code can set a bit to be off (0) or on (1).

Memory Before:
```
000000
```

wirewrite Code:
```
SET 0 1
```

Memory After:
```
100000
```

Fake memory is the only type of variable in the language, so it's used to store data. This includes giving input to functions.
<h2>Functions</h2>
The only functions in wirewrite are the ones built-in to the interpreter. There are no custom functions unless someone mods the interpreter source code to their own version. Here are the ones of this version, currently:
<br></br>

```
SET
```
```
PRINT
```
```
PRINTLN
```
```
INPUT
```
```
STOP
```
```
REPEAT
```

SET, STOP, and REPEAT are the most important functions and are a core part of the language, whereas PRINT, PRINTLN, and INPUT are functions that just let wirewrite programs communicate with the user.
<h3>SET</h3>
SET will set a specific bit of the fake memory to be either off (0) or on (1). When calling this function, you must specify the memory address (which bit) you're modifying and to what value (0 or 1).

```
SET <address> <value>
```
Example:
```
SET 8 1
```

This is the only function that wants input when you're calling it. The other functions either don't need any input or get input from looking at the fake memory values.
<h3>PRINT & PRINTLN</h3>
These two functions both print what you want to the terminal, but they only print one character at a time and it can be quite tricky to print anything to the terminal. The functions read the first seven bits of the fake memory (addresses 0 through 6) to get a number. Similarly to how fake memory addresses work, the number is used to get one character from the list of characters.

List of characters:
```
 abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*()-+_`~<>,.?/:;"'{}[]|\█▓▒░▔▕√©\n\t
```
*the first one is a space. the last one is \t, which is a tab. the second to last one is \n, which is a newline*

Example:
3 would be "c"
<br></br>
How do the functions get this number through 7 bits, you ask? The bits go by powers of 2. Each of the 7 bits represent their own number and add a number when the bit is turned on.
<br></br>
List of the bits' values:
```
0  -  1
1  -  2
2  -  4
3  -  8
4  -  16
5  -  32
6  -  64
```

You can actually get any number between 0 and 127 with those 7 bits.

This is 0:
```
0000000
```

This is 36:
```
0010010
```
4 + 32 = 36
<br></br>
This is 105:
```
1001011
```
1 + 8 + 32 + 64 = 105
<br></br>
And 127:
```
1111111
```
1 + 2 + 4 + 8 + 16 + 32 + 64 = 127
<br></br>
If you still don't understand it, I apologize, I'm not the best at explaining things. Here is a good link:
https://personal.math.ubc.ca/~cass/courses/m210/text/base2.pdf
<br></br>
Now, let me tell you about the difference between PRINT and PRINTLN. When using PRINT, it's going to just print right out. If you use PRINTLN, it's going to create a new line and then print. That's literally the only difference.
<br></br>
Example (printing "e" in wirewrite):

```
SET 4 1
SET 3 1
SET 2 1
SET 1 1
SET 0 1
PRINT
```
<h3>INPUT</h3>
INPUT will stop the program until the user types a character in the terminal. The character must be in the character list (the same one PRINT and PRINTLN uses) or the program will just crash. After the user presses a key, the bits in addresses 7 to 13 will change to represent the number of the character that the user pressed. It uses the same type of number system as PRINT and PRINTLN do. INPUT is only ever useful after learning how conditions and gates work.
<h3>STOP & REPEAT</h3>
STOP will tell the interpreter when to stop the program. REPEAT will tell the interpreter to go back to the first line of the code again. When writing wirewrite code, it's required that either one of these are used at the end of the program, otherwise it will crash.
<br></br>
this prints "a" forever:

```
SET 0 1
PRINTLN

REPEAT
```

<h2>Gates & Conditions</h2>
