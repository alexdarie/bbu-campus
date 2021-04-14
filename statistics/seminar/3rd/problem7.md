Think at the chance of answering exactly `7 out of 10` as a hunter aiming to shoot the `7th deer`. Let's suppose that the deer `no. 7` is the only one in the field right now. What is the chance of aiming the deer while all the other hunters miss?

X is the # of right answers<br>
player1: (0.8 R/0.2 W answer)   so P(X=7) = 0.2013 (0.7986)<br>
player2: (0.9 R/0.1 W answer)   so P(X=7) = 0.0574 (0.9426)<br>
player3: (0.75 R/0.15 W answer) so P(X=7) = 0.2503 (0.7497)<br>

From here we apply the Poisson Model:

X is the # of hits
P(n, i) = Σi (p<i1> * ... * p<ik> * q<ik+1> * ... * q<in>)

| Player | p | q |
|--------|---|---|
| 1 | 0.2013 | 0.7986 |
| 2 | 0.0574 | 0.9426 |
| 3 | 0.2503 | 0.7497 |

P(3,1) = p1q2q3 + q1p2q3 + q1q2p3 = 0.3650 (36% chance to answer 7 out of 10 for exactly one player out of 3)
