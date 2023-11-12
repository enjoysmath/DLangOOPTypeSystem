import std.stdio;
import pierce_ex1;
import pierce_ex2;



void main()
{
	
	while (true)
   {
		auto i = readln();
		auto parseTree = BoolNatLangForTyping(i);
		auto outputTree = typingOfBoolNatLang(parseTree);

		writeln(outputTree);
   }

}
