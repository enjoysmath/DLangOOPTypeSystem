module pierce_ex1;

import std.conv: to;

import pegged.grammar;

enum ourGrammar = `
BoolNatLang:
   Term     < IfThen / IsZero / PredFun / SuccFun / NatVal / BoolVal
   IsZero   < "iszero" Term
   PredFun  < "pred" Term
   SuccFun  < "succ" Term
   IfThen   < "if" Term "then" Term "else" Term
   BoolVal  < "true" / "false"
   NatVal   < ~([0-9]+)
`;

enum grammarName = "BoolNatLang";

mixin(grammar(ourGrammar));


/**  TEST COMMENT
 * Takes a ParseTree as input.
 * @param T arithmetic type. By default is float.
 * @param grammarName Name of the arithmetic grammar. Must be "ArithmeticNoVar" or "Arithmetic". By default is "ArithmeticNoVar"
 * @param ParseTree p ParseTree generated by ArithmeticNoVar
 * @param variable Associative array with variable values
 * @return The result of the arithmetic expresion. If the ParseTree is invalid
 *  or contains unexpected nodes, then will return NaN if T is a float or 0
 *  if T is a integral
 *  
 *  Goal for Pierce Exercise 1 is evaluate the different instructions in the BoolNatLang
 */
uint evaluateBoolNatLang(ParseTree parseTree)
{
   // TODO test remove
   import std.stdio;
   uint res = -1;

   switch (parseTree.name)
   {
      case grammarName:
      case grammarName ~ ".Term":
         res = evaluateBoolNatLang(parseTree.children[0]);
         break;
      case grammarName ~ ".SuccFun":
         auto arg = evaluateBoolNatLang(parseTree.children[0]);
         res = arg + 1;
         break;
      case grammarName ~ ".PredFun":
         auto arg = evaluateBoolNatLang(parseTree.children[0]);
         res = arg - 1;
         break;
      case grammarName ~ ".IfThen":
         auto ifCond = evaluateBoolNatLang(parseTree.children[0]);

         if (ifCond)
            res = evaluateBoolNatLang(parseTree.children[1]);
         else
            res = evaluateBoolNatLang(parseTree.children[2]);

         break;
      case grammarName ~ ".IsZero":
         auto arg = evaluateBoolNatLang(parseTree.children[0]);
         
         if (arg)
            res = 0;
         else
            res = 1;

         break;

      case grammarName ~ ".BoolVal":
         if (parseTree.matches[0] == "false")
            res = 0;
         else if (parseTree.matches[0] == "true")
            res = 1;

         break;

      case grammarName ~ ".NatVal":
         res = to!uint(parseTree.matches[0]);
         break;

      default:
         res = -1;
         break;
   }

   return res;
}

    
//unittest
//{   // Testing parsing arithmetic expression without variables
//    string testExpression = "1 + 2 * (3 + 10 / 4)";
//    const pNoVar = ArithmeticNoVar(testExpression);
//
//    assert(pNoVar.successful);
//    assert(pNoVar.toString == q"EOS
//ArithmeticNoVar[0, 20]["1", "+", "2", "*", "3", "+", "10", "/", "4"]
// +-ArithmeticNoVar.Term[0, 20]["1", "+", "2", "*", "3", "+", "10", "/", "4"]
//    +-ArithmeticNoVar.Factor[0, 2]["1"]
//    |  +-ArithmeticNoVar.Primary[0, 2]["1"]
//    |     +-ArithmeticNoVar.Number[0, 2]["1"]
//    +-ArithmeticNoVar.Add[2, 20]["+", "2", "*", "3", "+", "10", "/", "4"]
//       +-ArithmeticNoVar.Factor[4, 20]["2", "*", "3", "+", "10", "/", "4"]
//          +-ArithmeticNoVar.Primary[4, 6]["2"]
//          |  +-ArithmeticNoVar.Number[4, 6]["2"]
//          +-ArithmeticNoVar.Mul[6, 20]["*", "3", "+", "10", "/", "4"]
//             +-ArithmeticNoVar.Primary[8, 20]["3", "+", "10", "/", "4"]
//                +-ArithmeticNoVar.Parens[8, 20]["3", "+", "10", "/", "4"]
//                   +-ArithmeticNoVar.Term[9, 19]["3", "+", "10", "/", "4"]
//                      +-ArithmeticNoVar.Factor[9, 11]["3"]
//                      |  +-ArithmeticNoVar.Primary[9, 11]["3"]
//                      |     +-ArithmeticNoVar.Number[9, 11]["3"]
//                      +-ArithmeticNoVar.Add[11, 19]["+", "10", "/", "4"]
//                         +-ArithmeticNoVar.Factor[13, 19]["10", "/", "4"]
//                            +-ArithmeticNoVar.Primary[13, 16]["10"]
//                            |  +-ArithmeticNoVar.Number[13, 16]["10"]
//                            +-ArithmeticNoVar.Div[16, 19]["/", "4"]
//                               +-ArithmeticNoVar.Primary[18, 19]["4"]
//                                  +-ArithmeticNoVar.Number[18, 19]["4"]
//EOS");
//
//    // Parsing as a float
//    const f = parseArithmetic(pNoVar);
//    assert(f == 12.0f);
//
//    // Parsing as integer
//    const i = parseArithmetic!int(pNoVar);
//    assert(i == 11);
//}
//
//unittest
//{
//    // Testing parsing arithmetic expression witht variables
//
//    string testExpressionWithVar = "1 + 2 * (3 + 10 / 4) + fooBar";
//    const p = Arithmetic(testExpressionWithVar);
//
//    assert(p.successful);
//    assert(p.toString == q"EOS
//Arithmetic[0, 29]["1", "+", "2", "*", "3", "+", "10", "/", "4", "+", "fooBar"]
// +-Arithmetic.Term[0, 29]["1", "+", "2", "*", "3", "+", "10", "/", "4", "+", "fooBar"]
//    +-Arithmetic.Factor[0, 2]["1"]
//    |  +-Arithmetic.Primary[0, 2]["1"]
//    |     +-Arithmetic.Number[0, 2]["1"]
//    +-Arithmetic.Add[2, 21]["+", "2", "*", "3", "+", "10", "/", "4"]
//    |  +-Arithmetic.Factor[4, 21]["2", "*", "3", "+", "10", "/", "4"]
//    |     +-Arithmetic.Primary[4, 6]["2"]
//    |     |  +-Arithmetic.Number[4, 6]["2"]
//    |     +-Arithmetic.Mul[6, 21]["*", "3", "+", "10", "/", "4"]
//    |        +-Arithmetic.Primary[8, 21]["3", "+", "10", "/", "4"]
//    |           +-Arithmetic.Parens[8, 21]["3", "+", "10", "/", "4"]
//    |              +-Arithmetic.Term[9, 19]["3", "+", "10", "/", "4"]
//    |                 +-Arithmetic.Factor[9, 11]["3"]
//    |                 |  +-Arithmetic.Primary[9, 11]["3"]
//    |                 |     +-Arithmetic.Number[9, 11]["3"]
//    |                 +-Arithmetic.Add[11, 19]["+", "10", "/", "4"]
//    |                    +-Arithmetic.Factor[13, 19]["10", "/", "4"]
//    |                       +-Arithmetic.Primary[13, 16]["10"]
//    |                       |  +-Arithmetic.Number[13, 16]["10"]
//    |                       +-Arithmetic.Div[16, 19]["/", "4"]
//    |                          +-Arithmetic.Primary[18, 19]["4"]
//    |                             +-Arithmetic.Number[18, 19]["4"]
//    +-Arithmetic.Add[21, 29]["+", "fooBar"]
//       +-Arithmetic.Factor[23, 29]["fooBar"]
//          +-Arithmetic.Primary[23, 29]["fooBar"]
//             +-Arithmetic.Variable[23, 29]["fooBar"]
//EOS");
//
//    // Parsing as a float
//    const float[string] fVars = ["fooBar": 10.25f];
//    const fWithVar = parseArithmetic!(float, "Arithmetic")(p, fVars );
//
//    assert(fWithVar == 22.25f);
//
//    // Parsing as integer
//    const iVars = ["fooBar": 10];
//    const iWithVar = parseArithmetic!(int, "Arithmetic")(p, iVars);
//
//    assert(iWithVar == 21);
//}
//
//
//unittest
//{
//    // Some additional test borrowed from simple_arithmetic
//    float interpreter(string expr) => ArithmeticNoVar(expr).parseArithmetic;
//
//    assert(interpreter("1") == 1.0);
//    assert(interpreter("-1") == -1.0);
//    assert(interpreter("1+1") == 2.0);
//    assert(interpreter("1-1") == 0.0);
//
//    assert(interpreter("1+1+1") == 3.0);
//    assert(interpreter("1-1-1") == -1.0);
//    assert(interpreter("1+1-1") == 1.0);
//    assert(interpreter("1-1+1") == 1.0);
//    assert(interpreter("-1+1+1") == 1.0);
//
//    assert(interpreter("(-1+1)+1") == 1.0);
//    assert(interpreter("-1+(1+1)") == 1.0);
//    assert(interpreter("(-1+1+1)") == 1.0);
//    assert(interpreter("1-(1-1)") == 1.0);
//
//    assert(interpreter("1*1") == 1.0);
//    assert(interpreter("1/1") == 1.0);
//    assert(interpreter("-1*1") == -1.0);
//    assert(interpreter("-1/1") == -1.0);
//
//    assert(interpreter("1+2*3") == 7.0);
//    assert(interpreter("1-2*3") == -5.0);
//    assert(interpreter("-1-2*-3") == 5.0);
//    assert(interpreter("-1+2*-3") == -7.0);
//
//    assert(interpreter("1/2/(1/2)") == 1.0);
//    assert(interpreter("1/2/1/2") == .25);
//    assert(interpreter("1 - 2*3 - 2*3") == -11.0);
//
//    assert(interpreter("2*3*3 - 3*3 + 3*4") == 21.0);
//    assert(interpreter("2 * 3 * 3 - 3 * (3 + 3 * 4)") == -27.0);
//}
