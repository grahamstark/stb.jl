# Notes on DD226 Ch. 18 Microsimulation Model

[Graham Stark](mailto:gks56@open.ac.uk)

## Overview:

I'm building a microsimulation tax benefit model for DD226 Chapter 18 on microsimulation.

The model is in two parts: a 'back end' which does all the sums and a 'front end' which handles all the student interactions (sending tax changes to the model, and then receiving results back and drawing pictures and tables with them).

Example model pages [1](https://oustb.virtual-worlds.scot/bc-intro.html) | [2](https://oustb.virtual-worlds.scot/tax-benefit-package-1-poverty.html)

The front-end bits are written in a web language called Javascript. The Javascript I've written needs to be embedded in the Moodle web pages for ch. 18, along with the associated web forms. All the pages on the OU Moodles already contain large amounts of Javascript, and I've been careful to base my stuff on the javascript that's already there, so there shouldn't be all that much to install.

The back-end is in the form of a 'virtual machine'  - a big file which is a simulation of an actual computer. This is the standard way of building servers nowadays. To install the back-end, it should be a case of me giving an OU technical person a copy of the virtual machine file, and that person loading it in to a physical computer somewhere

## Slightly Techy stuff

The idea is that this is a very basic 'one-shot' service optimised to respond as fast as possible to simple requests.

### Server

* Model is written in [Julia](https://julialang.org/) and is available on [GITHub](https://github.com/grahamstark/stb.jl/);
* presently incomplete and running with a dummy set of calculations
* uses a simple Web framework [MUX](https://github.com/JuliaWeb/Mux.jl), front-ended by Apache
* The model constructs a large, read only household dataset in memory; once this is loaded, individual runs are fast (don't have exact timings because the model calculations are still in development);
* The inputs and outputs to the server are in RESTful JSON
  - accompanying note describes the JSON output;
  - no sessions, no authentication, no cookies;
  - json response is approx 20kb;
  - I haven't got exact timings for a model response but it's pretty fast (I think it will handle several complete runs per second but haven't run tests);
  - should be faster still with caching.
* server is currently Ubuntu 18, VirtualBox VM;
* currently runs on the machine under my desk;
* hardware requirements: a fair amount - would be best with multiple fast CPUs, and quite a lot of memory. Current VM has 1GB of memory and 4 CPUs assigned.

### Front-End

All output is generated client side from the Big JSON. I've tried to stick to libraries I see on the OU site.

* javascript: mainly uses JQuery;
* Uses [Vegalite](https://vega.github.io/vega-lite/) for graphics (happy to change this);
*  ~ [700 lines of my own JS currently](https://github.com/grahamstark/stb.jl/blob/master/web/js/stb-support.js)

### Possible Problems

* no security audit - no security at all, really;
* no way in the current setup to restrict use to OU staff and students. Not at all obvious to me how you could do that easily;
* no load testing - seems pretty fast, though;
* installation of the Julia code is messy and needs work to use the standard Julia package manager;
* API is very simple but likely to evolve;
* the Julia server is very slow to start up (about 1 minute)(but fast once it has).

### TODO

* I'm presently unclear how much of this the course team want to change, or keep;
* I'm unclear how much front-end work (Javascript and forms) will be required, and who should do it. I've created a bare-bones system; I think most of the needed outputs are there but the whole thing is quite ugly. Graphics might need re-written in whatever is the OU standard;
* Model calculation section needs finished - was making decent progress last week. Since we're modelling a hypothetical country we can always fudge the calculations round the edges if needs be;
* the server was built my me ...
