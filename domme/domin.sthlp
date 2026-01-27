{smcl}
{* *! version 3.2 April 08 2016 J. N. Luchman}{...}
{cmd:help domin}{right: ({browse "https://doi.org/10.1177/1536867X211025837":SJ21-2: st0645})}
{hline}

{title:Title}

{p2colset 5 14 16 2}{...}
{p2col :{cmd:domin} {hline 2}}Dominance analysis{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 13 2}
{cmd:domin} {it:depvar} [{it:indepvars}] {ifin} {weight} [{cmd:,} {it:options}]

{phang}
{it:indepvars} cannot include factor variables (see options {cmd:sets()} and
{cmd:all()} below, which can) but can include time-series variables for
commands in {cmd:reg()} that accept them.

{phang}
Note that {cmd:domin} requires at least two {it:indepvars} or sets of
{it:indepvars} (see option {cmd:sets()} below).  Because it is possible to
submit only sets of {it:indepvars}, the initial {it:indepvars} statement is
optional.

{phang}
{cmd:aweight}s, {cmd:fweight}s, {cmd:iweight}s, and {cmd:pweight}s are allowed
but must be usable by the command in {opt reg()}; see
{help weights:weights}.

{phang}
{cmd:domin} requires installation of Jann's {cmd:moremata} package (install
here: {bf:{stata ssc install moremata}}).


