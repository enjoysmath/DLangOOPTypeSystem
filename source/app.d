import std.stdio;
import pierce_ex1;



void main()
{
	
	while (true)
   {
		auto i = readln();
		auto parseTree = BoolNatLang(i);
		auto outputTree = evaluateBoolNatLang(parseTree);

		writeln(outputTree);
   }

}
