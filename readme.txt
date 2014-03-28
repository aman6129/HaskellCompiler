-- Mohammad Anees
-- UIN: 821009771
-- Got a lot of help from Piazza, mainly the SI and TA
--Readme.txt

----How to compile and run
	if on linux 
		ghc --make Main.hs -o mini
		./mini -v mytestfile.mini
	if on windows
		ghci Main.hs
		readRun True|False "testfile.mini"

----Implementation of Task 1, division

 	The division function was easy to add becuase most of the work behind allowing the compiler to actually parse it had been done for us
 	the only thing that I had to do was add the Division operator (OpDiv) into the OP data type in MiniLangSyntax.hs. And to make sure that it was defined clearly in all the helper functions such as stringtoOp, and show, and primEval. Last thing left to do was to make sure the parser actually knew what to do when it came across the "/" symbol, which was done by adding +++ symbol "/" into termX function in MiniLangParser.hs.

----Implementation of Task 2, comparisons

	This was a bit more dificult but the general principle was the same as Task 1. Firstly all the comparison operators had to be defined in the OP data type, and all of its helper functions (stringtoOP, show, primEval) etc. The part that was a little bit more dificult was to properly parse the comparison statements as to avoid the parser parsing longer comparison statments such as (x > 1 == x <= 1) wrong. This was done by introducing a new helper function comparison, that parses the comparison operators in the correct order.

----Implementation of Task 3, Block statments

	Block statments are like programs, in that they both have "many stmt" but block statments don't end with an expr. Implementation was easy as it followed a similar design principle to program parser. Block had to be added as a "Stmt" in the MiniLangSyntax.hs file, and defined for the show and exec functions. The way that block statements are evaluated is that all the statments inside the block are put into a list that is then executed individualy using higher order function foldl.

----Implementation of Task 4, While looooop

	While loops statment definition was very similar to that of Block. Main difference being that instead of looking for a bracket symbol, we were looking for a "while" followed by an "expr" in parenthesis. The statments inside of the while loop are then executed until the expr sent becomes false. Achieving this was the hard part, as it required a bit of recursive thinking. The way I ended up implementing it was by first checking if our expr remained true, and if so then executing the statments in the loop, and then calling the While loop again recursively. When the expr finally becomes false, the function will return the environment instead of executing the statement again.

----Implementation of Task 5, Var decleration and scoping

	I was only able to implement the var decleration. This was relatively easy because it all it meant was creating two new stmts that expected a symbol "var" before any new declerations. One stmt handles just variable decleration, while the other handles variable decleration plus a value assignment. Both use the type "Assignment2" to check for proper instantiation and to check that it hasn't been declared twice. All variables declared without a value get a value of 0

	Sadly I was unable to design my compiler to handle scoping. I did however implement the enterBlock, and exitBlock functions. But the entire concept of how to use them seemed pretty hard to grasp for me, even with the help from Piazza and the SI.

----Test file : myTest_var.mini
	
	I designed this to make sure that both styles of variable declerations where handled by my parser ( var x; var y = 10;) and also added a line that make sures that you can't redeclare the same variable twice. I also added a regular assignment on a ready declared variable to make sure that worked too. As well as a , currently commented out, line that trys to assign to a variable that was not declared. Both of the wrong var declerations cause the expected error to occur.

----Test file : myTest_while.mini

	I designed the test file to check if nested While loops would work, and if the changing the value of the variable in one of the expressions worked as expected. Although it wasn't explicitly stated, I wanted to make sure that nested while loops worked

----Test file : myTest_block.mini
	
	Designed the test file to make sure that both if else statments and regular blocks worked in my program. While loop blocks where tested in myTest_while.mini files

----Test file : myTest_comparisons.mini
	
	Designed to make sure that the comparisons worked, including multiple assignments

----Test file : myTest_division.mini
	
	Designed to make sure multiple divisions can happen in the same expression and that division between variables can happen as well

----Test file: myTest_skeleton.mini
	
	Designed to make sure that all working things can work in unison
	