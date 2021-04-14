## Installation using Docker

SWI-Prolog is a versatile implementation of the Prolog language. Its robust multi-threading, extended data types, unbounded arithmetic and Unicode representation of text allow for natural representation of documents (e.g., XML, JSON, RDF) and exchange of data with other programming paradigms.

If you type run -it swipl it will automatically pull the latest image

```bash
alexdarie$ docker run -it swipl
Unable to find image 'swipl:latest' locally
latest: Pulling from library/swipl
f17d81b4b692: Pull complete
cdf347419c03: Pull complete
3e693bb0e94a: Pull complete
Digest: sha256:...
Status: Downloaded newer image for swipl:latest
Welcome to SWI-Prolog (threaded, 64 bits, version 7.7.19)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit http://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

?-
```

otherwise, if it fails you can run

```
docker pull swipl
```

## Install on MacOS

```
alexdarie$ brew install gnu-prolog
```
and eventually
```
alexdarie$ sudo chown -R $(whoami) /usr/local/share/man/man5 /usr/local/share/man/man8
```
then go inside the folder where you defined your scripts and type
```
alexdarie$ gprolog
GNU Prolog 1.4.5 (64 bits)
Compiled Aug 20 2018, 15:27:00 with clang
By Daniel Diaz
Copyright (C) 1999-2018 Daniel Diaz
| ?- ['./coolProblems/schedule.pl'].
compiling /Users/alexdarie/GitHub/Logic-and-functional-programming/coolProblems/schedule.pl for byte code...
/Users/alexdarie/GitHub/Logic-and-functional-programming/coolProblems/schedule.pl compiled, 23 lines read - 1928 bytes written, 4 ms

(1 ms) yes
| ?-
```

## Compile your Prolog applications

```
?- ['/Users/alexdarie/GitHub/Logic-and-functional-programming/laboratory1.14.pl'].
true.
```
or
```
?- consult('/Users/alexdarie/GitHub/Logic-and-functional-programming/laboratory1.14.pl').
/Users/alexdarie/GitHub/Logic-and-functional-programming/coolProblems/schedule.pl compiled, 23 lines read - 1928 bytes written, 8 ms

(1 ms) yes
```
then
```
?- set_equals([1,3,4], [1,4,2], Result).
Result = 0 .

?- set_equals([1,3,4], [1,4,3], Result).
Result = 1 .
```

## How to exit?

```
?- halt.
```

## Prolog history

The Prolog term comes from 'Programming with Logic'. It's very different from other programming languages because it is declarative (not procedural), it uses recursion (there is no for or while loops), it uses relations (no functions), and because of the unification. First Prolog interpreter was made by Alain Colmerauer and Philippe Roussel back in 72'. Prolog grows in popularity especially in Japan and Europe between 80' and 90'. Prolog was used to program natural language interface in International Space Station by NASA. 

### Basic ideea
Prolog programs are often smaller, and smallness encourages well written code, hence easier to maintain. Prolog's basic ideea is that you describe the situation of interest, ask a question and it will logically deduce new facts about the situation you described and give us its deductions back as answers.

### Consequences
In order to use it you have to think declaratively, not procedurally, so you'll have to change your mindset.

### Building blocks
Atoms, numbers and variables are building blocks for complex terms. Complex terms are built out of a functor directly followed by a sequence of arguments: arguments are put in round brackets, separated by commas and the functor must be an atom. 

Below, woman is a functor followed by a list of arguments.
```
women(...)
```

Atoms are a sequence of characters starting with a lowercase letter, or an arbitrary sequence of characters enclosed in single quotes ('Vincent', 'Five dollar shake' i.e.). Also a sequence of special characters represents an atom.

There may be terms like: 
```
playsAirGuitar(jody).
loves (vincent, mia). 
```
or more complex ones: 
```
hide(X, father(father(father(butch)))). 
```

## Let's get through an example

Compile the schedule script.
```
?- ['/Users/alexdarie/GitHub/Logic-and-functional-programming/coolProblems/schedule.pl'].
true.
```

Then, let's query it.
```
?- classInformation(Day, Class, medium).
Day = monday,
Class = programming 
```
then hit ';'
```
Day = tuesday,
Class = english 
```
then hit ';'
```
Day = wednesday,
Class = programming 
```
then hit ';'
```
Day = thursday,
Class = circuits 
```
then hit ';'
```
false.
```

