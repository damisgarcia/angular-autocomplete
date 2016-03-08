# angular.autocomplete
## Getting angular.autocomplete and its dependencies

You can install [angular.autocomplete](https://github.com/damisgarcia/angular-autocomplete) with [bower](http://bower.io) by typing
`bower install angular.autocomplete`.

## bower.json

If you have a `bower.json` file, just add `angular.autocomplete` to its `dependencies` section and type `bower install`
or alternatively type `bower install --save angular.autocomplete` (which will automatically add the dependency to your `bower.json`).

## Usage

In a HTML file, add the script tags for the dependencies:

```html
<script type="text/javascript" src="../bower_components/jquery/dist/jquery.js"></script>
<script type="text/javascript" src="../bower_components/lodash/dist/lodash.js"></script>
<script type="text/javascript" src="../bower_components/snap.svg/dist/snap.svg.js"></script>
```

and then the script for script tag for angular.autocomplete:

```html
<script type="text/javascript" src="../bower_components/diagram-js/diagram.js"></script>
```

Now, to use diagram-js, add a script tag with something like:

```javascript
// get the library
var Diagram = require('angular.autocomplete');

// and instanciate
var diagram = new Diagram();
```

Have a look at the [index.html file](https://github.com/bpmn-io/diagram-js-examples/tree/master/simple-bower/app/index.html#L41) in the `app` directory for some inspiration.
