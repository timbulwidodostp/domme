{smcl}
{* *! version 1.0 July 2 2019 J. N. Luchman}{...}
{cmd:help domme}{right: ({browse "https://doi.org/10.1177/1536867X211025837":SJ21-2: st0645})}
{hline}

{title:Title}

{p2colset 5 14 16 2}{...}
{p2col :{cmd:domme} {hline 2}}Dominance analysis for mulitple equation models{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 13 2}
{cmd:domme} [{cmd:(}{it:eqname_1} {cmd:=} {it:parmnamelist_1}{cmd:)} 
             {cmd:(}{it:eqname_N} {cmd:=} {it:parmnamelist_N}{cmd:)}] 
{ifin} {weight}{cmd:,} {opt r:eg(full_estimation_command)} 
{opt f:itstat(returned_scalar | built_in_options)}
[{it:options}]

{phang}
{it:eqname} can be any equation name from that of a {it:depvar} to an
implied equation such as {cmd:inflate()} in {helpb zip} or {helpb zinb}
models. {it:parmnamelist}s can include any {it:varname} including factor and
time-series prefixed variables. Note that the function of {cmd:domme}'s
parenthetical statements are to produce constraints, and normal {it:varlist}
expansions will not be applied. {cmd:domme} accepts any weights that can be
used in the command entered in the {cmd:reg()} option.

{phang}
The syntax of {cmd:domme} in the {it:eqname_x} {cmd:=} {it:parmnamelist_x}
statements always creates parameter constraints of the form
{cmd:_b[eqname:parmname] = 0}, and the names submitted to it are created as
such from what is typed.  Thus, it is incumbent on the user to supply
{cmd:domme} with the appropriate {it:eqname}s and {it:parmname}s for the model
represented in the {cmd:reg()} option.

{phang}
{cmd:domme} requires installation of Jann's {cmd:moremata} package (install
here: {bf:{stata ssc install moremata}}).  Users are strongly encouraged to
install {help domin} as well and read over its help file for basic information
on dominance analysis (DA).


{title:Table of contents}

