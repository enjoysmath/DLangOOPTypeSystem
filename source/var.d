module var;

import term;

class Var : Term
{
public:
   this(string syms)
   {
      symbols = syms;
   }

   override string toString()
   {
      return symbols;
   }

private:
   string symbols;
}