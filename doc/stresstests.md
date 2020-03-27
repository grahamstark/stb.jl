# OU Tax Benefit Model - Some Rough Stress Tests

## Graham Stark
29/02/2020

This simple test launches batches of jobs at the server, either serially or in parallel, from a laptop in a Glasgow Library, over Wifi. Batches of 16 model runs are launched using [wget](https://www.gnu.org/software/wget/). I launch 1,6 and 16 batches simultaneously. The 6 and 16 cases are intended to simulate (possibly online) classroom use, when students are invited by the teacher to submit runs at roughly the same time.

The server takes ~3 seconds to respond to each request in the single thread, and ~26 seconds to respond to each request in the 16-thread case.  All runs were completed fully.

So 16 threads of 16 runs each = 256 runs in < 420 secs = ~1.6 secs/run. Time per run roughly halves between 1 and 6 request threads and then stays constant - the server is threaded and has 4 processors so in principle speed should be   ~1/4.

**Server** - 4 core VM running Ubuntu 18 on Oracle Virtual Box, 8GB memory 7,995.36 bogomips.

**Client** - Dell Ultra i5 (Glasgow Library Wifi)

| Simultaneous requests      | Elapsed(s)  |Processing(s/run) | Avg.Response time(s)|
|:---------------------------|------------:|-----------------:|--------------------:|
| 1                          | 53          |    3.3           |     3.3             |
| 6                          | 140-155     |   ~1.6           |     ~9              |
| 16                         | 373-419     |   ~1.6           |     ~26             |

So: server maxes out at ~1.6 secs per run. Average response time is ~3 seconds if made serially, ~26 seconds if 16 runs are submitted simultaneously, ~9 secs for 6 simultaneous requests.