{help domme##desc: 1. Description}
{help domme##setup: 2. Setup}
{help domme##opts: 3. Options}
{help domme##examp: 4. Examples}
{help domme##sav: 5. Stored results}
{help domme##remark: 6. Final remarks}
{help domme##refs: 7. References}


{marker desc}{...}
{title:1. Description}

{pstd}
DA for multiple-equation models is an extension of standard DA (see 
{help domin}) that focuses on finding the relative importance of parameter
estimates (PEs) in an estimation model based on the contribution of each PE to
an overall model fit statistic (see Luchman, Lei, and Kaplan [2020] for a
discussion).  Because it is an extension of standard DA, users should
familiarize themselves with standard DA before attempting to use the
multiple-equation version of the methodology.

{pstd}
DA for multiple-equation models differs from standard DA primarily in how the
ensemble of fit metrics is collected.  Standard DA obtains the ensemble of fit
metrics to compute dominance statistics by including or excluding independent
variables (IVs) from a statistical model.  DA for multiple-equation models
obtains the ensemble of fit metrics to compute dominance statistics by using
constraints that permit each PE to be estimated from the data or
constrained to zero in a given statistical model.  Constraining a PE to zero
effectively omits the parameter from estimation, and it cannot contribute to
model fit.


{marker setup}{...}
{title:2. Setup}

{pstd}
{cmd:domme} requires that all parameters to be dominance analyzed be written
out in the initial {cmd:(}{it:eqname} {cmd:=} {it:parmnamelist}{cmd:)}
statements.  {cmd:domme} will use the {cmd:(}{it:eqname} {cmd:=}
{it:parmnamelist}{cmd:)} statements (similar to those of commands like 
{helpb sureg}) to create parameter statements from which it will produce 
constraints.  Each entry in {it:parmnamelist} is given a separate constraint
with the associated {it:eqname}.  For example, the statement

{pstd}
{cmd:(price = mpg turn trunk foreign)}

{pstd}
will create the series of four parameters:

{pstd}
{cmd:_b[price:mpg] _b[price:turn] _b[price:trunk] _b[price:foreign]}

{pstd}
Such parameters would be produced by a model like 
{cmd:glm price mpg turn trunk foreign}.

{pstd}
Note that the current version of {cmd:domme} does not check to ensure that the
parameters supplied are in the model, and it is the user's responsibility to
ensure that the lists supplied are valid parameters in the fitted model.


{marker opts}{...}
{title:3. Options}

{phang}
{opt reg(full_estimation_command)} refers {cmd:domme} to a command that accepts
the option {cmd:constraints()}, that uses {helpb ml} to estimate parameters,
and that can produce the scalar in the {opt fitstat()} option.  The entry in
{cmd:reg()} can be any official command developed by StataCorp, any
community-contributed command in the Statistical Software Components Archive,
or any user-generated command on his or her machine. The command in
{cmd:reg()} must accept the {cmd:constraints()} option. Options to the
command in {cmd:reg()} may be passed using the {cmd:ropts()} option
described below.

{pmore}
The {it:full_estimation_command} is the full estimation command, not including
options following the comma, as would be submitted to Stata.

{pmore}
The {cmd:reg()} option has no default, and the user is required to provide a
valid statistical model.  Thus, {cmd:reg()} is required.

{phang}
{opt fitstat(returned_scalar | built_in_options)} refers {cmd:domme} to
a scalar-valued model-fit summary statistic used to compute all dominance
statistics.  The scalar in {opt fitstat()} can be any r-class, e-class or
other scalar produced by the estimation command in {opt reg()}.

{pmore}
In addition to fit statistics produced by the estimation command in 
{opt reg()}, {cmd:domme} also allows several built-in model fit statistics to
be computed using the model log likelihood and degrees of freedom.  Four fit
statistics are available using the built-in options for {cmd:domme}.  These
options are the McFadden pseudo-R^2 ({cmd:mcf}), the Estrella pseudo-R^2
({cmd:est}), the Akaike information criterion ({cmd:aic}), and the Bayesian
information criterion ({cmd:bic}).

{pmore}
To instruct {cmd:domme} to compute a built-in fit statistic, supply the
{cmd:fitstat()} option with an empty e-class scalar (that is,
{cmd:e()}), and provide the three-character code for the desired fit
statistic.  The command in {cmd:reg()} must return the {cmd:e(ll)} value
for the {cmd:mcf} options, must return the {cmd:e(ll)} and
{cmd:e(rank)} scalars for the {cmd:est} and {cmd:aic} options, and
must return the {cmd:e(ll)}, {cmd:e(rank)}, and {cmd:e(N)} scalars
for the {cmd:bic} option.  For example, to ask {cmd:domme} to compute
McFadden's pseudo-R^2 as a fit statistic, type {cmd:fitstat(e(), mcf)}.

{pmore}
Note that {cmd:domme} has no default, and the user is required to provide a
valid fit statistic. Thus, {cmd:fitstat()} is required.

{phang}
{opt ropts(command_options)} includes any options that the user wants to
submit to the command in the {opt reg()} option.  All additional options to
the command in {opt reg()} must be submitted in this option and not in the
{cmd:reg()} option as is the case with {cmd:domin}.

{phang}
{opt noconditional} suppresses the computation and display of conditional
dominance statistics and suppresses the "strongest dominance designations"
list.

{phang}
{opt nocomplete} suppresses the computation of complete dominance designations
and suppresses the "strongest dominance designations" list.

{phang}
{cmd:sets([(}{it:eqname_1_set_1} {cmd:=}
             {it:parmnamelist_1_set_1}{cmd:)} ... {cmd:(}{it:eqname_r_set_1}
	     {cmd:=}
             {it:parmnamelist_r_set_1}{cmd:)]} ... {cmd:[(}{it:eqname_1_set_N}
	     {cmd:=}
             {it:parmnamelist_1_set_N}{cmd:)} ... {cmd:(}{it:eqname_r_set_N}
	     {cmd:=}
             {it:parmnamelist_r_set_N}{cmd:)])}
binds together PEs as an inseparable set in the DA.  Hence, all PEs in a set
will always appear together in a model and are treated as a single PE. Note
that the syntax to generate parameter lists is similar to that of the standard
({it:eqname_x = parmnamelist_x}) syntax, save that sets of parameters must be
included in brackets (that is, {cmd:[ ]}).

{pmore}
For example, consider the model {cmd:glm price mpg turn trunk foreign}.
To produce two sets of parameters, one that includes {cmd:mpg} and {cmd:turn}
as well as a second that includes {cmd:trunk} and {cmd:foreign}, type
{cmd:sets([(price = mpg turn)]} {cmd:[(price = trunk foreign)])}.

{pmore}
This {opt sets()} statement refers to single equations within a model.  A
single set can include parameters from multiple equations -- in fact, doing so
is how IV dominance statistics can be computed in {cmd:domme}.

{phang}
{opt all((eqname_all_1 = parmnamelist_all_1)}
... {opt (eqname_all_n = parmnamelist_all_n))} binds together a set of PEs to
be included in all the combinations of models in the DA.  Thus, all PEs
included in the {opt all()} option are effectively used as covariates that are
to be included in the model fit metric but for which dominance statistics will
not be computed.  The magnitude of the overall fit statistic associated with
the set of PEs in the {opt all()} option is subtracted from the dominance
statistics for all IVs and reported separately in the results.  Note that the
syntax to create the {it:parmnamelist}s is identical to the standard
{cmd:domme} syntax.

{phang}
{opt reverse} reverses the interpretation of all dominance statistics in the
{cmd:e(ranking)} vector and {cmd:e(cptdom)} matrix and fixes the
computation of the {cmd:e(std)} vector and the "strongest dominance
designations" list.  {cmd:domme} assumes by default that higher values on
overall fit statistics constitute better fit because DA has historically been
based on the explained-variance R^2 metric.  However, DA can be applied to any
model fit statistic (see Azen, Budescu, and Reiser [2001] for other examples).
{opt reverse} is then useful for the interpretation of dominance statistics
based on overall model fit statistics that decrease with better fit (for
example, the built-in Akaike information criterion, Bayesian information
criterion statistics).


{marker examp}{...}
{title:4. Examples}

{pstd}Setup{p_end}
{phang2}{cmd:. sysuse auto}{p_end}

{pstd}Example 1: Path analysis/seemingly unrelated regression{p_end}
{phang2}{cmd:. sureg (price = length foreign gear_ratio) (headroom = mpg)}
{p_end}
{phang2}{cmd:. domme (price = length foreign gear_ratio) (headroom = mpg), reg(sureg (price = length foreign gear_ratio) (headroom = mpg)) fitstat(e(), mcf)}{p_end}

{pstd}Example 2: Zero-inflated Poisson with built-in Bayesian information
criterion{p_end}
{phang2}{cmd:. generate zi_pr = price*foreign}{p_end}
{phang2}{cmd:. zip zi_pr headroom trunk,inflate(gear_ratio turn)}{p_end}
{phang2}{cmd:. domme (zi_pr = headroom trunk) (inflate = gear_ratio turn), reg(zip zi_pr headroom trunk) f(e(), bic) ropt(inflate(gear_ratio turn)) reverse}{p_end}

{pstd}Example 3: Path analysis/seemingly unrelated regression model with
{cmd:all()} option{p_end}
{phang2}{cmd:. sem (foreign <- headroom) (price <- foreign length weight) (weight <- turn)}{p_end}
{phang2}{cmd:. estat ic}{p_end}
{phang2}{cmd:. domme (price = length foreign) (foreign = headroom), all((price = weight) (weight = turn)) reg(sem (foreign <- headroom) (price <- foreign length weight) (weight <- turn)) fitstat(e(), aic) reverse}{p_end}

{pstd}Example 4: Generalized negative binomial with {cmd:all()} and parameters
treated as _cons in the DA (that is, _b[price:foreign]){p_end}
{phang2}{cmd:.  gnbreg price foreign weight turn headroom, lnalpha(weight length)}{p_end}
{phang2}{cmd:. domme (price = turn headroom) (lnalpha = weight length), reg(gnbreg price foreign weight turn headroom) f(e(), mcf) ropt(lnalpha(weight length)) all((price = weight))}{p_end}

{pstd}Example 5: Generalized structural equation model with factor
variables{p_end}
{phang2}{cmd:. sysuse nlsw88, clear}{p_end}
{phang2}{cmd:. gsem (wage <- union hours, regress) (south <- age ib1.race union, logit)}{p_end}
{phang2}{cmd:. domme (wage = union hours) (south = age union 2.race 3.race), reg(gsem (wage <- union hours, regress) (south <- age ib1.race union, logit)) fitstat(e(), mcf)}{p_end}

{pstd}Example 6: Generalized structural equation model with sets to evaluate IVs{p_end}
{phang2}{cmd:. gsem (south union <- wage tenure ttl_exp, logit)}{p_end}
{phang2}{cmd:. domme, reg(gsem (south smsa union <- wage tenure ttl_exp, logit)) fitstat(e(), mcf) sets([(south = wage) (union = wage)] [(south = tenure) (union = tenure)] [(south = ttl_exp) (union = ttl_exp)])}
{p_end}


{marker sav}{...}
{title:5. Stored results}

{pstd}
{cmd:domme} stores the following in {cmd: e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(N)}}number of observations{p_end}
{synopt:{cmd:e(fitstat_o)}}overall fit statistic value{p_end}
{synopt:{cmd:e(fitstat_a)}}fit statistic value associated with PEs in {opt all()}{p_end}
{synopt:{cmd:e(fitstat_c)}}fit statistic value computed by default when the constant model is nonzero{p_end}

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:domme}{p_end}
{synopt:{cmd:e(cmdline)}}command as typed{p_end}
{synopt:{cmd:e(title)}}{cmd:Dominance analysis for multiple equations}{p_end}
{synopt:{cmd:e(fitstat)}}contents of the {opt fitstat()} option{p_end}
{synopt:{cmd:e(reg)}}contents of the {opt reg()} option{p_end}
{synopt:{cmd:e(regopts)}}contents of the {opt ropts()} option{p_end}
{synopt:{cmd:e(properties)}}{cmd:b}{p_end}
{synopt:{cmd:e(set}{it:#}{cmd:)}}PEs included in {opt sets()}{p_end}
{synopt:{cmd:e(all)}}PEs included in {opt all()}{p_end}

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
Any PEs in the model but not in the initial syntax for the command to
dominance-analyze, the {opt sets()} option, or the {opt all()} option are
assumed to act as a part of the model constant and are in some cases ignored in
computing the model fit statistic.  Thus, any PE not included in some modeling
statement will be treated like a regression constant in most regression models,
that is, as a baseline against which the full model is compared in terms of the
log likelihood.  "Constant" parameters are omitted entirely from fit statistic
computations for the built-in {cmd:mcf} and {cmd:est} options but are reported
as a part of the constant model fit statistic for the {cmd:aic} and {cmd:bic}
options in {opt fitstat()}.

{pstd}
When not using the built-in options, the user needs to supply {cmd:domme} with
an overall fit statistic that can be validly dominance analyzed.  Non-R^2
overall fit statistics can be used; however, {cmd:domme} assumes that the fit
statistic supplied acts like an R^2 statistic.  Thus, {cmd:domin} assumes that
better model fit is associated with increases to the fit statistic, and all
marginal contributions can be obtained by subtraction.  For model fit
statistics that decrease with better fit (that is, Akaike information
criterion, Bayesian information criterion, deviance), the interpretation of the
dominance relationships needs to be reversed (see example 2).


{marker refs}{...}
{title:7. References}

{p 4 8 2}
Azen, R., D. V. Budescu, and B. Reiser. 2001.
Criticality of predictors in multiple regression.
{it:British Journal of Mathematical and Statistical Psychology} 54: 201-225.
{browse "https://doi.org/10.1348/000711001159483"}.{p_end}

{p 4 8 2}
Luchman, J. N., X. Lei, and S. A. Kaplan. 2020.
Relative importance analysis with multivariate models: Shifting the focus from independent variables to parameter estimates.
{it:Journal of Applied Structural Equation Modeling} 4: 1-20.
{browse "https://doi.org/10.47263/JASEM.4(2)02"}.{p_end}


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
Help:  {helpb domin}, {helpb mixdom}, {helpb mvdom} (if installed){p_end}
