---
layout: main
title: Javascript constructor functions
---
# Javascript constructor functions

My goal isn't to teach about Javascript Prototypes, that's been [done](http://sporto.github.io/blog/2013/02/22/a-plain-english-guide-to-javascript-prototypes/).  I want to give my opinion on how to use them.

If you don't know what they are...I'll do 2 things for us:

1. Refer you to [this link](http://sporto.github.io/blog/2013/02/22/a-plain-english-guide-to-javascript-prototypes/)
    * This is the best article I've seen on it as of this writing
2. I give you a __brief__ synopsis of that link in case the URL ever changes:

###Recap
You inherit from other objects by doing this:

{% highlight js+smarty linenos %}
var Student = {school: "The Institution"};
var greg = {age: 34};
greg.__proto__ = Student;

greg.school == "The Institution";
{% endhighlight %}

Voila, you have created an object `greg` whose prototype chain includes an object `Student` such that any reference to attributes not assigned directly to greg (eg, `school`) will be searched for in `Students` because it's part of `greg`s prototype chain.

There are other, better ways to do this (see [Object.create](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/create)) since `__proto__` isn't supported everywhere, but `__proto__` gives you the gist.

Furthermore, there is another way to create objects with a prototype chain that includes another object.  It's called the constructor function.  In essence, you use the `new` as such:

{% highlight js+smarty linenos %}
var Student = function(name, age) {
  this.name = name;
  this.age = age;
  this.greet = function() { return "Hello " + this.name + ", hope you are well"; };
}

greg = new Student("Greg", 29);
greg.greet() == "Hello Greg, hope you are well";
{% endhighlight %}


By using new, everything that had `this` before it becomes a member of the new object (`greg` in this case)

Now, there is actually a different way to effectively accomplish the same thing, but let's move on to the next subtitle of this article, so that I can start making some of these my own thoughts.

###My point

Have a look at these snippets:

{% highlight js+smarty linenos %}
var Student = function(name, age) {
  this.name = name;
  this.age = age;
  this.greet = function() { return "Hello " + this.name + ", hope you are well" };
}
{% endhighlight %}


and

{% highlight js+smarty linenos %}
var Student = function(name, age) {
  this.name = name;
  this.age = age;
}
Student.prototype.greet = function() { return "Hello " + this.name + ", hope you are well"; };
{% endhighlight %}

For both of them, this still holds true:

{% highlight js+smarty linenos %}
var greg = new Student("Greg", 29);
greg.greet() == "Hello Greg, hope you are well";  // evaluates to true
{% endhighlight %}


So, here's where you can learn what `prototype` is if you don't already know.
In the second snippet, I'm using the `prototype` property of constructor functions to effectively add the rest of the `this` statements (in this case, just `this.greet`).
That's pretty much all `prototype` does.  It's a place to put things that you want a constructor functions children (so to speak) to have when they are created.  And I realize that "child" is a comvoluted term in computing, so humor me here.

Here's where I'm give my opinion.  `prototype` should __always__ be used for non-configurable attributes.  In the Student example, it's handy to be able to pass ("Greg", 29) to the function to configure the name and age attributes because name and age will change for every object, but the greet method can and should be shared across all methods given that it doesn't need any instance-specific configuration.  Therefore, I contend that greet should always be written with Student.prototype (as in the 2nd snippet) instead of this.greet (as in the 1st snippet).  My reasons are 2:

1. This pattern makes code easier to read
    * If you're reading through a new JS file, and there is a constructor function, it's easier to grasp what's going on in the code if you have all of the configurable code in the actual constructor and then all member functions listed down below in .prototype.function_name calls.
2. It prevents polluting the global namespace in the case that someone accidentally calls the constructor function without the `new` keyword.
    * If you were to call Student() without the `new` keyword before it, you would add age and name to the window object.  This is a use-case that hopefully will never happen, but in the case that someone doesn't know what the hell they're doing (it happens), then at least `.greet` won't get added to the global namespace as well.

My point is simple, and it's probably not even worth mentioning, but I try to be intentional when I code in every way, so I did my best to come up with a case for how to form constructor functions.  Let me know what you think.