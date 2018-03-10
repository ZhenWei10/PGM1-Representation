% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  EUF = CalculateExpectedUtilityFactor(I);
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  
 OptimalDecisionRule = I.DecisionFactors;
 
 OptimalDecisionRule.val = zeros(1,prod(D.card));
 
 if length(D.var) > 1 %In case of D have any parents 
 
 %solve the variable order problem between 2 factors (ismember is equivalence of %=% and match in R)
 [dummy, mapD] = ismember(D.var, EUF.var);
 assignments = IndexToAssignment(1:prod(EUF.card), EUF.card);
 indxD = AssignmentToIndex(assignments(:, mapD), D.card);
 
 for i = 1:(prod(D.card)/D.card(1))
 Indx = (((i-1)*D.card(1))+1):(((i-1)*D.card(1))+D.card(1));
 VALS = EUF.val(indxD)(Indx);
 [y,ind] = max(VALS);
 OptimalDecisionRule.val(Indx(ind)) = 1;
 end 
 
 else %In case of D don't have any parents
 [y,ind] = max(EUF.val);
  OptimalDecisionRule.val(ind) = 1;
 end
 
 I.DecisionFactors = OptimalDecisionRule;
 
 MEU = SimpleCalcExpectedUtility(I);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    

end
