# Weebly [![Gem Version](https://badge.fury.io/rb/weebly.svg)](http://badge.fury.io/rb/weebly) [![Dependency Status](https://gemnasium.com/joshbeitler/weebly.svg)](https://gemnasium.com/joshbeitler/weebly)

Sometimes, Weebly is a nice option to use for client websites when you simply
want to get something done quickly, or for situations in which you want to
allow your client to easily edit their site.

Unfortunately, Weebly's developer experience is quite poor, and has many odd
and strange requirements.  This simple gem allows you to develop your theme
in a sane and (mostly) trouble-free environment.

## Installation
```
$ gem install weebly
```

## Usage

### Referencing resources
When referencing resources in your site (eg: `href`, `src` attributes), you
*cannot include the full path!* Instead, simply include the file name, and
it will be found when the site is built.  For this reason, you will want to
test your site by running `weebly server`, and not opening your files directly
in a browser.

```html
<!-- Wrong.  Do not do this! -->
<link rel="stylesheet" href="css/master.css">

<!-- Correct.  Please do this instead. -->
<link rel="stylesheet" href="master.css">
```

### Weebly site structure
When a new site is created using the Weebly gem, several HTML files are created, each of which corrosponds to the applicable layout as used by Weebly.  `index.html` is the default layout, and is the only required one.  It is helpful to include layouts for the other page-types as well, however, as it increases the flexibility of the theme.

## Commands

#### `weebly new <sitename>`
Will create a new site in the current directory with the name `sitename`.
This site will include a basic directory structure, with places for CSS, JS,
HTML layouts, and images.

#### `weebly build [-b]`
When run from a directory containing a site (eg: `sites/hello`, where `hello`
is the Weebly site), this command will validate, clean up, and compress your
site to be Weebly-ready.  Supplying the `-n` flag will skip any validation checks that the gem might perform prior to a build.

#### `weebly validate`
Will validate your site to ensure that it conforms to Weebly's standards.  
(Searches for template tags, directory structure, etc.)

#### `weebly server`
Will run your site on a local webserver (defaults to `localhost:8000`) and
emulate the Weebly environment.  Note: *simply opening `index.html` in your
web browser is not good practice, and will not even work in this case.

## Contributing

1. Fork it (http://github.com/joshbeitler/weebly/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
```
Copyright 2014 Joshua Beitler

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
