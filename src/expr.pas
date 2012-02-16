Unit Expr;

{
THAI TRAN

I've netmailed you the full-featured version (800 lines!) that will do
Functions, exponentiation, factorials, and has all the bells and whistles,
but I thought you might want to take a look at a simple version so you can
understand the algorithm.

This one only works With +, -, *, /, (, and ).  I wrote it quickly, so it
makes extensive use of global Variables and has no error checking; Use at
your own risk.

Algorithm to convert infix to postfix (RPN) notation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Parse through the entire expression getting each token (number, arithmetic
operator, left or right parenthesis).  For each token, if it is:
 1. an operand (number)        Send it to the RPN calculator
 2. a left parenthesis         Push it onto the operator stack
 3. a right parenthesis        Pop operators off stack and send to RPN
                               calculator Until the a left parenthesis is
                               on top of the stack.  Pop it also, but don't
                               send it to the calculator.
 4. an operator                While the stack is not empty, pop operators
                               off the stack and send them to the RPN
                               calculator Until you reach one With a higher
                               precedence than the current operator (Note:
                               a left parenthesis has the least precendence).
                               Then push the current operator onto the stack.

This will convert (4+5)*6/(2-3) to 4 5 + 6 * 2 3 - /

Algorithm For RPN calculator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Note:  this Uses a different stack from the one described above.

In RPN, if an operand (a number) is entered, it is just pushed onto the
stack.  For binary arithmetic operators (+, -, *, /, and ^), the top two
operands are popped off the stack, operated on, and the result pushed back
onto the stack.  if everything has gone correctly, at the end, the answer
should be at the top of the stack.


Released to Public Domain by Thai Tran (if that matters).
}

interface

{$X+}

Const
  RPNMax = 10;              { I think you only need 4, but just to be safe }
  OpMax  = 25;

  
Function Evaluate(Expr : String; var code: integer): Real;
  

implementation  

Type
  String15 = String[15];
  
  TRealStack = object
  public
     Constructor Init;
     { Add an operand to the top of the RPN stack }
     Procedure RPNPush(Num : Real); 
     { Get the operand at the top of the RPN stack }
     Function RPNPop : Real;       
  private
     RPNStack   : Array[1..RPNMax] of Real;        { Stack For RPN calculator }
     RPNTop     : Integer;
  end;
  
  TOperatorStack = object
  public
    constructor init;
    { Add an operator onto top of the stack }  
    Procedure OpPush(Op : Char);  
    { Get operator at the top of the stack }
    Function OpPop : Char;               
    { Return priority of operator }
    Function Priority(Op : Char) : Integer; 
    { Get the value on top of the stack }
    Function Peek: Char;
  private 
    OpStack    : Array[1..OpMax] of Char;    { Operator stack For conversion }
    OpTop      : Integer;
  end;

  
  {**************************** Real Stack *************************}     
  
Constructor TRealStack.init;
 Begin
   RPNTop := 0;
 end;
     

Procedure TRealStack.RPNPush(Num : Real); { Add an operand to the top of the RPN stack }
begin
  if RPNTop < RPNMax then
  begin
    Inc(RPNTop);
    RPNStack[RPNTop] := Num;
  end
  else  { Put some error handler here }
end;

Function TRealStack.RPNPop : Real;       { Get the operand at the top of the RPN stack }
begin
  if RPNTop > 0 then
  begin
    RPNPop := RPNStack[RPNTop];
    Dec(RPNTop);
  end
  else  { Put some error handler here }
end;

{ RPN Calculator }
Function RPNCalc(var RPNStack: TRealStack; Token : String15): Boolean;                       
Var
  Temp  : Real;
  Error : Integer;
