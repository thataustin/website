# Javascript function forms

For a lot of my relatively inexperienced javascript life, I've had a lot of miconceptions about the different ways to create functions.  This article is quite possible useless since there are so many good articles on the topic, but I'm going to blog about it anyway...possibly because I'm in dire need of a way to pass the time until my new pool cue arrives in the mail.  

First off, I don't remember where exactly I learned these things, so I'll just give credit to [Mr. Douglas Crockford](http://www.crockford.com/), the source of most all vanilla JS knowledge.

I used to think that the following two lines of code were exactly the same in javascript:

{% highlight javascript linenos %}
function add(a, b) { return a + b; }
add = function (a, b) { return a + b; }
{% endhighlight %}

and while it's typically true enough for the CJP (common-man javascript programmer), I realized a while later that it isn't 100% accurate.

First, it is important to note that ‘function’ is a native type in javascript. Just as ‘number’ and ‘string’ are types, so is ‘function’. Having said this, a function can have many properties. For example, a function object can have a name property and a length property. Let’s have look at an example:

{% highlight javascript linenos %}
function say_hello() { alert(‘hello’); }

console.log(say_hello.name); // logs ‘say_hello’
console.log(say_hello.length); //logs 0
{% endhighlight %}

So creating a function this way actually creates an attribute on the say_hello variable called 'name' (sidenote: the length attribute is actually the number of arguments called for by the function signature).  Now I'll show you a difference between the two function forms:

{% highlight javascript linenos %}
var say_hello = function() { alert(‘hello’); }

console.log(say_hello.name); //logs ‘anonymous’
console.log(say_hello.length); //logs 0
{% endhighlight %}

Did you notice the function doesn’t have a name? That may not seem like a big deal, because you may think (as I often do) that say_hello(1, 2) functions the same in either case. And in this case it does.

But there are cases where naming a function one way over the other can actually cause you problems. What if you passed say_hello to a new scope?  And what if say_hello, rather than being the simple function that is, had a recursive call inside of it?  Let's look at a very simple example that almost covers the case I just described:

{% highlight javascript linenos %}
  var countDownToZero = function(number) {
      if (number <= 0) return "You made it to zero";
      return countDownToZero(number-1);
  };

  // ... some stuff happens in this terrible code ...

  var temp = countDownToZero;
  countDownToZero = undefined;

  // ... the function we care about ended up in a var called temp instead of a var with a rational name
  console.log(temp(20)); // TypeError: undefined is not a function
{% endhighlight %}

So, this a totally contrived example, but since you're reading this, keep going just a little further:

{% highlight javascript linenos %}
  var countDownToZero = function localName (number) {
      if (number <= 0) return "You made it to zero";
      return localName(number-1);
  };

  // ... again, some stuff happens in this terrible code ...

  var temp = countDownToZero;
  countDownToZero = undefined;

  // ... and again, the function we care about ended up in a var called temp instead of a var with a rational name
  console.log(temp(20)); // "You made it to zero"
{% endhighlight %}

Here, you can see how combining the two methods gives you something interesting. By naming the function itself, you have access to the function inside the function’s scope. This is very useful if you are going to pass the function outside of it’s original scope and still want to call it recursively.

So, all that to say, naming functions through assignment is different from naming them after the function keyword.

For completeness sake, I want to should probably mention the other forms of creating the function object.
First, there is the formal Function object. You should probably never use this, but here’s an example anyway:

{% highlight javascript linenos %}
var say_hello = new Function(‘string1′, ‘string2′, ‘alert("Hello, I noticed you said: " + string1 + string2);’);
say_hello(‘taco ‘, ‘sauce’); // alerts ‘Hello, I noticed you said: taco sauce’
{% endhighlight %}

Finally, there is the single-execution function, or as I like to call it, the “Fire in the hole!” function. To note, I’ve never called it that out-loud.

{% highlight javascript linenos %}
(function (){ alert(‘hello’); })(); // alerts ‘hello’
{% endhighlight %}

The cool thing about that form is that you create, run and basically destroy that function all at once. You don’t have to worry about naming it poorly, because you don’t name it. Not much good for recursion, but that’s like saying it’s not much good for recursion – go back to the beginning of this sentence if that didn’t make sense.

Okay, so we have our 4 different ways of declaring functions. I hope you’ve learned something about how to create a function in javascript. Now, if you want to know how to create a useful function, you should learn about “this”. The word “this” is a tricky, tricky thing in javascript, and not something you want to screw up.