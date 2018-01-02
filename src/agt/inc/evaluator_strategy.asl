// cooperator/freerider
+!decide_sanctions(_,SanctionDecisions)
: move_strategy(cooperator) |
	move_strategy(freerider) |
	not too_many_freeriders
<-SanctionDecisions = [].

// punishment/gossip only strategy
+!decide_sanctions(NormInstance,SanctionDecisions)
: too_many_freeriders &
	sanction_decision_strategy(S) &
	(S == gossip | S == punishment)
<-!active_sanctions_for(NormInstance,Options);
	Sanction = sanction(
		id(S),
		status(enabled),
		activation(Activation),
		Category,
		content(Content)
	);
	if ( .member(Sanction,Options) ) {
		SanctionDecisions = [Sanction];
		!increment_pending_sanctions
	} else {
		SanctionDecisions = [];
	}.

// random_choice/random_threshold strategies
+!decide_sanctions(NormInstance,SanctionDecisions)
: too_many_freeriders &
	sanction_decision_strategy(S) &
	(S == random_choice | S == random_threshold)
<-!active_sanctions_for(NormInstance,Options);
	if ( .empty(Options) ) {
		SanctionDecisions = [];
	} else {
		if ( .length(Options) == 1 ) {
			.nth(0,Options,Sanction);
		} else {
			!apply_sanction_decision_strategy(NormInstance,Options,SanctionDecisions);
		}
		!increment_pending_sanctions
		SanctionDecisions = [Sanction];
	}.

// random_choice sanction decision strategy
+!apply_sanction_decision_strategy(_,Options,[Sanction])
: sanction_decision_strategy(random_choice)
<-.random(X);
	if (X < 0.5) {
		.nth(0,Options,Sanction);
	} else {
		.nth(1,Options,Sanction);
	}.

// random_threshold sanction decision strategy
+!apply_sanction_decision_strategy(
	norm(_,_,_,_,target(Target),_,_,_),Options,[Sanction]
)
: sanction_decision_strategy(random_threshold)
<-?overall_img(Target,Threshold);
	.random(X);
	if (X < Threshold) {
		S = gossip;
	} else {
		S = punishment;
	}
	Sanction = sanction(
		id(S),
		status(enabled),
		activation(Activation),
		Category,
		content(Content)
	)
	.member(Sanction,Options).
