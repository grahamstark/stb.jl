# Main budget constraint output

this is the JSON used to create the chart on [this page](http://oustb.mazegreenyachts.com/bc-intro.html) and the following ones.

The graph shows the relationship between how much you earn and how much you take home after taxes paid and benefits received.

2 main elements: `base` and `changed` which show the graph before and after the users' changes.

then, for `base` and `changed`:

* `points`, which has 2 arrays
  - 1st array - gross income - the X- axis
  - 2nd array - net income - the Y- axis
* `annotations`: an array of tuples to be used as a tooltip for each point except the last, giving the "marginal tax rate" (tax on the next £1 after that) and "tax credit" (cash value of any tax-allowances and benefits) at that point.

The BC charts in the demo server are created using [Vega](https://vega.github.io/vega/) by the function `stb.createBCOutputs` in the file [stb-support.jl](https://github.com/grahamstark/stb.jl/tree/master/web/js).
