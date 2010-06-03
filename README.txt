St. Louis Code Camp – Lua Talk Notes and Source Code

Copyright 2006 Kyle Cordes

At the St. Louis Code Camp on May 6 2006, I gave a talk that was somewhat poorly titled “Painless Scripting with Lua”.  The topic more mostly about the overall use of scripting as a configuration and extension mechanism, with Lua as an example language.

The talk had no slides, only code and a 1-page handful with some notes.

Alternate Hard and Soft Layers

This is a Pattern from the C2 Wiki: http://c2.com/cgi/wiki?AlternateHardAndSoftLayers

In a system built with “hard” code (not in the sense of difficulty, rather in the sense of statically typed, statically compiled languages), organize that code in to layers, and between those hard layers, put “soft” layers in the form of scripts written in a dynamic, runtime modifying languages. AHSL is closely related to the idea of scriptable applications, with the additional notion of layering, rather than ad hoc extension.

“hard layer” languages:

C
C#
C++
Delphi (*)
Java
“soft layer” languages:

bash
BeanShell
Emacs Lisp
Groovy
JavaScript
Lua (*)
Python
Ruby
Tcl
This talks’ examples are in Delphi (hard) and Lua (soft). Delphi is a mostly static language, essentially similar in certain ways to C, C++, and Java, but with a Pascalish syntax.

Key Points about Lua:

* An easily learned, dynamic programming language
* Small, highly embeddable (~ 100 KB)
* Multi-platform (highly portable C code)
* Well suited to “Alternate Hard and Soft Layers”
* Free and open source
* Stable and mature
* Safe and Sandboxed
* Actively developed and maintained

Recommendation on Scripting:

* If you’re building a Java system, the most appealing scripting language is JavaScript, because it will be “in the box” in Java 6.
* If you’re building a .NET system, use a .NET-centric scripting mechanism
* If you’re building a Win32 system with a lot of COM in it, use the Windows Scripting Host and expose your system’s feature to the scripts via COM.
* If you’re building a system with a “hard” (very static) language, and want to keep your options open for cross-platform development / deployment, than Lua is an excellent choice, it is small, fast, proven, COM-free, and cross-platform.


http://kylecordes.com


