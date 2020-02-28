# Approx Stress Tests

## Graham Stark
29/02/2020

This simple test launches batches of jobs at the server, either serially or in parallel, from a laptop in a Glasgow Libary, over Wifi. Batches of 16 model runs are launched using wget. I launch 1,6 and 16 batches simultaneously. The 6 and 16 cases are intended to simulate (possibly online) classroom use, when students are invited by the teacher to submit runs at roughly the same time.

The server takes ~3 seconds to respond to each request in the single thread, and ~26 seconds to respond to each request in the 16-thread case. All runs were completed fully. 

Server - 4 core VM running Ubuntu 18 on Oracle Virtual Box, 8GB memory XX bogomips.

Client - Dell Ultra i5 (Glasgow Library Wifi)

| Threads      | Elapsed(s)  |Processing(s/run) | Response time(s/run)|
|:-------------|------------:|-----------------:|--------------------:|
| 1            | 53          |    3.3           |     3.3             |
| 6            | 140-155     |   ~1.6           |     ~9              |
| 16           | 373-419     |   ~1.6           |     ~26             |

So: server maxes out at ~1.6 secs per run. Average response time is ~3 seconds if made serially, ~26 seconds if 16 runs are submitted simultaneously, ~9 secs for 6 simultaneous requests.
