---
layout: post
title:  "Pipelines: The #1 data processing design pattern"
permalink: /pipelines
usemathjax: true
---

In mathematics, two functions $$f$$ and $$g$$ can be [composed] $$f \circ g$$, what is defined as

$$
(f \circ g)(x) = f(g(x))
$$

The same way, functions in programming can be composed into pipelines.

## Unix pipes

As a design pattern in programming, they were popularized by [unix pipes], where a series of commands can be 
composed using the pipe `|` operator. For example, the command below would count the unique cells from the second
column of a CSV file by combining the `cut`, `sort`, and `uniq` commands.

```shell
cut -d, -f2 data.csv | sort | uniq -c
```

The pattern was a consequence of [unix philosophy], which assumed the workflow composed
of chained programs

> 1. Make each program do one thing well. [...]
> 2. Expect the output of every program to become the input to another, as yet unknown, program. [...]

## Pipelines in functional programming

Pipelines are also popular in functional programming languages. For example, [Haskell] uses syntax inspired by mathematical
notation `(f . g)`. [OCaml] has the `|>` pipe operator defined as

```ocaml
let (|>) v f = f v
```

so `v |> f` gets translated to the `f v` function call, so `2 |> (+) 2 |> (/) 8` is the same as
`(/) 8 ((+) 2 2)`. [Clojure] uses the threading macros `->` and `->>` that pass the input as 
the first or second argument subsequently. In Clojure, the example that I just used would take
the following form

```clojure
(->>
    2
    (+ 2)
    (/ 8))
```

## Data processing pipelines in R

The pipes were also a very popular pattern in statistical [programming language R], where they
were first available through an external library that exposed the `%>%` operator, which in R 4.0.0 was included in
the core language as `|>`. For example, to calculate per-group averages an R user could use the following code

```r
library(dplyr) 

mtcars |>
    group_by(cyl) |>
    summarise(mpg = mean(mpg))

## # A tibble: 3 x 2
##     cyl   mpg
##   <dbl> <dbl>
## 1     4  26.7
## 2     6  19.7
## 3     8  15.1
```

*OK, but what's the fuss?* The main reason for using pipelines is that they lead to more concise and readable code.
An additional benefit is that the steps can be easily changed, replaced, or removed, which makes iterating over the
code easier. Pipelines also ensure consistency, because they guarantee that the steps would be always invoked in the
same order. 

The pipeline like above, consisting of [pure functions], fulfill all the mathematical properties of function
composition. Since we can define a new function $$p(x) = f(g(x))$$, we can use it for a composition as well
$$h \circ p = h \circ f \circ g$$. For the same reason pipelines in programming can as well be composed of other
pipelines. This is how a program can be decomposed into a series of smaller steps in a [functional architecture].

## Mutable pipelines

But there is another kind of a pipeline, the mutable (or trainable) one. In [Python's] [scikit-learn]
the code is often written in terms of pipelines like below

```python
complete_pipeline = Pipeline([
    ("preprocessor", preprocessing_pipeline),
    ("estimator", LinearRegression())
])
```

This pipeline is an object with the same interface as its steps, [exposing methods] like
`fit`, `transform`, or `predict`. When calling `complete_pipeline.fit(X, y)`, the pipeline would call `fit` in
`preprocessor` and pass the result as an input to the `fit` method of the `estimator`. The objects are Notice that
the `fit` method mutates the object, so after calling it, each of the steps would be behaving differently than before.
If during preprocessing we used a scaling transformer, it would learn how to scale the data given the training set,
so it could apply the transformation to new data. Calling `fit` on the machine learning model would lead to training it,
so the model can be used for making predictions.

We need a `fit` method that sets up the pipeline and a `transform` or `predict` method that applies it.
In scikit-learn the objects and so the pipeline is mutable, but it would also be possible to create
a pipeline in a functional programming paradigm. The only thing needed would be the support for [first-class functions].
In such a case, the `fit` function would return the predicted pipeline build from individual step functions. 
Such a purely functional pipeline could look like in the example below.

```python
def fit(steps, input):
    new_steps = []
    for step in steps:
        fitted = step(input)
        input = fitted(input)
        new_steps.append(fitted)
    return new_steps

def transform(steps, input):
    output = input
    for step in steps:
        output = step(output)
    return output

transform(fit([
    lambda x: lambda y: y + x,  # => y + 2
    lambda x: lambda y: y / x,  # => y / 4
], 2), 7)                       # => 9 / 4 = 2.25
```

Pipelines are simple, yet powerful and often get omitted when discussing design patterns.
They carry a key role in many data processing tasks, including modern machine learning pipelines.


 [composed]: https://en.wikipedia.org/wiki/Function_composition
 [pure functions]: https://en.wikipedia.org/wiki/Pure_function
 [unix pipes]: https://en.wikipedia.org/wiki/Pipeline_(Unix)
 [unix philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
 [haskell]: https://wiki.haskell.org/Function_composition
 [ocaml]: https://stackoverflow.com/questions/8986010/is-it-possible-to-use-pipes-in-ocaml
 [clojure]: https://clojure.org/guides/threading_macros
 [programming language r]: https://www.r-bloggers.com/2021/05/the-new-r-pipe/
 [functional architecture]: https://www.goodreads.com/book/show/34921689-domain-modeling-made-functional
 [scikit-learn]: https://mahmoudyusof.github.io/general/scikit-learn-pipelines/
 [exposing methods]: https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html
 [python's]: https://www.youtube.com/watch?v=BFaadIqWlAg
 [first-class functions]: https://en.wikipedia.org/wiki/First-class_function
