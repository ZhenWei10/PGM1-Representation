% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
  MEU = [];
  OptimalDecisionRule = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  I_temp = I;
D = I.DecisionFactors(1);
U = I.UtilityFactors;

for i = 1:length(U)
I_temp.UtilityFactors = U(i);
EUF_U(i) = CalculateExpectedUtilityFactor(I_temp);
end

EUF_sum = EUF_U(1);
for i = 1:(length(U)-1)
EUF_sum =  FactorSum( EUF_sum,EUF_U(i+1) );
end

OptimalDecisionRule = I.DecisionFactors;
 
OptimalDecisionRule.val = zeros(1,prod(D.card));
 

if length(D.var) > 1 %In case of D have any parents 
 
 %solve the variable order problem between 2 factors (ismember is the equivalence of %=% and match in R)
 [dummy, mapD] = ismember(D.var, EUF_sum.var);
 assignments = IndexToAssignment(1:prod(EUF_sum.card), EUF_sum.card);
 indxD = AssignmentToIndex(assignments(:, mapD), D.card);
 
 for i = 1:(prod(D.card)/D.card(1))
 Indx = (((i-1)*D.card(1))+1):(((i-1)*D.card(1))+D.card(1));
 VALS = EUF_sum.val(indxD)(Indx);
 [y,ind] = max(VALS);
 OptimalDecisionRule.val(Indx(ind)) = 1;
 end 
 
 else %In case of D don't have any parents
 [y,ind] = max(EUF_sum.val);
  OptimalDecisionRule.val(ind) = 1;
 end

I_temp.DecisionFactors = OptimalDecisionRule;

MEU = 0;

for i = 1:length(U)
I_temp.UtilityFactors = U(i);
MEU = MEU + SimpleCalcExpectedUtility(I_temp);
end

end
