---
layout: main
title: Javascript's Function.prototype
tags:
  - javascript
  - development
---
# <center>Javascript's `.prototype`</center>
__What is `.prototype` in javascript?__ There are a million articles on this, but I have a way I think of it that you may like:
#### <center>A kid.  And the kid's backpack.  Where the kid can create magical duplicates of the backpack.</center>
Let's ease into this with a fairly irrelevant bit of code:
{% highlight js+smarty linenos %}
var kid = {};
kid.glasses = true;
kid.height = 120;
kid.funny = "sometimes";
kid.backpack = {books: 3, pencils: 4};
{% endhighlight %}

So, we have a kid with glasses, that's just under 4' tall (120cm ~ 4') and has a backpack with some stuff in it.

Now, in my analogy, the **`kid`** represents a **`function`** in javascript, and the **`backpack`** represents **`.prototype`**. I didn't setup that last piece of code with a function because I was just easing you into my analogy with the simplest JS possible.  Keep reading and you'll see how kids (ie, functions) have magical backpacks that can be duplicated.

***There are always rules to magic*** - So the kid can duplicate the backpack and give the duplicate away, but magic always comes with a price (or rules of engagement, in this case):

* The duplicates start out with the exact same things as the original.
  * Seriously, the EXACT same things
    * I mean, if you break a pencil in the original backpack, you break that same pencil in all the duplicates, because the pencil in the duplicate is actually the same as the pencil in the original
      * But vice-versa isn't true... you can't break a pencil in a duplicate and expect it to be broken in the original...just doesn't work that way.

Sound like something magical from a Dr. Who plot, doesn't it?  That's because javascript is magical.

Now, in the code above, I chose an object literal (the **`{}`**'s) to represent the kid.  That makes sense, kids are nouns in the real world, so we can use objects to represent them in javascript.

But there's more than one type of object.  Functions are objects, too, right?

{% highlight js+smarty linenos %}
var kid = function () {};
kid.glasses = true;
kid.height = 120;
kid.funny = "sometimes";
kid.backpack = {books: 3, pencils: 4};
{% endhighlight %}

So, we used a **`function`** object to attach all of the kids stuff to.  You can still access **`kid.height`**, but kid is actually a function object in and of itself.  So, how do we go about duplicating the backpack (ie, the function's **`prototype`**) and magically passing it around like I mentioned above?

Lookit:
{% highlight js+smarty linenos %}
var kid = function () {};
kid.glasses = true;
kid.height = 120;
kid.funny = "sometimes";
kid.prototype = {books: 3, pencils: 4};

var duplicated_packpack = new kid();
console.log(duplicated_packpack.books); // 3

kid.prototype.books = 100;
console.log(duplicated_packpack.books); // 100
{% endhighlight %}

WHAT THE HELL?  Hey, don't use words like that around kids.  But also, let me explain what's going on here...

The **`new`** keyword in javascript is something that you can put before **`functions`** (and only functions) to create a new object that **`inherits`** from the functions **`prototype`** property.

**Let me re-play this in slow motion for you:**

If you create a function, you can also create an object from it if you use the **`new`** keyword.
{% highlight js+smarty linenos %}
var func = function() {}
var obj = new func();
{% endhighlight %}

And the object (**`obj`** in this case) magically inherits everything from the function's prototype (**`func.prototype`** in this case):

{% highlight js+smarty linenos %}
func.prototype.color = 'yellow';
console.log(obj.color); // yellow
{% endhighlight %}

So, why did I choose a kid and a backpack to represent this relationship?

Well, if you consider the last example I just typed out (with **`func`** and **`obj`**), **`func`** isn't the thing being duplicated.  That is, the kid isn't being duplicated.  You can assign things to **`func`** that don't get assigned to **`obj`**.  For example: 

{% highlight js+smarty linenos %}
func.color = 'blue';
console.log(obj.color); // yellow
{% endhighlight %}

**`obj`** ONLY inherits the things that are in **`func.prorotype`**.  **`prototype`** is like a backpack that's attached to **`func`** and it's the only part of func that gets duplicated, kind of like how a kid has a backpack, and the backpack gets duplicated, but the kid doesn't.

###A Caveat to the magical backpack
Back to our analogy of kids and backpacks...the astute reader will notice that I said duplicate backpacks (ie, objects that inherit from the function's prototype), START OUT WITH the same things as the original backpack.  Here's how they can change:

{% highlight js+smarty linenos %}
var func = function() {}
var obj = new func();

func.prototype.color = 'yellow';
console.log(obj.color); // yellow

obj.color = 'blue';
console.log(obj.color); // blue
console.log(func.prototype.color); // yellow
{% endhighlight %}

If you actually overwrite a property that is in the original backpack, then it no longer inherits from the original.  And in fact, you didn't overwrite the property from the original backpack, you just assigned a property to the new backpack and broke the link to the old backpack for that property.

The way to think about this is that you can't reach into one of the duplicate backpacks and change something there and expect it to change things in the original backpack.  That wouldn't be fair to the kid, after all.  

####BUT, I also just lied
There is a case where you can change things in the original backpack from a duplicate backpack...here's how:
{% highlight js+smarty linenos %}
var func = function() {}
var obj = new func();

func.prototype.color = {value: "yellow"};
console.log(obj.color.value); // yellow

obj.color.value = 'blue';
console.log(obj.color); // blue
console.log(func.prototype.color); // blue
{% endhighlight %}

We're inheriting the **`color`** object from func's prototype (backpack if you're following the analogy).  Since we're not trying to overwrite the entire **`color`** property but rather just **`color.value`**, javascript keeps our tie to **`color`** and actually updates **`func.prototype.color.value`**.  Now, if we had overridden **`obj.color`** entireley, it would have cut our tie to **`func.prototype.color`** entirely, and we would have created our own property for our backpack rather than be connected to the original.

This is because javascript always passes objects by reference, and not by value.  If that statement doesn't make sense, google it to find out more.

So functions are like kids, and their prototype property is like a magical duplicateable backpack...hope that makes perfect sense to you now :)


