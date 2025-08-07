#import "@preview/pyrunner:0.2.0" as py
#let compiled = py.compile(
  ```python
  def find_emails(string):
      import re
      return re.findall(r"\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b", string)
  ```,
)
#let txt = "My email address is john.doe@example.com and my friend's email address is jane.doe@example.net."
#py.call(compiled, "find_emails", txt)
#py.call(compiled, "sum_all", 1, 2, 3)
