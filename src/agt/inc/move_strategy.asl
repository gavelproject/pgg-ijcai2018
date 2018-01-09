+!play_move
: move_strategy(utilitarian)
<-	!check_new_pool_mates;
	?ewa(X);
	if ( .random(N) & N < X) {
		-+move(contribute);
		contribute(1);
	} else {
		-+move(defect);
		contribute(0);
	}.

+!check_new_pool_mates
<-	for ( pool_member(Player) &
			not .my_name(Player) &
			not punishments_received(Player,_) &
			not defections_towards(Player,_) ) {
		+punishments_received(PoolMate,0);
		+defections_towards(PoolMate,0);
	}.

+?ewa(X)
<-	?utility(U);
	?reputation_appreciation(Beta);
	jia.exp(-Beta*U,EPower);
	X = 1/(1+EPower).

+?utility(U)
<-	?reciprocity(Alpha);
	?max_utility(MaxU);
	?prob_being_punished(PBP);
	?freeriders_ratio(FRRatio);
	U = (MaxU*-2) * (Alpha*(1-FRRatio)+(1-Alpha)*PBP) + MaxU.

+?prob_being_punished(PBP)
<-	.findall(P,pool_member(P) & not .my_name(P),PoolMates);
	!sum_prob_being_punished(PoolMates,Sum);
	PBP = 1*Sum/.length(PoolMates).

+!sum_prob_being_punished([H|T],Sum)
<-	!sum_prob_being_punished(T,PartialSum);
	?punishments_received(H,P);
	?defections_towards(H,D);
	Sum = (P+0**D)/(D+2*0**D) + PartialSum.

+!sum_prob_being_punished([],0).

+!play_move
: move_strategy(cooperator) |
	move_strategy(nice) |
	(move_strategy(mean) & not too_many_freeriders)
<--+move(contribute);
	contribute(1).

+!play_move
: move_strategy(freerider) |
	(move_strategy(mean) & too_many_freeriders)
<--+move(defect);
	contribute(0).

+?freeriders_ratio(FRRatio)
<-?min_img_cooperator(MinCoop);
	.count(
		pool_member(Player) &
			overall_img(Player,ImgValue) &
			ImgValue < MinCoop,
		NumFrs
	);

	// GroupSize-1 = group size without me
	.count(pool_member(_),GroupSize);
	FRRatio = NumFrs/(GroupSize-1).

+move(defect)
: move_strategy(utilitarian)
<-	for ( pool_member(Player) & not .my_name(Player) ) {
		?defections_towards(Player,N);
		-+defections_towards(Player,N+1);
	}.
