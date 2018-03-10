% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  U = I.UtilityFactors(1);
  %Eleminate everything exept the variable that is the parent of the utility variable,
  All_vars_F = nan;
  for i = 1:length(F)
  All_vars_F = [All_vars_F, F(i).var];
  end
  All_vars_F = unique( All_vars_F(2:length(All_vars_F)) );
  
  Fac_U  = VariableElimination(F, setdiff( All_vars_F, U.var));
  
  if(length(Fac_U) > 1)
  Fac_temp = Fac_U(1);
   for i = 1:(length(Fac_U)-1)
   Fac_temp = FactorProduct(Fac_temp,Fac_U(i+1));
  end
  Fac_U = Fac_temp;
  end
  
  EU = sum(FactorProduct(U,Fac_U).val);
 
end
