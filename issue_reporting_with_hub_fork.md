# `github/hub` fork at `sgharms/hub:fis`

1. Clone https://github.com/sgharms/hub/
2. Checkout `fis` branch
3. Run `make`
4. This creates `bin/hub` in the git dir
5. Use _this_ `hub` (adjust PATH, use `/path/to/cloned/hub/bin/hub`)

The critical change is support for an `-r` flag which allows you to specify a repo to get the issues on *OR*, if you pass `-r STDIN` you can read in a file of repos to query. And that's very handy.

The `-f flag takes a format string for awesome output

**JSON** (wih some massaging)

`-f '{%n  "issueId": %I,%n  "issueTitle": "%t",%n  "issueURL": "%U",%n  "reporterId": "%au",%n  "createDate": "%uI"%n}%n%'`

**Simple List of Issue URLs**

`-f %U%n'`