begin
  RPNCalc := True;

  if (Length(Token) = 1) and (Token[1] in ['+', '-', '*', '/']) then
  Case Token[1] of                                   { Handle operators }
    '+' : RPNStack.RPNPush(RPNStack.RPNPop + RPNStack.RPNPop);
    '-' : RPNStack.RPNPush(-(RPNStack.RPNPop - RPNStack.RPNPop));
    '*' : RPNStack.RPNPush(RPNStack.RPNPop * RPNStack.RPNPop);
    '/' :
    begin
      Temp := RPNStack.RPNPop;
      if Temp <> 0 then
        RPNStack.RPNPush(RPNStack.RPNPop/Temp)
      else  { Handle divide by 0 error }
    end;
  end
  else
  begin                   { Convert String to number and add to stack }
    Val(Token, Temp, Error);
    if Error = 0 then
      RPNStack.RPNPush(Temp)
    else  { Handle error }
     RPNCalc := False;
  end;
end;
  {**************************** Op. Stack *************************}     
  
  
Constructor TOperatorStack.init;
 Begin
  OpTop := 0;
 end;
 
Function TOperatorStack.Peek: Char;
 Begin
   if OpTop = 0 then
     Peek := #0
   else
     Peek:=OpStack[OpTop];
 end;

Procedure TOperatorStack.OpPush(Op : Char);  { Add an operator onto top of the stack }
begin
  if OpTop < OpMax then
  begin
    Inc(OpTop);
    OpStack[OpTop] := Op;
  end
  else  { Put some error handler here }
end;

Function TOperatorStack.OpPop : Char;               { Get operator at the top of the stack }
begin
  if OpTop > 0 then
  begin
    OpPop := OpStack[OpTop];
    Dec(OpTop);
  end
  else  { Put some error handler here }
end;

Function TOperatorStack.Priority(Op : Char) : Integer; { Return priority of operator }
begin
  Case Op OF
    '('      : Priority := 0;
    '+', '-' : Priority := 1;
    '*', '/' : Priority := 2;
    else  { More error handling }
  end;
end;

Function Evaluate(Expr : String; var code: integer): Real;
Var
  I     : Integer;
  Token : String15;
  OpStack : TOperatorStack;
  RPNStack : TRealStack;
begin
  OpStack.init;
  RPNStack.init;
  Token  := '';
  Code := 0;

  For I := 1 to Length(Expr) DO
  if Expr[I] in ['0'..'9'] then
  begin       { Build multi-digit numbers }
    Token := Token + Expr[I];
    if I = Length(Expr) then
     Begin { Send last one to calculator }
        if RPNCalc(RPNStack,Token)=False then
          Begin
            Code:=-1;
            exit;
          end;
     end;
  end
  else
  if Expr[I] in ['+', '-', '*', '/', '(', ')'] then
  begin
    if Token <> '' then
    begin        { Send last built number to calc. }
      if RPNCalc(RPNStack, Token)=false then
        Begin  
          Code:=-1;
          exit;
        end;
      Token := '';
    end;

    Case Expr[I] OF
      '(' : OpStack.OpPush('(');
      ')' :
      begin
        While OpStack.Peek  <> '(' DO 
          Begin
            if RPNCalc(RPNStack, OpStack.OpPop) = false then
              Begin
                Code:= -1;
                exit;
              end;
          end;
        OpStack.OpPop;                          { Pop off and ignore the '(' }
      end;

      '+', '-', '*', '/' :
      begin
        While (OpStack.Peek <> #0) AND
              (OpStack.Priority(Expr[I]) <= OpStack.Priority(OpStack.Peek)) DO
          Begin
            if RPNCalc(RPNStack, OpStack.OpPop)=false then
              Begin
                Code := -1;
                exit;
              end;
          end;
        OpStack.OpPush(Expr[I]);
      end;
    end; { Case }
  end
  else;
      { Handle bad input error }

  While OpStack.Peek <> #0 do                     { Pop off the remaining operators }
    RPNCalc(RPNStack, OpStack.OpPop);
    
   EValuate:=RPNStack.RPNPop;
end;

end.
