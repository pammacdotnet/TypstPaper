#import "@preview/pyrunner:0.3.0" as py
#let compiled = py.compile(```py
import re
def find_emails(string):
    return re.findall(r"\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b", string)
def sum_all(*numbers):
    return sum(numbers)
```)
#let text = "My email address is john.doe@example.com and my friend's email address is jane.doe@example.net."
Result: #py.call(compiled, "find_emails", text)
#py.call(compiled, "sum_all", 1, 2, 3)
