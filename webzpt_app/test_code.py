From webzpt import WebZPTController, web, class_from
import re

urls = (
    '/([a-zA-Z]+)', 'index')
#authenticate\t900123456\ta
class index(WebZPTController):
    def GET(self, name):
        self.name = name
        pierre = student(firstname = 'Pierre', lastname = 'Larochelle')
        print self.view(partials = (top(), body(), pierre))

class body(WebZPTController):
    def content(self): 
        return 'This is the actual body'
   
class top(WebZPTController):
    def name(self):
        return 'Pierre Larochelle'

class student(WebZPTController):
    def __init__(self, firstname = 'empty', lastname = 'empty'):
        self.firstname = firstname
        self.lastname = lastname
        self.names = (firstname, lastname)

    

web.webapi.internalerror = web.debugerror
if __name__ == "__main__": web.run(urls, globals(), web.reloader)
