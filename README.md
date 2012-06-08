Duck is a language designed to be used in [genetic programming] (http://www.gp-field-guide.org.uk/). It's an (extreme) variation on [Lee Spector and Maarten Keijzer's Push] (http://push.i3ci.hampshire.edu/), but has ended up much closer in spirit to the exotic concatenative language [XY] (http://www.nsl.com/k/xy/xy.htm).

It's built to be easily extensible for domain modeling, and also non-brittle for genetic programming search.  Any arbitrary string is a syntactically valid Duck program.

### Duck language features:

* it is stack-based, similar to [Forth](http://en.wikipedia.org/wiki/Forth_(programming_language)) and [Push](http://hampshire.edu/lspector/push3-description.html)
* it is strongly concatenative, like [XY](http://www.nsl.com/k/xy/xy.htm)
* uses [duck-typing](http://en.wikipedia.org/wiki/Duck_typing) to map arguments to function calls, not static type matching
* uses greedy [partial application](http://en.wikipedia.org/wiki/Partial_application) to produce closures when objects respond to messages
* integer and floating-point arithmetic and numerical comparisons
* boolean operators
* dynamic variable bindings
* ordered collections (Lists)
* special-purpose dynamic collections with varying behavior (Binders, Assemblers, Interpreters)
* higher-order functions (map, reduce, folds of various kinds)

### planned features (under [active development] (http://www.pivotaltracker.com/projects/448409))

* various modes of forking and recursion
* string handling
* ranges and enumerators
* lazy evaluation
* direct programmatic manipulation of script text and queue items
* inline (and emergent) class definitions

### Executing scripts

A Duck script is interpreted as a series of *tokens* separated by whitespace, which are removed from the script one at a time, from left to right. Each token is immediately interpreted as a self-contained *message*, which is sent to component objects in the Interpreter in a fixed order.

Queued messages are *staged* for execution, one at a time, in FIFO order. The bottom-most staged message is first permitted to examine all of the objects currently on the stack (in top-down order) in a search for a *receiver*. If the message finds a receiver, the receiving object is removed from the stack, and the original message is replaced in the queue with the *results* of its response to the message.

In the case of function messages with multiple arguments (such as `:+`), the response a receiver has to the message is a *partial application of the function*. The resulting curried function object (itself a "message") subsequently "wants" its next argument(s) as receivers.

If no receiver is found in the stack, then the Interpreter itself is checked to see whether it can act as a receiver.

After a queued item has gathered as many arguments as it can from the stack, it is then *presented* to each item on the stack, to determine whether it (in turn) responds to the messages on the stack. If it does respond, it is removed from the queue and the message in question is removed from the stack, and the result of its response to the message replaces it as the next queued item.

Only when no receiver is found (among the items on the stack, or the Interpreter itself), and the item is shown not to respond to any item in the stack, is a queued object is pushed *onto* the stack.

Note that in all cases, "argument-matching" occurs by checking whether an object *responds to a specified message call*, not a type check. The message being checked may not always be identical to the message looking for a match. A "pure" message such as `:+` might be recognized by an `Int`, `List`, or `Script` item; a curried result such as `λ(3+?)` (the result of `:3` responding to `:+`) is actually looking for items that respond to the message `:neg` (indicating they are numeric).

This network of responses, used to manage syntactic and semantic consistency, is handled by convention only.

For example, `"3 2 1 - +"` contains five tokens. The first three represent messages that are converted by the Interpreter into integers, and they are parsed, queued, staged and pushed onto the stack in the order they appear. The token `-` is not recognized as a literal, so it is used to create a Message object, which lacks (and therefore "wants") a *target* that responds to the message `-`. When the Message object is staged, it's first allowed to examine the stacked integers; the topmost `1` literal responds to `-`, so it is consumed by the staged Message, which is replaced with a Closure object representing the partial application `?-1`, which "wants" something that responds to the message `neg` (implying it's a number of some sort). The newly-staged Closure is allowed to check the stack for arguments, and it finds the `2` literal this time, which it consumes to produce a new Int literal `1` (2 minus 1). This "wants" nothing on the stack, and isn't "wanted" by the remaining `1` literal, so it is pushed to the top.

    running "3 2 1 - +":
    (stack) <<< (staged)  <<< (queue)  <<< (script)         (notes)
    []      <<<           <<<   []     <<<  "3 2 1 - +"
    []      <<<           <<<   [3]    <<<  "2 1 - +"
    []      <<<    3      <<<   []     <<<  "2 1 - +"
    [3]     <<<           <<<   []     <<<  "2 1 - +"
    [3]     <<<           <<<   [2]    <<<  "1 - +"
    [3]     <<<    2      <<<   []     <<<  "1 - +"
    [3,2]   <<<           <<<   []     <<<  "1 - +"
    [3,2]   <<<           <<<   [1]    <<<  "- +"
    [3,2]   <<<    1      <<<   []     <<<  "- +"
    [3,2,1] <<<           <<<   []     <<<  "- +"
    [3,2,1] <<<           <<<   [:-]   <<<  "+"
    [3,2,1] <<<    :-     <<<   []     <<<  "+"
    [3,2]   <<<    λ(?-1) <<<   []     <<<  "+"             'λ(?-1)' wants an object that responds to :neg
    [3]     <<<    2-1    <<<   []     <<<  "+"             ... like any Number would
    [3]     <<<    1      <<<   []     <<<  "+"
    [3,1]   <<<           <<<   []     <<<  "+"
    [3,1]   <<<           <<<   [:+]   <<<  ""
    [3,1]   <<<    :+     <<<   []     <<<  ""
    [3]     <<<    λ(?+1) <<<   []     <<<  ""              'λ(?+1)' wants an object that responds to :neg
    []      <<<    3+1    <<<   []     <<<  ""
    []      <<<    4      <<<   []     <<<  ""
    [4]     <<<           <<<   []     <<<  ""
    

Similarly, the `+` Message first consumes the top `1` literal to produce a Closure representing `?+1`, and then consumes the other `1` to produce a new literal with value `2`. That's the only thing on the stack when we're done running this script.

This seems a very convoluted way to approach simple arithmetic, doesn't it? But note that the script `"- 2 3 + 1"` represents the *exact same outcome*, reached by a different sequence of Messages and Closures.

One more, to demonstrate the flexibility:

    running "( 2 1 ) 3 + map":
    (stack)          <<< (staged)         <<< (queue) <<< (script)             (notes)
    []               <<<                  <<< []      <<<  "( 2 1 ) 3 + map"
    []               <<<                  <<< [:(]    <<<  "2 1 ) 3 + map"
    []               <<<    :(            <<< []      <<<  "2 1 ) 3 + map"     only a Pipe object responds to :(
    [:(]             <<<                  <<< []      <<<  "2 1 ) 3 + map"     ... so it ends up on the stack as a Message
    [:(]             <<<                  <<< [2]     <<<  "1 ) 3 + map"
    [:(]             <<<   2              <<< []      <<<  "1 ) 3 + map"
    [:(,2]           <<<                  <<< []      <<<  "1 ) 3 + map"
    [:(,2]           <<<                  <<< [1]     <<<  ") 3 + map"
    [:(,2]           <<<   1              <<< []      <<<  ") 3 + map"
    [:(,2,1]         <<<                  <<< []      <<<  ") 3 + map"
    [:(,2,1]         <<<                  <<< [λ(?)]  <<<  "3 + map"           the token ')' is interpreted as a Pipe object
    [:(,2,1]         <<<  λ(?)            <<< []      <<<  "3 + map"           Pipes want arguments that respond to :be
    [:(,2]           <<<  λ(1,?)          <<< []      <<<  "3 + map"           ... and everything does!
    [:(]             <<<  λ(2,1,?)        <<< []      <<<  "3 + map"           ... but the :( message transforms the Pipe
    []               <<<  (2,1)           <<< []      <<<  "3 + map"           ... into a List
    [(2,1)]          <<<                  <<< []      <<<  "3 + map"
    [(2,1)]          <<<                  <<< [3]     <<<  "+ map"
    [(2,1)]          <<<   3              <<< []      <<<  "+ map"
    [(2,1), 3]       <<<                  <<< []      <<<  "+ map"
    [(2,1), 3]       <<<                  <<< [:+]    <<<  "map"               Now the :+ message is recognized by both Numbers
    [(2,1), 3]       <<<  :+              <<< []      <<<  "map"               ... and Lists
    [(2,1)]          <<<  λ(?+3)          <<< []      <<<  "map"               ... but the 3 is on top. The resulting Closure 
    [(2,1), λ(?+3)]  <<<                  <<< []      <<<  "map"               ...wants an argument that responds to :neg. Nope!
    [(2,1), λ(?+3)]  <<<                  <<< [:map]  <<<  ""
    [(2,1), λ(?+3)]  <<<  :map            <<< []      <<<  ""                  The :map message is recognized by a List
    [λ(?+3)]         <<<  λ(map(2,1),?)   <<< []      <<<  ""                  ...and the result looks for ANYTHING
    []               <<<  map(2,1,λ(?+3)) <<< []      <<<  ""                  ...which is "handed" each List item in turn
    []               <<<  (2+3,1+3)       <<< []      <<<  ""                  ... (whether it wants it or not)
    []               <<<  (5,4)           <<< []      <<<  ""
    [(5,4)]          <<<                  <<< []      <<<  ""                  and we're done
        

### Duck-typing in Duck

Every Duck object (including the Interpreter itself, as it happens) maintains an explicit list of `recognized_messages` it can respond to. Every item responds to the `:be` and `know?` messages, only some respond to `:+`, very few respond to `:parse`, and (to date) none respond to `:foo`. The class hierarchy of stack items makes it relatively simple for domain modelers to include large chunks of functionality into specialized subclasses, but as a matter of convention *objects are provided no explicit information about other objects' class*.

#### Object interaction: needing, recognizing, grabbing and using

All Duck objects also maintain a list of their `needs`, in the form of messages they "wish" something would respond to. Messages and other Closures are typically the only items which populate this list (literal Int items don't really feel much pressure to perform tricks). Messages `need` items that respond to their own message, so for example a `:+` Message will have a `needs` list that includes `:+`; it "wants" to meet somebody who can fulfill its mission. Closures, which represent partially applied functions, often have more carefully-designed `needs`. The closure `λ(?+3)` for instance, which represents the function "some argument plus three", clearly wants a *number* of some sort but not a List or a Matrix or a Script, though it _doesn't care_ whether it ends up with an Int or a Decimal or a Rational. Thus, its `needs` list should specify a message "signature" that the argument will recognize *if it is the right class, and no other*. (As of this writing, `:neg` is a message that can differentiate Numbers from other items.)

As we've seen above in the examples, whenever a new item is pushed onto a Stack, it is buffered and "staged" in an internal queue, and goes through a very particular sequence of *negotiations* with the other items already on the Stack.

1. The Stack is searched *in top to bottom order* for an item that fills one of the staged item's `needs`.
    * If one is found, then it is removed from the Stack immediately, the staged item `grabs` it, and the result of that curried function application is staged in place of the original item (and we GOTO 1)
2. The Stack items are queried *in top to bottom order* for an item which `needs` the staged item.
    * If one is found, it is removed from the Stack immediately, it `grabs` the staged item, and the result of that curried function application is staged in place of the original item (and we GOTO 1)
3. The staged item (whatever it is by now) is pushed onto the top of the Stack.

A crucial process in Duck interpretation is **grabbing** arguments. Every Duck object is a function (though literals like Ints and Lists trivially return themselves). Any item (including a literal) can be made to `grab` any other: If the grabbed item is able to fulfill one of the grabber's `needs`, it is consumed by partial application (currying), and a new object results; if a grabbed item cannot be used, *both are still destroyed* but the result is an identical copy of the grabber.

So, as a reasonable convention: don't have items going around grabbing stuff somebody else might need.

#### Unusual `grab` results

Some messages, like `:zap`, destroy the receiver. The "result" of a `:zap` Message grabbing a target item is *nothing at all* (`nil` in the Ruby implementation). A Stack will handle that outcome correctly.

Other messages, like `:trunc` and `:shatter`, produce multiple items. These will be *unshifted* onto the bottom of the Stack's buffer, in the order returned. So for example if a List `(1, 2, F)` is `:shatter`ed, the resulting Int, Int and Bool items will be re-buffered immediately *in that order*, and placed before anything else that might still be buffered and waiting to be pushed onto that Stack. 

If it happens that a `:+` is lurking on the stack somewhere, more stuff will happen soon. So be it.

#### Type-casting

Occasionally partial function application isn't enough to fully determine the class of a result. For example, both Decimal and Int items respond to `:+`. In the case of the Decimal, the Closure `λ(? + 1.23)` will clearly "always" produce another Decimal, whether it encounters an Int or a Decimal as its argument.

But the Closure `λ(? + 2)` might *still* `grab` either a Decimal (to produce a Decimal result), or an Int to produce an Int result.

I feel type-casting design decisions are better left as a matter for domain modelers. In the core Duck class definitions, I've tried to avoid including any but the most obvious type-casting events: in the outcome of common arithmetic operations, or the in the consistency of results from Message/String/Script and List/Stack manipulations.

The Duck classes are provided as *self-contained abstractions*. As a matter of convention, "slop" at the edges of these strict categories—such as might happen if one type-cast a Bool to act like an Int—should be avoided. Instead, focus on a careful choice of *message responses*, and of explicit type-conversion messages like `:to_bool`, `:to_int` and `:to_decimal` already included.

### Core Duck classes (rapidly changing!)

- Item
    - Bool
    - Closure
        - Collector
        - Message
        - Pipe
    - Error
    - List
        - Assembler
        - Binder
        - Interpreter
    - Number
        - Int
        - Decimal
    - Script
    - Variable

### The "result" of running a Duck script

`DuckInterpreter#run` returns the entire Interpreter object, with all its contents. Determining which stack items, if any, to examine in order to evaluate how well a Duck script satisfies one's goal is a matter of domain modeling---not programming.

I suspect sometime soon I'll add some convenience methods to interrogate the stack.

### Examples

See the directory `/examples` for scripts that exercise some of the quirks of the Duck language