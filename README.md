google-search
===================

So you want to search for something?


Usage
-------------------

    search = require("google-search");

    search.get("obama").then(function(result) {...});
    # result will be like this: 
    # [{href: "...", title: "...", content: "..."}, {...}, ...]

    # get multiple pages in one invocation
    search.getPages("obama", [1,2,3]).then(function(result) {...});
    search.getPages(["obama","putin"], [1,2,3]).then(function(result) {...});


License
---------------------

CC-BY 4.0: https://creativecommons.org/licenses/by/4.0/
