---
layout: main
title: Javascript named functions versus function variables
tags:
  - javascript
  - development
---
# Javascript function forms

For a lot of my relatively inexperienced javascript life, I've held miconceptions about the different ways to create functions.  I realize there are already many good articles on this topic, but I'm going to blog about it anyway...most likely it's that I'm in dire need of a way to pass the time until my new pool cue arrives in the mail.

I used to think that the following two lines of code were exactly the same in javascript:

{% highlight js+smarty linenos %}
function add(a, b) { return a + b; }
add = function (a, b) { return a + b; }
{% endhighlight %}

and while the difference between the two may be irrelevant to the CJP (Common-man Javascript Programmer), I know that the type of person that reads 1337 posts like these is _no_ CJP.

Before diving into code, it is important to note that 'function' is a native type in javascript. Just as 'number' and 'string' are types, so is 'function'. Having said this, a function can have properties. For example, a function object can have a name property and a length property.

Okay, let's look at some of code:

{% highlight js+smarty linenos %}
function say_hello() { alert('hello'); }

console.log(say_hello.name); // logs 'say_hello'
console.log(say_hello.length); //logs 0
{% endhighlight %}

Creating a function this way actually creates attributes for the say_hello variable called "name" and "length" (sidenote: the length attribute is actually the number of arguments called for by the function signature).  Now, let's look at how variable assignment works:

{% highlight js+smarty linenos %}
var say_hello = function() { alert('hello'); }

console.log(say_hello.name); //logs undefined
console.log(say_hello.length); //logs undefined
{% endhighlight %}

Did you notice the function doesn't have a name? That may not seem like a big deal, because you may think (as I often do) that say_hello(1, 2) will do the same thing when called regardless of how the function was formed.

But there are cases where naming a function one way over the other can actually cause you problems. What if you passed say_hello to a new scope?  And what if say_hello, rather than being the simple function that is, had a recursive call inside of it?  Let's look at a very simple, contrived example that a situation in which we lose functionality one way vs the other.:

{% highlight js+smarty linenos %}
  var countDownToZero = function(number) {
      if (number <= 0) return "You made it to zero";
      return countDownToZero(number-1);
  };

  // in a real situation, you'd probably have a lot of
  // code here, which is why you'd obliterate your reference

  var temp = countDownToZero;
  countDownToZero = undefined;

  // the function we care about ended up in a var called
  // temp instead of the original variable
  console.log(temp(20)); // TypeError: undefined is not a function
{% endhighlight %}

Now have a look at what happens when we name the function:

{% highlight js+smarty linenos %}
  var countDownToZero = function localName (number) {
      if (number <= 0) return "You made it to zero";
      return localName(number-1);
  };

  // in a real situation, you'd probably have a lot of
  // code here, which is why you'd obliterate your reference

  var temp = countDownToZero;
  countDownToZero = undefined;
  localName = undefined; // sanity check, unset localName as well

  // again, the function we care about ended up in
  // a var called temp instead of the original variable
  console.log(temp(20)); // "You made it to zero"
{% endhighlight %}

Here, you can see how naming the function gives you some safety. By naming it, you have access to the function inside the function's scope. This is very useful if you are going to pass the function outside of it's original scope and still want to call it recursively.

All that to say, naming functions through assignment is different from naming them after the function keyword.

**Credits** Actually, I don't remember where exactly I learned these things, so I'll just give credit to [Mr. Douglas Crockford](http://www.crockford.com/), the source of most all vanilla JS knowledge.
