# Rough Benchmarks 20/2/2020



as requested I've had a look at the likely cost of a server for this, but not got all that far. As I've mentioned the model code isn't finished yet, and in any case I've no idea how often the model will be run, so it's hard to get any kind of sensible benchmarks for how much memory/CPU time we'll need. From some time poking about on Azure and Amazon, and also talking to my own server provider, the best I can give you is rough lower/upper bounds of £25-£90 per month - so £300-1,080 pa. One possibility I'm exploring is to have something big and fast for 1 month per year - so the week before week 28 to 2 weeks after, say, and something scaled back the rest of the time: Azure certainly offer that.

<pre>

  memory estimate:  776.54 MiB
  allocs estimate:  28164012

10x calculations
  --------------
  minimum time:     1.355 s (17.14% GC)
  median time:      1.468 s (19.17% GC)
  mean time:        1.509 s (20.51% GC)
  maximum time:     2.119 s (15.48% GC)
  --------------

  samples:          80
  evals/sample:     1

100x calculations

   memory estimate:  3.81 GiB
  allocs estimate:  118177692
  --------------
  minimum time:     4.860 s (19.19% GC)
  median time:      5.115 s (19.83% GC)
  mean time:        5.179 s (20.04% GC)
  maximum time:     5.713 s (20.78% GC)
  --------------
  samples:          10
  evals/sample:     1

  single CPU

model name      : Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz
cpu MHz         : 4319.218
bogomips        : 7995.30

</pre>
