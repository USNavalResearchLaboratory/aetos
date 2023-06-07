(* ::Package:: *)

(*TODO REPLACE RULES THAT DO NOT CONTAIN VARIABLES*)
BeginPackage["Compactor`"]

Compact::usage="Compact[\!\(\*StyleBox[\"expr\", \"TI\"]\),...] 
generates a compact form of \!\(\*StyleBox[\"expr\", \"TI\"]\) by minimizing the number of leaf nodes of the expr syntax tree and providing relevant replacement rules. 
\!\(\*StyleBox[\"Options\", \"SubSection\"]\)
The option \!\(\*StyleBox[\"EliminateNumericRules\", \"TI\"]\) eliminates rules that contain only numbers. Defaults to True. 
The option \!\(\*StyleBox[\"EliminateIntermediateRules\", \"TI\"]\) eliminates rules that appear only in the replacements. Defaults to False. 
The option \!\(\*StyleBox[\"EliminateNegationReplacements\", \"TI\"]\) converts subexpressions of the form \!\(\*StyleBox[\"-1+x\", \"TI\"]\) to \!\(\*StyleBox[\"x-1\", \"TI\"]\). Defaults to True. 
The option \!\(\*StyleBox[\"ReplacementSymbols\", \"TI\"]\) contains an ordered list of replacement symbols. Defaults to Greek and Caligraphic uppercase letters.";

Options[Compact]=
{
LeafCountThreshold->1,
EliminateNumericRules->True,
EliminateIntermediateRules->False,
EliminateNegationReplacements->True,
ReplacementSymbols->
{\[CapitalAlpha],\[CapitalBeta],\[CapitalGamma],\[CapitalDelta],\[CapitalEpsilon],\[CapitalZeta],\[CapitalEta],\[CapitalTheta],\[CapitalIota],\[CapitalKappa],\[CapitalLambda],\[CapitalMu],\[CapitalNu],\[CapitalXi],\[CapitalOmicron],\[CapitalPi],\[CapitalRho],\[CapitalSigma],\[CapitalTau],\[CapitalUpsilon],\[CapitalPhi],\[CapitalChi],\[CapitalPsi],\[CapitalOmega],\[ScriptCapitalA],\[ScriptCapitalB],\[ScriptCapitalC],\[ScriptCapitalD],\[ScriptCapitalE],\[ScriptCapitalF],\[ScriptCapitalG],\[ScriptCapitalH],\[ScriptCapitalI],\[ScriptCapitalJ],\[ScriptCapitalK],\[ScriptCapitalL],\[ScriptCapitalM],\[ScriptCapitalN],\[ScriptCapitalO],\[ScriptCapitalP],\[ScriptCapitalQ],\[ScriptCapitalR],\[ScriptCapitalS],\[ScriptCapitalT],\[ScriptCapitalU],\[ScriptCapitalV],\[ScriptCapitalW],\[ScriptCapitalX],\[ScriptCapitalY],\[ScriptCapitalZ]}
};

Begin["`Private`"]

Compact[expr_,OptionsPattern[] ]:=Module[
{
subscriptSymbols,otherSymbols,exprNoSubscriptSymbols,subscriptReplacements,DummySymbol2d042193,variables,func,recoverReplacements,compacted,compacted2, compacted3,compacted4, compacted5,rep,unnecessary,symbolReplacements,length4,keep,keepIds,keepIds2,rules,lengthK,dropIds,ppAAppAAbb,notVariables,repNotMembers,compacted2a,final,iind,negationReplacements,negations1,negations,cc1,cc2,numericRepRules,compacted3a,compacted3b,numericIDs,lowLeafCountIDs,lowLeafCountRep
},

subscriptSymbols=Cases[expr,Subscript[_Symbol,_],Infinity]//Union;

subscriptReplacements=MapThread[#1->#2&,{subscriptSymbols,DummySymbol2d042193[#]&/@(Position[subscriptSymbols,#]&/@subscriptSymbols//Flatten)}];

exprNoSubscriptSymbols=expr/.subscriptReplacements;

otherSymbols=Cases[exprNoSubscriptSymbols,_Symbol,Infinity]//Union;

variables=Join[otherSymbols,subscriptSymbols];

(*Compile and convert to a pure function*)
func=Cases[Compile[##, 
  CompilationOptions -> {"ExpressionOptimization" -> True}]&[variables,expr],x_Function:>x]//First;

(*Replacement rules to recover in case Compile has generated non-human friendly variables names*)
recoverReplacements=MapThread[#1->#2&,{func[[1]],variables}];

(*Convert the mathematica provisional sub-expression names to something a bit more parsable*)
compacted=Cases[func,s_Symbol/;"Compile`"===Context[s],Infinity]//DeleteDuplicates//MapIndexed[#1->ppAAppAAbb@@#2&,#]&//func/.#/.HoldPattern[Function[_,Block[_,b_]]]:>Hold@\[FormalM][{ppAAppAAbb},b]/.\[FormalM]->Module&;

(*Base and replacement expressions*)
rep=compacted/.Hold[Module[_,CompoundExpression[s___,f_]]]:>Hold[f/.{s}]/.Set->Rule;

(*This doesn't seem to work*)
unnecessary=Cases[Cases[rep,ppAAppAAbb[_],Infinity]//Tally,{_,2}][[All,1]];
compacted2=Verbatim[Rule][Alternatives@@unnecessary,_]//DeleteCases[rep,#,Infinity]//.Cases[rep,#,Infinity]&;
(*This doesn't seem to work end*)

If[Length[compacted2]==2, (*There were no replacements*)
Compactor::noRefinement = "The compiler could not optimize the expression. This may be because the expression cannot be further simplified. Consider modifying the expression to guarantee Real domain assumptions hold.";
Message[Compactor::noRefinement];
Return[];
];



If[OptionValue[EliminateIntermediateRules],
(
keep=Cases[compacted2[[1,1]],ppAAppAAbb[_],Infinity]//Union;

lengthK=compacted2[[1,2,All,1]];

keepIds2=Flatten[Select[Table[Position[lengthK,keep[[iind]]],{iind,1,Length[keep]}],UnsameQ[#,{}]&]];

notVariables=Flatten[Position[Table[Length[Variables[compacted2[[1,2,iind,2]]]],{iind,1,Length[compacted2[[1,2]]]}],_?(#==0&)]];

keepIds=Complement[keepIds2,notVariables];

repNotMembers=Intersection[keepIds2,notVariables];

rules=compacted2[[1,2]];

compacted2a=Evaluate[compacted2[[1,1]]/.rules[[repNotMembers]]];

dropIds=Complement[Table[iind,{iind,1,Length[rules]}],keepIds];

(*Replacing successively*)
Do[
If[!MemberQ[keepIds,iind],
rules=Evaluate[rules/.rules[[iind]]]
],
{iind,1,Length[rules]}
];
compacted3={compacted2a,rules[[keepIds]]};
)
,
(
compacted3={compacted2[[1,1]],compacted2[[1,2]]};
)
];

If[OptionValue[EliminateNumericRules],
(
numericIDs=Position[compacted3[[2,All,2]],_?(NumericQ[#]&),1]//Flatten;
numericRepRules=compacted3[[2,numericIDs]];

compacted3a=compacted3[[1]]/.numericRepRules;
compacted3b=Delete[compacted3[[2]],Transpose[{numericIDs}]];

compacted3={compacted3a, compacted3b/.numericRepRules}//Simplify;
)];

(

lowLeafCountIDs=Position[LeafCount[#[[2]]]&/@compacted3[[2]],_?(#<OptionValue[LeafCountThreshold]&)];
lowLeafCountRep=compacted3[[2,lowLeafCountIDs//Flatten]];

compacted3a=compacted3[[1]]/.lowLeafCountRep;
compacted3b=Delete[compacted3[[2]],lowLeafCountIDs];

compacted3={compacted3a/.lowLeafCountRep, compacted3b/.lowLeafCountRep}//Simplify;
);

If[OptionValue[EliminateNegationReplacements],
(
negations1=Position[compacted3[[2,All,2]],Times[-1,_],{1}];
negations=Flatten[negations1];
negationReplacements=compacted3[[2,negations]];
cc1=compacted3[[1]]/.negationReplacements;
cc2=Delete[compacted3[[2]],negations1]/.negationReplacements;
compacted4={cc1,cc2};
),
(
compacted4=compacted3;
)
];

(*Perform replacement of the provisional variable names with the desired symbols*) 
symbolReplacements=OptionValue[ReplacementSymbols];
length4=Length[compacted4[[2,All,1]]];
compacted5=compacted4/.Table[compacted4[[2,iind,1]]->symbolReplacements[[iind]],{iind,1,length4}];

(*Recover non-human friendly variable names and return*)
compacted5/.recoverReplacements
];

End[]

EndPackage[]
