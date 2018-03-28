# CompilerCode
lex and yacc code for compiler for c and c++

***Packages Needed***:
    
    1)flex(sudo apt-get update
           sudo apt-get install flex)
     
    2) bison(sudo apt-get update
           sudo apt-get install bison)
   
   
   
              
              
***------Learning Materials for Lex and YACC working-------***:

        http://www.tldp.org/HOWTO/Lex-YACC-HOWTO-1.html
                 

***---COMPILATION STEPS----****:

  1)Traverse into the appropriate directory using cd command.
  
  2)Now execute the command "chmod +x ./compile.sh" to give permission for bash to execute the commands.
  
  3)Now execute the command "./compile.sh filename" where filename is the name of lex and yacc file.
  
  4)Execute the output using "./a.out < in.txt" where in.txt is the input file to the lexer.

 
 ******--------------FOLDERS AND THEIR COMPILATION TASKS PERFORMED-------------*****
 
 
***IFELSE***:

   Solves dangling else problem in programs by adding "else{}" to if statement that doesnot have a corresponding else statement.Parser matches else statements to appropriate if statements(nearest unmatched "if" statement) and adds "else{}" at appropriate places.
    
***FOR***:

   Converts for and dowhile loop into while loop statements.
    
***THREE_ADDR_Without_Array***:

   Generates a list of  three address statements for a given source file.Array references are not included in this type of parsing.

***THREE_ADDR_With_Array***:

   Generates a list of  three address statements for a given source file.Array references are  included in this type of parsing and corresponding three address statements for array references are generated.
    
***SymbolTable***:

   Generates symbol Table for a list of statements given and displays the result blockwise.

***SyntaxTree***:

   Generates Syntax Tree for a given expression and displays the result.Syntax tree is used as a intermediate code.
 
***Boolean Backpatching***:

   Generates list of three address statements with backpatching for boolean expressions.
 
 ***LabelTree***:
 
   Generates label tree from syntax tree and label tree is used in code generation.Code generation for machine is done with the help of algorithms appiled on labeled tree.
 
 ***FLOW Graph***:
 
   Generates leaders from three address statements and basic blocks are identified with the help of leaders among the generated three address statements.Finally Flow Graph which depicts the flow among basic blocks is implemented.
      
 ***DAG***:
 
   Generates Direct Acyclic Graph for the list of statements generated .This is done to identify common sub expressions and to eliminate them.
 
 ***Copy_and_Constant_Prop***:
 
   Implements Compiler copy propagation and constant folding Compiler Optimizations Techniques.
         
      
   
  
