#joint calc
All_values <- expand.grid(c("P0","P1"),c("A1","A0"),c("T0","T1"))
Pp1 = 0.01
Pa1 = 0.1
Pt1_cp0a0 = 0.1
Pt1_cp0a1 = 0.5
Pt1_cp1a0 = 0.6
Pt1_cp1a1 = 0.9

All_values$Joint_P <- apply(All_values,1, function(x){
if(x[2] =="A1") {
  Pa = Pa1
}else{
  Pa = 1 - Pa1
}
if(x[1] =="P1") {
    Pp = Pp1
}else{
    Pp = 1 - Pp1
}
  if(x[1] =="P1"){
    if(x[2] =="A1"){
      Pt_cap = Pt1_cp1a1
    } else{
      Pt_cap = Pt1_cp1a0 
    }
  } else {
    if(x[2] =="A1"){
      Pt_cap = Pt1_cp0a1
    } else{
      Pt_cap = Pt1_cp0a0
    }
  }
  if(x[3] == "T0"){
  Pt_cap = 1-Pt_cap
}
  
Joint_p = Pa*Pp*Pt_cap
return(Joint_p)
}
)

#Q1: find out P(A=1|T=1,P=1)

All_values[ All_values$Var3 == "T1" & All_values$Var1 == "P1",]

normalize_P <- function(M_x){
  M_x$Joint_P = M_x$Joint_P/sum(M_x$Joint_P)
  M_x
}

normalize_P(All_values[ All_values$Var3 == "T1" & All_values$Var1 == "P1",])

#Q2: find out P(A=1|T=1)

#0.1428571

#1. marginalize P out
Marginalize <- function(M_x, variable = "Var1"){
idx <- apply( M_x[, colnames(M_x)[colnames(M_x)[1:3] != variable]] , 1, function(x) paste0(x[1],"_",x[2])) 
tapply(M_x$Joint_P,idx,sum)
}


Joint_AT <- Marginalize(All_values)

#Conditioning on T1 and normalize it.
unormalized_cond <- Joint_AT[grepl("T1",names(Joint_AT))]

unormalized_cond/sum(unormalized_cond)

#0.3478261
