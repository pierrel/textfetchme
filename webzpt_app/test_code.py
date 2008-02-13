from webzpt import WebZPTController, web
import re

urls = (
    '/([a-zA-Z]+)', 'index')

class index(WebZPTController):
    def GET(self, name):
        self.name = name
        print self.view(partials = (body(), top()))

class body(WebZPTController):
    def content(self): 
        return 'This is the actual body'
   
class top(WebZPTController):
    def name(self):
        return 'Pierre Larochelle'
    

web.webapi.internalerror = web.debugerror
if __name__ == "__main__": web.run(urls, globals(), web.reloader)
