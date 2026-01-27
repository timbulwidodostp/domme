{smcl}
{* *! version 1.1 March 11 2015 J. N. Luchman}{...}
{cmd:help mvdom}{right: ({browse "https://doi.org/10.1177/1536867X211025837":SJ21-2: st0645})}
{hline}

{title:Title}

{p2colset 5 14 16 2}{...}
{p2col :{cmd:mvdom} {hline 2}}Wrapper program for {cmd:domin} to conduct multivariate regression-based dominance analysis{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 13 2}
{cmd:mvdom} {it:depvar_1} {it:indepvars} [{it:{help if}}] {weight}{cmd:,} 
{opt dvs}({it:depvar_2} [... {it:depvar_r}])
[{opt noc:onstant} {opt pxy}]
{p2colreset}{...}

{phang}
{help fvvarlist:Factor} and 
{help tsvarlist:time-series variables} are not allowed.
{cmd:aweight}s and {cmd:fweight}s are allowed; see {help weights}.

{phang}
{cmd:mvdom} is intended for use only as a wrapper program with
{cmd:domin} for the DA of multivariate linear regression, and its
syntax is designed to conform with {cmd:domin}'s expectations. It is not
recommended for use as an estimation command outside of {cmd:domin}.

{phang}
{cmd:mvdom} works with {cmd:domin} because it follows the {it:depvar}
{it:indepvars} syntax broadly by including {it:depvar_1} in the initial syntax
statement but requires at least one other (that is, {it:depvar_2}) in the
{cmd:dvs()} option that are filled into the base regression command during
estimation. Note the {cmd:if} qualifer in {cmd:mvdom}'s syntax, which is a key
requirement for any wrapper program designed to be used with {cmd:domin}.


{title:Description}

{pstd}
{cmd:mvdom} sets the data up in a way to allow for the dominance analysis of a
multivariate regression by utilizing {help canon}ical correlation.  The
default metric used is the Rxy metric described by Azen and Budescu (2006).

{pstd}
{cmd:mvdom} uses the first variable in the varlist as the first dependent
variable in the multivariate regression.  All other variables in the varlist
are used as independent variables.  All other dependent variables are entered
into the regression in an option.  The output of the dominance analysis (that
is, in {cmd:domin}) will show only the first dependent variable in the output.


{marker options}{...}
{title:Options}

{phang}
{opt dvs(depvar_2 [... depvar_r])} specifies the second through $r$th
other dependent variables to be used in the multivariate regression. Note the
first dependent variable, {it:depvar_1}, as shown in the syntax.  {cmd:dvs()}
is required.

{phang}
{opt noconstant} does not subtract means when obtaining correlations (see
the {opt noconstant} option of {help canon}).

{phang}
{opt pxy} changes the fit statistic from the default "symmetric" Rxy metric to
the "nonsymmetric" Pxy model fit statistic.  Both fit statistics are described
by Azen and Budescu (2006).


{title:Stored results}

{phang}
{cmd:mvdom} stores the following in {cmd: e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(r2)}}model fit statistic (either Rxy or Pxy){p_end}
{p2colreset}{...}


{title:Reference}

{p 4 8 2}
Azen, R., and D. V. Budescu. 2006.
Comparing predictors in multivariate regression models: An extension of dominance analysis.
{it:Journal of Educational and Behavioral Statistics} 31: 157-180.
{browse "https://doi.org/10.3102/10769986031002157"}.{p_end}


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
Help:  {manhelp mvreg R}, {manhelp canon R}, {helpb domin}, {helpb domme}, {helpb mixdom} (if installed){p_end}
