# Main JSON output

The main results give lots of summary output from a microsimulation tax-benefit model of Scotland. The outout is reasonably final, with one exception (tables of gainers and losers, which will be expanded when I have time). Not all of the output is to be displayed - a lot of it comes from standard library routines, but I'm thinking of including a fuller output option, maybe by dumping everything in a `csv` file students could put in a spreasheet.

It's used to produce the output on [this page](http://oustb.virtual-worlds.scot/tax-benefit-tour.html), and the ones that follow.

All the code used is on [GITHub](https://github.com/grahamstark/stb.jl/).

The Julia output routine that produces the json is `summarise_results` in [src/web/](https://github.com/grahamstark/stb.jl/blob/master/src/web/web_model_libs.jl).

And an example Javascript handler is [stb-support.jl](https://github.com/grahamstark/stb.jl/tree/master/web/js).

Generally, there are 3 sets of results in the JSON file:

    0 - Base results - how much taxes, benefits, etc. you get if you don't change any of the rates.
    1 - Reform results - results after the user has made changes;
    3 - Difference - absolute differences between 2 and 1.

The javascript file `stb-support.jl` shows the code I've written to parse the json file. It's unsophisticated! But it might be useful as a reference.

The main fields in the file, in the order they appear, are:

### gainers and losers
- `gainlose total` - total counts of people losing, unchanged (nc), and gaining from the change
- `gainlose_by_sex` - as above but broken down by  Male/Female
- `gainlose_by_thing` - test output splitting gainers by some arbitrary field

the final version will have several more elements (gains and losers by employment status, tenure type, etc.). Only the total gain/lose is displayed at present.

### poverty

Measures of how many poor people there are. There are 3 sets of results (base, changed, difference). Only the field `headcount` is actually used in the main display. So, for example, the poverty level for the changed system is `results.poverty[1].headcount`. You'd normally multiply by 100 to express as %s.

### inequality

As poverty. The field `gini` is displayed, and `deciles` is used to create the "lorenz curve" in the 2nd row of the main output. The `deciles` array has three arrays:
    0: population shares (x-axis on the graph);
    1: income share (y-axis);
    2: income level for the decile (not used).

### avg_metr

Average Marginal Effective Tax Rate - 3 element array (0=pre-, 1=changed, 2=difference), showing the average of the tax rate people face on the next £ they earn.

### metr_histogram

As above but split into a histogram. So `623159.3333333336` is a count the number of people with a zero tax rate (the ".333.." is because of how the data is weighted).

###   "metr_axis"

the ranges used in the METR histogram - lower limits, so the first 2 being `-99999 ` and `0` selects everyone with a 0 tax rate.

### deciles

the is a duplicate of of the decile fields in the inequality record. I can't remember why I included this.

### targetting_total_benefits

these show the percentage of each benefit that is spent on the poor. The `targetting_total_benefits` field is used in the model display - the usual base-, post-, and difference fields.

### targetting_benefit1, targetting_benefit2

these names are test cases and will change as the model develops. Not used in the main display. They show how much of each individual benefit is targetted on the poor.

### totals

Total costings for various elements (total amount spent on a benefit, per year, or total tax raise). Three base-, changed-, difference Dictionaries.

### poverty_line, growth_assumption, unit_count

not currently used (`unit_count` is number of people). Other fields may be added at the end, such as a count of households.
