---
layout: post
title:  "Pielines: The #1 data processing design pattern"
permalink: /pipelines
---

In mathematics, two functions $f$ and $g$ can be [composed] $f \circ g$, what is defined as

$$
(f \circ g)(x) = f(g(x))
$$

As a design pattern in programming, they were popularized by [unix pipes], where series of commands can be 
composed using the pipe `|` operator. For example, the command below would count the
unique cells from the second column of a CSV file by combining the `cut`, `sort`, and `uniq`
commands.

```shell
cut -d, -f2 data.csv | sort | uniq -c
```

The pattern was a consequence of [unix philosophy], that assumed the workflow composed
of chained programs

> 1. Make each program do one thing well. [...]
> 2. Expect the output of every program to become the input to another, as yet unknown, program. [...]

It is also popular in functional programming languages. [OCaml uses] the `|>` pipe operator
defined as

```ocaml
let (|>) v f = f v
```

so `v |> f` gets translated to the `f v` function call, so `2 |> (+) 2 |> (/) 8` is the same as
`(/) 8 ((+) 2 2)`. [Clojure] uses the threading macros `->` and `->>` that pass the input as 
first or second argument subsequently. In Clojure, the example that I just used would take
the following form

```clojure
(->>
    2
    (+ 2)
    (/ 8))
```

The pipes were also a very popular pattern in statistical [programming language R], where they
were first available through an external library that exposed the `%>%` operator, which in R 4.0.0 was included in the core language as `|>`. For example, to calculate per-group averages
an R user could use the following code

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

*OK, but what's the fuss?* The main reason of using pipelines is that they lead to more readable and concise code. Moreover, the steps can be easily changed, replaced, or removed.

The pipeline like above, consisting of [pure functions], fulfills all the mathematical properties of function composition. Since we can define a new function $h(x) = f(g(x))$,
we can use it for a composition as well $k \circ h = k \circ f \circ g$. For the same reason
pipeline in programming can as well be composed of other pipelines. This is how a program
can be decomposed into a series of smaller steps in a [functional architecture].

But there is another kind of a pipeline, the mutable one. In [Python's] [scikit-learn]
the code is often written in terms of pipelines like below

```python
complete_pipeline = Pipeline([
    ("preprocessor", preprocessing_pipeline),
    ("estimator", LinearRegression())
])
```

This pipeline is an object with the same interface as it's steps, [exposing methods] like
`fit`, `transform`, or `predict`. When calling `complete_pipeline.fit(X, y)`, the pipeline would call `fit` in `preprocessor` and pass the result as and input to the `fit` method of the `estimator`. Notice that the `fit` method mutates the object, so after calling it, each of the
steps would be behaving differently then before. If during preprocessing we used a scaling transformer, it would learn how to scale the data given the training set, so it could apply the
transformation to new data. Calling `fit` on machine learning model, would lead to training it,
so the model can be used for making predictions.


 [composed]: https://en.wikipedia.org/wiki/Function_composition
 [pure functions]: https://en.wikipedia.org/wiki/Pure_function
 [unix pipes]: https://en.wikipedia.org/wiki/Pipeline_(Unix)
 [unix philosophy]: https://en.wikipedia.org/wiki/Unix_philosophy
 [ocaml uses]: https://stackoverflow.com/questions/8986010/is-it-possible-to-use-pipes-in-ocaml
 [clojure]: https://clojure.org/guides/threading_macros
 [programming language r]: https://www.r-bloggers.com/2021/05/the-new-r-pipe/
 [functional architecture]: https://www.goodreads.com/book/show/34921689-domain-modeling-made-functional
 [scikit-learn]: https://mahmoudyusof.github.io/general/scikit-learn-pipelines/
 [exposing methods]: https://scikit-learn.org/stable/modules/generated/sklearn.pipeline.Pipeline.html
 [python's]: https://www.youtube.com/watch?v=BFaadIqWlAg
