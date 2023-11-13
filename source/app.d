import std.stdio;
import pierce_ex3;




void main()
{	
    while (true)
   {
      auto i = readln();
      auto parseTree = BoolNatLangForTyping(i);
      auto output = evaluateBoolNatLangForTyping(parseTree);

      writeln(output);
   }

}
