{smcl}
{* *! version 1.1 March 11 2015 J. N. Luchman}{...}
{cmd:help mixdom}{right: ({browse "https://doi.org/10.1177/1536867X211025837":SJ21-2: st0645})}
{hline}

{title:Title}

{p2colset 5 15 17 2}{...}
{p2col :{cmd:mixdom} {hline 2}}Wrapper program for {cmd:domin} to conduct linear mixed-effects regression dominance analysis{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 14 2}
{cmd:mixdom} {it:depvar} {it:indepvars} [{it:{help if}}] {weight}{cmd:,} 
{opt id(idvar)}
[{opt re:opt(re_options)} {opt xtm:opt(mixed_options)} {opt noc:onstant}]

{phang}
{help fvvarlist:Factor} and 
{help tsvarlist:time-series variables} are allowed.
{cmd:fweight}s and {cmd:pweight}s are allowed; see {help weights:weights}.

{phang}
{cmd:mixdom} is also designed to be used only in {cmd:domin} and is
primarily useful for computing the R^2_within and R^2_between
fit statistics described by Luo and Azen (2013) as well as accommodating the
random-effects identifier ({it:idvar}) (that is, the variable that would be
placed following the {cmd:||} in {cmd:mixed}) with the {cmd:id()} option.


{title:Description}

{pstd}
{cmd:mixdom} sets the data up in a way to allow for the dominance analysis of a
linear mixed-effects regression by utilizing {help mixed}.  The method outlined
here follows that for the within- and between-cluster Snijders and Bosker
(1994) R^2 metric described by Luo and Azen (2013).

{pstd}
{cmd:mixdom} allows only one level of clustering in the data (that is, one
random effect), which must be the cluster constant/mean/intercept. Luo and Azen
(2013) recommend that even if random coefficients are present in the data, they
should be restricted to a fixed effect only in the dominance analysis.

{pstd}
Negative R^2 values indicate model misspecification.


{marker options}{...}
{title:Options}

{phang}
{opt id(idvar)} specifies the variable on which clustering occurs and that will
appear after the random-effects specification (that is, {cmd:||}) in the
{cmd:mixed} syntax.  {cmd:id()} is required.

{phang}
{opt reopt(re_options)} passes options to {cmd:mixed} specific to the
random-intercept effect (that is, {opt pweight()}) that the user would like to
utilize during estimation.

{phang}
{opt xtmopt(mixed_options)} passes options to {cmd:mixed} that the user would
like to utilize during estimation.

{phang}
{opt noconstant} does not estimate an average fixed-effect constant (see the 
{opt noconstant} option of {help mixed}).


{title:Stored results}

{phang}
{cmd:mixdom} stores the following in {cmd: e()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Scalars}{p_end}
{synopt:{cmd:e(r2_w)}}within-id model fit statistic{p_end}
{synopt:{cmd:e(r2_b)}}between-id model fit statistic{p_end}
{p2colreset}{...}


{title:References}

{p 4 8 2}
Luo, W., and R. Azen. 2013.
Determining predictor importance in hierarchical linear models using dominance analysis.
{it:Journal of Educational and Behavioral Statistics} 38: 3-31.
{browse "https://doi.org/10.3102/1076998612458319"}.{p_end}

{p 4 8 2}
Snijders, T. A. B., and R. J. Bosker. 1994.
Modeled variance in two-level models.
{it:Sociological Methods and Research} 22: 342-363.
{browse "https://doi.org/10.1177/0049124194022003004"}.{p_end}


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
Help:  {manhelp mixed R}, {helpb domin}, {helpb domme}, {helpb mvdom} (if installed){p_end}
