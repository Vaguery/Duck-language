Duck is a language designed to be used in [genetic programming] (http://www.gp-field-guide.org.uk/). It's an (extreme) variation on [Lee Spector and Maarten Keijzer's Push] (http://push.i3ci.hampshire.edu/), but has ended up much closer in spirit to the exotic concatenative language [XY] (http://www.nsl.com/k/xy/xy.htm).

It's built to be easily extensible for domain modeling, and also non-brittle for genetic programming search.  Any arbitrary string is a syntactically valid Duck program.

### Duck language features:

* integer and floating-point arithmetic and numerical comparisons
* boolean operators
* stack-based, similar to Forth and Push
* concatenative, like XY
* passive collection structures (lists), and also more dynamic self-organizing collections (assemblers)
* map/reduce and other list-based functional operations
* uses _duck-typing_ to map arguments to function calls, not static type matching
* uses [greedy] partial application to produce closures when objects respond to messages

### planned features (under [active development] (http://www.pivotaltracker.com/projects/448409))

* local variable bindings
* various modes of forking and recursion
* string handling
* higher-order functions
* ranges and enumerators
* lazy evaluation
* direct programmatic manipulation of script text and queue items
* inline (and emergent) class definitions

### Executing scripts

A Duck script is interpreted as a series of *words* separated by whitespace, which are removed from the script one at a time from left to right. Each word is parsed to create a single *token* representing a Duck function call, and is pushed onto a processing queue.

Queued tokens are *staged* for execution, one at a time, in FIFO order. Each staged token is first permitted to examine and remove the items currently on the stack (in top-down order) for use as its *missing arguments*; if it can use one of the stack items, that is removed from the stack and the *curried* result of the pending item "using" the stack item is calculated and replaces it in the staging area.

Once the queued item has gathered as many arguments as it can from the stack, it is then *presented* to each item on the stack, to be used as *that item's* next missing argument. If it can be used, it is removed from the queue and the *curried* result of applying the stack item to the waiting item is shifted onto the bottom of the queue.

Note that in both cases, argument-matching occurs by checking whether an object *responds to a specified message call*, not a type check.

If the staged object is not consumed as an argument by another item on the stack, then it *modifies* the stack (typically by pushing itself to the top), and execution continues with the next token of the script.

For example, `"3 2 1 - +"` contains five tokens. The first three represent integers, and they are parsed, queued, staged and pushed onto the stack in the order they appear. The token `-` is not recognized as a literal, so it is used to create a Message object, which lacks (and therefore "wants") a *target* that responds to the message `-`. When the Message object is staged, it's first allowed to examine the stacked integers; the topmost `1` literal responds to `-`, so it is consumed by the staged Message, which is replaced with a Closure object representing the partial application `?-1`, which "wants" something that responds to the message `neg` (implying it's a number of some sort). The newly-staged Closure is allowed to check the stack for arguments, and it finds the `2` literal this time, which it consumes to produce a new Int literal `1` (2 minus 1). This "wants" nothing on the stack, and isn't "wanted" by the remaining `1` literal, so it is pushed to the top.

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
    []               <<<    :(            <<< []      <<<  "2 1 ) 3 + map"     only a Connector object responds to :(
    [:(]             <<<                  <<< []      <<<  "2 1 ) 3 + map"     ... so it ends up on the stack as a Message
    [:(]             <<<                  <<< [2]     <<<  "1 ) 3 + map"
    [:(]             <<<   2              <<< []      <<<  "1 ) 3 + map"
    [:(,2]           <<<                  <<< []      <<<  "1 ) 3 + map"
    [:(,2]           <<<                  <<< [1]     <<<  ") 3 + map"
    [:(,2]           <<<   1              <<< []      <<<  ") 3 + map"
    [:(,2,1]         <<<                  <<< []      <<<  ") 3 + map"
    [:(,2,1]         <<<                  <<< [λ(?)]  <<<  "3 + map"           the token ')' is interpreted as a Connector object
    [:(,2,1]         <<<  λ(?)            <<< []      <<<  "3 + map"           Connectors want arguments that respond to :be
    [:(,2]           <<<  λ(1,?)          <<< []      <<<  "3 + map"           ... and everything does!
    [:(]             <<<  λ(2,1,?)        <<< []      <<<  "3 + map"           ... but the :( message transforms the Connector
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
        

### The "result" of running a Duck script

`DuckInterpreter#run` returns the entire Interpreter object, with all its contents. Determining which stack items, if any, to examine in order to evaluate how well a Duck script satisfies one's goal is a matter of domain modeling---not programming.

I suspect sometime soon I'll add some convenience methods to interrogate the stack.

### Examples

See the directory `/examples` for scripts that exercise some of the quirks of the Duck language