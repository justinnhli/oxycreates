<style>
    /* CSS for code-prettify (prepend <!--?prettify linenums=true?--> to use) */
    .prettyprinted ol.linenums {counter-reset:codeLineNum;}
    .prettyprinted ol.linenums li {counter-increment:codeLineNum; position:relative; list-style-type:none; background-color:transparent;}
    .prettyprinted ol.linenums li:before {content:counter(codeLineNum); position:absolute; right:100%; margin-right:1em;}
    blockquote {font-style:italic; background-color:#EEEEEE;}
</style>
<script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>

# A Debugging Guide

> "Debugging is twice as hard as writing a program in the first place."
>
> \- Brian Kernighan, The Elements of Programming Style

More than programming, debugging requires the mindset of a problem solver. Code *can* be written sloppily and in an ad-hoc way; debugging *must* be done methodically and with attention to detail. This guide is about the concrete steps of debugging, but I highly recommend first reading [Ryan Chadwick's problem solving tutorial](https://ryanstutorials.net/problem-solving-skills/) for an introduction to the appropriate attitude and mindset. This guide is heavily inspired by [a similar guide by John Regehr](https://blog.regehr.org/archives/199).

A brief table of contents:

* [Terminology]()
* [A Debugging Guide]()
* [A Simple Example]()
* [A More Complicated Example]()
* [Other Resources]()

## Terminology

To make things clearer, I will use the following terms for the rest of this guide:

* *Symptom* - The behavior of the program that is incorrect. This could be a null pointer exception, or a ValueError, or simply some output or return value that is incorrect.
* *Bug* - The underlying code that is incorrect, which made lead to zero or more symptoms.
* *Diagnostic Code* - Code that is written not as part of the program, but to help with debugging.
* *Input* - The data that your program operates on. This could be actual typed input from the user, arguments to a function, numbers from a spreadsheet, or even mouse movements on a webpage.
* *Test Case* - Although this usually means some input that we know the correct behavior for and can check against, here I use this term to mean the input that causes the program to exhibit symptoms.
* *Minimal Test Case* - The smallest test case that will cause the same symptom. Alternately, the smallest test case that will expose the same bug (even if the symptoms are different).

It is important to remember here *symptoms are not the same as bugs*. Your program may be buggy, but could run fine without symptoms on the input you are using. Sometimes, different symptoms under different inputs may ultimately be caused by the same bug. Other times, a symptom may be due to multiple bugs in your code, all of which must be fixed before the symptom goes away. On occasion, the symptom may lead to the realization that your current approach is completely infeasible, in which case the code will have to be rewritten from scratch.

Debugging is process where, given one or more symptoms, you determine the bug(s) that led to it, and (ideally) removing those bugs from the code. In this sense, debugging is like being a detective trying to figure out what happened from evidence left behind, or like a scientist trying to understand some puzzling phenomenon. Lucky for us as programmers, we have the ability to replay what happened by running the program again, and to ask the computer to tell us more about what is happening by adding diagnostic code.

<!--
(FIXME talk about the relationship between testing)
-->

## A Debugging Guide

> "Would you tell me, please, which way I ought to go from here?"
> 
> "That depends a good deal on where you want to get to," said the Cat.
> 
> "I don't much care where -" said Alice.
>
> "Then it doesn't matter which way you go," said the Cat. 
>
> \- Lewis Carroll, Alice in Wonderland

This guide is written for what's known as "print debugging" - that is, I'm assuming that the only thing you have is the source code and the ability to add print statements. Many languages and IDEs have debuggers, which will do the printing for you or offer other ways of understanding what your program is doing. These are highly useful, and I recommend learning to use them in your programming language/environment of choice. Debuggers may not always be available, however, and even with debuggers, the *thinking process* of debugging is the same, which is why this guide uses print debugging.

A lot of programmers, when they first start writing code, engage in what I call "trial-and-error debugging": they see that the program doesn't work, they randomly change their code, then run it to see if that fixed the problem. *The sooner you get rid of this habit, the better.* While this strategy might get you through your first (or even second) programming class, it will *not* work as your program gets more complicated. There are simply too many possible things to change that, without knowing what you're doing, proceeding with guess-and-check will never fix your program, or worse, will only introduce additional bugs.

Instead, debugging requires FIXME

1. Verify that the symptom exists, and determine the correct behavior. That second part is probably *the* most important step of debugging: *you can't debug your code if you don't know what your code is supposed to do*. And I don't mean what your code is supposed to do overall; I mean what your code is supposed to do *at every single line*, and why that line is necessary. If you can't answer that question, this is the time to pause and review the step-by-step outline for your code - you do have a step-by-step outline, right?

2. (Optional) Create a minimal test case. A lot of bugs FIXME

3. Add some diagnostic code immediately before the symptom. FIXME

    FIXME This is creating a new "symptom" - you know what the diagnostic code should print, and you can now check that it is (or isn't) printing that.

4. Make sure your diagnostic code is correct and easy to understand. Never forget that *your diagnostic code is still code, and it can have bugs of its own*. You will never fix your bug(s) if your diagnostics is feeding you bad information. Similarly, if your program now crashes in your diagnostic code, you're not learning anything about where your code might be incorrect.

    Slightly related to making sure your diagnostic output is correct is making sure your diagnostic output is understandable. Don't just print out a variable; print out the variable and some text that tells you what variable it is and where it's printing from. There is nothing more draining than having to count the lines to figure out which value corresponds to which variable.

5. Identify which variable(s) are incorrect, and what its correct value(s) should be. If you don't know which variables are incorrect, see the note in Step 1.

6. Add the diagnostic code earlier in your program execution when you are sure your code is correct. FIXME

7. Keep adding diagnostic code until you have identified where the bug is. If the diagnostic output is correct for some part of your program, add diagnostic code to a later line. If the diagnostic output is *incorrect* for some part of your program, add diagnostic code to an earlier line. The goal here is to isolate a single line of code where your bug might be, before which your diagnostic code shows no symptoms, after which the diagnostic output is incorrect. If this line of code calls a function, you may have to continue debugging inside that function.

    There are two main ways this can go wrong:

    * There is more than one line of code between where your diagnostics are correct and where they are incorrect, and the code is complicated (eg. it has loops and conditions and all sorts of other things). There are two common causes of this:

        * It might be because *your diagnostics are not detailed enough*. Maybe you have only been printing the ID of an object and not all of its other member variables, and it is the member variables that are being checked. Maybe you have only been printing some variables but not others, and those other variables are being changed. In this case, the next step is obvious: add more diagnostic code until all the relevant variables are printed out, then go back to Step 5.

        * It might be because *you do not fully understand what your code should be doing*. In this case, the next step is *also* obvious, but much harder: think through what the correct behavior of your code should be, then try this step again.

        Note that these causes are not mutually exclusive - you might not be printing some variable, *and* you are also unsure how that variable should change in the code.

    * The line of code you identified was written by someone else. For example, it might be a call to a function given to you by your professor, a function from a library/framework, or a function that is part of the standard library of the programming language itself. In this case, you should:

        1. Re-read the documentation for that function to make sure you understand what its parameters and return values are, and that it does what you think it should do.

        2. Double-check that you are calling the function with the correct arguments, in the correct order. (FIXME something about creating a small test case for this)

        3. To be *absolutely* sure that you are calling the function correctly, try writing a small program that only calls that function, making sure to recreate your arguments from scratch. This may or may not be possible depending on your program and how complicated your arguments are.

        4. If you are absolutely sure that you are using the function correctly, it's not impossible that the function has a bug! If the function comes from a library or framework, this is the time to start Googling to see if other people have run into this issue.

        5. If searching online doesn't give any answers, this is the time to contact the author of the code, either by filing a bug report on Github (if the code is open source), or by emailing your professor. Since you may not get an answer for a while (or ever), it is time to start thinking about how you can write your code *without* using the buggy function.

8. FIXME check for typos, etc.

    FIXME realize that some variable is wrong because some *other* line of code is wrong

## A Simple Example

<!--?prettify linenums=true?-->
```python
def quadratic(a, b, c):
    """Solve the quadratic formula and return the first (positive) root."""
    root = sqrt((b * b) - (4 * a * c))
    numerator = -b + root
    x = numerator / 2 * a
    return x
```

## A More Complicated Example

FIXME how I overwrote my AVLTree in MemArch?

## Other Resources

* [Problem Solving Skills and Techniques](https://ryanstutorials.net/problem-solving-skills/) - Ryan Chadwick
* [How to Debug](https://blog.regehr.org/archives/199) - John Regehr
* [What does debugging a program look like?](https://jvns.ca/blog/2019/06/23/a-few-debugging-resources/) - Julia Evans
* [UChicago's debugging guide](https://uchicago-cs.github.io/debugging-guide/)