{title:Table of contents}

    {help domin##desc: 1. Description}
    {help domin##disp: 2. Display}
    {help domin##opts: 3. Options}
    {help domin##examp: 4. Examples}
    {help domin##sav: 5. Stored results}
    {help domin##remark: 6. Final remarks}
    {help domin##refs: 7. References}


{marker desc}{...}
{title:1. Description}

{pstd}
Dominance analysis (DA) determines the relative importance of independent
variables (IVs) in an estimation model based on contribution to an overall
model fit statistic (see Gr{c o:}mping [2007] for a discussion).  DA is an
ensemble method in which importance determinations about IVs are made by
aggregating results across multiple models, though the method usually requires
the ensemble contain each possible combination of the IVs in the full model.
The all-possible-combinations ensemble with {it:p} IVs in the full model
results in 2^{it:p}-1 models fit.  That is, each combination of {it:p}
variables alternating between included versus excluded (that is, the 2 base to
the exponent) where the constants-only model is omitted (that is, the -1
representing the distinct combination where no IVs are included; see Budescu
[1993]).  {cmd:domin} derives three statistics from the 2^{it:p}-1 estimation
models.

{pstd}
General dominance statistics are the most commonly reported and easiest to
interpret.  General dominance statistics are derived as a weighted average
marginal or incremental contribution to the overall fit statistic an IV makes
across all models in which the IV is included.  If IV {it:X} has a larger
general dominance statistic than IV {it:Y}, IV {it:X} "generally dominates" IV
{it:Y}.  If general dominance statistics are equal for two IVs, no general
dominance designation can be made between those IVs.

{pstd}
General dominance statistics distill the entire ensemble of models into a
single value for each IV, which is why they are easiest to interpret.  In
addition, a useful property of the general dominance statistics is that they
are an additive decomposition of the fit statistic associated with the full
model (that is, the general dominance statistics can be summed to obtain the
value of the full model's fit statistic).  Thus, general dominance statistics
are equivalent to Shapley values (see {bf:{stata findit shapley}}).  General
dominance statistics are the arithmetic average of all conditional dominance
statistics discussed next.

{pstd}
Conditional dominance statistics are also derived from the
all-possible-combinations ensemble.  Conditional dominance statistics are
computed as the average incremental contributions to the overall model fit
statistic within a single "order" for models in which the IV is included --
where "order" refers to a distinct number of IVs in the estimation model.  One
order is thus all models that include one IV.  Another order is all models that
include two IVs, and so on, to {it:p} -- or the order including only the model
with all {it:p} IVs.  Each IV will then have {it:p} different conditional
dominance statistics.

{pstd}
The evidence that conditional dominance statistics provide with respect to
relative importance is stronger than that provided by general dominance
statistics.  Because general dominance statistics are the arithmetic average of
all {it:p} conditional dominance statistics, conditional dominance statistics
considered as a set provide more information about each IV or, alternatively,
are less "averaged" than general dominance statistics.  Conditional dominance
statistics also provide information about IV redundancy, collinearity, and
suppression effects because the user can see how the inclusion of any IV is, on
average, affected by the inclusion of other IVs in the estimation model in
terms of their effect on model fit.

{pstd}
If IV {it:X} has larger conditional dominance statistics than IV {it:Y} across
all {it:p} orders, IV {it:X}  "conditionally dominates" IV {it:Y}.  To be more
specific, for {it:X} to conditionally dominate {it:Y}, the conditional
dominance statistic associated with {it:X} at order 1 must be larger than the
conditional dominance statistic associated with {it:Y} at order 1.  The
conditional dominance statistic associated with {it:X} at order 2 must also be
larger than the conditional dominance statistic associated with {it:Y} at order
2.  The conditional dominance statistic associated with {it:X} at order 3 must
also be larger than the conditional dominance statistic associated with {it:Y}
at order 3 and so on to order {it:p}.  Thus, the conditional dominance
statistics at each order must all be larger for {it:X} than for {it:Y}.  If, at
any order, the conditional dominance statistics for two IVs is equal or there
is a change rank order (that is, {it:X}'s conditional dominance statistic is
smaller than {it:Y}'s conditional dominance statistic), no conditional
dominance designation can be made between those IVs.  Conditional dominance
implies general dominance as well, but the reverse is not true.  {it:X} can
generally dominate {it:Y} but not conditionally dominate {it:Y}.

{pstd}
Complete dominance designations are the final designation derived from the
all-possible-combinations ensemble.  Complete dominance designations are made
by comparing all possible incremental contributions with model fit for two IVs.
The evidence the complete dominance designation provides with respect to
relative importance is the strongest possible and supersedes that of general
and conditional dominance.  Complete dominance is the strongest evidence
because it is completely unaveraged and pits each IV against one another in
every possible comparison.  Thus, it is not possible for some good incremental
contributions to compensate for some poorer incremental contributions as can
occur when such data are averaged.  Complete dominance then provides
information on a property of the entire ensemble of models because it relates
to a comparison between two IVs.

{pstd}
If IV {it:X} has a larger incremental contribution to model fit than IV {it:Y}
across all possible comparisons, IV {it:X}  "completely dominates" IV {it:Y}.
As with conditional dominance designations, for {it:X} to completely dominate
{it:Y}, the incremental contribution to fit associated with {it:X} without any
other IVs in the model must be larger than the incremental contribution to fit
associated with {it:Y} without any other IVs in the model.  The incremental
contribution to fit associated with {it:X} with IV {it:Z} also in the model
must also be larger than the incremental contribution to fit associated with
{it:Y} with IV {it:Z} also in the model.  The incremental contribution to fit
associated with {it:X} with IV {it:W} also in the model must also be larger
than the incremental contribution to fit associated with {it:Y} with IV {it:W}
also in the model and so on for all other 2^({it:p}-2) comparisons (that is,
all possible combinations of the other IVs in the model).  Thus, the
incremental contribution to fit associated with {it:X} for each of the possible
2^({it:p}-2) comparisons must all be larger than the incremental contribution
to fit associated with {it:Y}.  If, for any comparison, the incremental
contribution to fit for two IVs are equal or there is a change in rank order
(that is, {it:X}'s incremental contribution to fit is smaller than {it:Y}'s the
incremental contribution to fit with the same set of other IVs in the model),
no complete dominance designation can be made between those IVs.  Complete
dominance implies both general and conditional dominance, but, again, the
reverse is not true.  {it:X} can generally or conditionally dominate
{it:Y} but not completely dominate {it:Y}.

{pstd}
By comparison with general and conditional dominance designations, the complete
dominance designation has no natural statistic.  That said, {cmd:domin} returns
a complete dominance matrix that reads from left to right.  Thus, a value of 1
means that the IV in the row completely dominates the IV in the column.
Conversely, a value of -1 means the opposite, that the IV in the row is
completely dominated by the IV in the column.  A 0 value means no complete
dominance designation could be made because the comparison IVs' incremental
contributions differ in relative magnitude from model to model.


{marker disp}{...}
{title:2. Display}

{pstd}
{cmd:domin}, by default, will produce all three types (that is, general,
conditional, and complete) of dominance statistics.  The general dominance
statistics cannot be suppressed in the output, are the first set of statistics
to be displayed, mirror the output style of most single-equation commands (for
example, {cmd:regress}), and produce two additional results.  Along with the
general dominance statistics, a vector of standardized general dominance
statistics, which is a general dominance statistic vector normed or
standardized to be out of 100%, will be displayed.  The final column is a
ranking or the relative importance of the IVs based on the general dominance
statistics.

{pstd}
The conditional dominance statistics are second, can be suppressed by the 
{opt noconditional} option, and are displayed in matrix format.  The first
column displays the average marginal contribution to the overall model fit
statistic with one IV in the model, the second column displays the average
marginal contribution to the overall model fit statistic with two IVs in the
model, and so on until column {it:p}, which displays the average marginal
contribution to the overall model fit statistic with all {it:p} IVs in the
model.  Each row corresponds to an IV.

{pstd}
The complete dominance statistics are third, can be suppressed by the 
{opt nocomplete} option, and are also displayed in matrix format.  The rows of
the complete dominance matrix correspond to dominance of the IV in that row
over the IV in each column.  If a row entry has a 1, the IV associated with the
row completely dominates the IV associated with the column.  By contrast, if a
row entry has a -1, the IV associated with the row is completely dominated by
the IV associated with the column.  A 0 indicates no complete dominance
relationship between the IV associated with the row and the IV associated with
the column.

{pstd}
Finally, if all three dominance statistics are reported, a "strongest dominance
designations" list is reported.  The strongest dominance designations list
reports the strongest dominance designation between all pairwise, IV
comparisons.


{marker opts}{...}
{title:3. Options}

{phang}
{opt reg(command, command_options)} is the Stata {it:command} or model (that
is, the regression) the user intends to apply in the DA.  The entry in
{opt reg()} can be any official command developed by StataCorp, any
community-contributed command in the Statistical Software Components Archive,
or any user-generated command on his or her local machine.  The command in 
{opt reg()} must follow the standard single dependent variable model
{it:command} {it:depvar} {it:indepvars} syntax.  {opt reg()} also allows the
user to pass {it:command_options} for the {it:command} in {opt reg()}.  When a
comma is added in {opt reg()}, all the syntax following the comma will be
passed to each run of the {it:command} in {opt reg()} as options to that
{it:command}.  {opt reg()} is a required option, but when nothing is entered,
it defaults to {cmd:reg(regress)} and will produce a warning denoting the
default behavior.

{phang}
{opt fitstat(scalar)} is the scalar-valued model fit statistic used to compute
all dominance statistics that are returned by the {it:command} in {opt reg()}.
{opt fitstat()} is a required option, but because {opt reg()} defaults to
{cmd:reg(regress)}, the default for this option is {cmd:fitstat(e(r2))}, the
R^2 scalar returned by {opt regress}.

{phang}
{opt noconditional} suppresses the computation and display of conditional
dominance statistics.  Suppressing the computation of conditional dominance
statistics can save computation time when conditional dominance statistics are
not desired.  Suppressing the computation of conditional dominance statistics
also suppresses the "strongest dominance designations" list in the Results
window.

{phang}
{opt nocomplete} suppresses the computation of complete dominance designations.
Like {opt noconditional}, this option suppresses the "strongest dominance
designations" list.

{phang}
{opt epsilon} is an approximation to DA using the relative weights analysis or
"epsilon" approach (Johnson 2000).  {opt epsilon} is faster than DA because it
does not fit all subsets of possible models but rather uses singular value
decomposition to approximate the process.

{pmore}
The {opt epsilon} approximation is more limited than the traditional DA
approach, allows none of the IV grouping options, and requires 
{opt noconditional} as well as {opt nocomplete}. Additionally, {opt epsilon}
can be used with only three estimation commands currently: {opt regress}, 
{opt glm}, and the wrapper program for {opt mvreg} called {cmd:mvdom}.

{pmore}
{opt epsilon} obviates each subset regression by orthogonalizing IVs using
singular value decomposition (see {helpb matrix svd}).  {opt epsilon}'s singular
value decomposition approach is not equivalent to the all-possible-combinations
approach but is many times faster for models with many IVs and tends
to produce similar answers regarding relative importance (LeBreton, Ployhart,
and Ladd 2004).  {opt epsilon} also does not allow the use of {opt all()}, 
{opt sets()}, {opt mi}, {opt consmodel}, and {opt reverse}, and does not allow
the use of {help weights}.  Using {opt epsilon} also produces only general
dominance statistics (that is, requires {opt noconditional} and 
{opt nocomplete}).

{pmore}
{opt epsilon} can obtain general dominance statistics for {cmd:regress},
{cmd:glm} (for any {opt link()} and {opt family()}, see Tonidandel and LeBreton
[2010]) and {cmd:mvdom} (the community-contributed wrapper program for
multivariate regression; see LeBreton and Tonidandel [2008]; see also example 6
below).  By default, {opt epsilon} assumes {cmd:reg(regress)} and
{cmd:fitstat(e(r2))}.  Note that {opt epsilon} ignores entries in 
{opt fitstat()} because it produces its own fit statistic.

{pmore}
Note: The {opt epsilon} approach has been criticized for being
conceptually flawed and biased (see Thomas et al. [2014)], despite research
showing similarity between dominance- and epsilon-based methods (for
example, LeBreton, Ployhart, and Ladd [2004]).  Thus, the user is cautioned in
the use of {opt epsilon} because its speed may come at the cost of bias.

{phang}
{opt sets((indepvars_set_1) ... (indepvars_set_n))} binds together IVs as an
inseparable set in the DA.  Hence, all IVs in a set will always appear
together in a model and are treated as a single IV for dominance statistics
computations.  Factor and time-series variables can be included in any
{it:indepvars_set} for commands that accept them (see example 3 below).

{pmore}
The user can specify as many IV sets of arbitrary size as is desired.  The
basic syntax is {opt sets((x1 x2) (x3 x4))}, which will create two sets
(denoted {cmd:set1} and {cmd:set2} in the output).  {cmd:set1} will be created
from the variables {it:x1} and {it:x2}, whereas {cmd:set2} will be created
from the variables {it:x3} and {it:x4}.  All sets must be bound by
parentheses -- thus, each set must begin with a left parenthesis, {cmd:(}, and
end with a right parenthesis, {cmd:)}, and all parentheses separating sets in
the {opt sets()} option syntax must be separated by at least one space.

{pmore}
The {opt sets()} option is useful for obtaining dominance statistics for IVs
that are more interpretable when combined, such as several dummy or effects
codes reflecting mutually exclusive groups.

{phang}
{opt all(indepvars_all)} defines a collection of IVs to be included in all the
combinations of models in the DA.  The magnitude of the overall fit statistic
associated with the set of IVs in the {opt all()} option is subtracted from the
dominance statistics for all IVs and is reported separately in the results.
The {opt all()} option accepts factor and time-series variables for commands
that accept them. See example 2 below.

{phang}
{opt mi} invokes Stata's {helpb mi} options within {cmd:domin}.  Thus, each
analysis is run using the {cmd:mi estimate} prefix, and all the
{opt fitstat()} statistics returned by the analysis program are averaged
across all imputations (see example 10 below).

{phang}
{opt miopt()} includes options in {cmd:mi estimate} within {cmd:domin}.  Each
analysis is passed the options in {opt miopt()}, and each of the entries in
{opt miopt()} must be a valid option for {cmd:mi estimate}.  Invoking 
{opt miopt()} without {opt mi} turns {opt mi} on and produces a warning noting
that the user neglected to also specify {opt mi}.

{phang}
{opt consmodel} adjusts all fit statistics for a baseline level of the fit
statistic in {opt fitstat()}.  Specifically, {cmd:domin} subtracts the value of
{opt fitstat()} with no IVs (that is, omitting all entries in {it:varlist}, in
{opt sets()}, and in {opt all()}).  {opt consmodel} is useful for obtaining
dominance statistics using overall model fit statistics that are not zero when
a constants-only model is fit (for example, Akaike information criterion [AIC]
and Bayesian information criterion [BIC]) and the user wants to obtain
dominance statistics adjusting for the constants-only baseline value.

{phang}
{opt reverse} reverses the interpretation of all dominance statistics in the
{cmd:e(ranking)} vector and {cmd:e(cptdom)} matrix. It also fixes the
computation of the {cmd:e(std)} vector and the "strongest dominance
designations" list.  {cmd:domin} assumes by default that higher values on
overall fit statistics constitute better fit because DA has historically been
based on the explained-variance R^2 metric.  However, DA can be applied to any
model fit statistic (see Azen, Budescu, and Reiser [2001] for other examples).
{opt reverse} is then useful for the interpretation of dominance statistics
based on overall model fit statistics that decrease with better fit (for
example, AIC and BIC).


{marker examp}{...}
{title:4. Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Example 1: Linear regression DA{p_end}
{phang2}{cmd:. domin price mpg rep78 headroom}{p_end}

{pstd}Example 2: Ordered outcome DA with covariate (for example, Luchman [2014]){p_end}
{phang2}{cmd:. domin rep78 trunk weight length, reg(ologit) fitstat(e(r2_p)) all(turn)}{p_end}

{pstd}Example 3: Binary outcome DA with factor variable (for example, Azen and
Traxel [2009]){p_end}
{phang2}{cmd:. domin foreign trunk weight, reg(logit) fitstat(e(r2_p)) sets((i.rep78))}{p_end}

{pstd}Example 4: Comparison of interaction and nonlinear variables{p_end}
{phang2}{cmd:. generate mpg2 = mpg^2}{p_end}
{phang2}{cmd:. generate headr2 = headroom^2}{p_end}
{phang2}{cmd:. generate mpg_headr = mpg*headroom}{p_end}
{phang2}{cmd:. regress mpg2 mpg}{p_end}
{phang2}{cmd:. predict mpg2r, resid}{p_end}
{phang2}{cmd:. regress headr2 headroom}{p_end}
{phang2}{cmd:. predict headr2r, resid}{p_end}
{phang2}{cmd:. regress mpg_headr mpg headroom}{p_end}
{phang2}{cmd:. predict mpg_headrr, resid}{p_end}
{phang2}{cmd:. domin price mpg headroom mpg2r headr2r mpg_headrr}{p_end}

{pstd}Example 5: Epsilon-based linear regression approach to dominance with
bootstrapped standard errors{p_end}
{phang2}{cmd:. bootstrap, reps(500): domin price mpg headroom trunk turn gear_ratio foreign length weight, epsilon}{p_end}
{phang2}{cmd:. estat bootstrap}{p_end}

{pstd}Example 6: Multivariate regression with wrapper {helpb mvdom}, using
default Rxy metric (for example, Azen and Budescu [2006]; LeBreton and
Tonidandel [2008]){p_end}
{phang2}{cmd:. domin price mpg headroom trunk turn, reg(mvdom, dvs(gear_ratio foreign length weight)) fitstat(e(r2))}{p_end}
{pstd}Comparison DA with Pxy metric{p_end}
{phang2}{cmd:. domin price mpg headroom trunk turn, reg(mvdom, dvs(gear_ratio foreign length weight) pxy) fitstat(e(r2))}{p_end}
{pstd}Comparison DA with {opt epsilon}{p_end}
{phang2}{cmd:. domin price mpg headroom trunk turn, reg(mvdom, dvs(gear_ratio foreign length weight)) epsilon}{p_end}

{pstd}Example 7: Gamma regression with deviance {cmd:fitstat} and constants-only comparison using {opt reverse}{p_end}
{phang2}{cmd:. domin price mpg rep78 headroom, reg(glm, family(gamma) link(power -1)) fitstat(e(deviance)) consmodel reverse}{p_end}
{pstd}Comparison DA with {opt epsilon}{p_end}
{phang2}{cmd:. domin price mpg rep78 headroom, reg(glm, family(gamma) link(power -1)) epsilon}{p_end}

{pstd}Example 8: Mixed-effects regression with wrapper {helpb mixdom} (for
example, Luo and Azen [2013]){p_end}
{phang2}{cmd:. webuse nlswork, clear}{p_end}
{phang2}{cmd:. domin ln_wage tenure hours age collgrad, reg(mixdom, id(id)) fitstat(e(r2_w)) sets((i.race))}{p_end}

{pstd}Example 9: Multinomial logistic regression with simple program to return
BIC{p_end}
{phang2}{cmd:. program define myprog, eclass}{p_end}
{phang2}{cmd:. syntax varlist if, [option]}{p_end}
{phang2}{cmd:. tempname estlist}{p_end}
{phang2}{cmd:. mlogit `varlist' `if'}{p_end}
{phang2}{cmd:. estat ic}{p_end}
{phang2}{cmd:. matrix `estlist' = r(S)}{p_end}
{phang2}{cmd:. ereturn scalar bic = `estlist'[1,6]}{p_end}
{phang2}{cmd:. end}{p_end}
{phang2}{cmd:. domin race tenure hours age nev_mar, reg(myprog) fitstat(e(bic)) consmodel reverse}{p_end}
{pstd}Comparison DA with McFadden's pseudo-R^2{p_end}
{phang2}{cmd:. domin race tenure hours age nev_mar, reg(mlogit) fitstat(e(r2_p))}{p_end}

{pstd}Example 10: Multiply imputed DA{p_end}
{phang2}{cmd:. webuse mheart1s20, clear}{p_end}
{phang2}{cmd:. domin attack smokes age bmi hsgrad female, reg(logit) fitstat(e(r2_p)) mi}{p_end}
{pstd}Comparison DA without {cmd:mi} ("in 1/154" keeps only original observations for comparison as in 
{bf:{help mi_intro_substantive:[MI] intro substantive}}){p_end}
{phang2}{cmd:. domin attack smokes age bmi hsgrad female in 1/154, reg(logit) fitstat(e(r2_p))}{p_end}


{marker sav}{...}
{title:5. Stored results}

{pstd}
{cmd:domin} stores the following in {cmd: e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(fitstat_o)}}overall fit statistic value{p_end}
{synopt:{cmd:e(fitstat_a)}}fit statistic value associated with IVs in {opt all()}{p_end}
{synopt:{cmd:e(fitstat_c)}}constants-only fit statistic value computed with {opt consmodel}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:domin}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(title)}}title of command in option {opt reg()}{p_end}
{synopt:{cmd:e(fitstat)}}contents of the {opt fitstat()} option{p_end}
{synopt:{cmd:e(reg)}}contents of the {opt reg()} option (before comma){p_end}
{synopt:{cmd:e(regopts)}}contents of the {opt reg()} option (after comma){p_end}
{synopt:{cmd:e(mi)}}{cmd:mi}{p_end}
{synopt:{cmd:e(miopt)}}contents of the {opt miopt()} option{p_end}
{synopt:{cmd:e(estimate)}}estimation method ({cmd:dominance} or {cmd:epsilon}){p_end}
{synopt:{cmd:e(properties)}}{cmd:b}{p_end}
{synopt:{cmd:e(depvar)}}name of dependent variable{p_end}
{synopt:{cmd:e(set}{it:#}{cmd:)}}IVs included in {it:indepvars_set#} in {opt sets()}{p_end}
{synopt:{cmd:e(all)}}IVs included in {opt all()}{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Matrices}{p_end}
{synopt:{cmd:e(b)}}general dominance statistics vector{p_end}
{synopt:{cmd:e(std)}}general dominance standardized statistics vector{p_end}
{synopt:{cmd:e(ranking)}}rank ordering based on general dominance statistics vector{p_end}
{synopt:{cmd:e(cdldom)}}conditional dominance statistics matrix{p_end}
{synopt:{cmd:e(cptdom)}}complete dominance designation matrix{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Functions}{p_end}
{synopt:{cmd:e(sample)}}marks estimation sample{p_end}
{p2colreset}{...}


{marker remark}{...}
{title:6. Final remarks}

{pstd}
It is the user's responsibility to supply {cmd:domin} with an overall fit
statistic that can be validly dominance analyzed.  Traditionally, only R^2 and
pseudo-R^2 statistics have been used for DA because of their interpretability
-- but {cmd:domin} was developed with extensibility in mind, and any statistic
{it:could} potentially be used (see Azen, Budescu, and Reiser [2001] for other
examples).  Arguably, the most important criteria for an overall fit statistic
to be used to compute dominance statistics are 1) {it:monotonicity}, or that
the fit statistic will not decrease with inclusion of more IVs (without a
degree-of-freedom adjustment such as those in information criteria);
2) {it:linear invariance}, or that the fit statistic is invariant or unchanged
for nonsingular transformations of the IVs; and 3) {it:information content},
or interpretation of the fit statistic as providing information about overall
model fit.

{pstd}
Although non-R^2 overall fit statistics can be used, {cmd:domin} assumes that
the fit statistic supplied {it:acts} like an R^2 statistic.  Thus, {cmd:domin}
assumes that better model fit is associated with increases to the fit statistic
and all marginal contributions can be obtained by subtraction.  For model fit
statistics that decrease with better fit (that is, AIC, BIC, deviance), the
interpretation of the dominance relationships needs to be reversed (see
examples 7 and 9).

{pstd}
It is the user's responsibility to provide {cmd:domin} with predictor
combinations that can be validly dominance analyzed.  That is, including
products of variables and individual dummy codes from a dummy code set can
produce invalid DA results or can at least produce dominance statistics with a
complicated interpretation.  If an IV should not be analyzed {it:by itself} in
a regression model, then it should not be included in {it:varlist}, and the
user should consider using a {opt sets()} specification.

{pstd}
Some users may be interested in obtaining relative importance comparisons for
interactions and nonlinear variables, as well as for indicator variables or
dummy codes (that is, any variable that can be constructed by a 
{help factor variable}).  Whereas dummy codes should be included together in a
{opt sets()} set, users can follow the residualization method laid out by
LeBreton, Tonidandel, and Krasikova (2013; see example 4) to obtain relative
importance of interaction and nonlinear variables.

{pstd}
{cmd:domin} can also produce standard errors using {help bootstrap}ping (see
example 5).  Although standard errors can be produced, the sampling
distribution for dominance weights has not been extensively studied.  
{helpb permute} tests are also conceptually applicable to dominance weights.

{pstd}
{cmd:domin} comes with two wrapper programs, {cmd:mvdom} and {cmd:mixdom}.
{cmd:mvdom} implements multivariate regression-based DA described by Azen and
Budescu (2006; see {helpb mvdom}).  {cmd:mixdom} implements linear
mixed-effects regression-based DA described by Luo and Azen (2013; see
{helpb mixdom}).  Both programs are intended to be used as wrappers into
{cmd:domin} and serve to illustrate how the user can also adapt existing
regressions (by StataCorp or user-written) to evaluate in a relative
importance analysis when they do not follow the traditional {it:depvar}
{it:indepvars} format.  As long as the wrapper program can be expressed in
some way that can be evaluated in {it:depvar} {it:indepvars} format, any
analysis could be dominance analyzed.

{pstd}
Any program used as a wrapper by {cmd:domin} must accept at least one optional
argument and must accept an {helpb if} statement in its {help syntax} line.

{pstd}
{cmd:domin} does not directly accept the {helpb svy} prefix -- but does accept
{cmd:pweight}s.  Because {cmd:domin} does not produce standard errors by
default, to respect the sampling design for complex survey data, the user need
provide {cmd:domin} only the {cmd:pweight} variable for commands that accept
{cmd:pweight}s (see Luchman [2015]).


{title:Acknowledgments}

{pstd}
Thanks to Nick Cox, Ariel Linden, Amanda Yu, Torsten Neilands, Arlion N., Eric
Melse, De Liu, and Patricia "economics student" for suggestions and bug
reporting.


{marker refs}{...}
{title:7. References}

{p 4 8 2}
Azen, R., and D. V. Budescu. 2006.
Comparing predictors in multivariate regression models: An extension of dominance analysis.
{it:Journal of Educational and Behavioral Statistics} 31: 157-180.
{browse "https://doi.org/10.3102/10769986031002157"}.{p_end}

{p 4 8 2}
Azen, R., D. V. Budescu, and B. Reiser. 2001.
Criticality of predictors in multiple regression.
{it:British Journal of Mathematical and Statistical Psychology} 54: 201-225.
{browse "https://doi.org/10.3102/10769986031002157"}.{p_end}

{p 4 8 2}
Azen, R., and N. M. Traxel. 2009.
Using dominance analysis to determine predictor importance in logistic
regression.
{it:Journal of Educational and Behavioral Statistics} 34: 319-347.
{browse "https://doi.org/10.3102/1076998609332754"}.{p_end}

{p 4 8 2}
Budescu, D. V. 1993.
Dominance analysis: A new approach to the problem of relative importance of
predictors in multiple regression.
{it:Psychological Bulletin} 114: 542-551.
{browse "https://doi.org/10.1037/0033-2909.114.3.542"}.{p_end}

{p 4 8 2}
Gr{c o:}mping, U. 2007.
Estimators of relative importance in linear regression based on variance
decomposition.
{it:The American Statistician} 61: 139-147.
{browse "https://doi.org/10.1198/000313007X188252"}.{p_end}

{p 4 8 2}
Johnson, J. W. 2000.
A heuristic method for estimating the relative weight of predictor variables
in multiple regression.
{it:Multivariate Behavioral Research} 35: 1-19.
{browse "https://doi.org/10.1207/S15327906MBR3501_1"}.{p_end}

{p 4 8 2}
LeBreton, J. M., R. E. Ployhart, and R. T. Ladd. 2004.
A Monte Carlo comparison of relative importance methodologies.
{it:Organizational Research Methods} 7: 258-282.
{browse "https://doi.org/10.1177/1094428104266017"}.{p_end}

{p 4 8 2}
LeBreton, J. M., and S. Tonidandel. 2008.
Multivariate relative importance: Extending relative weight analysis to
multivariate criterion spaces.
{it:Journal of Applied Psychology} 93: 329-345.
{browse "https://doi.org/10.1037/0021-9010.93.2.329"}.{p_end}

{p 4 8 2}
LeBreton, J. M., S. Tonidandel, and D. V. Krasikova. 2013.
Residualized relative importance analysis: A technique for the comprehensive
decomposition of variance in higher order regression models.
{it:Organizational Research Methods} 16: 449-473.
{browse "https://doi.org/10.1177/1094428113481065"}.{p_end}

{p 4 8 2}
Luchman, J. N. 2014.
Relative importance analysis with multicategory dependent variables: An
extension and review of best practices.
{it:Organizational Research Methods} 17: 452-471.
{browse "https://doi.org/10.1177/1094428114544509"}.{p_end}

{p 4 8 2}
------. 2015.
Determining subgroup difference importance with complex survey designs: An
application of weighted dominance analysis.
{it:Survey Practice} 8: 1-10.
{browse "https://doi.org/10.29115/SP-2015-0022"}.{p_end}

{p 4 8 2}
Luo, W., and R. Azen. 2013.
Determining predictor importance in hierarchical linear models using dominance
analysis.
{it:Journal of Educational and Behavioral Statistics} 38: 3-31.
{browse "https://doi.org/10.3102/1076998612458319"}.{p_end}

{p 4 8 2}
Thomas, D. R., B. D. Zumbo, E. Kwan, and L. Schweitzer. 2014.
On Johnson's (2000) relative weights method for assessing variable importance:
A reanalysis.
{it:Multivariate Behavioral Research} 49: 329-338.
{browse "https://doi.org/10.1080/00273171.2014.905766"}.{p_end}

{p 4 8 2}
Tonidandel, S., and J. M. LeBreton. 2010.
Determining the relative importance of predictors in logistic regression: An
extension of relative weight analysis.
{it:Organizational Research Methods} 13: 767-781.
{browse "https://doi.org/10.1177/1094428109341993"}.{p_end}


{title:Author}

{pstd}Joseph N. Luchman{p_end}
{pstd}Senior Scientist{p_end}
{pstd}Fors Marsh Group LLC{p_end}
{pstd}Arlington, VA{p_end}
{pstd}jluchman@forsmarshgroup.com{p_end}


{marker alsosee}{...}
{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 21, number 2: {browse "https://doi.org/10.1177/1536867X211025837":st0645}{p_end}

{p 7 14 2}
Help:  {helpb domme}, {helpb mixdom}, {helpb mvdom} (if installed){p_end}
