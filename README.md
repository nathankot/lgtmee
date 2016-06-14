# Looks good to me emoji

![lgtmee](https://github.com/nathankot/lgtmee/blob/master/logo.png)

*Code review with your dedicated emoji.*

At [Plaid][plaid] we give everyone their personal emoji, mine is 🍌. The general
pattern is, if a pull request looks good you will make a comment including your
personal emoji.

LGTMEE makes it even better by listening in on new issue comments and
automatically adding a `review:#{user}` label to the pull-request.

## Installation

1. Setup a new Github user for LGTMEE.
2. Create a personal access token for the new user.
3. Setup application (see below for Heroku setup guide.)
4. For each repository that you want to use this for, give access to the new
   user and setup a webhook pointing to your desired application URL. The
   webhook only needs to be forwarding `issue_comment` events.

### Set up on Heroku

```sh
$ heroku create --buildpack https://github.com/heroku/heroku-buildpack-ruby.git
$ heroku config:set GITHUB_USER=username GITHUB_ACCESS_TOKEN=token WEBHOOK_SECRET=secret
$ git push heroku master
```

## Configuration

Environment variable           | Description
------------------------------------------------------------------------------------
`GITHUB_USER`                  | The github user to add labels with.
`WEBHOOK_SECRET`               | Chosen secret when configuring the webhook.
`GITHUB_ACCESS_TOKEN`          | A personal access token created for the user.
`GITHUB_SITE`                  | Alternative enterprise Github site (optional.)

# License

> MIT License
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
> FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
> COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
> IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[plaid]: https://plaid.com
