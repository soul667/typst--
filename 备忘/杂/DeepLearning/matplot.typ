#import "@preview/pyrunner:0.2.0" as py

#let compiled = py.compile(
```python
import numpy as np
def sum_all(*array):
    return sum(array)
```)

#let txt = "My email address is john.doe@example.com and my friend's email address is jane.doe@example.net."

#py.call(compiled, "find_emails", txt)
// #py.call(compiled, "np_test")