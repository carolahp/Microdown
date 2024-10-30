# Microdown Syntax
The syntax covers two distict categories - inline and paragraphs. 
- Inline commands cover things like emphasis and links.
- Paragraphs are commands that span several lines of text (lists, code examples, etc). We often named them Bloc level elements. 


## Inline syntax
### Text emphasis
- **bold** is done by `**bold**` (You can get \** by `\\**`)  
- _italics_ is done by `_italics_` (should be underline, but now it stuck, there is no underline)
- ~strike~ is done by `~strike~`
- `inline code` is done by   \`inline code\`

### Links and Figure
- [Link](https://Pharo.org) is done as `[Link](https://Pharo.org)`. The produced link will open in the standard browser (Pharo `WebBrowser class >> #openOn:`)
- ![alt text](https://pharo.org/web/files/pharo-logo-small.png) is done using ` ![alt text](https://pharo.org/web/files/pharo-logo-small.png) `.  Often larger figures are done by placing using this syntax on a line by itself

### File level Metadata

Microdown uses JSON to handle file-header metadata as shown after:

```
{
"author" : "Stéphane Ducasse",
"title" : "a cool documentation"
}
```

### Bloc parameters

Microdown has a generic way to manage arguments of elements. The syntax is `tag|key1=value1&key2=value2`. 



### Anchors and References
Microdown supports different anchors: at the heading level, math equations and figures.

#### Heading anchors
`@anAnchor` starting a new line defines the anchor `anAnchor`. This type of anchor is a bloc level element.

#### Figures

```
![This is a caption. %width=50&anchor=aFigAnchor](testMicrodown/toplevel.png)
```
![This is a caption. %width=50&anchor=aFigAnchor](testMicrodown/toplevel.png)

Any anchor can be refer to using an anchor reference following this syntax: `*@anAnchor@*`

#### Equations

Using the same mechanism you can define a caption and an anchor of an equation.

```
$$ %anchor=frac&caption=The crazy equation
\frac{1}{1+2}
$$
```

### Microdown Math 

Microdown supports both inline math using `$` and equation `$$`

`$x^2$` - inline `$\LaTeX$` is done using `$x^2$` (and `$LaTeX$`).

```
$$ %anchor=frac&caption=The crazy equation
\frac{1}{1+2}
$$
```

produces a fraction. Notice the use of %anchor=frac to define metadata.

$$
\frac{1}{1+2}
$$


### Raw 

Microdown also supports the possibility to express raw text using `{{{` and `}}}`.

```
{{{**bold**}}}
```

### Microdown inline extensions
There is potentially an endless number of extensions one would like to add to Microdown. Rather than keep inventing new syntax, the generic syntax for inline syntax is:
`{!extensionName|parameter1=value1&parameter2=value2&parameter3=value3!}`. What the extension does will typically depend on the vistor ($\LaTeX$ generation, Text generation, HTML generation etc)

Some extensions are already defined in the Microdown library:
- **inputFile|path=uri** - inserts the contents of the microdown document at uri at this place.
- **footnote|note=some note which goes to the foot**  - adds a footnote the the generated document
- **citation|ref=somewhere so others can find it** - adds a reference to the generated document


## Microdown Bloc level elements a.k.a Paragraphs

### Headers
Headers are done by lines starting with `#`. One `#` is the largest header, six `######` is the smallest header. The header text is written after the `#` signs.`

##### This is a header level 5, done as `##### This is a header level 5` 

### Comments
It is possible to put comments in the Microdown source. Lines starting with `%` are creates a comment paragraph, but most tools ignore them.

```
% They really are
```

### Quote blocks
> Lines starting with `>` are supposed to be rendered in an indented manner
> At present the in-image rendering leaves something to be desired
>  But it works for now
Each source line which is part of the quote block need to start with a `>`

```
> this is a quote block
> spawning on multiple lines
```


### Annotated paragraphs

Microdown supports annotated paragraphs using `>[! as follows:

```
>[! Important]
> Microdown is extensible
```

>[! Important]
> Microdown is extensible


### Raw HTML paragraphs

With recent versions of Microdown you can embedded top level HTML blocks.

```
<address>
kjlkjljlkj
hkjhkjh
<\address>
```


### Unordered lists
Unordered list are made by prefixing a line with '-' or `*`.
* item 1
- item 2
* It is possible to make a long item
  with several lines of text by indenting the following lines 
  by 2 spaces (two!, not three or one or tab)

#### Indented lists
* Item 1
  * by prefixing the `-` or `*` by two spaces, one indent the list by one level
    * Item 1.1.1
  * Item 1.2
* Againg, the indentation is two spaces!
    * If you indent by say 4 spaces instead of two, it is just seen as a new line in the preceding bullet point

### Ordered lists
Ordered lists are done by prefixing a line with a digit followed by `.` or `)`.
2. First item
4) The numbers need not be in order, the rendering will start the numbering from one and increment

### Mixed lists
It is possible to mix the two types of lists
1. This is first item, made using `1. This is first item`
   - sub item
   * Indenting sublist is tricky, but the bullet (`*` or '-') must be matched up under the first letter in the line `This is the ...`
      In this case 3 spaces of indentation `1._`
1. Next numbered item

### Horizontal lines
***
Are created by a single line starting with at least three `*` - this works: `***` as well as `*************`
*************

### Code blocks
To show code one use a tripple  backquote
```text
  ```pharo
	Metacello new
		repository: 'github://svenvc/zinc/repository';
		baseline: 'ZincHTTPComponents';
 		load.
  ```
```
produces:
```pharo
  Metacello new
    repository: 'github://svenvc/zinc/repository';
    baseline: 'ZincHTTPComponents';
    load.
```
#### Predefind language modifiers
The `pharo` modifier used above is good for pharo expressions. Often one will show a full method,  and should use `method` to get a better highlighting and coloring of the method header
```text
  ```method
    accept: aVisitor
           ^ aVisitor visitCode: self
  ```
```
produces:

```method
accept: aVisitor
 	^ aVisitor visitCode: self
```

Plain unformatted text us made by using the `text` modifier, which will just print the body as is.
```text
  ```text
    accept: aVisitor
           ^ aVisitor visitCode: self
  ```
```
produces:
```text
accept: aVisitor
 	^ aVisitor visitCode: self
```

### Tables
It is possible to write tables in markup. These tables are intended to be short and not too wide. The cells of the tables can only be markedup with inline markup.
```text
| Header1 | Header2 | Header 3 |
| --- | ---- | --- |
| cell 1 1 | cell 1 2 | cell 1 3 |
| cell 2 1 | cell 2 2 | cell 2 3 |
```
produces:
| Header1 | Header2 | Header 3 |
| --- | ---- | --- |
| cell 1 1 | cell 1 2 | cell 1 3 |
| cell 2 1 | cell 2 2 | cell 2 3 |

**Notice**, unlike some other markdowns, Microdown requires lines to start with `|`. 
There has to be at least the `---` in the line after the header. 
Leaving out the second line merely produce a table without header highlighting.

| Header1 | Header2 | Header 3 |
| cell 1 1 | cell 1 2 | cell 1 3 |
| cell 2 1 | cell 2 2 | cell 2 3 |
