module pierce_ex2;

import pierce_ex1;
import std.conv: to;

import pegged.grammar;


enum grammarName = "BoolNatLangForTyping";

enum ourGrammar = grammarName ~ `:
   Term     < IfThen / IsZero / PredFun / SuccFun / NatVal / BoolVal 
   Type     < Bool / Nat
   IsZero   < "iszero" Term
   PredFun  < "pred" Term
   SuccFun  < "succ" Term
   IfThen   < "if" Term "then" Term "else" Term
   BoolVal  < "true" / "false"
   NatVal   < ~([0-9]+)
   Bool     < "Bool"
   Nat      < "Nat"
`;

mixin(grammar(ourGrammar));

/**  
* @param ParseTree parseTree: generated by ArithmeticNoVar
* @return Hopefully the type of a bool / nat expression in this small language.
*/
string evaluateBoolNatLangForTyping(ParseTree parseTree)
{
   // TODO test remove
   import std.stdio;
   uint res = -1;

   switch (parseTree.name)
   {
      case grammarName:
      case grammarName ~ ".Term":
         return evaluateBoolNatLangForTyping(parseTree.children[0]);
      case grammarName ~ ".SuccFun":
      case grammarName ~ ".PredFun":
         return "Nat";

      case grammarName ~ ".IfThen":
         auto ifCond = evaluateBoolNatLang(parseTree.children[0]);

         if (ifCond)
            return evaluateBoolNatLangForTyping(parseTree.children[1]);
         else
            return evaluateBoolNatLangForTyping(parseTree.children[2]);

      case grammarName ~ ".IsZero":
      case grammarName ~ ".BoolVal":
         return "Bool";

      case grammarName ~ ".NatVal":
         return "Nat";

      default:
         return "(Stuck)";
   }
}















