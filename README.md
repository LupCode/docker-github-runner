1. `docker build -t github-runner .`
2. `docker run -it --privileged --restart=always -v /var/run/docker.sock:/var/run/docker.sock --name github-runner -e url=<url> -e token=<token> -e name=<name> (-e group=<group>) github-runner`

Environment variables that can be set:
 - url=<url>			URL of repository or organization the runner should be linked to
 - token=<str>			Token used for registering runner
 - name=<str>			Name of the runner
 - group=<str>			Group the runner should be added to

Use `docker attach <container>` and then `STRG + C` to proparly shutdown container!

