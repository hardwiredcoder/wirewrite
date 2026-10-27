<h1>The wirewrite Programming Language</h1>
wirewrite is a programming language designed to make it feel like you're typing wires and gates, like an assembly language. It has a fake, binary memory that your wirewrite script uses to store values, receive user input, and print to the terminal. The language isn't ideal and it's made to just to offer a challenge to programmers.
<h2>How's it Built?</h2>
wirewrite is an interpreted language programmed using the <a href="https://dlang.org" target="_blank">D programming language</a> (aka Dlang). Since wirewrite code gets very complicated and involves an enormous amount of steps to just do one simple thing, it's expected for it to run pretty slowly, even compared to other interpreted languages like Python or Ruby.
<h2>Fake Memory</h2>
Fake memory is binary based.
<br></br>

```
010010
```

Each slot is either a 0 or a 1.

```
010010
^^^^^^
012345
```
