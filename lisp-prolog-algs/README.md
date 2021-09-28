## Installation using Docker

SWI-Prolog is a versatile implementation of the Prolog language. If you type `run -it swipl`, it should automatically pull the latest image

```bash
me$ docker run -it swipl
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
me$ brew install gnu-prolog
```
and eventually
```
me$ sudo chown -R $(whoami) /usr/local/share/man/man5 /usr/local/share/man/man8
```
then go inside the folder where you defined your scripts and type
```
me$ gprolog
GNU Prolog 1.4.5 (64 bits)
Compiled Aug 20 2018, 15:27:00 with clang
By Daniel Diaz
Copyright (C) 1999-2018 Daniel Diaz
| ?- ['./coolProblems/schedule.pl'].
compiling /Users/alexdarie/GitHub/f/schedule.pl for byte code...
/Users/alexdarie/GitHub/f/schedule.pl compiled, 23 lines read - 1928 bytes written, 4 ms

(1 ms) yes
| ?-
```

## Compile your Prolog applications

```
?- ['/Users/alexdarie/GitHub/f/laboratory1.14.pl'].
true.
```
or
```
?- consult('/Users/alexdarie/GitHub/f/laboratory1.14.pl').
/Users/alexdarie/GitHub/f/schedule.pl compiled, 23 lines read - 1928 bytes written, 8 ms

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

## Building blocks
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

## An example

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

