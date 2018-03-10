% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  F = [I.RandomFactors,I.UtilityFactors];

  All_vars_F = nan;
  for i = 1:length(F)
  All_vars_F = [All_vars_F, F(i).var];
  end
  All_vars_F = unique( All_vars_F(2:length(All_vars_F)) );
  
  Fac_U = VariableElimination(F, setdiff(All_vars_F,I.DecisionFactors.var));
  
  if(length(Fac_U) > 1)
  
  Fac_temp = Fac_U(1);
  
   for i = 1:(length(Fac_U)-1)
   
   Fac_temp = FactorProduct(Fac_temp,Fac_U(i+1));
   
  end
  
  EUF = Fac_temp;
  
  else
  
  EUF = Fac_U;
  
  end
 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
end  
